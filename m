Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C9FBD2D104
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49C46B0005; Tue, 13 Jan 2026 08:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21496B0089; Tue, 13 Jan 2026 08:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8B16B008A; Tue, 13 Jan 2026 08:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD5546B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:40:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 790591AC24E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:40:31 +0000 (UTC)
X-FDA: 84327050262.22.CEFEE94
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012000.outbound.protection.outlook.com [40.107.209.0])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6778DA0017
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:40:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=azhs1NR7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.209.0 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768311628; a=rsa-sha256;
	cv=pass;
	b=Qjo4zqfsPDf0BVPtZrfCjFNG+BGFC74ZKbUKy5PopqvajWmdaq64wNsTQIdRdXWKEFzNyG
	t2Zrvv9lHP+nzN6UWnnvRNjZYzniAfMwjVdSUupv+53T9ByHhvSYhWURiFjY0gqoGMSgDv
	eECNagUiUxbeAUvILDKVjEQrK68DZUU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=azhs1NR7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.209.0 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768311628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VN8HDaNDjc0QmMyMmCD4G/kW7yZuBFTgZj92LF30/o4=;
	b=dFZB2Scgivj2kJ1PkJSotYgJFm0t4nuIfevzTFzOBzmLntWci9Hr6ArXMX5og3Vr6lRArB
	IrbvLxjH8MOHJsh6XS3j1DZAvH5OJsZJ3YjSkGJsAjrf/1B8myObGjYmQOiHYwWVxDrTj+
	CJ1kruVJJXDZfYs3h/POBDQEAAjC/Hs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tTHRIFfqp2FIabeOdoKq1fcMmdEkROCjbbTgWHf2F+P/hAt+CPFyBb44gfjOh1HmMZmIl15f8wlHwH1SKIWHwVQMPoU+Mzmdv+oGY4txeC/wMnjaCXc7rNC2tJgCVSMHFNgZwk2SY5qBIHqWIFR9Ndd9O5mGIE0J88Qtz1g+d1SbPQZY52mECqn198tC8ktTQJeo9jkVPnEumwbOuaktblECy6Ysy/0SlAogd90mqIu9IWWdCb2fBfYEZCLLL1avdRCmD9GXOqJPHU738pMUDUbG8wBDZFitntLdj/tmvdL4JhxL2FUEVNTZQG2m0M+3PcYaVRAiuixX+qKyW7kLaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VN8HDaNDjc0QmMyMmCD4G/kW7yZuBFTgZj92LF30/o4=;
 b=NnyPXfDp/91gry9TQnfhu/CuzUqudjLbC5AwEaWZhTYe4auaENOjUhYdtDFso5537Lk9LRzVCllCG4wbP04/P/KpS3HE8MvN0NAmbAPXSdhhDTRIHxkSVoM/0wLbFZtV8UtknApHdDXHluUUV+5HYLNDokE0lwAfUkbAMOkHUtuQWTik0Wx5zNlYVccereOG8C41XwLiLFc6KdwQNF3MEJp2LMnFUKU/oRAcUjN3JYsOMvikIQjGap8y5ii+i5ZTxavxK+42XntcRp1m2aiN0eVw0PVGAXGszoCrVg/UYevYybNyUIn54mR20u5+CvQqMGatMb8ruKpRuadWc54iLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VN8HDaNDjc0QmMyMmCD4G/kW7yZuBFTgZj92LF30/o4=;
 b=azhs1NR7H5qVQZw/IAVbWuTFH1HXzFuGnLyXn4jj5eTwO5GU+s+BAemKmVLCM4AcSUk3nRP4ZJLJKUiSki82IDLD7GU/Vd9vKSttQVElYmsp96eGZ+3ClgKNxaP+ZtBDd6RcM6LAyko2X396G+0Y7+JJ4rTeZWQl9ZWPh3hRomg=
Received: from IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10)
 by CH2PR12MB4071.namprd12.prod.outlook.com (2603:10b6:610:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 13:40:25 +0000
Received: from IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2]) by IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 13:40:24 +0000
Message-ID: <22fe9000-117a-4b14-a51b-1349d01772f0@amd.com>
Date: Tue, 13 Jan 2026 21:40:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] drm/amdkfd: Add batch userptr allocation support
To: Felix Kuehling <felix.kuehling@amd.com>
Cc: dmitry.osipenko@collabora.com, Xinhui.Pan@amd.com, airlied@gmail.com,
 daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org,
 Honglei Huang <honglei1.huang@amd.com>, alexander.deucher@amd.com,
 Ray.Huang@amd.com, =?UTF-8?Q?Christian_K=C3=B6nig?=
 <christian.koenig@amd.com>
