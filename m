Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD5AD20683
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5D66B0008; Thu,  4 Dec 2025 08:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ACAD6B0027; Thu,  4 Dec 2025 08:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775396B0029; Thu,  4 Dec 2025 08:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 662A06B0008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:03:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 839361DF2A3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:03:28 +0000 (UTC)
X-FDA: 84181804896.11.5557388
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013074.outbound.protection.outlook.com [52.103.46.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id A27A42001E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:03:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=HOTMAIL.DE header.s=selector1 header.b=AfTXpEds;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of bernd.edlinger@hotmail.de designates 52.103.46.74 as permitted sender) smtp.mailfrom=bernd.edlinger@hotmail.de;
	dmarc=pass (policy=none) header.from=hotmail.de
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764853405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfLQ8ERO31JC65yQjD9THg9jlyeHDYx4InrsaHOtEfo=;
	b=VXQQzgfUu2Td//GBnDB359pXcPwk0+YL2/Ym5PckcgL21RO5IwqTr3aezIw1JDe0ioqMWh
	yPpG1V3kssvkZr5twM7DT+TvBaUTxJhjeI0MWfhkfRodJb/gtWnUvnsMmavlIS+4hrsuA3
	HvcVL3EfcESI/D0qbt1CMpm7aCxcZCg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764853405; a=rsa-sha256;
	cv=pass;
	b=MmIfPaS2g4of4sSLPTS1DREGi0bQ++9Q7pZ1hQlexFSLKA7xW5GvH22Ekbcxl8daU0RC7y
	IAlIPoUFzgjhjvR+yGmKm3lALM+0MzpZlO6RSC8ywnpNVfaM687NcynzfgONFS72tmWBD7
	s7AZofbe9Q/rTRqaKGgF64lBV7fGRgs=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=HOTMAIL.DE header.s=selector1 header.b=AfTXpEds;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of bernd.edlinger@hotmail.de designates 52.103.46.74 as permitted sender) smtp.mailfrom=bernd.edlinger@hotmail.de;
	dmarc=pass (policy=none) header.from=hotmail.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aQwcAejHuY8Xa85/4KvTDv5gneYhlzp6wxWXcIX8g1oy3YkL84ieHejIKjb5bjWicSfJBP7bIb4AiMzcKF7UfcrJbI2U+0jOUJxXiqAe7Us1qQvX6GKn4wNn7/6UQR1U+oI14+LWgBpsvXv36nXirhRLn4VMjsYXoL+ZgnrjnRyaRrSoaiYAAlDfEsDjXGjj+JID7k079oFxW6uTv1HhtdyC5lmvqFmrChk+UuJrSv4GjRvpZERbyCSi6okkyQourJGvLmcf/NZGyfJqhdMcQeLA6zroYZROVejCKmMNX5dh3PRpc1el9hIn9UZ7h9LeOdeHUphnnqfYcmbEpJz8Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfLQ8ERO31JC65yQjD9THg9jlyeHDYx4InrsaHOtEfo=;
 b=fPIcRHMHLU/oakofHymYo7obkSQoL47dcukx5ZFABfTGgMZxooGOvJNuT4f/bTxWdIN51ZA/DCxPW70RBPUi77X7LcipQjffanhdrvMTdAofCIWJ1/GcP2jMEDSZGSydeQa9J4W+An6IrYdwKulp2vro7OkUOgNVS3zAXMsuBkKnfNmeGrkNOICWwikn9PQxQk4Z31X7hCTEQjIjEHCdzGaOJ4a9SstsHpnAY1+/psBLZu9hxBlRwo5InjmMXHB4N29N5cTTwo/dajnJUU5OV5e3InJhb1cqhANzlWsOZZDecovLR7niZcjNU2/IZa2GYKwbwgAnKUq1OY6eZj78rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FfLQ8ERO31JC65yQjD9THg9jlyeHDYx4InrsaHOtEfo=;
 b=AfTXpEdsSzodZQOGz2YnXmbLZljdb466MPXH6oa+ZI+x2RWbD/r0tFOqsm/TV+uuJRUFSF/dPOjzlqmIMY42vme9prsY6WnL4rsU3Yw2Muh9/5rgXg7T/xbuN8lj8h3qJP6onuBKVtU6/s1Ya94WN2miBZIdAxUrYrY9UlQpx8H3aiy2JaI/VANxi6QJn7bFp5ActHTR/r1yYuzSWTWWtQC9N2FFgo61w9/QZjBXOMdlbeHJsd+MPp6kgqucj3jJmMd7S03k/TfQkHVMTcLtSjnKmLbpPUE8PNshphm42RGc6PPfT0a8SYrfCbcz1aMIxnUXpLag9GD3DNsrCMr4Pw==
