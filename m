Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1911E60A2618
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=est.tech header.i=@est.tech header.a=rsa-sha256 header.s=selector1 header.b=ckbU0IUP
Received: by kanga.kvack.org (Postfix)
	id 22EB36B083B; Tue, 27 Oct 2026 12:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206166B083D; Tue, 27 Oct 2026 12:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE006B083E; Tue, 27 Oct 2026 12:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFE4D6B083B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:35:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01A071201B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:35:03 +0000 (UTC)
X-FDA: 85368955728.23.913088A
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2A94140002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:35:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=ckbU0IUP;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8DRXoUs270oIsrA0zx7bkkTJUXxnQQL0lAGR3RwAuo=;
	b=YsBRTw3YhTfbXXxJlcxN0z1+Ai9ow/3fKRPbZOuUaVMR5xS6YM2uDZglPD4XRLozwrEO5U
	ooIMQSziwjTFVsFJ418AnfPP1EPX0WNeURcxAp/ZJeUiWmjv+tGoJMS7QywH75ANCDOg85
	LFAShdffcByyhvZhlkWH8o1jqJ9HyHw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=est.tech header.s=selector1 header.b=ckbU0IUP;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of yunseong.kim@est.tech designates 52.101.70.28 as permitted sender) smtp.mailfrom=yunseong.kim@est.tech
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793118901;
	b=hPI8SDQ0idVvGfdGnsFh4XgwZgqtv2yXl7TIStV66XuVzSg5+vsqe3q2rf+1n1fpByLwys
	Yagh4DGjhVAm4/Jex/1AUYT5icATcCm9tB4+Nf0hggCvMbx8XwDRfLj0Cy6SDeFuwn2Ieq
	fHsSjluDOZ3d4++9Q0XJl3JjrTFO8kI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PYtMwxPhGXCMLhU1LK33rmORLxoyy6pyKgTVKcSjj7Wg5QC+xdPTmwM/4wO/Or3Y4GeDt2imjmp83pVNZ3f2COm3mJMe7hfT/k1rcasG4dTPANHvKUFe2d6gBwTXAXt8VoZ6g3umquw2CZbfgiSvxMyWj4GjPJ3XfJefPgo37gf23vnjIHwtCLXjtt8oQoadqwImyFgQcmeu9N4F1fMGGY/P48pBsWQxH/CeSeOotqGEpRumMj6qp/GqoMI0bq63uFLzhoN7LiL4yLjGJyYIwjyrIwdjGdfjKvo1zi6w0RJgD5ZiHa/sQlUXOfoHFJgmM2AbW3zJOUK8KG+cArUBcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8DRXoUs270oIsrA0zx7bkkTJUXxnQQL0lAGR3RwAuo=;
 b=T9pzH/YifZAyKX5AtbRN3Bo3489IeSvhbWT71kWZls/Lo2L6d9Tvq2bDPPynvUzT611tyjfePSZjmRgKyq+S99XPY/Hr0gJSMsJjFtmBmVzHfSrJm9m1jAfMxp5SZlYbAvv1+kNotZsCS/Qk4bm6c/EEuS690GIAZ7otmX7R37crw3kTnBIB7Dd0ga8t/A8oxIeIim6FIv4GFTUK9vlAutw5ZDx1hb51vkG/VDZkWavyZnltCL9NwxY0OpbgY+EB0kexZEyTyDZCoUHSEZ8MlT1QsOR22d7jzuUqge/6fRA2irgMsR1X74OBOrv8ub3kIVVSdFzKuGl1CB3Fw4iJkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8DRXoUs270oIsrA0zx7bkkTJUXxnQQL0lAGR3RwAuo=;
 b=ckbU0IUPDSu7K4RryORqJHxUuuABU+C0dtBj5huddh0UYbwRXmPXfi5mJk3FkX+kKN5d1yqb238iE4qDRz4AGn81dt3zkfQesbj0KTW5oxEKcWcqH5mpWCBv4cuK4VjdDLefNHW4+MFDLD+zcFT1umg7LDkS9qyZ3hEeuKBi6cvwRyXpBC7b3oKHGLZCcs2XT3Tw3o2UVY5kGXl5ovI8mmNmOlbG2gPhINiALP3soFNuWaChR91zGSmASVTmS2j1rZWOxXbymuwcazG7W4tzGd96xjuGqWfFRoppk1fs7JdVjARF+i4vZDA7aMfUNATPTVyUuu0TEiBOB4uX9SSBmA==
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM (2603:10a6:d10:1a3::22)
 by VE1P189MB1135.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:148::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 16:34:57 +0000
