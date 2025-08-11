Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C18CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23EA38E002F; Mon, 11 Aug 2025 05:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF068E000A; Mon, 11 Aug 2025 05:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7328E002F; Mon, 11 Aug 2025 05:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC1188E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:54:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9BC68C072F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:54:52 +0000 (UTC)
X-FDA: 83764017624.01.23609EA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5E61180004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:54:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of zhangzihuan@kylinos.cn: DNS error) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754906087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6d4mCwhqCUjW1C03cCUKBw5cNwfV9qVOoJh5u245K0=;
	b=kKenRxZmC1PcM/qikHOjFn3CducowOe18XzZZ/GaMcHPaWcX/L3SdNwaBJCfH57dlWUg5i
	saVZTCdSNsXe8KaVmCdH1Smuv0kw1WI4fNYdO52r0s5uTJHz4f2pseBOl028S3h8QAka4j
	Ut2pCbDRwQ6hhYRXpdhe9oAa/BQ+zJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754906087; a=rsa-sha256;
	cv=none;
	b=AMDkvXsRG+8kEm6Z3/Pxi+rITl8jjlUL8kdJ5sMaGxKQ1ecSjrjnxX13xxeQIR88WAsV0T
	gvtxg/8spMU1Vw82M4dNZPYEc6fGfbzFDJC2+XHKEhlUq6xmaaCzTZQKNbpIQS0wyz4qiB
	X/hLEmkgNgieHN3Ae0qMR6Rv+2que4w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=temperror (imf16.hostedemail.com: error in processing during lookup of zhangzihuan@kylinos.cn: DNS error) smtp.mailfrom=zhangzihuan@kylinos.cn
X-UUID: 2b9da468769911f0b29709d653e92f7d-20250811
X-CID-CACHE: Type:Local,Time:202508111725+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:acc68978-f090-491f-984d-775e43d21c34,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:d6456464c6e6748e41fc8f4c855f847f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2b9da468769911f0b29709d653e92f7d-20250811
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1249145062; Mon, 11 Aug 2025 17:54:28 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 9F9D3E009021;
	Mon, 11 Aug 2025 17:54:27 +0800 (CST)
X-ns-mid: postfix-6899BDD3-5075201002
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 81F3EE008FED;
	Mon, 11 Aug 2025 17:54:24 +0800 (CST)
Message-ID: <4ceb0e8c-d164-4323-add0-a0770ec2afc6@kylinos.cn>
Date: Mon, 11 Aug 2025 17:54:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 5/9] freezer: set default freeze priority for
 PF_SUSPEND_TASK processes
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, David Hildenbrand <david@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Nico Pache <npache@redhat.com>,
 xu xin <xu.xin16@zte.com.cn>, wangfushuai <wangfushuai@baidu.com>,
 Andrii Nakryiko <andrii@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Jeff Layton <jlayton@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Adrian Ratiu
 <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <20250807121418.139765-6-zhangzihuan@kylinos.cn>
 <20250808143943.GB21685@redhat.com>
 <0754e3e3-9c47-47d5-81d9-4574e5b413bc@kylinos.cn>
 <20250811093216.GB11928@redhat.com>
 <428beb0d-2484-4816-86c3-01e91bd7715a@kylinos.cn>
 <20250811094651.GD11928@redhat.com>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250811094651.GD11928@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D5E61180004