Received: from GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:158:401::8d4) by DB5P195MB2377.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:10:488::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 13:03:21 +0000
Received: from GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 ([fe80::dde:411d:b5f2:49]) by GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 ([fe80::dde:411d:b5f2:49%8]) with mapi id 15.20.9366.012; Thu, 4 Dec 2025
 13:03:20 +0000
Message-ID:
 <GV2PPF74270EBEE0AAAE2EB22B668EE21A7E4A6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
Date: Thu, 4 Dec 2025 14:03:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Are setuid shell scripts safe? (Implied by
 security_bprm_creds_for_exec)
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
 Roberto Sassu <roberto.sassu@huaweicloud.com>,
 Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
 Kees Cook <kees@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Drewry <wad@chromium.org>, Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Serge Hallyn <serge@hallyn.com>, James Morris
 <jamorris@linux.microsoft.com>, Randy Dunlap <rdunlap@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Yafang Shao <laoar.shao@gmail.com>,
 Helge Deller <deller@gmx.de>, Adrian Reber <areber@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
 Alexei Starovoitov <ast@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, tiozhang <tiozhang@didiglobal.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Frederic Weisbecker <frederic@kernel.org>, YueHaibing
 <yuehaibing@huawei.com>, Paul Moore <paul@paul-moore.com>,
 Aleksa Sarai <cyphar@cyphar.com>, Stefan Roesch <shr@devkernel.io>,
 Chao Yu <chao@kernel.org>, xu xin <xu.xin16@zte.com.cn>,
 Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@redhat.com>, Dave Chinner <dchinner@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>,
 David Windsor <dwindsor@gmail.com>, Mateusz Guzik <mjguzik@gmail.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 "Joel Fernandes (Google)" <joel@joelfernandes.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Hans Liljestrand <ishkamiel@gmail.com>,
 Penglei Jiang <superman.xpt@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Adrian Ratiu <adrian.ratiu@collabora.com>, Ingo Molnar <mingo@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Cyrill Gorcunov <gorcunov@gmail.com>, Eric Dumazet <edumazet@google.com>,
 zohar@linux.ibm.com, linux-integrity@vger.kernel.org,
 Ryan Lee <ryan.lee@canonical.com>, apparmor <apparmor@lists.ubuntu.com>
References: <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEE807D016A79FE7A2F463E4D6A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <87tsyozqdu.fsf@email.froward.int.ebiederm.org>
 <87wm3ky5n9.fsf@email.froward.int.ebiederm.org>
 <87h5uoxw06.fsf_-_@email.froward.int.ebiederm.org>
 <6dc556a0a93c18fffec71322bf97441c74b3134e.camel@huaweicloud.com>
 <87v7iqtcev.fsf_-_@email.froward.int.ebiederm.org>
 <dca0f01500f9d6705dccf3b3ef616468b1f53f57.camel@huaweicloud.com>
 <87ms42rq3t.fsf@email.froward.int.ebiederm.org>
 <GV2PPF74270EBEE90CDCD964F69E806EF58E4D9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251204054915.GI1712166@ZenIV>
From: Bernd Edlinger <bernd.edlinger@hotmail.de>
In-Reply-To: <20251204054915.GI1712166@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0422.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::16) To GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:158:401::8d4)
X-Microsoft-Original-Message-ID:
 <cfe4ef32-dd26-4777-88dc-4f2f1b2fa6e8@hotmail.de>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PPF74270EBEE:EE_|DB5P195MB2377:EE_