Received: from FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a]) by FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 ([fe80::4658:dbd6:d572:896a%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 16:34:57 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Tue, 27 Oct 2026 17:34:08 +0100
Subject: [PATCH RFC 1/2] kcov: collect early boot coverage of init_task
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-early-kcov-v1-1-6f2f053255ad@est.tech>
References: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
In-Reply-To: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, James Morris <jmorris@namei.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Luis Chamberlain <mcgrof@kernel.org>, 
 Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, workflows@vger.kernel.org, 
 linux-modules@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kbuild@vger.kernel.org, Yunseong Kim <yunseong.kim@est.tech>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793118887; l=25011;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=74AyX/SIebeUnsLU/FH1d1NaaQfZYIzUZIuz0aQkm2A=;
 b=wBwQNDDH3z43dCpgbChDCAYKQDA3F4L3SgycpHczA+RbM56Kz9bs0ZCPdWnUseteoklw5+L15
 qem5EY9//vqBiReHYu72u81conkzCUsNp1wIty6Oq2/yTGETNI/ISdd
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: LO4P123CA0429.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::20) To FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:d10:1a3::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FRWP189MB3398:EE_|VE1P189MB1135:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1f6c1d-2409-4973-8ca8-08df34483cac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|921020|261026121527099003|260925021911599003|260925021311599003|260925022911599003|5023799004|56012099006|11063799006|261009223027099003|261021123027099003|261022075727099003|261022115727099003|261022105027099003|261022113327099003|261021135927099003|261021121427099003|261021130227099003|261021133027099003|261026135527099003|22082099003|18002099003|6133799003|10067099003|261026140227099003|3023799007|261026130827099003;
X-Microsoft-Antispam-Message-Info:
	vzDueyUTerJBzTg/LS/K4KPQbxXyOXY0MStBtBgKhVADG14AxaIZaSwCK5MkaT3Z6hMqE/pjcJlofn4Fc2xW5g1SUeaz+Zg6C7sqZvWyTHxartCMuDfeWkpkE7itrra5bWA6lVAElxEVTevMJ8+eff44qpjotYtBMLmSuo1wsaMMZE2AiIwwf+x9QPsKm5EHnLmMq4Gw3jiF8yEUY3CBHA9WALMel3WGgYKMrFNrE7zIZ/Bq8ad5I4WCUPcBv0g5Dj1EuZMIzrBSNsckRzIEYc43VIExgPUrZC40En/O9LFZNKRC8OxHGxLMqXCmyb+9gOyJqKIudHXh3HhivybusgtlOZnXE4XVkOCK5C27jYMh2CLVsS+9qShFe/6Nfa1wf04iKLnht+bgRmbOKff+Mf8Hscn8ZPgfupWtu+PfZjjgmtl3xl5ls0ryWaoXohq30dbvVk0kvbQM0mH01DYMWZpprQrTekH0h1zlOJARnNXP+9IJfvS/2iUFzV928SP+9xGP6p7Ufexg8xnDrsgdp+yFFyV3w7mhVsbVAPFkr8InEV9Hd/Ia4hQyx23qZRhmMcZSmRuIf9afHz5Yq3+D04Oo4Ux9k/7dQ0jv6cLti3b7rYgGfq3jf9t8NZ+c5brIMhB5Id20j2Dw+cC6DvBYYcSo1p5/958h7BEmzPTqY09gdvQHEmuCrAZAqZhXKESyy2wusffmx5lgZdy6iCNoMA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRWP189MB3398.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(921020)(261026121527099003)(260925021911599003)(260925021311599003)(260925022911599003)(5023799004)(56012099006)(11063799006)(261009223027099003)(261021123027099003)(261022075727099003)(261022115727099003)(261022105027099003)(261022113327099003)(261021135927099003)(261021121427099003)(261021130227099003)(261021133027099003)(261026135527099003)(22082099003)(18002099003)(6133799003)(10067099003)(261026140227099003)(3023799007)(261026130827099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WnE3SG1hY1dnaGpUUG9PNjJuNytJNUgxZ3ZNQXh5NmlYYVd2RnErRzVLUjZr?=
 =?utf-8?B?THY1OGJmRW9qY3JPb0NjdWJ5TGEybWkxSVB2SVVjWEdsZmRZMTVqWUpzM3dU?=
 =?utf-8?B?NEZSdGptazlEZ1prTGVFSGwrTGF0VXJCeXE2azZyZllVMHlDSW5vRVB2SzJN?=
 =?utf-8?B?QXlGd2RJdE0zbXhxdkNydEtuN1hudzdSaWVQZnJPVlEzY2xHQU9Zd0Q2SHlF?=
 =?utf-8?B?WjdTbzkzenNVVm0yMTlKWjlhb1JJSkFnOEUrY0RTZFFicFl3eVZSaVhsb3NV?=
 =?utf-8?B?aXY2YzlpQithSC9QQ1BocU1NZnZkZkMvNFJGbmxDNmc1ZWpCWnI2WUhzQW1Z?=
 =?utf-8?B?TXhNeldjMlNLeU5KYmVVK1BRT3N5NVVsQWQrbk9zSlRYYkx1alRROHZySG1u?=
 =?utf-8?B?MmhkeHl3TmI5NXhXU0Z2SW5Wb0hvRjNnQ05wamV1VksvT21pSENReDlqa0E0?=
 =?utf-8?B?WWtoa2V3SEZmb216YnFvczNNYjhPVkNRMVNXakY4eHAzNEphcVI4QzVucEFv?=
 =?utf-8?B?QldnWkVsVndMdzArc3FLbFhzalZvOUhvUWJTak8yRkE4aXZzRnRyM3kvdW5n?=
 =?utf-8?B?ZXlmaFJmai9MclpEbWVSTHR1L3Y1R08vUXJ5ZWduWXc5cnA2WUpMR1o2Sng4?=
 =?utf-8?B?ZWhCdEF6ZVljYmRmRU82QzJtcHpGVGRGMkgxMGlUNk9SbDdpTnJzOTQzOFZs?=
 =?utf-8?B?TTd2Y2kyZ1V3TE9QMnpiYmdHM2k1YmdKSU5tOW44Ujh2aGgzMGhMUjFXUTRk?=
 =?utf-8?B?OUF5ZHluTzJNeHRGSjhQNXVwMUkxOWRPaG03a1pTYUsvTVBJWlJDeHJnclFJ?=
 =?utf-8?B?Y1dOa0VRVkcyZUxDa0J5aTR2RXpuZU1VWmg3a1FNcThwc3V0KytpTk1ldTEr?=
 =?utf-8?B?UzllaTBubldqSDVwOEoweWQ2MVVTSkZvSFdBWVk3S3hybGJEdDgyN2tzYlV5?=
 =?utf-8?B?ZmxPMTN0RnNNRnUvUXNQL2dEdXd3aUxhWDZndk1tUCtrMS9KdDA2bmxYOFNr?=
 =?utf-8?B?cUhOVHZzRHRTeFA2RFk5VzFZMXhBQWJYbm41ajNZdXpZL3dTcHZlblRFR0g3?=
 =?utf-8?B?TTBVYWFkc3ZFUmx5TTlrVlZYNHBIaS9IWktWR0NZL25XTUc5WndLbFdVUWVS?=
 =?utf-8?B?Qzl0Vk1NQTZTMmZ3VExhYWZ2U2lLVkdJMGFNeDNxcCt2cnVZV2d3cXNTZG5n?=
 =?utf-8?B?bDJpbVkzL0xhMHdsRjVVaW14Vjk3TXhUZkdHQnc0Tm1qemtlYnBnZitlZnd5?=
 =?utf-8?B?NzZvS0Y1VFE2ZHRnTlBmeGx3RmdYaVM3R2RuVG5rSnZ2bVFYWnBLUnV3c25U?=
 =?utf-8?B?MUYvaGdaMFVlbnpzK0R5UjE5ZzFRYjA1d3hvblZFT291WXJabThBV2J3bEZO?=
 =?utf-8?B?bXdqeEc5cWx0OHhON3dzRGVkcVdPS2lNSHdaeUhhcGlrTlhQcnBkR2NUbXJO?=
 =?utf-8?B?UXozWWtlcXJiQWgwbjhBVHN6TmRlRklCMWVSaXVhcTR1UUtRd2EvRHFBUjZQ?=
 =?utf-8?B?bWVldk1ZWkttOHBFR1hzRUoyQVd2eGtETERQdjNHWENCeDFkTkp1aWpVUVRi?=
 =?utf-8?B?enhqTlhWUGRMckZsL29yUGlYNEd6eG10NTVkNGFsbVowYUppSmpXYi9DR0My?=
 =?utf-8?B?bVNJWUNEQkxTVVZsRjIxVmEwdDB6TzhXQ0FFWWVsalFXUGtSK1prM1FSZi9s?=
 =?utf-8?B?RmtOS0ZLQzBZUWhtM3Z1VEZFWk95VzRqQit3Tkd3ZHVLUm5IRm0xQk05Rjd1?=
 =?utf-8?B?aFZhVUNYdkJwTGV6YktGQS9URXo1emtEYXBmVFE2dkFUaUYxQk1nNHI2WXBt?=
 =?utf-8?B?Y0JZc2hEOGp0OUZiRlpJUXJFYUk2bHorQWQvWnhXbkxMb3AzSzh5ZzBwWGRI?=
 =?utf-8?B?QnkzVUJEb2wrcUVFMEZPeWlCNXJvRXQvMHZycTlZUVduRDZ2RWpIajdXL3di?=
 =?utf-8?B?ZHJTeHFqVlFEL1haVEdLRktvdUNBczdaYTJmdUZMajhnUUZ0R3dIWEJiUXpK?=
 =?utf-8?B?MUc1dXFMbGJYMVB5N1lwSU9mbWJuVWIxc1ljc0FjWW9KQkdFZDBDZlpBVDJ3?=
 =?utf-8?B?b3VFWjBzNklUU3FaOUVkVm5mMmdmSGg5RmhQV1FHWUpScUl0TEJCZWMwODBj?=
 =?utf-8?B?UE1VbDk1QUpET1lDWDVNSWtlemNaMzBZVVZxS0xXUmF2cEJNWHlFTUlkck5C?=
 =?utf-8?B?VVRBSnRRd0NFNDVOREJpVi9OTFYrUEt4Tzc1ZGhOakJjVmFFdFFySkFuZmRa?=
 =?utf-8?B?SE9pL0tsbFErUjc3Y2NCY1Fpcy82QUJhVGtTeW5BQWRkRUhCbzlZcHRiSWU3?=
 =?utf-8?B?djQ5UnhjSzMvd0lDVkNDVys1S2NtN3dXQ0Q4azlnU2s2OVFTUTEvUT09?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1f6c1d-2409-4973-8ca8-08df34483cac
X-MS-Exchange-CrossTenant-AuthSource: FRWP189MB3398.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 16:34:57.7319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dv64r5flH08HD9ddutDiZ9HmDBdYnRL+PdA4HPN+/gzAB3XpYGXivIUK8cIWycrJmkU+8CWD47MtxZoZRN/DQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P189MB1135
X-Rspamd-Queue-Id: F2A94140002
X-Stat-Signature: gothb53fb6u7d9q4akhrw1eyxozueseh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793118900-687410
X-HE-Meta: U2FsdGVkX19SBx6m5hBA3UHsOxTYE6j9kFhVLrnnwAfKQTj6B93J/X3xv26cqKUkixzdJ4GIKAt1SG6eDf6F7CHrEFTEDUNKdwk/RBPZCGBhCzIkZAt5IZdXreR9D3stNNwE7unxJ+8TfyNz6nDulWKB/IyLIfdwyR9hQeUfg2k5618wgpB5ZLUXPXH70KDZ5B3C04uEVhp2SasHMseSyxuPVHX2yBf+axALBVTnMsZTtgODdu71eTOMf6NfLYBz003DkGpHlvhgsLxW3pcDaTVVWrO2YfH27J2Y+QzssE4YETgaCzq9Y80lTRIvAi+msoOJu80rLrYdR08hVsyQMvhC16B9ZYIwENgrz0PPiVp2jGoUGMmjMM9jg98RkA9gtpbwahYANt6Y0RMRvqmXTJyUaX76+CbPvwPzlOX+d+Wa5LNuplWmLALn/R+8QgOPFYheRgx26/QwwG3hIqWWyyYUoRvIipLTPmMZsgUAyJCxkCrqiM6hL2MUDnE9+uQW+RF9INuHqEXi1VvJDATTBtXWBBQubynQfPPFvTPvCuHlTSp39eA/A5VgwjrduRnNdw/4v34qeo37cgad+OafVfYbcNjUnQXksQxpC1lbzUzDzgD291TMQyODtV734xmcALOYuhnKJdnlDiU3R00qdTla6GnQgZKPAV9DAy+r8/Fiij4XTQT2UiuC96F/eabIfPDw9HLkDmCXJAq6v5rYrcZc0ZuKtpbAo8Z/X4RnIXEUCP1QMBykBZOM2rLmPOYs8Wzc7nfiwTMJeMgnFaIs4n2HRD/MTNnPUu1el7dkt+us4weqrzZs0KLnsAJ7vV2/Kch8ER7cAlGFXLPVsAhhSZGqzorCNmHeVBEybO9vWg2xsVihwKO2ZzuWtbvNfRbtAGKn8VOdZhfn+oRVaVhAYeHiTtk02gEz6UKJoAQd6l02WZghiNoCJJmwa5JWVvt7NE2g/BNQc+J9ITmRewL
 N9AQDv7d
 2RJc4YCKJtAGuL+K2HlNvNz6oJWBaDHde1S9Gu7V3ADiiRjcJPz+kmsl9dMxbXNzh43+TPqm8zcs48u88nJWt20UBtX6ph+EMsi8aV+agTVqKF7m0eCXJVaYPUuNs7gguLjfYL9Nc2bZYb4coBXDfSS2FcnZ2Y903bgVVC+d9PdmOus30W0VtuTzOeB4OCtPYjLKHF9jaEJsmBtWq0f/4YHrKRHp4oU+uzKdmh0I5CSiTmaYJ5BMmGwq3/Wub3Q3NnXUsdkiP4gx2/6jPDv5l74btKFcFmtOe3AwDE/LJNyazq7CmrGFpjFS4NwhMv6XxmHquT73wO4pI6febPJ0CJJ3+oSodkVre48jbA/0vERX76+VoffI1oX0YPT/NL9dNg0FhSDEyi5UK9+IULVXZgMCw1SAm6VpqEvDw9/CAAFwfRPCeiJcbiRxOBxkCaEllg7dtXTTDNlMjQuMyydA0+Ldb+voi2QVb0tYzYyxxk2eI0R7RCrwZhJKXApoalZks8ln1zHuDdbgmEcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KCOV only collects coverage once a task has opened
/sys/kernel/debug/kcov, so everything that runs while the kernel boots
is invisible to it. The boot path is hard to follow from the source:
what start_kernel() really executes depends on the configuration, the
architecture, the firmware and the command line, and much of it is in
inlined helpers. Early ftrace does not fill the gap: function tracing
only starts in early_trace_init(), works at function granularity, and
cannot see inlined code or the many objects built without ftrace
hooks.

Add CONFIG_EARLY_KCOV. With it, every PC executed by init_task from
right after early parameter parsing in start_kernel() (that is, after
setup_arch()) until the start of rest_init() is recorded with
KCOV_TRACE_PC semantics:

 - early_kcov_init() allocates a memblock buffer, attaches it to
   init_task and enables KCOV_MODE_TRACE_PC. The size defaults to
   CONFIG_EARLY_KCOV_SIZE_MB (256) and can be changed with
   early_kcov_size=; 0 disables the collection.
 - early_kcov_stop() disables collection at the start of rest_init().
 - A late_initcall frees the unused tail of the buffer and exposes the
   rest as /sys/kernel/debug/early_kcov, in the usual KCOV layout
   (word 0 is the number of PCs, the PCs have the KASLR offset
   removed). This is done there because memblock memory can only be
   returned once deferred struct page init has completed. If the file
   cannot be created, the buffer is freed right away.
 - Writing to the file removes it and frees the buffer. debugfs does
   not support unlink, so "rm" is not possible; the removal is done
   from a work item because debugfs_remove() waits for the write to
   return.

__sanitizer_cov_trace_pc() is not changed, so KCOV users that do not
enable CONFIG_EARLY_KCOV are not affected.

Many objects are excluded from KCOV because their coverage is noise
for syscall fuzzing: the scheduler, RCU, locking, the page and slab
allocators, parts of lib/. For boot coverage they matter; without them
sched_init() and build_all_zonelists() do not show up at all. Add
CONFIG_KCOV_INSTRUMENT_NOISY, which depends on CONFIG_EARLY_KCOV, and a
kcov-noisy kbuild helper, and use the helper for those generic
objects. With the option off the build is unchanged. Objects excluded
because instrumenting them is unsafe are left alone.

Boot loops run the same blocks millions of times, so a full boot
records a lot of PCs: on a 2G two-node x86_64 guest, 16.9M PCs
(129 MiB) with KCOV_INSTRUMENT_ALL and 31.7M PCs (242 MiB) with
KCOV_INSTRUMENT_NOISY as well, for about 11k distinct PCs. The volume
grows with the amount of memory.

Document early_kcov_size= and the debugfs interface in
kernel-parameters.txt and Documentation/dev-tools/kcov.rst.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 Documentation/admin-guide/kernel-parameters.txt |  17 +++
 Documentation/dev-tools/kcov.rst                |  60 ++++++++
 include/linux/kcov.h                            |  13 ++
 init/main.c                                     |   4 +
 kernel/Makefile                                 |   6 +-
 kernel/kcov.c                                   | 184 ++++++++++++++++++++++++
 kernel/locking/Makefile                         |   2 +-
 kernel/module/Makefile                          |   2 +-
 kernel/rcu/Makefile                             |   2 +-
 kernel/sched/Makefile                           |   2 +-
 lib/Kconfig.debug                               |  45 ++++++
 lib/Makefile                                    |  14 +-
 mm/Makefile                                     |  20 +--
 scripts/Kbuild.include                          |   6 +
 14 files changed, 353 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 2e8ee12e06de1..fb1f2def7eb3b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1404,6 +1404,23 @@ Kernel parameters
 			is useful for tracking down temporary early mappings
 			which are not unmapped.
 
+	early_kcov_size=nn[KMG]
+			[KNL,EARLY] When CONFIG_EARLY_KCOV is enabled, set the
+			size of the buffer that records the code coverage
+			(KCOV_TRACE_PC) of the boot task from right after
+			early parameter parsing in start_kernel() (that is,
+			after setup_arch()) until rest_init(). The size is
+			rounded up to a page and must be less than 2^32
+			words and fit in the address space; larger values
+			are rejected and the default is kept. 0 disables
+			early boot coverage.
+			PCs that do not fit in the buffer are not recorded.
+			The coverage is read from /sys/kernel/debug/early_kcov,
+			see Documentation/dev-tools/kcov.rst. The unused part
+			of the buffer is freed at the end of boot, the rest
+			when the file is written to.
+			Default: CONFIG_EARLY_KCOV_SIZE_MB
+
 	earlycon=	[KNL,EARLY] Output early console device and options.
 
 			When used with no options, the early console is
diff --git a/Documentation/dev-tools/kcov.rst b/Documentation/dev-tools/kcov.rst
index 1a739290c8ecc..8d449084ecd8d 100644
--- a/Documentation/dev-tools/kcov.rst
+++ b/Documentation/dev-tools/kcov.rst
@@ -383,3 +383,63 @@ local tasks spawned by the process and the global task that handles USB bus #1:
 		perror("close"), exit(1);
 	return 0;
     }
+
+Early boot coverage
+-------------------
+
+KCOV can also record the code executed while the kernel boots, before any
+task can open the ``kcov`` file. To enable it, configure the kernel with::
+
+        CONFIG_KCOV=y
+        CONFIG_KCOV_INSTRUMENT_ALL=y
+        CONFIG_EARLY_KCOV=y
+
+Every PC executed by the boot task (``init_task``) from right after early
+parameter parsing in ``start_kernel()`` until the start of ``rest_init()`` is
+recorded with the same semantics as ``KCOV_TRACE_PC``. ``setup_arch()`` runs
+before that point and is not covered. Coverage ends before the initcalls run.
+
+The buffer is allocated from memblock. Its size defaults to
+``CONFIG_EARLY_KCOV_SIZE_MB`` and can be changed with the ``early_kcov_size=``
+boot parameter, where ``early_kcov_size=0`` disables the collection. Boot loops
+execute the same blocks millions of times, so a full x86_64 boot records tens of
+millions of PCs. If the buffer fills up, the remaining PCs are not recorded and
+the kernel log says so::
+
+        kcov: Early boot coverage stopped. Recorded 2097151 / 2097151 PCs (buffer full, coverage truncated; increase early_kcov_size=)
+
+After boot, the coverage can be read from ``/sys/kernel/debug/early_kcov``. It
+has the same layout as the buffer of the ``kcov`` file: the first word (an
+``unsigned long``) is the number of recorded PCs, followed by the PCs in
+execution order. No ``ioctl()`` or ``mmap()`` is needed. As with the ``kcov``
+file, the KASLR offset is subtracted from the PCs, so they must be resolved
+against ``vmlinux``, not ``/proc/kallsyms``. On a 64-bit kernel::
+
+        cat /sys/kernel/debug/early_kcov > early_kcov.raw
+        od -An -v -t x8 -w8 -j8 early_kcov.raw | awk '{ print "0x" $1 }' |
+                sort -u | addr2line -f -e vmlinux
+
+The unused part of the buffer is freed at the end of boot. The rest stays
+allocated until the file is written to: writing anything to it removes the file
+and frees the buffer::
+
+        echo 1 > /sys/kernel/debug/early_kcov
+
+Like the per-task coverage, early boot coverage skips interrupt context. Some
+interrupt entry code runs before the hardirq count is raised, for example the
+x86 FRED system vector wrappers, and is recorded as if ``init_task`` executed it.
+If such an interrupt arrives in the middle of recording a PC, one of the two
+PCs can be lost.
+
+Many objects are built without KCOV instrumentation because their coverage is
+not a function of syscall inputs: the scheduler, RCU, locking, the page and slab
+allocators and parts of ``lib/``. They run during boot too. To include them in
+the early boot coverage, set::
+
+        CONFIG_KCOV_INSTRUMENT_NOISY=y
+
+which instruments every object whose Makefile excludes it from KCOV with
+``KCOV_INSTRUMENT_foo.o := $(kcov-noisy)`` (or ``KCOV_INSTRUMENT :=
+$(kcov-noisy)`` for a whole directory). Objects that cannot be instrumented
+safely keep ``KCOV_INSTRUMENT := n``. As this option degrades the coverage
+signal for syscall fuzzing, it depends on ``CONFIG_EARLY_KCOV``.
diff --git a/include/linux/kcov.h b/include/linux/kcov.h
index 895b761b2db15..b9b1a2c71df8f 100644
--- a/include/linux/kcov.h
+++ b/include/linux/kcov.h
@@ -107,4 +107,17 @@ static inline void kcov_remote_start_usb_softirq(u64 id) {}
 static inline void kcov_remote_stop_softirq(void) {}
 
 #endif /* CONFIG_KCOV */
+
+#ifdef CONFIG_EARLY_KCOV
+/*
+ * Coverage of init_task from right after early parameter parsing in
+ * start_kernel() until rest_init().
+ */
+void early_kcov_init(void);
+void early_kcov_stop(void);
+#else
+static inline void early_kcov_init(void) {}
+static inline void early_kcov_stop(void) {}
+#endif /* CONFIG_EARLY_KCOV */
+
 #endif /* _LINUX_KCOV_H */
diff --git a/init/main.c b/init/main.c
index 27f4cb392349d..958b4d476de7f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -35,6 +35,7 @@
 #include <linux/percpu.h>
 #include <linux/kmod.h>
 #include <linux/kprobes.h>
+#include <linux/kcov.h>
 #include <linux/kmsan.h>
 #include <linux/ksysfs.h>
 #include <linux/vmalloc.h>
@@ -749,6 +750,7 @@ static noinline void __ref __noreturn rest_init(void)
 	struct task_struct *tsk;
 	int pid;
 
+	early_kcov_stop();
 	rcu_scheduler_starting();
 	/*
 	 * We need to spawn init first so that it obtains pid 1, however
@@ -1084,6 +1086,8 @@ void start_kernel(void)
 	print_kernel_cmdline(saved_command_line);
 	/* parameters may set static keys */
 	parse_early_param();
+	/* Needs early_kcov_size= and must run before memblock is retired */
+	early_kcov_init();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
diff --git a/kernel/Makefile b/kernel/Makefile
index 4ff92e24680c5..b9e4f06e02ad0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -27,14 +27,14 @@ endif
 
 # Prevents flicker of uninteresting __do_softirq()/__local_bh_disable_ip()
 # in coverage traces.
-KCOV_INSTRUMENT_softirq.o := n
+KCOV_INSTRUMENT_softirq.o := $(kcov-noisy)
 # Avoid KCSAN instrumentation in softirq ("No shared variables, all the data
 # are CPU local" => assume no data races), to reduce overhead in interrupts.
 KCSAN_SANITIZE_softirq.o = n
 # These are called from save_stack_trace() on slub debug path,
 # and produce insane amounts of uninteresting coverage.
-KCOV_INSTRUMENT_extable.o := n
-KCOV_INSTRUMENT_stacktrace.o := n
+KCOV_INSTRUMENT_extable.o := $(kcov-noisy)
+KCOV_INSTRUMENT_stacktrace.o := $(kcov-noisy)
 # Don't self-instrument.
 KCOV_INSTRUMENT_kcov.o := n
 # If sanitizers detect any issues in kcov, it may lead to recursion
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 35420f0ac524d..e9f2b5cbb0060 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -25,6 +25,9 @@
 #include <linux/kcov.h>
 #include <linux/refcount.h>
 #include <linux/log2.h>
+#include <linux/kmemleak.h>
+#include <linux/memblock.h>
+#include <linux/workqueue.h>
 #include <asm/setup.h>
 
 #define kcov_debug(fmt, ...) pr_debug("%s: " fmt, __func__, ##__VA_ARGS__)
@@ -1098,6 +1101,187 @@ struct kcov_common_handle_id kcov_common_handle(void)
 }
 EXPORT_SYMBOL(kcov_common_handle);
 
