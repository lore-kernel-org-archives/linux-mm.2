Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03898E9D407
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CE496B0096; Wed,  4 Feb 2026 11:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B696B0098; Wed,  4 Feb 2026 11:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F766B009B; Wed,  4 Feb 2026 11:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C97E6B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:12:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B247FC0DA6
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:12:13 +0000 (UTC)
X-FDA: 84407266146.03.0AC619C
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021088.outbound.protection.outlook.com [52.101.95.88])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD496140002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:12:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Vj3aH9/K";
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.88 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770221531; a=rsa-sha256;
	cv=pass;
	b=69RpKpMYiCpJo78fiUeYpAkB7fGGFV/gPmOMp1ZLtJ/jhElR9OAKnX/84DrrbYmMeT41pn
	VXqnw421dQmApglLVBQbyyXet1TFG6xhaVHsYWBSYh2/hXN7RYmQ+5jcnGuSXmFIDFUyk8
	GjrHWscXpgzco1+NoDg/rgbssjmgSgM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="Vj3aH9/K";
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.88 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770221531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aXWtCdZKUWdZpMQBoiMqDDwMeGpCOiWEQijuHeCqDE=;
	b=wemP63P7TeQhXn0Stu23gIrpiHZbetsDMe7JjRtsRNazSvjUioQetbxCZjnhP969yXJRcX
	H49pFeipmYYXtjlM7iOGbLIpCVYyb6rHrYlpNj0oYbhDLXNn/PiljIaz2yCkq2eJ36wN8O
	XAEy0k1M8z6eu28oeg7ugDx6VNimvcc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLkfe/IhbAqYTtvqHu86KWSuYiVAlzyOeMJUyeWZE4Laz4CH2A615vhz1HWi+dHrIDUwm5eMFVVYKn1fvwBRUP7DWVi4hQLBahFejJaAoZ+OzwGyFl+N736jZDj/i1uD5XXz13FXcLELQ9GCVBPIBcRoxFlJgVgYrNH5d6Kor1zzFQUDGd9Stjw33LlYJamst5RVlARa5wMAOOj2KtnlT2+BY3ql2IG6MhvdDRKjOMVIVhCVor/oFfKuVv5l7XuaHCDWr0TPaZyTGeC4u894GgPyEYRnou9vedDHEHf/+yXl8ucxEQAxh9WSToJYjU47VdL73c1Z4FUjEugZGqiHoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2aXWtCdZKUWdZpMQBoiMqDDwMeGpCOiWEQijuHeCqDE=;
 b=M1F0gOpUj4GU5JdZ6FrsswJfKNpnIgYWzmxzozDCc3661vh4PjFiJxzddutyPyn41w9oR6b4T+nQvvHlxXIVsovkbYA4i6hDDsslmv9fYPkp4PsRXA1hcVCAKWdVE82JrFbL9+FiP0YAm4TgVz9g7S+bRMQAICAxzg9m9PXw8G5hqrHsIbmzSt+ySK9Wy05XnwXIgcPx2KqvK37AC/kMYQeuoTB/CVZs5NIKMJ53NojTMzcshjbljFHe/WSWu3p7mF3UZbO8I7ChRjT+HkT1GOTX8fGzZvdkiokN8t2nZ3wJXi9vzIujtc0BzeSUppMCG/56BV3WQyaLKUWD2FpWYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aXWtCdZKUWdZpMQBoiMqDDwMeGpCOiWEQijuHeCqDE=;
 b=Vj3aH9/Ku19s6h/3fwdSajhYyDXvZX/4Cxhz6J7BJw5vFBOGd850wx+g0I0Xw+YcZ3S9uKy+kuzBUS7eKUnoV9xIodShgWl5cxYhT+Q0/Mt3JIYMtf2bMn0sDhO/UKJ3MXoJFRh/YwG5AB33kNiFq6EqR8sist79xVUrP/V46nE=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LOBP265MB8355.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:46f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Wed, 4 Feb
 2026 16:12:06 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 16:12:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Feb 2026 16:12:05 +0000