X-MS-Office365-Filtering-Correlation-Id: cb352ac1-afa8-42b2-f63c-08de33357fb0
X-MS-Exchange-SLBlob-MailProps:
	dx7TrgQSB6cF2LXCYaYySNJkazjXzT0W6dI2EvZNId9LCZCpVWYpywxz0+YXNOfUkrsFpc0ZuSwIV7Z5JRtJSHc+80d/GHB40BPWqGNMRZMLRvfsqcGZZVKhRvOXwlT+hU2ku9waROpqbAFl+ug1RyctFHWMPkTDadNb9tLLU9B6bGJKUygYmut6GvLsBHjIIthjgeCf3GTl1nQVZ/ybX9qAgDUz8IEy7UPTrUG/A/Uoy09vCW+LCOyhp3h5EYxavBswvGPfhxs3ikIp925Z1UVg/FewWXEoqEucjhFxhPdQacvPDP0b7qqenbw+L3qxWfOTAycrjO4cLdkUoYDKCUyzgR9i3QABrDjBc8DuxiMX1yZkr5Wdl75waQFi5KGsnEssPmnMQgKhmhHwJ1AZIUlNNMOv+ZvLD3/60BTzqU3w4whoqcYehT9iXiy+DhuZYdXcI+sxSAmo6hrKh+ye6cR5KpkzYKGQPuHhHql1iefEHBf1Q5Ppm8RK6uTamPXjE17tbnOXKRMconPd8lwDHdlBwJ85rbKHovqjqrODPYhfVUNYAUEhMAQjogdJ9sLH9gEbqIuwN+0WEMwt40IypgMp7ppqPF3pNrqSZcOyXbEPtQMa/qiI9FRTmVNgTaJwwZRwBbfncf7HMtuqcZ1kTyYk5GQK+ztS+hLxaPC+oVhoEor3z6V9jdoZChG+DYBAHZWhT6AvTkmEP0otDXMNaAfiY6By2AF19pCnKeCRUdHPBuUlyUwZTmRKCSifgFHlowuXMSo1HtU=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|6090799003|51005399006|461199028|8060799015|19110799012|23021999003|12121999013|5072599009|21061999006|10092599007|15080799012|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmlvL1FYeGxxaTg4SjdqVkpzbGNaa09jUCs1MWNkUkgxc3BuUlpCSjdRbytl?=
 =?utf-8?B?VXdUUXNBQ1RpcG5LTG4yZHFOTVQwOVZ3cU00bTdkRmdRc2ZXWDFkM0FTTlhq?=
 =?utf-8?B?OWM5TExSVWZqanBTQncyYi9IQUZobEhGOS9TNW1ndHBlVHVPdHFZTEFxME9q?=
 =?utf-8?B?aHFlcXRWM1NhejI5YWJyb00wSnNPeld3bHpuelFVSUpXTGN1YVRWYUxKWDZ4?=
 =?utf-8?B?dll2SElNV1p0QVlBeEw3c0hVeTRFY0szQmdEYnpxcFB1NmFxMEltbm5QQVNa?=
 =?utf-8?B?SGNDVFZXenVyT1BsK2huQml5K1lPTG9ZNGkzUktPOG0zWHdwREJaOCtPSDZB?=
 =?utf-8?B?UUdkVVovZTlwSElyOUNJU0dCMnNYR0VrcmtqNlp4eStyRVJ6OGkwNEc3UG1Y?=
 =?utf-8?B?Z2hvMTJJN0hjcmRNb0hOaTEwbHlocitWbGFXbCt5L3EwMlRLZG5xOVA2VGZ2?=
 =?utf-8?B?RzlrZHEwTDVMMTlIZlZaT3VrNHUyeG1WS1dGNFJNRG8yblI2Q1R2MWdJenJ5?=
 =?utf-8?B?aGZscjdKVDR1cTY4akhNL243bXpHM1ZYenpJbTdVOXdVaVZ2STd3Um9iVkdB?=
 =?utf-8?B?cy9xL3NOWG5pOCtzekJwNXBEcGozcFpDRVFRNE9od0NDK0gzbGhmUGpNY2J3?=
 =?utf-8?B?VGlGM0VKbTRFbUdLaHFMR0JBQWtKREcySHBpekhsUmRqcDBTNDZ6TmQwKzZy?=
 =?utf-8?B?cVZTakw4czFRSEpHWUFhRTRZSWVnRjliZE5FdWRuRGpqeEZkUCtIZDE2V05s?=
 =?utf-8?B?WGV2RWt1K3ljN2FIdkZRck5BL29FS2VjWTRYbTZkZzR3RDl1Z1p4VVZiYnYv?=
 =?utf-8?B?WUpzaHB6Zm0xL0gybmZqb0p6RkhCeE16QVRobEdRbE16eGNZUG5pMFJ3d0ZW?=
 =?utf-8?B?TEJoTnpnYy9rWHlPU0RxRFlEMVJjMm12ci8rbGdOR3BubFI5dEJFazdtcWZ5?=
 =?utf-8?B?OG51dnpkTDFyWnJSYlZ6V0kyWGlxRERNRGRYNDdwcE1kL003MGJUdklrVE1I?=
 =?utf-8?B?eGdMMUhYelNxa3VHdFZYWFkzazF1c3VkbXF1U2RGajlpYVlCV1EyWEZXb1FB?=
 =?utf-8?B?V205NDFSWHczSXM2WWVKUk56cHFkVjhTdVBERy9oVWRHQ0F5YTlMdCsxb3VK?=
 =?utf-8?B?bG1rNE5IWXRRWGdHaUg5Z1VJWmJ4dmtMSEg1UFp0WmNVVWdNRVYydEVsMnRm?=
 =?utf-8?B?UGt6dDA4NGxzUGJVSUhxd0FNVzMwbC8yMTFnb09RbTJYb0VWZGpsaDFYTHlI?=
 =?utf-8?B?dWxick14eS90bEtvdXBqc0pDUCs2RFdRbUJLd1A4MUh5V0RQTWl5M2lVWHc4?=
 =?utf-8?B?NWdGSDJTYmtlSmdsMnBqK0pKNGw1eDg0WFJTR0ZVZ3hJYWdRc0F3Qy94dGpU?=
 =?utf-8?B?ODBuMUtDUW1yeHdMUkJBeDNRd3dYVDAwcUtJQm41M1FqRlZPNE96SjlXTmlL?=
 =?utf-8?B?RGlqUkgwL3I5SSt0Mm5mWE81NWdJbDB2NllRa3dqdnR5QWV0NzcrSmkrWmFu?=
 =?utf-8?B?YXQ3SXo4L2ZDSzJoMDUvVk5mdW1vTTB1allhSmdiQWdpWHhTclI3aStwazB2?=
 =?utf-8?B?ei9ZRnJCVlJrV20rWXZJWnM3VDZPRVFXblR6enZSd3g0QkgwQ0QxaGZYSVVM?=
 =?utf-8?B?ZlpKcDF3eEx4UDBnQ3JRWi9TNUQxYkt2MUZtdzBtWnQ1WTJseXpTTGdLZk1i?=
 =?utf-8?B?TTVmcS9JUEl6cXo4U0JDVy9ZeDc2aVJsUGZQK0tBUXAzdXhaYVpJbFpnOTk4?=
 =?utf-8?Q?kJ/loB1bc/BHbV8Phg=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWp4SWxKUWFIaTMycWlvVlFJZHV0dFBYUERZbkFBWC8rM05CcFZZL2hxVEsx?=
 =?utf-8?B?SkkvSW5LTmthcS9veTVXS0YzMnlIbnkvNzJjNHQ2OGlkcTV4elFQRmN6UUhz?=
 =?utf-8?B?eisxS1pMQjdTV2RIZFFkUjc0MExBS1A5bGs0K0VFa29mcFlxbDd4ZTE2N3dR?=
 =?utf-8?B?MEs3d1JYQ3FjVVVaVkxoRVR0RGI1U2k4Z3ZpWktHOGxkVTN0eEx0Y1FONi81?=
 =?utf-8?B?bHVaVCtwNEFTQkZ6aEZIWXpoYVBDRm1CZFZpMXVlRy83V0oyNTZsODdkbGJh?=
 =?utf-8?B?clZPME4zN1o1NzhoVTVqekJQTFRUNFNXVEh4bUExRWRjeUlwRXZYMW9nUmMw?=
 =?utf-8?B?MDM5V0hpNWp0SEdIc3lDeldXZnd3YXlnZWJmMDdWelhGdHlQMXl0OHhsRmxl?=
 =?utf-8?B?QXZuZTVNTHo3alI1VWdhVXUveHh0ajRjQXovNkhUc2lVci9nV1lzelZtaWZr?=
 =?utf-8?B?TXlJMmM2cFZUVjVBNWx0U2NxNjUvVXRSYW1jSkloN1Y4a21Ud0xiYW8xYnVR?=
 =?utf-8?B?ZlVJQjlxRys2NllpSlpEOFhrbzJsS0dyZ0hGbWVUVmJRRW9IR01uZ0RVRVdN?=
 =?utf-8?B?b3V6ajlTcnZmd1Z0dVZXaEpwUFhZOVdmMjdxYkhDcDkvS3ZQWUJTTC9GYzUz?=
 =?utf-8?B?Qjl3YWR5OGpZVERyait6QndIK3JMOFBibllkUzlWdmtwaEpzUm56WHI3RGJo?=
 =?utf-8?B?Z3FaTVRJL2tyMnMxVThKUVNsR2tGcnJENDdqSS9yTEtTdStkMnBRKytMSTJ0?=
 =?utf-8?B?eXo1VFNQQ09NNk5aWGhTYnNOU0JiQkkzU2dRdnNhTEY5Zi8vek1tSm1aUmtp?=
 =?utf-8?B?b0Q4ZG4waFNreHFUcitROGlzTUlRU0p2enJKYmtDYm5qbGtjeVRnSFFFRWNs?=
 =?utf-8?B?WUE2K1FqQXlOZCtCeXpsUUNnTGtBVFNLWkxyemFyQTlnN2ViS3doS3ZRSFhv?=
 =?utf-8?B?WVdibTltZ0dtVzFaMWJMU1Fkb0l4cUdpalNQdGRGbUxUcjBZK0ZSTWRnaTZz?=
 =?utf-8?B?TkJTSjNpVSswU2hQZkRVK1c5dFhrQUo5Q0xzNlIzdXloTGNUbWJYM3BzZENh?=
 =?utf-8?B?RmV0dGJXc0lrZVF3SlRzTmlobjI0dkxxbWZnWFhsUG1TVEZzaGZPbDlwTVp2?=
 =?utf-8?B?SVRwbTlzRTFldGxjaHYwdnV3aWRqc0Mxa3d3Rm5EWDVNODBhaGhVYmszYmpx?=
 =?utf-8?B?SkJ1akQ4cERFVWpjYWprTEV1OVg4a3RKckJQNGVtbHlReFo3U1paMWRnZTlo?=
 =?utf-8?B?QXZZS3M4N0hNTmNuZmFXN0tibGhTYXpCamJobHpFMSs0U1BlUDNPODdFWW1B?=
 =?utf-8?B?b0RXa2NkMzM5UkZiSVJ0Tk9aMEJYR1ZkZGxOU083RkxXcWY0T2ZTaGlUTW5l?=
 =?utf-8?B?cFhsSVR3b1ZBbElvaVQ2blJhNFh4eGVISU5NOUxIbUhDbmtFNm9oYXExREJJ?=
 =?utf-8?B?bVZhbURvbUNwcW1JbVpGTVE4MUF5QkhQL3NtQ1Zwc0dEd1RLMExXQzRhcnQ3?=
 =?utf-8?B?bjZLNTZmZ2FOV2hBRVRUZzB3c3Jwb0hjOVVHMzFXSHpMb2kxbGxvNUlRNENP?=
 =?utf-8?B?Yys4VFkza0dOUEYvOTBVU25UdXN1OTBUNjhTSHRmSGg5UndYcmNMK050SFYy?=
 =?utf-8?B?ZmNJcDdSRjhEbVh5RTZUK0lUZSt6SkxLVlJ3dDdmQnlueFZXUENpRm9xelRj?=
 =?utf-8?B?Wjh6Zm41SlE3Yng0L0taeHZqMnhkcE9GVEZFUzUwUGZtb3MvK1JsZE1RNnkv?=
 =?utf-8?Q?uBwkX0DCE7SuSOzYfd1xadnRIr3Cdj5xZ+lLp+B?=