+#ifdef CONFIG_EARLY_KCOV
+/*
+ * Early boot coverage.
+ *
+ * Every PC executed by init_task from right after early parameter parsing in
+ * start_kernel() (that is, after setup_arch()) until the start of rest_init()
+ * is recorded, with the same semantics as KCOV_TRACE_PC, into a buffer
+ * allocated from memblock. The buffer uses the regular kcov layout: area[0] is
+ * the number of recorded PCs, followed by the PCs. It is exported via
+ * /sys/kernel/debug/early_kcov; writing to that file removes it and frees the
+ * buffer.
+ */
+#define EARLY_KCOV_DEFAULT_SIZE	((unsigned long)CONFIG_EARLY_KCOV_SIZE_MB << 20)
+
+/* Requested buffer size in bytes, 0 disables early coverage. */
+static unsigned long early_kcov_size __initdata = EARLY_KCOV_DEFAULT_SIZE;
+/* Buffer that was attached to init_task, kept for the debugfs reader. */
+static unsigned long *early_kcov_area;
+/* Size of early_kcov_area in unsigned longs. */
+static unsigned long early_kcov_nr_entries;
+static struct dentry *early_kcov_dentry;
+
+static int __init early_kcov_size_setup(char *arg)
+{
+	/* task_struct::kcov_size is an unsigned int number of longs. */
+	const u64 max = round_down(min_t(u64, ULONG_MAX,
+					 (u64)UINT_MAX * sizeof(unsigned long)),
+				   PAGE_SIZE);
+	unsigned long long size;
+	char *end;
+
+	if (!arg)
+		return -EINVAL;
+
+	/* Range check before narrowing, memparse() returns a 64-bit value. */
+	size = memparse(arg, &end);
+	if (end == arg || size > max)
+		return -EINVAL;
+
+	early_kcov_size = PAGE_ALIGN(size);
+	return 0;
+}
+early_param("early_kcov_size", early_kcov_size_setup);
+
+void __init early_kcov_init(void)
+{
+	unsigned long *area;
+	unsigned long nr_entries;
+
+	if (!early_kcov_size) {
+		pr_info("Early boot coverage disabled\n");
+		return;
+	}
+
+	area = memblock_alloc(early_kcov_size, PAGE_SIZE);
+	if (!area) {
+		pr_warn("Failed to allocate %lu bytes for early boot coverage\n",
+			early_kcov_size);
+		return;
+	}
+
+	nr_entries = early_kcov_size / sizeof(unsigned long);
+	/* The first word is the number of PCs, see __sanitizer_cov_trace_pc(). */
+	area[0] = 0;
+	early_kcov_area = area;
+	early_kcov_nr_entries = nr_entries;
+
+	init_task.kcov_size = nr_entries;
+	init_task.kcov_area = area;
+	/* See comment in check_kcov_mode(). */
+	barrier();
+	WRITE_ONCE(init_task.kcov_mode, KCOV_MODE_TRACE_PC);
+
+	pr_info("Early boot coverage started (%lu bytes, %lu PCs max)\n",
+		early_kcov_size, nr_entries - 1);
+}
+
+void __init early_kcov_stop(void)
+{
+	unsigned long nr_pcs;
+
+	if (!early_kcov_area)
+		return;
+
+	WRITE_ONCE(init_task.kcov_mode, KCOV_MODE_DISABLED);
+	barrier();
+	init_task.kcov_area = NULL;
+	init_task.kcov_size = 0;
+
+	nr_pcs = READ_ONCE(early_kcov_area[0]);
+	pr_info("Early boot coverage stopped. Recorded %lu / %lu PCs%s\n",
+		nr_pcs, early_kcov_nr_entries - 1,
+		nr_pcs >= early_kcov_nr_entries - 1 ?
+		" (buffer full, coverage truncated; increase early_kcov_size=)" :
+		"");
+}
+
+static ssize_t early_kcov_read(struct file *file, char __user *buf,
+			       size_t count, loff_t *ppos)
+{
+	unsigned long nr_words;
+
+	/* Coverage collection has stopped, the buffer does not change. */
+	nr_words = min(READ_ONCE(early_kcov_area[0]) + 1, early_kcov_nr_entries);
+
+	return simple_read_from_buffer(buf, count, ppos, early_kcov_area,
+				       nr_words * sizeof(unsigned long));
+}
+
+static void early_kcov_release(struct work_struct *work)
+{
+	unsigned long size = early_kcov_nr_entries * sizeof(unsigned long);
+
+	if (!early_kcov_dentry)
+		return;
+
+	/* Waits for readers that are still in early_kcov_read(). */
+	debugfs_remove(early_kcov_dentry);
+	early_kcov_dentry = NULL;
+
+	kmemleak_free_part_phys(__pa(early_kcov_area), size);
+	free_reserved_area(early_kcov_area, (void *)early_kcov_area + size, -1,
+			   "early boot coverage");
+	early_kcov_area = NULL;
+	early_kcov_nr_entries = 0;
+}
+static DECLARE_WORK(early_kcov_release_work, early_kcov_release);
+
+static ssize_t early_kcov_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	/*
+	 * Removing the file from here would deadlock: debugfs_remove() waits
+	 * for this write to return.
+	 */
+	schedule_work(&early_kcov_release_work);
+	return count;
+}
+
+static const struct file_operations early_kcov_fops = {
+	.read		= early_kcov_read,
+	.write		= early_kcov_write,
+	.llseek		= default_llseek,
+};
+
+static int __init early_kcov_late_init(void)
+{
+	unsigned long size, used;
+
+	if (!early_kcov_area)
+		return 0;
+
+	/*
+	 * Deferred struct page init has completed by now, so memblock memory
+	 * can be handed to the page allocator: drop the unused tail of the
+	 * buffer.
+	 */
+	size = early_kcov_nr_entries * sizeof(unsigned long);
+	used = PAGE_ALIGN((READ_ONCE(early_kcov_area[0]) + 1) *
+			  sizeof(unsigned long));
+	if (used < size) {
+		memblock_free((void *)early_kcov_area + used, size - used);
+		early_kcov_nr_entries = used / sizeof(unsigned long);
+		pr_info("Freed %lu KiB of unused early boot coverage buffer\n",
+			(size - used) >> 10);
+	}
+
+	early_kcov_dentry = debugfs_create_file("early_kcov", 0600, NULL, NULL,
+						&early_kcov_fops);
+	if (IS_ERR(early_kcov_dentry)) {
+		/* Nobody can read the coverage, do not keep it around. */
+		early_kcov_dentry = NULL;
+		memblock_free(early_kcov_area, used);
+		early_kcov_area = NULL;
+		early_kcov_nr_entries = 0;
+	}
+	return 0;
+}
+late_initcall(early_kcov_late_init);
+#endif /* CONFIG_EARLY_KCOV */
+
 #ifdef CONFIG_KCOV_SELFTEST
 static void __init selftest(void)
 {
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index cee1901d4cff8..9041cbbec9aae 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Any varying coverage in these files is non-deterministic
 # and is generally not a function of system call inputs.
-KCOV_INSTRUMENT		:= n
+KCOV_INSTRUMENT		:= $(kcov-noisy)
 
 CONTEXT_ANALYSIS_mutex.o := y
 CONTEXT_ANALYSIS_rtmutex_api.o := y
diff --git a/kernel/module/Makefile b/kernel/module/Makefile
index 50ffcc413b545..6d163116d2840 100644
--- a/kernel/module/Makefile
+++ b/kernel/module/Makefile
@@ -5,7 +5,7 @@
 
 # These are called from save_stack_trace() on slub debug path,
 # and produce insane amounts of uninteresting coverage.
-KCOV_INSTRUMENT_main.o := n
+KCOV_INSTRUMENT_main.o := $(kcov-noisy)
 
 obj-y += main.o
 obj-y += strict_rwx.o
diff --git a/kernel/rcu/Makefile b/kernel/rcu/Makefile
index 0cfb009a99b9f..fd23c1dad641b 100644
--- a/kernel/rcu/Makefile
+++ b/kernel/rcu/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 # Any varying coverage in these files is non-deterministic
 # and is generally not a function of system call inputs.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT := $(kcov-noisy)
 
 ifeq ($(CONFIG_KCSAN),y)
 KBUILD_CFLAGS += -g -fno-omit-frame-pointer
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index b1f1a367034ff..4b4db5cca9b08 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -9,7 +9,7 @@ ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
 
 # These files are disabled because they produce non-interesting flaky coverage
 # that is not a function of syscall inputs. E.g. involuntary context switches.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT := $(kcov-noisy)
 
 # Disable KCSAN to avoid excessive noise and performance degradation. To avoid
 # false positives ensure barriers implied by sched functions are instrumented.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6759087154edd..40bf654ec7515 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2233,6 +2233,51 @@ config KCOV_INSTRUMENT_ALL
 	  filesystem fuzzing with AFL) then you will want to enable coverage
 	  for more specific subsets of files, and should say n here.
 