X-Stat-Signature: xue4b6casw198717wuow3hdustasjdze
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754906081-341852
X-HE-Meta: U2FsdGVkX18epQ8bp+tnsBz+1AgJcseIq1iYr1uRHFuUJS6t+9m/fmPe0bChD685jc9vnd9uHwdVGj07D7GhFQRtSFSrBLqeUd2Jda/+JDnU6valogfBZHGb+o6e9X2rU4w0CT8S/oIA0iG+H/WB74nEq4dPFyO8N66gP1CWScsK6M0OdSfhan9iIHlQ84LTQ/ULw2Z3Km4gKodV2AWE3ZIrypMCQfqppuBs4amNp4vg47vittbczPqO0BZxe5Vgp3t7SBFqdjRYH8l2l7nBcTHVL52WsJivZppnkPSJzLKATcqPmaKN3WirZGoa/QkID0OvOOEEghOTtGxe9eF7SLYMZaDwcUL6Togo9jHtsWb/of0WSpgQq/EwXXe1Jpi1k7MJwcbFtZj14QX7ZpPPkV22dB6TpwmrdwtaeLj6aqaZSUvFEwgXH6C3cPeMD55ciOREUUVSj531+Dzpg0iPFj94ZI0i+QAV3IqCh/Q0Hxajv1oNNZmaRuH5nf0INMbqbaQFHj7o9mFXXFxeEeeWflZxt/CPOhgBON4oTrar7TP9OtNHBe9PHDCZ+EbiZTp1mXntu1FyA8CNQF40IeBIwj5sxjIKeLzZ48JA5RjiWA9LjpURsifj4L0bDWTAJiei3XVHlahHaWknP8K9PcKu0//LQ4jhpnlrfVB5KIToCcvXzL6kMkgYiT9OBNuaMDHzO9hHQrvZ3Sf1PbsULGM2pKCYzNgLYtZTTX4eFl/WJl3OtvcD5f42SCMPWj55YEGG8gyBI7s/eahlwc9A+0PIQoElN6wlUl5GpK2cDA54MAa+EbIM4b1ybYWRM4I67V//UYv9iLuZOIQ4oj194YWJ5Vjm92oyExSkMT1ZQORAvPq4oaY8R2j3g8OMR70WjFiJ8jVXz6MoNy+jc4jFgsuRzU8cu0v8j7i1MvPVowcPQY1dgdKKy2oYeT4IRZchakq5KLqdk7V9v5zO5wOogzB
 bm2rUqyd
 DV67raFZtYEc/d/L6y3O+YLw811ok3CX3Gb6dbm5baXqz2Z+RwYXX7HV295SaNQnKKHMtj3vr3/F1WlZ7xAb8MD3ftmIwWMmVyFgt0Z4MFHiL2wDMrvyIuvsD2jlTBl1FmbWMI5ocZYFFPiRf3N0Povj8/Xh3fydEKI1jVP+5bvAuGUvW7ErvTPfr52KQzjaNFfyqVHGJO9bbrcty8v5p9SZ0dVptTjL8UZE2xfFH/XN25mNQKOi8rV0cMN9vXzbCzbNTD+THDTzOX72WnXrrSX8vSNsOeyRqJkkeoJrouT98Q+RiL+QoGaZS76Yf9TyGs3OnPFkCg1LupPoEaWq20/LqFubYA2aP2itr9zhqND1evH7PkFqNq5+f9rXgEreqmEqQnMRD9F4y62Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/11 17:46, Oleg Nesterov =E5=86=99=E9=81=93:
> On 08/11, Zihuan Zhang wrote:
>> =E5=9C=A8 2025/8/11 17:32, Oleg Nesterov =E5=86=99=E9=81=93:
>>> On 08/11, Zihuan Zhang wrote:
>>>> =E5=9C=A8 2025/8/8 22:39, Oleg Nesterov =E5=86=99=E9=81=93:
>>>>> On 08/07, Zihuan Zhang wrote:
>>>>>> --- a/kernel/power/process.c
>>>>>> +++ b/kernel/power/process.c
>>>>>> @@ -147,6 +147,7 @@ int freeze_processes(void)
>>>>>>
>>>>>>   	pm_wakeup_clear(0);
>>>>>>   	pm_freezing =3D true;
>>>>>> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
>>>>> But why?
>>>>>
>>>>> Again, freeze_task() will return false anyway, this process is
>>>>> PF_SUSPEND_TASK.
>>>> I=C2=A0 think there is resaon put it here. For example, systemd-slee=
p is a
>>>> user-space process that executes the suspend flow.
>>>>
>>>>  =C2=A0If we don=E2=80=99t set its freeze priority explicitly, our c=
urrent code may end up
>>>> with this user process being the last one that cannot freeze.
>>> How so? sorry I don't follow.
>> The problem is in this part:
>>
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (user_only && !(p->flags=
 & PF_KTHREAD) && round <
>> p->freeze_priority)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>>
>> PF_SUSPEND_TASK is a user process, so it meets the =E2=80=9Cneeds free=
zing=E2=80=9D
>> condition and todo gets incremented.
>              ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> No.
> 	if (p =3D=3D current || !freeze_task(p))
> 		continue;
>
> 	todo++;
>
> Again, again, freeze_task(p) returns false.
>
>> But it actually doesn=E2=80=99t need to freeze,
>> so resulting in an infinite loop
> I don't think so.
>
> Oleg.
Sorry, you=E2=80=99re right =E2=80=94 it=E2=80=99s indeed unnecessary. In=
 an earlier version, I=20
incremented the counter before the continue, but I later removed that=20
and forgot about it.