X-OriginatorOrg: sct-15-20-8534-20-msonline-outlook-87dd8.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: cb352ac1-afa8-42b2-f63c-08de33357fb0
X-MS-Exchange-CrossTenant-AuthSource: GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 13:03:20.5836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5P195MB2377
X-Rspamd-Queue-Id: A27A42001E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 4eixefndsewwn9hjyss54w9otr7u5ng7
X-HE-Tag: 1764853405-467469
X-HE-Meta: U2FsdGVkX18SiRGTJeMeVeH42kzEMAND59xbjtzRFqwGs8dT4Bg6YeyGtDpGMy+8m9E+U2nBen3fND83LYzu7wO50zWqh5EUfuAaiWOIjRjx89MO1PUGYgxAr2UqdM3pyMXztS2N2FCWV1UmSrZUugGQy5+mxSj0ZNaQdsIaL+Iia40EX8vMc2jF1QIv9mF3HVb9DJRnqYfrq/M7hedv1E0IOUTuR5FObftLCSUq7969R8memBH2mzEVDtHCFMXh6+Ncf6nctUWsGfnNJZEh+n6DT2F7P5DCN+57REj4xjmNb+6JQ4+cLhLdHNcnzXdAgPigHLQSuBkGsXXa5X1yNLMs3mvNmZxzqawp8WC50LOXx5QixUz3U0dWFckfg2IbxeYMBU3YE2U5d0bopZ1DHukrb+ba4nmPrOne9kzoRl6Avq9eEjYNjeB5+FSYrID8xJnsirqmuVUvjm9QUuUVCVhcZDRGyZT4VVavr++NfdIpDSoayWzOBhVzJvwcquJsH+eOr7I0Kaoe2tbUX3EBAIYG8/iEPqFdY6zRKWocJUTukRB6BAc26rSIYMY7K76eZL5Y6UzNhTVVnfdXIy+dHQoMnr5QGgksY5IVeFCVva1cPPT4tjmvECpB9r/KcQ92xqjuP4FrHwVeHeRAls027sDnSAizUHN2k8LgYV9ejxSNkGr7/yGhF+Yus1KlVluxDwBJgY6E3y+rIxJxIXPaY9aXQ328NItfa3pnzpG+DW697YLin6Oi7m536n8ULNDFc4q4yAcVdK1+Zz/MLSXKRYAqipVNF5D0UNwxYZDz23Gy3NcA4DeKDfYsZ3Arrfk60ZKRSEKbUiRBWhKrSFvWg+hUpZbT1SGg0iJdtUXidz9BK/b/czFSSYra0kWpI3HSSONYgWdrwSE3WQnvfAQuyg0gZCHPm6nBQWuB8ccoVmkVAw3/3E+YkVkA/L3PpYIvHYdhDhK1Fun7ChiU7uG
 3REVgO/Z
 SpQWPXtisoZBQX9fUV4BCPfE3ETQK0bHo5drNhc13qRI5JJsG2ZB5MNwtjpOWILj6XJzx/M7xNL8T8iYrdeAJzB/FWMN4/Oni08xGcA0OHrFFZ2zMzKVsHanFgNFCGpEd0mYQnn/lCHJuW6/Q1ZZOXh83N2iOdBONj3lkIgICSwXhWyYyzCVjEOIOIXJxrJghWeVo7qWFpBLDtRHZaOf4RdEsUr3DbTFTuf6jvJlAdnlx7BEGcTujPifXhUIPOZR2NSFwsAY4nriQ7cMY4dJxDhWESlfkLhzKs78JP5ZAV8GTnSU9RA6kOWaZhpmu3KPo0pET3MuJLuvZlglwww7p0o1CoxpHEk52pyGR/rtpbWxSwTnkmByk5/ijYxzrHU0sjfGKgigvS4llKWvOUctUCvAJWvrp1PP7IPsTfq3PhcXxpI31ewj0FXkKe7pAXMPWcy7+tDDqWalaisx0YnZAwYawscNSTY2x96ewA/hXYbWJwY0LL8ZsVuicrGIuvgYrOpegSkQcKoye2TJRTaa7Q5zq/4ZkJfANuNOXWdh2pQXIYInFVG9a3lFNMZeMc1wdAJeFfkZ/rih1l0zmXM61J2l39IGajmr3elb6fg/6kSmsndO/8DkhsD2qLGfyVsEbXag7X8xbO2GQ+sRY1y1O7QIyJiHV/GZdDLg8+mbkBScWHbkU9K44AP6zSSZ19VAeC7wuE0D70ai0FZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 06:49, Al Viro wrote:
> On Wed, Dec 03, 2025 at 02:16:29PM +0100, Bernd Edlinger wrote:
> 
>> Hmm, yes, that looks like an issue.
>>
>> I would have expected the security engine to look at bprm->filenanme
>> especially in the case, when bprm->interp != bprm->filename,
>> and check that it is not a sym-link with write-access for the
>> current user and of course also that the bprm->file is not a regular file
>> which is writable by the current user, if that is the case I would have expected
>> the secuity engine to enforce non-new-privs on a SUID executable somehow.
> 
> Check that _what_ is not a symlink?  And while we are at it, what do write
> permissions to any symlinks have to do with anything whatsoever?

When we execve a normal executable, we do open the binary file with deny_write_access
so this might allow the security engine to inspaect the binary, before it is used.
However this behavior has changed recently, now it has some exceptions, where even
this behavior is no longer guaranteed for binary executables, due to
commit 0357ef03c94ef835bd44a0658b8edb672a9dbf51, but why?  I have no idea...

But with shell scripts an attack is possible, where a sym-link is executed,
and the SUID bit of the target file is used but a race condition might allow
the attacker to replace the script that is used by the shell:

Consider this:

ln -s /usr/bin/legitimate-suid-sctipt.sh
where legitimate-suid-sctipt.sh starts with "#! /bin/bash -"

and the attack works this way:
./legitmate-suid-script.sh &
ln -f -s do-what-i-want.sh legitimate-suid-script.sh


Bernd.