+config EARLY_KCOV
+	bool "Collect code coverage of the early boot path"
+	depends on KCOV && DEBUG_FS
+	help
+	  Record every PC executed by the boot task (init_task) from right
+	  after early parameter parsing in start_kernel() until rest_init(),
+	  with KCOV_TRACE_PC semantics, and export it via
+	  /sys/kernel/debug/early_kcov. Writing to that file removes it and
+	  frees the buffer. This shows which code a given configuration and
+	  machine actually run during boot. Only instrumented code is
+	  recorded, so this is mostly useful with KCOV_INSTRUMENT_ALL.
+	  See Documentation/dev-tools/kcov.rst.
+
+	  This reserves EARLY_KCOV_SIZE_MB of memory during boot and slows
+	  down the boot. If unsure, say n.
+
+config EARLY_KCOV_SIZE_MB
+	int "Default early boot coverage buffer size in MiB"
+	depends on EARLY_KCOV
+	range 0 2048
+	default 256
+	help
+	  Size of the early boot coverage buffer, rounded up to a page. It
+	  can be overridden with early_kcov_size=. 0 disables the collection
+	  unless early_kcov_size= is given.
+
+	  Each recorded PC takes one word. With KCOV_INSTRUMENT_ALL an x86_64
+	  boot records about 17M PCs (130 MiB), and 30M to 40M PCs (240 to
+	  310 MiB) with KCOV_INSTRUMENT_NOISY, growing with the amount of
+	  memory. PCs that do not fit are not recorded.
+
+config KCOV_INSTRUMENT_NOISY
+	bool "Also instrument code excluded only for noisy coverage"
+	depends on EARLY_KCOV && KCOV_INSTRUMENT_ALL
+	help
+	  Some code (scheduler, RCU, locking, page and slab allocators,
+	  rbtree, stack unwinding, ...) is excluded from KCOV instrumentation
+	  because its coverage is not a function of system call inputs and
+	  only adds noise to coverage-guided fuzzing. Code that is excluded
+	  because it cannot be instrumented safely is not affected.
+
+	  Say y to instrument the noisy code as well, so that the early boot
+	  coverage shows the complete execution path. This degrades the
+	  coverage signal for syscall fuzzing, so say n for fuzzing kernels.
+
 config KCOV_IRQ_AREA_SIZE
 	hex "Size of interrupt coverage collection area in words"
 	depends on KCOV
