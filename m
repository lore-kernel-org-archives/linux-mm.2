Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B063CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38216B00F1; Mon, 11 Aug 2025 05:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FFC6B00F3; Mon, 11 Aug 2025 05:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94C8F6B00F4; Mon, 11 Aug 2025 05:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 862A96B00F1
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:25:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 448A8BB412
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:25:32 +0000 (UTC)
X-FDA: 83763943704.15.F6FC5AA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 439C240008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:25:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754904330; a=rsa-sha256;
	cv=none;
	b=iIrhzXdm8n0IVReBfLHGp/vO+JrdPiYvRSOjZwk8Ur0BKTYnYDPEGZJM5CJaJzaxXEuZru
	BCAUtDhx3V9v4JEazbcU35otoLBJDdTYyAyYWykaOlFkfNEotRR50xTMWEaltPcUWmnL5V
	eYdA3V9/ZYVLmVSCVasTzYu7DzjB+lU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754904330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pd87iunJHFRWcILRtFWKZ2FeAzjIeCZuwvCnTv7xREU=;
	b=YMd+JdClE/GzCPyv9/7+wx7M3TiOy0KilonWN3A2wDVjWJuFxGXlxLST7JIqdhN+j7Bhkf
	TQE4fOuXnx3OxKRXHB3ev1TP//xXUohOBzaVdgEETyNxh54WmGItkPvTQvuJElNgvaFalM
	XbH6cZz2+/0trRpwUm+vF8cBMx4OjtQ=
X-UUID: 1918392e769511f0b29709d653e92f7d-20250811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:482ea64d-9d7c-4d03-b134-789f2a05fb1b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:d6456464c6e6748e41fc8f4c855f847f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1918392e769511f0b29709d653e92f7d-20250811
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2091135485; Mon, 11 Aug 2025 17:25:19 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id C5CB2E00901E;
	Mon, 11 Aug 2025 17:25:18 +0800 (CST)
X-ns-mid: postfix-6899B6FE-684577930
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id EE6C2E008FED;
	Mon, 11 Aug 2025 17:25:10 +0800 (CST)
Message-ID: <0754e3e3-9c47-47d5-81d9-4574e5b413bc@kylinos.cn>
Date: Mon, 11 Aug 2025 17:25:10 +0800
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
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250808143943.GB21685@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h86w489ix4wuturtyknk46ehtk4m9s68
X-Rspam-User: 
X-Rspamd-Queue-Id: 439C240008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754904328-991719
X-HE-Meta: U2FsdGVkX18StlrMy8YQYDgQa510r0bgC+aMMsNgXPKKvaffMs0+oIKz7IERIQtb0RUZA+6pAfnl90uijCypL+Yf0XEYj+weR9gbM0suwOcy2OihjsCgh51Mo+apgmveD6c0rS2bAhQWY/driMr0B6kkPT6QFGivzLrayFS0IJ8PzP+/t+sTq9XwZ/sBqRdLDvU4edkmbqf1KuoGmNHQC8kOE2m9sAEL5FGoslU7hpF6lN93Evqopm25bFjF0MqLuARNbBJTLubkY3Rm7oARpMp+jGHjA75Gy2kUQ2ptTIBnGEOsVe9gx2FmC4xzxijsOg1jLv+3CDwQm7h2ZTrD+a5DtzROFWqBxTF6YasovC8rPobMCgLSiH0v5xPH8PiCYtj69izXZwarzE5svyWCjBbPXYe79ypVgP8mqwxyOAro2B0bxruyrKmkQkFm+siEeizOz4+zHownDJMSJApKNViS74vdLhVOjb4YIbnX89i76vVsxwE5rFovcPJKJbC/6uA9+DFtWfJetu3Mrh5vBOjmDsBhdf5LZhRX7RGFo9uCaLLNx8noiDdDWB69Uv8yJHfIbINy5OVjWLRwHsNadGdQP0KrFOu9ZEqhlUZZl67mMG8ZHp25CNlXhBO4FTw2SQiJ2C75slQocnEDgyhiTuARuPlP0p4cB4Ut+vLI1srBjhjUXmdDv8GFhq3YIn9IUvctBs1xyYaXMXet6lYMG2TjNcXZqzBH1mjJoBLLvw3mKiauuS7juVj2UvDmvDf12Q7P+AgnxmK4PuoaZlf5d9fDU7342Y93xKGGOVFUOPseQNDhlJKE9ZCsHo4+7xfsIwMsAZhU3/0E9xCH8J9OfU3miClcJwIhvJmbGNUS6XvsN6IZry8wja7z+GM/6wtTobxz1C31PXoFzj38gPgy7Se+AP1oYfm2vKooA/0PCODL8NM+ci3xz/8Mh1vZ47lSesqxwk365lEWGlzvvQN
 gWbeslhx
 Qeu1+7xLzVslYhEaWVEAWixXS2d4yS9u5KZFA+kpRIxVGV1ffUehqJC5tRFx1VqBtkbiQDW8++wy7FuAEDXRNLHz82M4bPGX3XBZVudgaaXV8pLNnDOI0uZdGUdj+fpdUSGb7aPkHpLkatm2UKuSmd7SXfeO5MqlXGHSrO7nuh5fijHJnlLKr8abc+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/8 22:39, Oleg Nesterov =E5=86=99=E9=81=93:
> On 08/07, Zihuan Zhang wrote:
>> --- a/kernel/power/process.c
>> +++ b/kernel/power/process.c
>> @@ -147,6 +147,7 @@ int freeze_processes(void)
>>
>>   	pm_wakeup_clear(0);
>>   	pm_freezing =3D true;
>> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
> But why?
>
> Again, freeze_task() will return false anyway, this process is
> PF_SUSPEND_TASK.

I=C2=A0 think there is resaon put it here. For example, systemd-sleep is =
a=20
user-space process that executes the suspend flow.

 =C2=A0If we don=E2=80=99t set its freeze priority explicitly, our curren=
t code may=20
end up with this user process being the last one that cannot freeze.

Of course, we could adjust the code logic to handle it differently, but=20
in our model its freeze priority is considered the lowest, so setting it=20
here ensures consistent behavior.


>> @@ -218,6 +219,7 @@ void thaw_processes(void)
>>   	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
>>   	curr->flags &=3D ~PF_SUSPEND_TASK;
>>
>> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NORMAL);
>>   	usermodehelper_enable();
> What if current->freeze_priority was changed via
> /proc/pid/freeze_priority you add in 9/9 ?

Sorry, my oversight. You are right =E2=80=94 in this case we probably sho=
uld not=20
allow user space to change the freeze_priority of a PF_SUSPEND_TASK.=20
This would avoid unintended behavior during suspend.

>
> Oleg.
>