Message-Id: <DG6B5Q4FJTYT.32ZVBMHJ6OR3G@garyguo.net>
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
From: "Gary Guo" <gary@garyguo.net>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>
Cc: "Gary Guo" <gary@garyguo.net>, "Alice Ryhl" <aliceryhl@google.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun.feng@gmail.com>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid> <aX2tyn9nBUEKM-SN@tardis.local> <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set> <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid> <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net> <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set> <878qddqxjy.fsf@t14s.mail-host-address-is-not-set> <aYFKbWfQmTInYy91@tardis.local> <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87ldh8ps22.fsf@t14s.mail-host-address-is-not-set>
X-ClientProxiedBy: LO4P302CA0016.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::6) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LOBP265MB8355:EE_
X-MS-Office365-Filtering-Correlation-Id: 273e5acc-d40c-4d31-82f7-08de64082416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDZITFZkSDBRUldRUVg2aEs3bmRDREgyMWhySnFTWmZVS2kzMEVwZjJPT1RN?=
 =?utf-8?B?MWdOYnZnQ0JmU21LWk1IRm5kTmRJQWREb2RTU3Q3bEpWWlJFQ0hmQkpKUXVu?=
 =?utf-8?B?M3g4L0RiNDlLVmY5Zzc1L2xxK05TWk0xOFZjK1RJZU1DVFNGMlJLc3g3ZjVB?=
 =?utf-8?B?SnJmOTdSRUVndSszeTR2R1ZjMkxKQVBGb2ErSWhHSHlnQnl1Qlp2L0FUWS93?=
 =?utf-8?B?ekJIRmh6Y053MVcwM01HUTB1QlEwR3JwOW5FYUV4ZGlQUG43ejN3NzdmdGh5?=
 =?utf-8?B?S3VJb1N5bCsvdGZUTWd6MVkvelozRWloeTRNeWh1OUxsV0lmT29YVHpLTGV0?=
 =?utf-8?B?aVdhMGhuOUloMm5KMEJ3dnBUeXJLeTJlQWdaUXIrbENyUS9WODlSRWhRRXlT?=
 =?utf-8?B?anIvbStidHZMZUdKY0FHa3BJcXF4RzF6eFlWZXA3dFJkdFRZeit3M3lwZ1I2?=
 =?utf-8?B?R28rRXB2Y0lIREJNK3UzZmxvSlY4TUp5Q0lHZk40b0VDa0N6dTRxak53VTVm?=
 =?utf-8?B?a3pEQ0hBTHVxUjQ5dHZhYXl4ZThPTFF3dDJFcWVDNWUyWkxmaHBMalJ4TTl3?=
 =?utf-8?B?S0VvUlVCYmFqdSt5OXdjVFBPczFsdURUMXh6SlVxRVlXa1hHV0FFMkpHeTF2?=
 =?utf-8?B?ZEZWaW9WQm5qQ21ITjRDVm55Mm42R1MweERiZ2RzSFhkaDdPbTFrMW5uUjFL?=
 =?utf-8?B?OXZ5aDl0aEJSemVYN251QXhsRVR2VWtaYkwvZ0EyTG5kQUhzZ1NRakN1bEZk?=
 =?utf-8?B?VFBFUjJvcGtKdFNrRml0TkpyTWg0T0tKU3hoMjJkQUgrR0pPYXlvSDdCZ29I?=
 =?utf-8?B?eFFCM25tRnpZM2VoQnBPVVBVbktZK3Z2SGlZZWV3bjFUMEFsdWVuUnE1ZHJW?=
 =?utf-8?B?MGtGUHpyTk5sMXZEMm5jNk9XOXAwcHpLOVd2bXpnQWJUeEM4bzVFdXR0SW1x?=
 =?utf-8?B?UVdrVUZ5ZncybVRDU1FuRmw0SXVDMkUwbmtYT0ZnbnBYczVTMHd2cXIrWDJw?=
 =?utf-8?B?VjNHd25weUgveG9ySGdOUStYTHNEUENDeGVlNzdXcGVMRE1ETDIxcVB5eTNy?=
 =?utf-8?B?WGNRYWptTktZNnBpaWRSK1Z1ekJDaXQ1YlUyMWRuV1JXRXBPdzcrYU1rbTFy?=
 =?utf-8?B?aENJTVpaNjdtZzM4RXFmTVh3Uk9uSGJKR2M5aVhJS2VEMXhnY2Z6WlBvYndv?=
 =?utf-8?B?cXJhVm52U2tZOU9qblZMaFp6V3dGZWNPQzJLZmxsQ0ZReXphL3NuQWwwbmc5?=
 =?utf-8?B?R29wazVyVitrWnRybFc0dk8wZnJ0WEFQdnFCMlRRN3pYSHNNMVlTaEpYYkZa?=
 =?utf-8?B?UHRld0JVOHpHKzJ5b0xWNWhtN01lNDM3TE1HUFVGUUZOUUlKNjBuR1BKSU5n?=
 =?utf-8?B?UEFFOUVYQkxEZ3ZrTmxNZXQ2WktBTzRGcytYdjVnQ0F3VUFTUDJwa1NzalUy?=
 =?utf-8?B?TVdsNGhNTHlNQXpCckNaOHU1cGgxanFWWWgyY2Z6TS9pOHZoT05RZVBGckZP?=
 =?utf-8?B?OXFSV2gwNDlUdXU5VXdqOUV1YVRHZk9yRVdkdTlxTktqUVlnKzNMUlhVZFJ1?=
 =?utf-8?B?d3BSMHZmamVBU2V3S0VHOVo0azUxT0NrVFk3amw2blFlUXdDYkhzYzdiWkhh?=
 =?utf-8?B?MEFsR3VkTklXUmIyL3Y0am5pS2ZyMkJ6SnBEUjd5cmxpcXlCQjE0ZmNka2pK?=
 =?utf-8?B?Yng0K1JNVVUzNis5cDVUTytaSUJiVVB1OFc4R2k1MTBLN2hQcFM2Z29pNkFB?=
 =?utf-8?B?aW5IYWp2S3ZSVzZQQXErVXNtd2ppcUFwd2pLODFFNDc2NFp3VUtMTXVuZEl3?=
 =?utf-8?B?MkpIOHNMRG9zNFR2R2dwTlE5c0dxbS9uRzNBWDNHUG1HSUc4eHFHSi9YcVVV?=
 =?utf-8?B?eTlKVTVpbjVhK1JKM1RSVU1QS3d3RWN5UkRjU1c5aGo5NGhQZ0F1R3lXZVBY?=
 =?utf-8?B?d1UzL0o2TWdSTlo4VkRKVlJPVWkxVkxha0wvLytGbE5HdVQ5TSsyYzIvalNr?=
 =?utf-8?B?eE1hbVd4TDhsUU1lRHZobEh6RVJHZkJyWnZYZ3ZNVUJzNEpJLzVCVTZqYmo0?=
 =?utf-8?B?OGJleVZIL0c0cDJQNlVUanB5dE9wdlZWM3djVzRvQkE0cnp2N1crZWhpOUJK?=
 =?utf-8?Q?IW00=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWZVMEZTYUVVWUZkM3ZjVi9xM0h5QThXeVg4UHdTbkJFWkkzUFNrZDRLUlNW?=
 =?utf-8?B?WnBpRE9SSlJSTTV5ZVBRRWNYdWlhME9Wd2VDVE9USTRneUFrTGdDUHZJL29l?=
 =?utf-8?B?UHRWYjdScGU1RnZrdnlxQWkrdkQ1cXhoSXhOWXN5TThyRmprTGxqbElXVVhR?=
 =?utf-8?B?VkYzdGRDUXZqZk1oNmROb1lOZ1FPVjhCY0pzM1Q2R2tkZnhzWUhLeW44YWNV?=
 =?utf-8?B?SzFkVDBneDA0aTZuMWNiZ3h3bFJZOHpUMnY4RzUvOWxHYU82OVF4VnFuQkU2?=
 =?utf-8?B?NFlKcWYycUZBWFB4anp2Ymg1dGVSMXBlajZOM1FVSmxmREhFK0NXMEpuak5K?=
 =?utf-8?B?M2diOFBNMmJQYm1UMmJtNVcyOWFjMkQ0eDhKbk1jVVZFMEt2NmY3bjJnRFh2?=
 =?utf-8?B?NUpHMHQ3bW85aDAzRmh6VkFjZXJpMWlpcU0yVVgyV01nWThaeC9lNmRHWmM5?=
 =?utf-8?B?MWNITEZEd0xYcEN4anBWMldsSkt1U0V1SHo1LzhOT2Y4NXRNUk5Jd0k4WlVK?=
 =?utf-8?B?Z2JaOWpGbXQxeCthazVvNzV3UndkZkFPNWs5c3k0bytySDhjM1NZdVl4RnJS?=
 =?utf-8?B?alFBSXFBajJuTHRMTWY5MWtlcXMzZFEzcVhrOGVNWGVrVWNXdC85cFB5WC9q?=
 =?utf-8?B?VnN1a2x2MExpb0IwVlhYTGpST3g4N1h1UWpxbWhoWDc4bmFtMmZqcUdpa2h2?=
 =?utf-8?B?MmFiYXJSYytPUTJjajBVQ0hqN2dTSlprL3FPSzFBQzZDdzBhZkVGWEV4NE9B?=
 =?utf-8?B?WlFCdDNlQlMwcTk3L1pFUEZ4eVViRDNXekdmT0pYRVNIemtyV2tvWGtEWnpL?=
 =?utf-8?B?MVp0aUpKS1QzWXdnaWp4TnR3MmJRSzRiVVpLWmpKNkt3d1NwcnRyc0lNcFFx?=
 =?utf-8?B?dXZpdWN5dTlnMFNNTWJQQk1HaWp4dEJhNnQxWTNOREFUaVBMMW00aFlKTFR6?=
 =?utf-8?B?SXVRWDV2VWN1MVNlMlFyNUgxYjd2bWY3L29TU2NZMGJncXhleHUzeml6RHpB?=
 =?utf-8?B?SDFla3VCSGQyMzJKMTZ2ekc4cGJXK2l2L05tWWRMZHBJK3g0Z21MaUNnVWxa?=
 =?utf-8?B?MDBUelRmSnBXVHBVa1JxQ2loRW84TUZad2h6SDdCSTFhWWdiNnQvR0Q5Q3ZM?=
 =?utf-8?B?RG1sbHRwVDRWQXVQYS9ENmtFYmpzdG5yMWhxajVSVW1aeHV0Mk9ueDdhRUJz?=
 =?utf-8?B?SmhBa29jOUxEK2l1U2ozYWkzZlZ1SDJoUDB5WmwycXMzbUFBczNPblFQaG0z?=
 =?utf-8?B?WDRVS0h3aGFTcFl0U3BBdVptdUE4T1ZjMzhtcXZkQkFQalZKRDFTRDZUQlBt?=
 =?utf-8?B?QSt4MHJKRndFMFBvLzhRUnB0OVR3ZzVjZ1Z2Z01IVkFPL2tOd2kxVFdqSG1h?=
 =?utf-8?B?bGY1V2dNTFppclEwUG1RMGVZOHozcDBtYlg4ckVQSVZLYzhsM05vQmxlNlFJ?=
 =?utf-8?B?b3k1RVlJaUlUTlRySVFhdW1nNGJDbnFPYTliSkgrRnY5VmEvV2VQWDBxbWw5?=
 =?utf-8?B?akpXRkF0bDBJeDVPWGRQdDRYbExWODlySW90ZEdQMW1UbWFYMWQwa1liaC9R?=
 =?utf-8?B?eXcwSU80NU0yUFI3aHRuL0puVXkwSXdyVzlBcFl0TlAva09Icll5ZngwYWl5?=
 =?utf-8?B?Zy9GdUdWeENweTdSeXh4QmUyWG8xM1drTlp4ZEJPdW95czlMblZQTmpoSlF0?=
 =?utf-8?B?dE13MnRMQmY0TElQNTNOdldIZFVxYUhIdE9MZHhvT3N3WG4zdjVrQjVGR1dC?=
 =?utf-8?B?YkJ4dGNwMGNPK1daaGF4K2lvbTJhNldDSElUaEdOSUwxd1FyZnpoQkdzaU1V?=
 =?utf-8?B?UUVwUG96TERmWUd3dzlHUlRHR1hWVGY4TjVRYkZFOGJXWnpRYSsxMDhwbHVm?=
 =?utf-8?B?Zmh5TVhpbzl2ZmY3YkpoT3dqMEFtRjBwcVd5d0EydnZLVDhjRGRkdFRlUWRq?=
 =?utf-8?B?WlEvR1pNYXZHS0FjREZZeE9OYTZDQ2k2QlFDdFVRVDRFcmF2Y1ljTXg5YkVF?=
 =?utf-8?B?NWNXUXdkRk9ZeG9QWHRQQzdrUFhBWCtJTHFSMkU5NjZhQWpzNXBKa2FOWkNr?=
 =?utf-8?B?REFQRTR1YkV3Tmg5cDJQZDNnd3MrNmtTajZiNm8yVkw2TEhOUkU1RFM2Wms4?=
 =?utf-8?B?a0loUEZ5d3pVRkV3bmhpTTZQWXJ0Z3lhRUswQnUxLzdnaWJJZzY3TEJXem9k?=
 =?utf-8?B?b1REWHRDLzF2NWRaSm0vT2ZrZEFLdWJBWTNpWTVvSU1uL3g2dWxLNzVXQkJF?=
 =?utf-8?B?NXEwdHljZVhVUEdnM3RBRnV1SnpvcWtOZ3c2eU5OSGVNUUZOTThvdW9lM2JM?=
 =?utf-8?B?QmozaWJLaEp4Y00wdHBPMDNpcXlEeWYwM3VLalg2UHVNWDJGdk9uZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 273e5acc-d40c-4d31-82f7-08de64082416
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 16:12:06.2312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJeXLUSFiF4jOLMc9U4HyaDGV7IrLBpTFX0EXyOZNr5VsItlZGxUSw4Hm9iqQxZ4VMIw4btVNeZD+sxmDezAfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOBP265MB8355
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD496140002
X-Stat-Signature: w6a4artm9qu18mdsqaf86bocrnsutj8g
X-HE-Tag: 1770221530-433946
X-HE-Meta: U2FsdGVkX19Lp1t9Ntgd9q70twilcNfcGA2Rajg2+fwPdT5+V+DIQAtiLfdmgDZ3l46A7Z9RiOIpF6vYEQodPiGoa4TnkikH705dd1nHPks2RCRrj4nSUiXQ3tryahdjL/93oGCqppC48cF9AgIGsSXdYi2Le5yxZmepgaD6XIUSQI/8FmV+lCvMPDD+ygwBJ03oo2hJdOOSNLJ5BRaa5AFT82b9gZkQQOj9yPv0/pF5V4p7wfVhXYXZR0TmD1I7xKJFrVTCojYvEBFw9gsEnBPVYpYRyNxy8BADT7AkevRJPDctVLsMLwUz3ru6RjmhMPUY9YFEZfK12BF7uZ0fI/qPkbF4eVsw+yAkWQbZ4C5Xt51ezGQ7GnZLwzTb3drZC3p9nMCnVzWGF2ThwcKPEYOIvEVAnu2UAxMNB5JEiKPBWIkTEfy0kBm8UXGgjkef4uklDYv5n3H94VjL2SOGhCMDgHrp5wVh2SvJsHZRGmA9VCUj5AnoRPdCVlwcXLoOq3XYJUiKxMrcBIZ2mRrPVBJds7OWBXxg+IoAOOjgSRk8d9BlLBejwuidI/rQzBjYAcNgRSUm0UtlLyIzgeY1opKn3vCOb6l+tVJFAhByJQIL/JSaIKVcSji7Yi2kRDsDrSbqCAys0FIe8HZuN3HiTvZ1hNeKbo5YHfjjZTBxh0kkIxbQXSGc+LqV64nFzEP0xmMzH62+6jBz9CSiqjOC02k4VrCDG7xBtbantczK6dlQdQypJBcu9l4HhOySPTJN/NwHOa3APeogLCEAfE3t1hlBvnvcX/6eJ0xbhYESPK+kOVem4w9DC95BvmzVXS2SlHfP8b+KkF/OZkVa8TvP7lRWuMVkkTwFYxRhYwB1vCzyiN72J4gb3eoJ5fqtICSe7Pg4JV+4T8ftw0/AqBtrAlSjAi897oKyNyNTN5wtV6GgQuiB7pQ20x3R3JATP6N1qLoGJloIG0NKn+3Kr4M
 XpuJbuhr
 It+lJbIm0FAW3qfiiTNrq7Q0V8YH414FBR4QN0gZ15sZpyTR7j/OVZiOfXeL4fK/h4R+TfbVy37MHZXotUH4+72twtGmIGhjnc6iyYydAbvrLsJ5IjQdE3XQxPiHd+HlTCz8Dni6CFQxzlE+kfQBlMuZO15okf6tTwZ4AlOhnKolBwEzvmo/WeL/OfOloxIQeAl3e3GYNDRYBDJ6dtlMJNL71mTLgvYJCfcQRoPwyq1xob9lfadoENDqk4lqnvROLrFrElGifJqs/++QxJ30MfJImI7OCWLzRYiuXmo4dZkSFGBQKSufjxAZeyUCXncgRdOP4rZhUP8SZUjY4Y5cksXPpsZj76OLSDokIoVQqSHzetmmjw6PQ6aDomzGFAsoY8s6ZAMZhcHNEAvMtycAfxxTRMGjfzYVxj7ECWFk005Dmc58qmXnq9s+p627bz31pWxJYWMftf7kB0gv3lNd7Cxj1WojoVjjuYBx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 4, 2026 at 1:16 PM GMT, Andreas Hindborg wrote:
> Boqun Feng <boqun@kernel.org> writes:
>
>> On Sat, Jan 31, 2026 at 10:31:13PM +0100, Andreas Hindborg wrote:
>> [...]
>>> >>>>
>>> >>>> For __user memory, because kernel is only given a userspace addres=
s, and
>>> >>>> userspace can lie or unmap the address while kernel accessing it,
>>> >>>> copy_{from,to}_user() is needed to handle page faults.
>>> >>>
>>> >>> Just to clarify, for my use case, the page is already mapped to ker=
nel
>>> >>> space, and it is guaranteed to be mapped for the duration of the ca=
ll
>>> >>> where I do the copy. Also, it _may_ be a user page, but it might no=
t
>>> >>> always be the case.
>>> >>
>>> >> In that case you should also assume there might be other kernel-spac=
e users.
>>> >> Byte-wise atomic memcpy would be best tool.
>>> >
>>> > Other concurrent kernel readers/writers would be a kernel bug in my u=
se
>>> > case. We could add this to the safety requirements.
>>> >
>>>=20
>>> Actually, one case just crossed my mind. I think nothing will prevent a
>>> user space process from concurrently submitting multiple reads to the
>>> same user page. It would not make sense, but it can be done.
>>>=20
>>> If the reads are issued to different null block devices, the null block
>>> driver might concurrently write the user page when servicing each IO
>>> request concurrently.
>>>=20
>>> The same situation would happen in real block device drivers, except th=
e
>>> writes would be done by dma engines rather than kernel threads.
>>>=20
>>
>> Then we better use byte-wise atomic memcpy, and I think for all the
>> architectures that Linux kernel support, memcpy() is in fact byte-wise
>> atomic if it's volatile. Because down the actual instructions, either a
>> byte-size read/write is used, or a larger-size read/write is used but
>> they are guaranteed to be byte-wise atomic even for unaligned read or
>> write. So "volatile memcpy" and "volatile byte-wise atomic memcpy" have
>> the same implementation.
>>
>> (The C++ paper [1] also says: "In fact, we expect that existing assembly
>> memcpy implementations will suffice when suffixed with the required
>> fence.")
>>
>> So to make thing move forward, do you mind to introduce a
>> `atomic_per_byte_memcpy()` in rust::sync::atomic based on
>> bindings::memcpy(), and cc linux-arch and all the archs that support
>> Rust for some confirmation? Thanks!
>
> There is a few things I do not fully understand:
>
>  - Does the operation need to be both atomic and volatile, or is atomic e=
nough on its
>    own (why)?

In theory, C11 atomic (without using volatile keyword) and Rust atomic are =
not
volatile, so compiler can optimize them, e.g. coalesce two relaxed read of =
the
same address into one. In practice, no compiler is doing this. LKMM atomics=
 are
always volatile.

>  - The article you reference has separate `atomic_load_per_byte_memcpy`
>    and `atomic_store_per_byte_memcpy` that allows inserting an acquire
>    fence before the load and a release fence after the store. Do we not
>    need that?

It's distinct so that the semantics on the ordering is clear, as the "acqui=
re"
or "release" order is for the atomic argument, and there's no ordering for =
the
other argument.

Another thing is that without two methods, you need an extra conversion to
convert a slice to non-atomic slice, which is not generally sound. (I.e. yo=
u
cannot turn &[u8] to &[Atomic<u8>], as doing so would give you the ability =
to
write to immutable memory.

>  - It is unclear to me how to formulate the safety requirements for
>    `atomic_per_byte_memcpy`. In this series, one end of the operation is
>    the potential racy area. For `atomic_per_byte_memcpy` it could be
>    either end (or both?). Do we even mention an area being "outside the
>    Rust AM"?

No, atomics are inside the AM. A piece of memory is either in AM or outside=
. For
a page that both kernel and userspace access, we should just treat it as ot=
her
memory and treat userspace as an always-atomic user.

>
> First attempt below. I am quite uncertain about this. I feel like we
> have two things going on: Potential races with other kernel threads,
> which we solve by saying all accesses are byte-wise atomic, and reaces
> with user space processes, which we solve with volatile semantics?
>
> Should the functin name be `volatile_atomic_per_byte_memcpy`?
>
> /// Copy `len` bytes from `src` to `dst` using byte-wise atomic operation=
s.
> ///
> /// This copy operation is volatile.
> ///
> /// # Safety
> ///
> /// Callers must ensure that:
> ///
> /// * The source memory region is readable and reading from the region wi=
ll not trap.

We should just use standard terminology here, similar to Atomic::from_ptr.

> /// * The destination memory region is writable and writing to the region=
 will not trap.
> /// * No references exist to the source or destination regions.
> /// * If the source or destination region is within the Rust AM, any conc=
urrent reads or writes to
> ///   source or destination memory regions by the Rust AM must use byte-w=
ise atomic operations.

This should be dropped.

> pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8, len: u=
size) {
>     // SAFETY: By the safety requirements of this function, the following=
 operation will not:
>     //  - Trap.
>     //  - Invalidate any reference invariants.
>     //  - Race with any operation by the Rust AM, as `bindings::memcpy` i=
s a byte-wise atomic
>     //    operation and all operations by the Rust AM use byte-wise atomi=
c semantics.
>     //
>     //  Further, as `bindings::memcpy` is a volatile operation, the opera=
tion will not race with any
>     //  read or write operation to the source or destination area if the =
area can be considered to
>     //  be outside the Rust AM.
>     unsafe { bindings::memcpy(dst.cast::<kernel::ffi::c_void>(), src.cast=
::<kernel::ffi::c_void>(), len) };

The `cast()` don't need explicit types I think?

Best,
Gary

> }
>
>
> Best regards,
> Andreas Hindborg