diff --git a/lib/Makefile b/lib/Makefile
index a2afe954805cb..f81096084d18d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,13 +13,13 @@ endif
 # These files are disabled because they produce lots of non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. For example,
 # rbtree can be global and individual rotations don't correlate with inputs.
-KCOV_INSTRUMENT_string.o := n
-KCOV_INSTRUMENT_rbtree.o := n
-KCOV_INSTRUMENT_list_debug.o := n
-KCOV_INSTRUMENT_debugobjects.o := n
-KCOV_INSTRUMENT_dynamic_debug.o := n
-KCOV_INSTRUMENT_fault-inject.o := n
-KCOV_INSTRUMENT_find_bit.o := n
+KCOV_INSTRUMENT_string.o := $(kcov-noisy)
+KCOV_INSTRUMENT_rbtree.o := $(kcov-noisy)
+KCOV_INSTRUMENT_list_debug.o := $(kcov-noisy)
+KCOV_INSTRUMENT_debugobjects.o := $(kcov-noisy)
+KCOV_INSTRUMENT_dynamic_debug.o := $(kcov-noisy)
+KCOV_INSTRUMENT_fault-inject.o := $(kcov-noisy)
+KCOV_INSTRUMENT_find_bit.o := $(kcov-noisy)
 
 # string.o implements standard library functions like memset/memcpy etc.
 # Use -ffreestanding to ensure that the compiler does not try to "optimize"
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62eef..d272f2bb4c3db 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -20,16 +20,16 @@ KCSAN_INSTRUMENT_BARRIERS := y
 # These files are disabled because they produce non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. E.g. slab is out of
 # free pages, or a task is migrated between nodes.
