Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3DB1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB036B0088; Fri, 20 Mar 2026 09:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1DA6B0089; Fri, 20 Mar 2026 09:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8016B008A; Fri, 20 Mar 2026 09:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 005976B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:32:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0A66B70BF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:32:08 +0000 (UTC)
X-FDA: 84566529936.24.B5272DF
Received: from YT6PR01CU002.outbound.protection.outlook.com (mail-canadacentralazon11022095.outbound.protection.outlook.com [40.107.193.95])
	by imf19.hostedemail.com (Postfix) with ESMTP id 81C561A0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:32:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=iiIVQ17q;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.95 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774013525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euh5OcS9euhYAEwp44Kv5PxdvVQVVcQhqzS5c8ceE4c=;
	b=qcpjDxsKPm8Nbra75qQn+bUD5iD7Fu2QU2XYWD+UPQV11ut8+MSeK8HyMVJXI4miKVFZDp
	/MNYM31BvAafdVhag3sJz8n30zUWsY9/656HAcg1iq73HzvOyd+Uz5JmTaamuyMSprwNx4
	bipH+jLQ7UlAb244oKTax+GDhIq8F+0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774013525; a=rsa-sha256;
	cv=pass;
	b=Gyu2MiHBuadIkU6aItViUYLqvOLE/KdxjJkfO9ICUBV9kC0FdzGfRWuWTo++0xg8RPClsA
	Ph8Gf5gIVUWf+vR+wxV1/cEmU5BhdOndu72EieBXdxqw18s5L1yEdshMz33riEv8dNViYl
	Do9s2em2sfvNdNp2/0bAPAJssRPHvik=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=iiIVQ17q;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 40.107.193.95 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J2FxIj9CmWLF4Rlsi9DFmqMEltwGfcYnN3ct/252uADWUHHWlOuFCsxi4w7eh0QFRGAS/AoL9oe2esUONGUvpNitMPRN/bzaR6mT8E1AP+6JcImxlAo+Uw0R3yPrrj/lWZY2qdUegv4+g95Ys9tIG9dfBsVFxkL/4Mji6BeLR0eGBEhGzoEzjpaEXd4b1viYogOJLlYAabdA4frYdaYpmB+A4EF2sgPQIC87dHY5fu8VHiJmdMGXwtmjRaXp9QppYlj+ztpJETTdBRXFNRJ/7MwpXC74IW0a4v6aWwDe+e9+R+ovOpXxXqsx/0sjJHyJrqtWorK8fydnP67HARqMLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=euh5OcS9euhYAEwp44Kv5PxdvVQVVcQhqzS5c8ceE4c=;
 b=xsbOeSnaVAfrP4mCm4pAOWbhM8Ra/TR3Crg80zwhCM18Bv5iilEo6boL/KiFnLm0PTLtLiIDvzE+CPgnOt+elS6A6YCQgACbqngPQpf3Z/9fyZdsbxlPRVg4QOV+1/uI2HJUB0Fga4A3cyBbv+PvoUxl6Q3IQLV5CZQsr/3gdWNeLdlj5lg2qiVn0WNAKAcyIMFEGixY2glc3fIB/eROrRe/cskjvhk2ljoRB1HgixN8bNLEIIyn4zi4ME63JDCFgeF28QLE4IMPv/xHS2JUUymw0rlXoBfJ28RE5Cccv0XIA30uafgTGANOApKCM0k8a/pdpAs4lvjdI7KI1TRRhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euh5OcS9euhYAEwp44Kv5PxdvVQVVcQhqzS5c8ceE4c=;
 b=iiIVQ17qF4oIvneOS+vf8+5OD/Rrkic75RM5Apca0iNLW+cAlzInj/QvOfFCRce+va4ODIhddA5m3nAyrTbRfgnayzRjTrkpMA3VTHtf7M0gHKZUIvCxIeFyJif0GOYKWxP8MXlJ0xMNeLyB90WUb43VkogzBXsx0vNlGLJ6uLCor7dVA/TwJc2J/SfJBxFcbycdu78+fR0Ji8VNiekSBIh40wlsQvIwAmFxCu/F9StJDwpC7hsLceXW0yvBruwFxVmBzeCLwFqiu3dz/3Q4P5wecMFo+eVx3roDDqgi9t2X5WzbGJtijKYnLGa7p1rc5D7wowKnIRQFsHy+t6SZPg==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT2PR01MB8438.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.22; Fri, 20 Mar
 2026 13:31:58 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%3]) with mapi id 15.20.9723.022; Fri, 20 Mar 2026
 13:31:58 +0000