References: <20260104072122.3045656-1-honglei1.huang@amd.com>
 <64f0d21c-1217-4f84-b1ce-b65c1f5c2ef1@amd.com>
 <b6004bee-ffef-48ea-ba0d-57b390cb771c@amd.com>
 <76c44385-bcf8-4820-a909-569bd2d36198@amd.com>
 <ab5d1bb7-7896-49fd-a9ea-19294f4f57ca@amd.com>
 <dc1f5de7-40c4-4649-8f2f-0fee4b540783@amd.com>
 <ee4e502b-7b49-4ef7-b7b7-20afba189e1c@amd.com>
 <78db6cf0-f119-4788-9bda-5f45e9d60899@amd.com>
Content-Language: en-US
From: Honglei Huang <honghuan@amd.com>
In-Reply-To: <78db6cf0-f119-4788-9bda-5f45e9d60899@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KUZPR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:d10:33::11) To IA1PR12MB6435.namprd12.prod.outlook.com
 (2603:10b6:208:3ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6435:EE_|CH2PR12MB4071:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3795ff-eb83-4b26-b7d6-08de52a94e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VitKNHh0WlhnbVJ2N0RMYlFyZ2NndW5DNmFMUHNxZ0FNZnNGSnhpM3ErejRC?=
 =?utf-8?B?OWJKVnpmaUJ5dXh4R21qL3d1SE9TRTMrMStqUlo2SGhyOWU5eHFnWFZTWGEz?=
 =?utf-8?B?QnJ3cFp3YXEzWGt1UFFLYlVqMlRFTlB3KyswOVBXNVhUaklnK2RHOHdWUE1u?=
 =?utf-8?B?U1oweFhmbnU0QW1RdVRlYkFvUVNpWWtKbnhzQThtNHNFWWY3RTdpc09maWxV?=
 =?utf-8?B?QSt6QW5VWHB5cGFZRm4yUHV2T1RNL1RoMVUvcVliVE9iOFpXZUJSbklsNDcz?=
 =?utf-8?B?VW8rendMaDZoTmJTeFJDNkVYUXp3cVRJazdmVWVMOEtlYXp6dVB3dFVQdGd1?=
 =?utf-8?B?WHVMd3ltWUJWdjAvNE5ibGRuTWVKTklhd0JLYnVBUmZIMEhkNEtPVEhYMGM4?=
 =?utf-8?B?R0puMUdDazVIalp1Wk9ZM085dkV3VG1jL0lHWWpsR0Z0aTBTQTIwK2xLNVdw?=
 =?utf-8?B?UytWTGtOUWVISld4b0V4SGpveExqRlNnc05ZV0hYaGowd0tuQkxZRGdTZUNa?=
 =?utf-8?B?eGt5Nzk2RlAvd000OEx5T3NBSExzZFBURVJWbEU4SXZSa1I3SmU2MjB4MVc3?=
 =?utf-8?B?QURVRGpIVWhrcy9hTUIwa05leXdoSFIyVEkvMEhrMVZDZGZPM1E2ZUtlTHNn?=
 =?utf-8?B?TXFBeEhoeHpzcll0MVVjZ3lvU3NML2psQkNMeGNhTjVZZFJ5Mm0xVmhtbEZr?=
 =?utf-8?B?SHBUVjhCSEZCY0hSTE5SU0RoNDBEYmpIWnc1V1lsem5qdFJOSmtFVFNNM1hJ?=
 =?utf-8?B?eXNFNkJjQ241MXJDclI4c1ZBTkVkVHhydWM1U2pzVVp5YjBRZkFPS281eGhZ?=
 =?utf-8?B?dTh3RjhVMVJ4bU9abzBEM0tjd2o2RTlBZEMyZWdUQkdZNEE5MXBwOWZiNUc4?=
 =?utf-8?B?d0IxVFI0WXBpVTA0cXhRNUpROVF2cmV3dG16a2VEYWNmQkU1akYwSGF1akgw?=
 =?utf-8?B?KzVFWjZhYjVVUm9xaW1XZmE5ZW14YXJKL3Nka24vcHU0VzBOeDJBSFFWaE1G?=
 =?utf-8?B?OWJMeEN1Q0ViQjhvV3ZTMjBXdTBCdlNNeE1qSlhzS3EzMWlKeXJyZTRnZjJu?=
 =?utf-8?B?bTNUQ1BuUmduQlUyTzViVFhSWEo0UExUc1ZWbjRFTkVocUoyMjJKemxkTjBi?=
 =?utf-8?B?VGdIRGx4b1dSWlRSdCtOekY1dHVVcjkzTVh4Q1RWV2lpR0NoN0JlNHVLQlBP?=
 =?utf-8?B?c0pTYjRUOFJvV3hkNVBRUFEwVXJIb05XOHNqM3JEQmpmQTlna2h1dC9lNW9E?=
 =?utf-8?B?RUZMdlZnTUdBOUVtYmtHQXU2UzNsQ1g5aWt0RE10aS9BbDhHWERFcUwwaUZO?=
 =?utf-8?B?TGJ2c01GYzlTNC9QN1ZSUkdONytiV1FkcVFRQlhkTHBxUmRoaHQ3SUNCUEtP?=
 =?utf-8?B?QSsxOXdBSTFjSGpteTlmY1JvRzJNVUdkampXcVdiM3VJSFFuTTgxM1JWMm56?=
 =?utf-8?B?MkhFSUF4MGx3L0dMemtZSmtZbk5hQm40RTVDcDIvODRuYkxqNDVBQU52dUF1?=
 =?utf-8?B?RDkzK200bGNCRmNUejNna1R0WjM0d2ZOZlZLZUZsM2VQNVVOejB3Qm5GdjZF?=
 =?utf-8?B?NTAzeUpXbVFlUDFJbWJXTlRnUFhDa0tUOWplNzg2c0JvQncySFQ5eDRsL3pR?=
 =?utf-8?B?cmhSVXl6dkNqWlhmOWFuSUpabkFkWlZGamhMMm00VitQNEY5MytVVEd1bWVj?=
 =?utf-8?B?MkFzdDZMZ1FSc0FWVWFkL2FiZm1sdVIySlRSVllXRFFETW1leUdSREdyS2pn?=
 =?utf-8?B?VnpRVE16b0JRb0hJejJqYnk1eVBsSDVPVWFHSW9tT1NHYUZSMmxXOVIyWU8x?=
 =?utf-8?B?eXNra2JiM1RqeWgvd052blcrMkRCYTY4S0xxU2VvZVU5NUpFcmFrSlBJWDg0?=
 =?utf-8?B?K0lnMFEyQXMycEFDalpsQnJtaUtUMEFXMVpjd3VYVGtvcG1LSnpwQ3VacVJa?=
 =?utf-8?B?dWhDVjNvQWFET0M2Nm5zREVydjJaTGE2MWw2WUYwZ05JT1V0a2RwNHRDUnFN?=
 =?utf-8?B?UllXRFk2bnpBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6435.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlRjWGJyTThISEgwbWhhY0pIMFdxNUExeVhZb0hJMURVR3VaZzlWcUVyckZp?=
 =?utf-8?B?eHBsVERPZDRhUHRkTUJCeDFlMmZESGROQk1GbWtpdE9MRStibStRcUJjMUlu?=
 =?utf-8?B?Wm9nS0owWDBsNmp2aXNWWWlhZzg3Y2RMY2FnMzFoMWVOWnNROTZpOE1QRmZm?=
 =?utf-8?B?K2w0UVB1YmJZZC9ZeVpZWXlFOGJxMlR4dGlEb0U4ZE43dGdIYWVtOUw3Ly9X?=
 =?utf-8?B?cUlrL2kwaU4wbzFPZ1lVZWx1V0IvYkJBd1o0Q1Q5ano1ajhhMUVYUWxETTlW?=
 =?utf-8?B?VndOYTVHWTJQVkZ4VGpXT3VJVXF2UzB6bUhHdGljSEdhOXZnSVFkejIrbytK?=
 =?utf-8?B?QWZpQVJhbHAwd2E2UDZEK2VXRVhtc3lvUC9NcjVKbU5aT2FLOTJTdG1lOTFs?=
 =?utf-8?B?U0RnRy9DM09seHdNRWJ2WldFRVZWZGtseGo3NXpzY3pGbEcxaWk1VHFlVmtB?=
 =?utf-8?B?eGNvemF4cEc1VDF1RUhTRTg2Y2VPMm1nK0dJMElMbU8vR1VKQlJKN1pXWlE4?=
 =?utf-8?B?ZC9jUEUyV2kwMTRxZzNjNU1QVjYyMWpiS01HaEc0cjJrYTBFUkxndDhqNzBH?=
 =?utf-8?B?aXk1eTEwQ2xHUXVCWVl2Y1BRWE84bjFRWEtFcklPZ2VNVjVRaUFRK2lTMmhl?=
 =?utf-8?B?UWZSQ3ZBWmpCSDVaODM5UVFobDczNWN1dllaSVdGNHZqODNwQ29QNFRZNkNB?=
 =?utf-8?B?RnV0VEJTYUhGOWNMOURWK1lVd0Y5YlFuUlZ5aUtidVdUbW93N0xTL2dPaFA2?=
 =?utf-8?B?dUZnd3hvMytWVzZLeWZLd3BuYUlsVzFOendlRmg3NnJUOFpaaDFhdmI2Wk12?=
 =?utf-8?B?aVo0N3huMWJJU2tmYkxXTTJrTUhBSjNXYzVIaHZIdExINjk3QWtSd3g4TDNU?=
 =?utf-8?B?clRJVXE3d0FyU1dnQ2pRRFVyL0NWZXJJeHVBa0xVQmJxdGc0amdJMFpUdDBl?=
 =?utf-8?B?b0tXVE5pSFZpREJNcmhwSkx3bEpGc0xRUWRGSWhLNnArdHRMdklHb3Y4N3lM?=
 =?utf-8?B?cjVrN1VMck1hcVJSaXJjUG1sQlNvdGxIb0xKS1JMaU5OYklzM0JxNVZ6LzNa?=
 =?utf-8?B?YUh0eC96WWtYMHcxQUMzb3F2eGd2UG5ZQUF3NS9BYjYzbVk1VHhxQ3JKUE1v?=
 =?utf-8?B?Qy9TUlRFSDNpRUZsWk04M0QzZHB5NTBNalBBUGZCYnhKbTc3VTNDcEVGbjhV?=
 =?utf-8?B?alJ5bmk4NG5jK2dmNm9pZVhWUTZqSUNLaW1vVjRMcmcybDB5TDhSbTlIMnJi?=
 =?utf-8?B?eFRtckZZcmlXTjlrMXdhMEhxSm1OUEVMN0FXSW5ZZU9qYXlLcEc3T3ZFOWxH?=
 =?utf-8?B?NkF4Tmdpb1pFajAwbjVka2Irajg3YlZLckU0T0h3N0QzN1p0L2daUEM4Rmcr?=
 =?utf-8?B?WjhHY3NhaDc3RzhCODlvVjBrK1MzNUpoZUpXQmVvenBUVmpFT1F4enhvUFBQ?=
 =?utf-8?B?Q1FOcnZLVFBMWjlIbkp1Q0dPWTNHb0grWERXa0tFZDJiSzI2c1c4VXNRVmZz?=
 =?utf-8?B?a2V3VEduWWZLcXE3eWY3YjNhZC9PR1pHMWxaN1hDbjltOHNIZTNVNVRhbG84?=
 =?utf-8?B?dEt3RFIvcll1T1R2VFJKYUZDZk1ic0R6RGtyM0ltVEMyK20yU0hvMXlrS1pO?=
 =?utf-8?B?Qy9hZXRNMDgrbUxLMk1ySGR6UmZLaUtrVnJrSWIwcGM4RVFQKzRiWk9lSXZE?=
 =?utf-8?B?QzllZTNibGJoWmE3RTl4eXlUNWtoRm5NeEhNRmJndU5sMTZ4Z2dNcFlQenRw?=
 =?utf-8?B?ZHU0T1ROVU9SS01NSVFVMTFLTDhuTGtiM21PWHlkK1A0Zmc4TlBnWUMvcnFV?=
 =?utf-8?B?YXBiSHBWd0ZHQU93QnQrK1FXZ1A4dEcveC9LTkVCd1ZkSDJxckgxRXVvemNr?=
 =?utf-8?B?Z0NFQmxGdTFaenRsS3N3RWk3MWdTK21YTUFNUTFCTUpCdkpKcFU4bjV0dTUx?=
 =?utf-8?B?R2h6OGxOQUUwZmRsalAzZkdaMmdlRlQyT2EvYUdDcFRGQnh4SGZjMHZWa1ZG?=
 =?utf-8?B?N2xTQVVnendTbVY3UHRSeDRuYWtlM21qdGdBQ0hGNFVQd2NNdEx6bXhvaERh?=
 =?utf-8?B?OGwvTmtYaUR3S3ZRRElFQzlNT09yU2J0SXdCK2U1NkNzaElIa2dTTDliNzEy?=
 =?utf-8?B?ZjBQRXd0WDUyZDBRc3FkVVIxSW9LbE1lZmdVTEdkYUtXYmdkYmZtVnUwc1lS?=
 =?utf-8?B?dFl3RHFybFZrNWlnUHQ1RDhkUUpiWHBjcTJwUlRyNEZxYTBuN1VQRWI2aXJH?=
 =?utf-8?B?K2FlZk9hMEFqb1czUVFmTTRNSzhpYlRueWhJY2dYYkFST3RMTmVHenM0VGlM?=
 =?utf-8?Q?DEZYMDunPTx7mbOE4G?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3795ff-eb83-4b26-b7d6-08de52a94e09
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6435.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 13:40:24.7943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30jjD8U9EdntDc7pwPmFjIxZrfqxgV3rZNT2uZyHtHOV29n8g49t1e/ZyV9tOoHvMjCxDFel13HXIaQw1YfteQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4071
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6778DA0017
X-Stat-Signature: 4pru419jwcbjk8911u57ohe5uointppp
X-Rspam-User: 
X-HE-Tag: 1768311628-244227
X-HE-Meta: U2FsdGVkX19EKz3fO1H0QBDbn4dcAWt1vxTeIOybdNFodZAWVL73JMT+f4Wa7lllP0fdJ/p2j5EX6BDcRRoAyGgH5PG4hdB6IXMuDiDtW46dK1QNyf6Br06SoZ2d1YQ0MAFSaRSVjIVrwrQacpA03B/yfDyhN3RLG4kW5SIt1BRzGTBJFoOByUJpwoUSrd+V4A9/1I7ywLZrjgxzWxHL9Zwk8ImBw8Bw7BU53MAxi394cie2pICL9ZR9lI1FwRIjAq0z1ibNRnXp43SP9O+t2Zi/uP6TkC5lnTHAUXVEKT2JPu2wkVdfust3iIr1D988NFpxdjZwCRXZpZd6gKMYEp3p/BGoCaSaM2QYJ8jq/t/qxGUJX1BzC3iu12QAGam9qhCv+PnXStv8fjc4POVWTbZQlvKJAJTwLOW6QXHfRxjI0CWtA5B4ZSJzpBDXT5I3T9nfAU3Kaa0eRLv/Rol83Q1YbxusNZxrvPIKmv9UY43J+zGCY23zWqtlMc1rFtd8IblnJPoNyOvUCYysr8oRVNoWQd5M8GxTIQE/TELSyfU6rGTHYG1LVf5zmjDjLZFqJ+PlLmOo5NtZpEh9YkSp0pzbSkzaMNld36hIsHoI7bH+F9Z40NrLasDavV1PAvrIf51zDaHM76YbwKSlId0g8+BN87zzGhtWpeB4CX+zqvtzt/2joKzFK5lc+0t2O0FR9uxRohMUodvzm9Q/zERaDL86f9/xld1+MMpH/u+tZClyxyVvgNJuuCXCDFyF88ckluj/bMQk3+Rf5l/fwhVqNixbWwD3tVJOGxA03bkpAseDCPgL2oENCdpJU02TCzYQB9e5aJU17VqNG0OL88F0U8RMzRT08O22ecvNLVnvC3tPZ/clDT+ZUX1hKf0PfBPYLWpqdGeNV1KtoXMNXeu7vWEe3Ycs9TJjp9AZWRh9R6mG/FtdMk7hBT2d5HAMyqQis6Ge3tLKm6rJAyg8KHj
 HQWj4SMP
 ngCaA2xVcktmW6ghPlSWtomwVi283rnuk/FJhA5hdKL5Jg+wDae/FDcW11OZyY7txGsqIKqx2ZTsQ9FVpXQ/4bUDNTLFfIpsoM/ez3Cu8oohAc9EINz0XkSJ+eg2LpMuSZGUMFlWqqt67ygC+Xvxj0qKvcnpA+4gTj+yUYMaf1ZmEmtP3G5cqs1Ra0kY1+GNZhOOSETqk8IBAw7ZDZx9c1nx6n5NBckM3sy58Qg4lSRB8bQKBMuM0FsaairakmKTvnT7E4U7c1x4KCfUnT8Rhoi7mE55SRRMa306TSUKNPfcL8coXEYaJeWQBesW0bINdrMm1TuYa6Oxi6SJ9tUdJ4Y7rj+Yo9JHDVtpFtT2x8FrxSciuKFVeSPaWIE+vIxp7tWgr3vvmVyHQoUfovY42+eOBez0vP20yNB+PpkeOmqXMfQMQi0mOyQUHw5EdliauHf8o3OZHVwcpUznLzGgCexK4YU4Z1+UI5jKsa5pzEhqGf9JRIT7e1MVIDsTwBoKBSjJSkYXvZSskodaCKEz/drIiDfaY3R2du7ofASCWKeoA+yWZ/l0DNzX7UneNiA+fssJifZm3rHL58fThiilGr2llZioyPNcy8X7EoT2DWgj86v0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Felix,

Thank you for the detailed technical guidance. You are absolutely right.

I will follow your suggestion and will work on the DRM HMM integration 
path you proposed.

That said, I believe moving towards DRM render node APIs  will take a 
very long time. DRM currently lacks SVM support. SVM is a critical 
component that affects almost every aspect of GPU computing, and porting 
it to DRM is a massive engineering effort. Realistically, KFD and DRM 
will likely need to coexist for the foreseeable future.

For this reason, I will also continue to simplify the current KFD-based 
implementation and I work on the long-term DRM solution.

Regards,
Honglei


On 2026/1/13 04:51, Felix Kuehling wrote:
> 
> On 2026-01-12 06:55, Honglei Huang wrote:
>>
>> Hi Felix,
>>
>> Thank you for the clarification about the render node transition.
>>
>> I went back and checked the relevant DRM code, and I found that it is 
>> missing some infrastructure and it seems like the SVM is not supported 
>> in drm.
>>
>> And most current hardware platforms utilize the KFD driver, we must
>> rely on the KFD infrastructure to enable this functionality. The DRM 
>> stack currently lacks the SVM infrastructure, and building it from 
>> scratch is not feasible for immediate deployment needs.
> 
> As far as I can tell, you're not using any SVM infrastructure. In fact 
> you specifically made the point that SVM wasn't suitable for your 
> application because you wanted to map non-contiguous CPU address ranges 
> into a contiguous GPU address range. So I don't understand what your 
> dependency on SVM infrastructure is here.
> 
> The DRM stack uses HMM under the hood for its userptr implementation, 
> which should be quite similar to what KFD does. The difference is in the 
> MMU notifier handling. I guess that's where some work would be needed so 
> that amdgpu_mn_invalidate_range_start_gfx can invoke 
> amdgpu_amdkfd_evict_userptr to stop usermode queues. Or maybe some 
> allocation flag in the userptr BO that tells amdgpu_hmm_register to hook 
> up the HSA MMU notifier.
> 
> And then you'd need to add support to the 
> amdgpu_amdkfd_restore_userptr_worker to validate and map userptr BOs 
> managed through the GEM API.
> 
> I'm not saying this is easy. I spent months trying to get this to work 
> reliably for DMABuf imports a few years ago.
> 
> Regards,
>    Felix
> 
> 
>>
>> Therefore, I plan to continue with my previous direction to find a 
>> "minimal impact" technical solution within KFD.
>> Regards,
>> Honglei
>>
>> On 2026/1/10 10:28, Honglei Huang wrote:
>>>
>>> Hi Felix,
>>>
>>> You're right - I understand now that the render node transition is 
>>> already
>>> Appreciate the clarification.
>>>
>>> Regards,
>>> Honglei
>>>
>>>
>>> On 2026/1/10 05:14, Kuehling, Felix wrote:
>>>> FWIW, ROCr already uses rendernode APIs for our implementation of 
>>>> the CUDA VM API (DMABuf imports into rendernode contexts that share 
>>>> the VA space with KFD and VA mappings with more flexibility than 
>>>> what we have in the KFD API). So the transition to render node APIs 
>>>> has already started, especially in the memory management area. It's 
>>>> not some far- off future thing.
>>>>
>>>> Regards,
>>>>    Felix
>>>>
>>>> On 2026-01-09 04:07, Christian König wrote:
>>>>> Hi Honglei,
>>>>>
>>>>> I have to agree with Felix. Adding such complexity to the KFD API 
>>>>> is a clear no-go from my side.
>>>>>
>>>>> Just skimming over the patch it's obvious that this isn't correctly 
>>>>> implemented. You simply can't the MMU notifier ranges likes this.
>>>>>
>>>>> Regards,
>>>>> Christian.
>>>>>
>>>>> On 1/9/26 08:55, Honglei Huang wrote:
>>>>>> Hi Felix,
>>>>>>
>>>>>> Thank you for the feedback. I understand your concern about API 
>>>>>> maintenance.
>>>>>>
>>>>>>  From what I can see, KFD is still the core driver for all GPU 
>>>>>> compute workloads. The entire compute ecosystem is built on KFD's 
>>>>>> infrastructure and continues to rely on it. While the unification 
>>>>>> work is ongoing, any transition to DRM render node APIs would 
>>>>>> naturally take considerable time, and KFD is expected to remain 
>>>>>> the primary interface for compute for the foreseeable future. This 
>>>>>> batch allocation issue is affecting performance in some specific 
>>>>>> computing scenarios.
>>>>>>
>>>>>> You're absolutely right about the API proliferation concern. Based 
>>>>>> on your feedback, I'd like to revise the approach for v3 to 
>>>>>> minimize impact by reusing the existing ioctl instead of adding a 
>>>>>> new API:
>>>>>>
>>>>>> - Reuse existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU ioctl
>>>>>> - Add one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
>>>>>> - When flag is set, mmap_offset field points to range array
>>>>>> - No new ioctl command, no new structure
>>>>>>
>>>>>> This changes the API surface from adding a new ioctl to adding 
>>>>>> just one flag.
>>>>>>
>>>>>> Actually the implementation modifies DRM's GPU memory management
>>>>>> infrastructure in amdgpu_amdkfd_gpuvm.c. If DRM render node needs 
>>>>>> similar functionality later, these functions could be directly 
>>>>>> reused.
>>>>>>
>>>>>> Would you be willing to review v3 with this approach?
>>>>>>
>>>>>> Regards,
>>>>>> Honglei Huang
>>>>>>
>>>>>> On 2026/1/9 03:46, Felix Kuehling wrote:
>>>>>>> I don't have time to review this in detail right now. I am 
>>>>>>> concerned about adding new KFD API, when the trend is moving 
>>>>>>> towards DRM render node APIs. This creates additional burden for 
>>>>>>> ongoing support of these APIs in addition to the inevitable DRM 
>>>>>>> render node duplicates we'll have in the future. Would it be 
>>>>>>> possible to implement this batch userptr allocation in a render 
>>>>>>> node API from the start?
>>>>>>>
>>>>>>> Regards,
>>>>>>>     Felix
>>>>>>>
>>>>>>>
>>>>>>> On 2026-01-04 02:21, Honglei Huang wrote:
>>>>>>>> From: Honglei Huang <honghuan@amd.com>
>>>>>>>>
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> This is v2 of the patch series to support allocating multiple 
>>>>>>>> non- contiguous
>>>>>>>> CPU virtual address ranges that map to a single contiguous GPU 
>>>>>>>> virtual address.
>>>>>>>>
>>>>>>>> **Key improvements over v1:**
>>>>>>>> - NO memory pinning: uses HMM for page tracking, pages can be 
>>>>>>>> swapped/ migrated
>>>>>>>> - NO impact on SVM subsystem: avoids complexity during KFD/KGD 
>>>>>>>> unification
>>>>>>>> - Better approach: userptr's VA remapping design is ideal for 
>>>>>>>> scattered VA registration
>>>>>>>>
>>>>>>>> Based on community feedback, v2 takes a completely different 
>>>>>>>> implementation
>>>>>>>> approach by leveraging the existing userptr infrastructure 
>>>>>>>> rather than
>>>>>>>> introducing new SVM-based mechanisms that required memory pinning.
>>>>>>>>
>>>>>>>> Changes from v1
>>>>>>>> ===============
>>>>>>>>
>>>>>>>> v1 attempted to solve this problem through the SVM subsystem by:
>>>>>>>> - Adding a new AMDKFD_IOC_SVM_RANGES ioctl for batch SVM range 
>>>>>>>> registration
>>>>>>>> - Introducing KFD_IOCTL_SVM_ATTR_MAPPED attribute for special 
>>>>>>>> VMA handling
>>>>>>>> - Using pin_user_pages_fast() to pin scattered memory ranges
>>>>>>>> - Registering multiple SVM ranges with pinned pages
>>>>>>>>
>>>>>>>> This approach had significant drawbacks:
>>>>>>>> 1. Memory pinning defeated the purpose of HMM-based SVM's on- 
>>>>>>>> demand paging
>>>>>>>> 2. Added complexity to the SVM subsystem
>>>>>>>> 3. Prevented memory oversubscription and dynamic migration
>>>>>>>> 4. Could cause memory pressure due to locked pages
>>>>>>>> 5. Interfered with NUMA optimization and page migration
>>>>>>>>
>>>>>>>> v2 Implementation Approach
>>>>>>>> ==========================
>>>>>>>>
>>>>>>>> 1. **No memory pinning required**
>>>>>>>>      - Uses HMM (Heterogeneous Memory Management) for page tracking
>>>>>>>>      - Pages are NOT pinned, can be swapped/migrated when not in 
>>>>>>>> use
>>>>>>>>      - Supports dynamic page eviction and on-demand restore like 
>>>>>>>> standard userptr
>>>>>>>>
>>>>>>>> 2. **Zero impact on KFD SVM subsystem**
>>>>>>>>      - Extends ALLOC_MEMORY_OF_GPU path, not SVM
>>>>>>>>      - New ioctl: AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH
>>>>>>>>      - Zero changes to SVM code, limited scope of changes
>>>>>>>>
>>>>>>>> 3. **Perfect fit for non-contiguous VA registration**
>>>>>>>>      - Userptr design naturally supports GPU VA != CPU VA mapping
>>>>>>>>      - Multiple non-contiguous CPU VA ranges -> single 
>>>>>>>> contiguous GPU VA
>>>>>>>>      - Unlike KFD SVM which maintains VA identity, userptr 
>>>>>>>> allows remapping,
>>>>>>>>        This VA remapping capability makes userptr ideal for 
>>>>>>>> scattered allocations
>>>>>>>>
>>>>>>>> **Implementation Details:**
>>>>>>>>      - Each CPU VA range gets its own mmu_interval_notifier for 
>>>>>>>> invalidation
>>>>>>>>      - All ranges validated together and mapped to contiguous 
>>>>>>>> GPU VA
>>>>>>>>      - Single kgd_mem object with array of user_range_info 
>>>>>>>> structures
>>>>>>>>      - Unified eviction/restore path for all ranges in a batch
>>>>>>>>
>>>>>>>> Patch Series Overview
>>>>>>>> =====================
>>>>>>>>
>>>>>>>> Patch 1/4: Add AMDKFD_IOC_ALLOC_MEMORY_OF_GPU_BATCH ioctl and 
>>>>>>>> data structures
>>>>>>>>       - New ioctl command and kfd_ioctl_userptr_range structure
>>>>>>>>       - UAPI for userspace to request batch userptr allocation
>>>>>>>>
>>>>>>>> Patch 2/4: Extend kgd_mem for batch userptr support
>>>>>>>>       - Add user_range_info and associated fields to kgd_mem
>>>>>>>>       - Data structures for tracking multiple ranges per allocation
>>>>>>>>
>>>>>>>> Patch 3/4: Implement batch userptr allocation and management
>>>>>>>>       - Core functions: init_user_pages_batch(), 
>>>>>>>> get_user_pages_batch()
>>>>>>>>       - Per-range eviction/restore handlers with unified management
>>>>>>>>       - Integration with existing userptr eviction/validation flows
>>>>>>>>
>>>>>>>> Patch 4/4: Wire up batch userptr ioctl handler
>>>>>>>>       - Ioctl handler with input validation
>>>>>>>>       - SVM conflict checking for GPU VA and CPU VA ranges
>>>>>>>>       - Integration with kfd_process and process_device 
>>>>>>>> infrastructure
>>>>>>>>
>>>>>>>> Performance Comparison
>>>>>>>> ======================
>>>>>>>>
>>>>>>>> Before implementing this patch, we attempted a userspace 
>>>>>>>> solution that makes
>>>>>>>> multiple calls to the existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU 
>>>>>>>> ioctl to
>>>>>>>> register non-contiguous VA ranges individually. This approach 
>>>>>>>> resulted in
>>>>>>>> severe performance degradation:
>>>>>>>>
>>>>>>>> **Userspace Multiple ioctl Approach:**
>>>>>>>> - Benchmark score: ~80,000 (down from 200,000 on bare metal)
>>>>>>>> - Performance loss: 60% degradation
>>>>>>>>
>>>>>>>> **This Kernel Batch ioctl Approach:**
>>>>>>>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>>>>>>>> - Performance improvement: 2x-2.4x faster than userspace approach
>>>>>>>> - Achieves near-native performance in virtualized environments
>>>>>>>>
>>>>>>>> The batch registration in kernel avoids the repeated syscall 
>>>>>>>> overhead and
>>>>>>>> enables efficient unified management of scattered VA ranges, 
>>>>>>>> recovering most
>>>>>>>> of the performance lost to virtualization.
>>>>>>>>
>>>>>>>> Testing Results
>>>>>>>> ===============
>>>>>>>>
>>>>>>>> The series has been tested with:
>>>>>>>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>>>>>>>> - Various allocation sizes (4KB to 1G+ per range)
>>>>>>>> - GPU compute workloads using the batch-allocated ranges
>>>>>>>> - Memory pressure scenarios and eviction/restore cycles
>>>>>>>> - OpenCL CTS in KVM guest environment
>>>>>>>> - HIP catch tests in KVM guest environment
>>>>>>>> - AI workloads: Stable Diffusion, ComfyUI in virtualized 
>>>>>>>> environments
>>>>>>>> - Small LLM inference (3B-7B models) using HuggingFace transformers
>>>>>>>>
>>>>>>>> Corresponding userspace patche
>>>>>>>> ================================
>>>>>>>> Userspace ROCm changes for new ioctl:
>>>>>>>> - libhsakmt: https://github.com/ROCm/rocm-systems/commit/ 
>>>>>>>> ac21716e5d6f68ec524e50eeef10d1d6ad7eae86
>>>>>>>>
>>>>>>>> Thank you for your review and waiting for the feedback.
>>>>>>>>
>>>>>>>> Best regards,
>>>>>>>> Honglei Huang
>>>>>>>>
>>>>>>>> Honglei Huang (4):
>>>>>>>>     drm/amdkfd: Add batch userptr allocation UAPI
>>>>>>>>     drm/amdkfd: Extend kgd_mem for batch userptr support
>>>>>>>>     drm/amdkfd: Implement batch userptr allocation and management
>>>>>>>>     drm/amdkfd: Wire up batch userptr ioctl handler
>>>>>>>>
>>>>>>>>    drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  21 +
>>>>>>>>    .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 543 +++++++++ 
>>>>>>>> ++ + +++++-
>>>>>>>>    drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 159 +++++
>>>>>>>>    include/uapi/linux/kfd_ioctl.h                |  37 +-
>>>>>>>>    4 files changed, 740 insertions(+), 20 deletions(-)
>>>>>>>>
>>>
>>