-KCOV_INSTRUMENT_slab_common.o := n
-KCOV_INSTRUMENT_slub.o := n
-KCOV_INSTRUMENT_page_alloc.o := n
-KCOV_INSTRUMENT_debug-pagealloc.o := n
-KCOV_INSTRUMENT_kmemleak.o := n
-KCOV_INSTRUMENT_memcontrol.o := n
-KCOV_INSTRUMENT_memcontrol-v1.o := n
-KCOV_INSTRUMENT_mmzone.o := n
-KCOV_INSTRUMENT_vmstat.o := n
-KCOV_INSTRUMENT_failslab.o := n
+KCOV_INSTRUMENT_slab_common.o := $(kcov-noisy)
+KCOV_INSTRUMENT_slub.o := $(kcov-noisy)
+KCOV_INSTRUMENT_page_alloc.o := $(kcov-noisy)
+KCOV_INSTRUMENT_debug-pagealloc.o := $(kcov-noisy)
+KCOV_INSTRUMENT_kmemleak.o := $(kcov-noisy)
+KCOV_INSTRUMENT_memcontrol.o := $(kcov-noisy)
+KCOV_INSTRUMENT_memcontrol-v1.o := $(kcov-noisy)
+KCOV_INSTRUMENT_mmzone.o := $(kcov-noisy)
+KCOV_INSTRUMENT_vmstat.o := $(kcov-noisy)
+KCOV_INSTRUMENT_failslab.o := $(kcov-noisy)
 
 CFLAGS_init-mm.o += -Wno-override-init
 
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8c311b997e246..8b1f540e8c3e7 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -52,6 +52,12 @@ basetarget = $(basename $(notdir $@))
 # real prerequisites without phony targets
 real-prereqs = $(filter-out $(PHONY), $^)
 
+###
+# KCOV_INSTRUMENT value for code that is excluded from KCOV only because its
+# coverage is noise for syscall fuzzing, see CONFIG_KCOV_INSTRUMENT_NOISY.
+# Usage: KCOV_INSTRUMENT_foo.o := $(kcov-noisy)
+kcov-noisy = $(if $(CONFIG_KCOV_INSTRUMENT_NOISY),,n)
+
 ###
 # Escape single quote for use in echo statements
 escsq = $(subst $(squote),'\$(squote)',$1)

-- 
2.47.3