Message-ID: <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
Date: Fri, 20 Mar 2026 09:31:57 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Michal Clapinski <mclapinski@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner
 <tglx@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com> <ab1J9ODkX5iChu-C@hyeyoo>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <ab1J9ODkX5iChu-C@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::24) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT2PR01MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 82068799-6116-498c-7f3f-08de86850fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IatTAdeCCT64RG4ZE55RJsgtcYGblHZMpURWOgMD5qn/qn49SyAZU1ob4t1WBzIxcrZYfSITWALBpNshBBklzUTeE5o/euoRVa1BhPX16kSFZNXGH4Yb/EvIFXjKo23bstaWctoLP7t7dS+B3lhjZtn5oW1J2DnTAcZy2PaLaua4BBl/JHpBUGDfwKtSUkSHXuKm3o3KDxh8u/x4mPMRJwcJQUVs+5FIrmqjmYiu2sKncwM/DU55hes3UsZwOAaAWPvXkJ0vRyP+MKe7bpzj7DsBTKGN3g0SHNBZ+4qluQw6Gy2trUbkJhwYt+FMNy1vXHRK5bpbh+E5XNF2Erba6gkKYZLEGHFJd0Z5S0BuYifZLxrNBrt23duTYA8Ay9Y3d+w+BHaJXt7zVL9KbHx//c/MzDniFlUXYHNVxGXsy5wJ41dwcsvpgc7GpnSIjB6EmoWz8y6TkNC/dr8zno9oCCd4B3pXddGVJiQl+16cGNaMQyut6QOrBA4kP8pq2EFx92N5jIqCSu+XgVVBSihr0NOtxTjf5LgFtCBdk7cP93RaIj4CHoS6RqQL4MqCzFkOCat1b8sIAGwZn3KVIJi8owkyuslG/rMdn9rP8DtH/oYO/2faOfLgJDdmjsAa5ORrTbjFmdU7eHpPKjz3Sl2TiRV3Y9RjgJX6fEzP9NZoZFrBhOMVUlrhh/j/wjKcmjjI
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHVlK005TkVKTWFNcXozMjY4YWhMUmhzVU84NStKVlVJc1JxZk1UdmxQd0Mv?=
 =?utf-8?B?Wm1Yb2tTUFhac3NKYjVTenNTS1E5VnhXVXBvSThZZjJETDFVdDJSdW0wWmF2?=
 =?utf-8?B?eW9NQ2V4R1FKY0cvWXo1cHEwalliMi9GTHJEUExUaW5kc0xQK0RteTBXaTRl?=
 =?utf-8?B?MWlUcmJJMWpWWEliTitZMFFBYzZwbjFFYzhoVmJNNGJ5NHZlb2FKMDhTUjFW?=
 =?utf-8?B?ZXRDOEtmdEY2ZUlQZUFEMmF0QlVwZXF0WDh0SHl4aVJTakJUQUtzdmNjZ0xU?=
 =?utf-8?B?SkZtR0NLdjVHNmhtNHZoenB5OFhmMFZjTThNelA3bXBaS2hZeW5IUWRER0lS?=
 =?utf-8?B?Z2tyMC9VYmdqbTkzQ0xKUVpiYkRMZmI3QU12d3ZVR3Q3bUNPTkZmaEFpZGVq?=
 =?utf-8?B?b3lXNS9nSHZ4WHY4R3dSZzhKZHV5cGYrRUR1c0JQR0ZpK3g0ZWhIV1ZJL1BQ?=
 =?utf-8?B?alZpT0F1bkl3eW5ta00xTUM1UEp5WmhqSERJMmtUMGF6dkdmbitGWDFFY3E2?=
 =?utf-8?B?TWtSUExFTmpWQ0JZbWxmMWg3QitqT0FrUGlSMXZMTzdwNW5aUjd2WXZ0TDB2?=
 =?utf-8?B?aUQrVGdHSGRhb1JuVGtMNkYrQitzVHkxbHZSQ1FJQ1FaNU9PTWNyTDRocERZ?=
 =?utf-8?B?emFKU2UrVjFPelJNYkQ5YU5sRVdmZVJNcXdFdDk3dGNmKzZUdVN3a1pCdVBn?=
 =?utf-8?B?WVZkVnFJS1d4Sy9EdGc1QSsxKzBKc1hVVW5KbmlUTTNmYS9qVnJWVjRES2I4?=
 =?utf-8?B?Y3JrWXNEdTY2QUc0KzVndkc0QndvcW81TitpVW96U3JrVkJMaTNzbE1vOTNI?=
 =?utf-8?B?UitnOTR1Sy9KLzNiQkpoSmwzTS81dFRydFFiNzYyVWxiMEJMdGorUWdDK2VT?=
 =?utf-8?B?K0Rkc2E1N1B6TFhOaFdMTTlZQW1BanYvT3NobHhMQ2laUUtBRld4KzRLb2Ns?=
 =?utf-8?B?WEUybVNWWmMzTUJKeWMyZjBRaFMrNzB3b0dpZkdiSHNBSGV5azl5QTk4eFdq?=
 =?utf-8?B?SmJWdTZwT2RpNHl6N1FpREVGSFhSTXlsSmc4ekxIYU80OVRpYUlURGxYa0pJ?=
 =?utf-8?B?LzdSRXVyT1ZwL2krczlNZXVYRXZnUVZwZStydVRFbU16VnE0b0hEM1V0NHdU?=
 =?utf-8?B?RWZQYjJzQnVXQ0tVSlFLaE1YZ2hETk9vWlhiY1JQdVROSHlCSWVmNm5SaWwx?=
 =?utf-8?B?VmdTOUJFbmdsc1BZQTJVWlBnaHNHODhJdHpVZGNXSkZuYUc2eVlCYTZraEZ2?=
 =?utf-8?B?MDdWSVNIamJvRHhlQW03eS9FZk1nakRBR2tqNWd2eDAzN2U3N0lCZ25Cc3Jt?=
 =?utf-8?B?eHEvTlhlcmpGR09MYWdHVlQ5NVlnV09zeGNQNCs3cjYyUHE0Wlh0SWh4cXR6?=
 =?utf-8?B?UmhtM1BCYjEwQU01VUpUNFpvRDVGV09NK3l5MVFMeVE1OUVWUUJjQ2RiYzJh?=
 =?utf-8?B?MCtreklONDR0a2NIdUpGNkg3K1FVWmNOTS9SOEViVXlGL24xODJ0NzhPbnM4?=
 =?utf-8?B?TGhOdnhmVUt3SWQvOFYxcy9DOThOWU5JWVZnaW9MRmluejBqQ1QxZEpadVpi?=
 =?utf-8?B?YktMSEpGMkhVK2NLSTBkbjNwcUsvU0hHYVNCckloak1TTzVSYy9JbjQ3aURY?=
 =?utf-8?B?dGluTE1Ca3pBYTJJNnVyQ1FJNHVGZEYzZW1SME1ia044ZEZhTmVoNDhrMlNR?=
 =?utf-8?B?Z1RJajB5NlZVTjFIbHFxejNJdk5FWmJLOW9UbUh3c2JFRmZZczRlOXlpOEFW?=
 =?utf-8?B?bkh6ck52cUJJcEhwV3M4ZGRWUmZaK1lSdERZL0o0eWtmWkpmQldpNTBHekJN?=
 =?utf-8?B?TmhGS2RzME9EalJKV3hVbmV1MGxTZ01WU0xhRXA3d1NsTElSNkRzYVVobFhr?=
 =?utf-8?B?K1pOR0ZRdHpVWGxsb2NSNHNRcHFMeXl5MlF3QlNERVhsaEg5cGpkK3pQc2Ri?=
 =?utf-8?B?cjF6TGZIMVVPV3YxSHY1OG5Oei81SmNxbUhpUlZDSlFoTjEyUEpsa3NmRTFW?=
 =?utf-8?B?N0o4QWZUa2hiRjVUNjhBZVpiU1dnOFZNazkxdStHbjNmNGVpQ0VYVnpINEJF?=
 =?utf-8?B?dHNnZVg0Rzg4UDY5ano3VGtkclhNb1JZTGUyK3BHS013K3dtUlgydnhJbWNC?=
 =?utf-8?B?QVRSRloyTTYrcVl3emx5MVVRZlFOUXVBcE92OHltNGZXT2VXY0RGUEIra3lS?=
 =?utf-8?B?TFczNVQrcDRNY05wLzRNSEpldHZ1aEs4bTQ5dHdDRkl6WjJ1aTA2WDRpVjFV?=
 =?utf-8?B?NjVLQ1Jodjh4SnhsZk4xNWVCWkpPdlZWNE02bEUxNHgrVG5kL1JndzFLTXBL?=
 =?utf-8?B?cEtWbWh6ZG9KTWRsZFBjMnlmQVRiZEhQT1QyTHFjdXBRNi85ZzVKbngwbHBC?=
 =?utf-8?Q?dlaYOy/sTe3s82bv+/ziXyXV+2yNayvw0uKr+?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82068799-6116-498c-7f3f-08de86850fc1
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 13:31:58.7818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: biqDI1BaxURJLyfnHGo+1nssRAiGjB97bmPFeVf1cV0vZ/qOHgJotj5El4gAK0rAeQTKb9DtT8KUP+oA3uXUsb+SY6cSwMsrGmmsK78dp8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8438
X-Stat-Signature: 167xrit9mpiqbmgp4o5xzigfmsi7ggqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 81C561A0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774013524-54585
X-HE-Meta: U2FsdGVkX1/bToJyPy3cDQEAgpTwJMaGW2zNJoIaaAYzX/rQY/wTZHJrE4cHW+Wp4yNSU7Gdmqi7oYNgD9Jbfla4T6m6Nq9fRya3ypNAQrrCBQqcuBYV0HURJnm7cPqc6f6udiNofZUqOyEwUwm/37xbwfCZkZSBTKxQiqsKU2Yn7tExOPQk1u3pizD3JEW+qkVqDt79q3agkiXCtbyyqk7VNOlPDZ8+bgxsT8iGlwGw+og8m1yt2M+/4YtyA0jbgc0C0Goyas2Kbv8t3PkzQa7kMVVZt75BMzu5DIfbY47J6S1aQpEpLgO9EJUz63fidi1vTd+CUqDH/ZdT0QWZ2YgrGLs09waEmlKW+ZfOytr8xrBxCPHiwypa+3mjv+yEFQz68yGWDO5QzoOLjrbybw3t1it79Uf30DmRcmHcllBD9rjMISjhzwzKAwdqVyItXYX3B6IBWdyHanjjePKwO9RtULTVyXRWr3QMGsRVwiGsIrYY8tOl4F9Q7Lb3iXfn36IxZIW5hzMQe9cQNgQ/Othna2uBwxfxFhqOukxqCFyFy2fd+GRLFWV+X9Rx7RlCWKEQ4c8xwjE1RIhOTQPTfLXUTY340XCL0qJokiwsezpCHx7bbVbMUvTYc+A3AEf5tPDrmu/vwcnD/UV8ztcU7pXv1maOfTrdI7MU+bNq22sm3qquYTsfk6YBd5IKZYv1nPh1CsN0QUk5V2YwLxIMrSKJHuqqfot5UYxgC81c5greEVKgrYNnZahl9ISpRqk72L8iiiSCsE6KWaQXMHByefCtG6mqIIuHvodDAmE84Kx+9hOVynMc20tBKX2fsuWd25DSwkq+UomFr1E6NU3Z2BbWe0RWv/goKFlXG8xhHWsEBiSAxaJVQWc4NYygSdsa7/ehl/QAUDeO9+ogv4GVEF2KK/YGH+KAqgbZ/rAUsjmYKiBoqgC7XgGZFHiPlcw+DbFOE7HOhtjghQ/z7i+
 /tXByHW3
 Fo9si+KbpIY3zTY5Gg5x8QQ5Xc85MmJPT8i0yVHJJq1q0JwYUUzdfPFSJ7Re40QWiF9sPhmvVne2wbF2E6EgT2GzarMjDVsj5IGlkwvjgAiu0R41qnsV4izjtGoLK1mFw8Qmn3xevn9NhDAgRb9Anmlrfpj8Tjcr3aim9vhiSVn3nXhdQ4Fr1MSmwehk+bXNxYrBSV12ccAaY74P9q6apG8gCCGSmIy+Yg+pcDNty6IWXNNah21Ii/9WtOU2Lgsmt2Ffm6cMN6ehthqVgzNiGhA+VVav+4AmMUwP3uVAkYvUY78hNqr1OMltVqu48rTyS9a8xvtgGV3x0CssmSKw8Wc6pxzfecXgQlkI242U3mySIoOHv8kpc/lyT68kB6dozNcT61exbFNrR3K2gZehBSFDbDwZDPTXBXomNJ6JaelcbHLezgKA8V2SZ6ZJIlote8jFlc8MACIgIupRuKp6boxGV9oFn9Let5X37G23pZ80zwPUEaeYjGvKGI0wcrXomnOkzOYSh0zr9RvSaHwwY9a11LN2EVKb/ZZUOvKx0xrqXNB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-20 09:21, Harry Yoo (Oracle) wrote:
> On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
>> On 2026-03-20 00:17, Harry Yoo wrote:
>> [...]
>>>> [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/
>>>
>>> @Mathieu: In patch 1/3 description,
>>>> Changes since v7:
>>>> - Explicitly initialize the subsystem from start_kernel() right
>>>>     after mm_core_init() so it is up and running before the creation of
>>>>     the first mm at boot.
>>>
>>> But how does this work when someone calls mm_cpumask() on init_mm early?
>>> Looks like it will behave incorrectly because get_rss_stat_items_size()
>>> returns zero?
>>
>> It doesn't work as expected at all. I missed that all users of mm_cpumask()
>> end up relying on get_rss_stat_items_size(), which now calls
>> percpu_counter_tree_items_size(), which depends on initialization from
>> percpu_counter_tree_subsystem_init().
>>
>> If you add a call to percpu_counter_tree_subsystem_init in
>> arch/powerpc/kernel/setup_arch() just before:
>>
>>          VM_WARN_ON(cpumask_test_cpu(smp_processor_id(), mm_cpumask(&init_mm)));
>>          cpumask_set_cpu(smp_processor_id(), mm_cpumask(&init_mm));
>>
>> Does the warning go away ?
> 
> Hmm it goes away, but I'm not sure if it is it okay to use nr_cpu_ids
> before setup_nr_cpu_ids() is called?

AFAIU on powerpc setup_nr_cpu_ids() is called near the end of
smp_setup_cpu_maps(), which is called early in setup_arch,
at least before the two lines which use mm_cpumask.
  
>> Alternatively, would could use a lazy initialization invoking
>> percpu_counter_tree_subsystem_init from percpu_counter_tree_items_size
>> when the initialization is not already done.
> 
> So this probably isn't a way to go?

I'd favor explicit initialization, so the inter-dependencies are clear.

> Hmm perhaps we should treat init_mm as a special case in
> mm_cpus_allowed() and mm_cpumask().

I'd prefer not to go there if boot sequence permits and keep things
simple.

I think we're in a situation very similar to tree RCU, here is what
is done in rcu_init_geometry:

         static bool initialized;

         if (initialized) {
                 /*
                  * Warn if setup_nr_cpu_ids() had not yet been invoked,
                  * unless nr_cpus_ids == NR_CPUS, in which case who cares?
                  */
                 WARN_ON_ONCE(old_nr_cpu_ids != nr_cpu_ids);
                 return;
         }

         old_nr_cpu_ids = nr_cpu_ids;
         initialized = true;

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

