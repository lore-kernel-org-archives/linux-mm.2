Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67F5C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 01:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DAD46B0096; Thu,  7 Aug 2025 21:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AB56B0098; Thu,  7 Aug 2025 21:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379DC6B009A; Thu,  7 Aug 2025 21:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2239F6B0096
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:13:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5A581A1157
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:13:52 +0000 (UTC)
X-FDA: 83751818304.02.3651C00
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E3DDC0006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 01:13:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754615630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l8Jn4VPIGAIneMH/RkoOF62RMFhf9H+gODm1lGC0N4M=;
	b=Mk1mL9RCw8J/s70Z7VSBvABIrT/UHLKmeeT4pj8INNakeJvWZ6h4hOGuBy6xWTvo539apW
	Vzxmp17vVeQIi0bURi4ekwcBmuWH0pL0LWRoZgwU+Bjb6FfgHpQhc15/TdV6SCE1tLHQl+
	nCF6zqJTDBlFEJ/ejqsbZauaV4DGTZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754615630; a=rsa-sha256;
	cv=none;
	b=TU0rhhk0WSk+QS+7rfdhgb8SrfEoyUYevM+VBcv4jeslioroZt67MHUZfZrL+FB5dzHHuo
	c880Nuh2r/rtTe8BfDyo6fpym+51qwIuy3o6//+8BAYDTY4u+DiqLXIwXuiHQ+lQqkKKSw
	2tAnTo8El65ufDQKSYhBJFNaryn1IaU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
X-UUID: eb81b21273f411f0b29709d653e92f7d-20250808
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:776e54fd-e886-4705-8814-2912ed7b1ed4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:b62a745bded9568a354f757b5e9c74bc,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: eb81b21273f411f0b29709d653e92f7d-20250808
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1518627884; Fri, 08 Aug 2025 09:13:40 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 7C2CBE0000B0;
	Fri,  8 Aug 2025 09:13:40 +0800 (CST)
X-ns-mid: postfix-68954F44-36935566
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id E603EE0000B0;
	Fri,  8 Aug 2025 09:13:30 +0800 (CST)
Message-ID: <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
Date: Fri, 8 Aug 2025 09:13:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: Michal Hocko <mhocko@suse.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 David Hildenbrand <david@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
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
 <aJSpTpB9_jijiO6m@tiehlicka>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <aJSpTpB9_jijiO6m@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2E3DDC0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 3kbshq8jd9aquxzpf1zbt7ysrwim9nca
X-HE-Tag: 1754615628-422020
X-HE-Meta: U2FsdGVkX1+oJgr5IJFqcDz0osXYEnD2NG8Yz5UpibyJYcG8qLNIFhmC/Q1B1PPnktRCTGwIF5e65VuZZbctC70u5+vWPgHXqx8VHR3bznXkb2RUbEJ2LWfwQoxYd2IGukBrknhU+LzqH48yJJwQ5b83UVenoBlIANSS9hweDo9hHyAEo089LkOd99MMLzu1dIzfoeeOFrgRfNsuBhnOad8/D0zGRCWTj9qNoKfpoSP5Yj7yyptoYUlUSIsL+XWOJayxai4XzhTja0eM95RfoeC5JaU8GRllToSHTCGgE4NZ5R3P2boky2oKm+M+nSS9hF+O7jn3ymWb+SxYKuncHK20jhXXq/RoR2sFofrDI3y+7V17ztYxnGOtiCBOqRZdswSZjPw4YUVQQ7S4Yl4RXl1eV3JNJMlAMjoVfWj7Ou1C2eAnoDvyVB8eDMSgrTZwE52+f+jbs5DYEXupSzO9cDFNg+kMA9GTlXnDNpD1GDL/HVNaJWsHbZVIkA2b+aBtSG+YCx4F6m6Fx85mulI8Xo3spqw9IY6rxBeux5kRSHmy64SqIzxqWagUDUYP5L1LmHedKVtcoq50QtPK4yIWLE+umGbwJ+ccQ7tToEImRAE+3SEdKkY71C1N0kS6jhba8Wpqpg3VPNbmwj0Sth1npB3Hh5vlyuZUl1/5AsLmaCIf4qxrexOGw74QBtuvW1HkueUhwQxR+F9bxBo+FuoEhkCWHNE0895muG7tv26IS3PvMjLeD0g8f1i9zznebVTSvcZOI0Q579NwxBNI1vNx0ozaIg+0XnyMJM8FCzQSlowqmUam+2U46A2uFCIR4aHu8bvCxC6iAbsQ7F1Ry39a8cYgaD1XgC7IGg5ihc64PHdaeTNrt7rrgHEor0frPYyq4Z/dGe0w34kkX4qdEl/OVnGZKH0oWnH5N61/fODUkUvX3pGJN0uu8H4ZrxlIXEYhYhyNb6AgbE+MNfhudW4
 lZCc13UX
 RPcUTg/vmkT/tmpfDJGtIUaQ3LudJbRFz6ZIX7wfVfa368vY2SQnzX+/OIeaGROFrwzTTGtT8mQNfWj2+CmT3hlXuckNmfMC0x7SOemLFJYdbO81kITTJmwhl1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2025/8/7 21:25, Michal Hocko =E5=86=99=E9=81=93:
> On Thu 07-08-25 20:14:09, Zihuan Zhang wrote:
>> The Linux task freezer was designed in a much earlier era, when usersp=
ace was relatively simple and flat.
>> Over the years, as modern desktop and mobile systems have become incre=
asingly complex=E2=80=94with intricate IPC,
>> asynchronous I/O, and deep event loops=E2=80=94the original freezer mo=
del has shown its age.
> A modern userspace might be more complex or convoluted but I do not
> think the above statement is accurate or even correct.
You=E2=80=99re right =E2=80=94 that statement may not be accurate. I=E2=80=
=99ll be more careful=20
with the wording.
>> ## Background
>>
>> Currently, the freezer traverses the task list linearly and attempts t=
o freeze all tasks equally.
>> It sends a signal and waits for `freezing()` to become true. While thi=
s model works well in many cases, it has several inherent limitations:
>>
>> - Signal-based logic cannot freeze uninterruptible (D-state) tasks
>> - Dependencies between processes can cause freeze retries
>> - Retry-based recovery introduces unpredictable suspend latency
>>
>> ## Real-world problem illustration
>>
>> Consider the following scenario during suspend:
>>
>> Freeze Window Begins
>>
>>      [process A] - epoll_wait()
>>          =E2=94=82
>>          =E2=96=BC
>>      [process B] - event source (already frozen)
>>
>> =E2=86=92 A enters D-state because of waiting for B
> I thought opoll_wait was waiting in interruptible sleep.

Apologies =E2=80=94 my description may not be entirely accurate.

But there are some dmesg logs:

[   62.880497] PM: suspend entry (deep)
[   63.130639] Filesystems sync: 0.249 seconds
[   63.130643] PM: Preparing system for sleep (deep)
[   63.226398] Freezing user space processes
[   63.227193] freeze round: 0, task to freeze: 681
[   63.228110] freeze round: 1, task to freeze: 1
[   63.230064] task:Xorg            state:D stack:0     pid:1404  tgid:14=
04  ppid:1348   task_flags:0x400100 flags:0x00004004
[   63.230068] Call Trace:
[   63.230069]  <TASK>
[   63.230071]  __schedule+0x52e/0xea0
[   63.230077]  schedule+0x27/0x80
[   63.230079]  schedule_timeout+0xf2/0x100
[   63.230082]  wait_for_completion+0x85/0x130
[   63.230085]  __flush_work+0x21f/0x310
[   63.230087]  ? __pfx_wq_barrier_func+0x10/0x10
[   63.230091]  drm_mode_rmfb+0x138/0x1b0
[   63.230093]  ? __pfx_drm_mode_rmfb_work_fn+0x10/0x10
[   63.230095]  ? __pfx_drm_mode_rmfb_ioctl+0x10/0x10
[   63.230097]  drm_ioctl_kernel+0xa5/0x100
[   63.230099]  drm_ioctl+0x270/0x4b0
[   63.230101]  ? __pfx_drm_mode_rmfb_ioctl+0x10/0x10
[   63.230104]  ? syscall_exit_work+0x108/0x140
[   63.230107]  radeon_drm_ioctl+0x4a/0x80 [radeon]
[   63.230141]  __x64_sys_ioctl+0x93/0xe0
[   63.230144]  ? syscall_trace_enter+0xfa/0x1c0
[   63.230146]  do_syscall_64+0x7d/0x2c0
[   63.230148]  ? do_syscall_64+0x1f3/0x2c0
[   63.230150]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   63.230153] RIP: 0033:0x7f1aa132550b
[   63.230154] RSP: 002b:00007ffebab69678 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
[   63.230156] RAX: ffffffffffffffda RBX: 00007ffebab696bc RCX: 00007f1aa=
132550b
[   63.230158] RDX: 00007ffebab696bc RSI: 00000000c00464af RDI: 000000000=
000000e
[   63.230159] RBP: 00000000c00464af R08: 00007f1aa0c41220 R09: 000055a71=
ce32310
[   63.230160] R10: 0000000000000087 R11: 0000000000000246 R12: 000055a71=
b813660
[   63.230161] R13: 000000000000000e R14: 0000000003a8f5cd R15: 000055a71=
b6bbfb0
[   63.230164]  </TASK>
[   63.230248] freeze round: 2, task to freeze: 1


You can find it in this patch

link:=20
https://lore.kernel.org/all/20250619035355.33402-1-zhangzihuan@kylinos.cn=
/

>> =E2=86=92 Cannot respond to freezing signal
>> =E2=86=92 Freezer retries in a loop
>> =E2=86=92 Suspend latency spikes
>>
>> In such cases, we observed that a normal 1=E2=80=932ms freezer cycle c=
ould balloon to **tens of milliseconds**.
>> Worse, the kernel has no insight into the root cause and simply retrie=
s blindly.
>>
>> ## Proposed solution: Freeze priority model
>>
>> To address this, we propose a **layered freeze model** based on per-ta=
sk freeze priorities.
>>
>> ### Design
>>
>> We introduce 4 levels of freeze priority:
>>
>>
>> | Priority | Level             | Description                       |
>> |----------|-------------------|-----------------------------------|
>> | 0        | HIGH              | D-state TASKs                     |
>> | 1        | NORMAL            | regular  use space TASKS          |
>> | 2        | LOW               | not yet used                      |
>> | 4        | NEVER_FREEZE      | zombie TASKs , PF_SUSPNED_TASK    |
>>
>>
>> The kernel will freeze processes **in priority order**, ensuring that =
higher-priority tasks are frozen first.
>> This avoids dependency inversion scenarios and provides a deterministi=
c path forward for tricky cases.
>> By freezing control or event-source threads first, we prevent dependen=
t tasks from entering D-state prematurely =E2=80=94 effectively avoiding =
dependency inversion.
> I really fail to see how that is supposed to work to be honest. If a
> process is running in the userspace then the priority shouldn't really
> matter much. Tasks will get a signal, freeze themselves and you are
> done. If they are running in the userspace and e.g. sleeping while not
> TASK_FREEZABLE then priority simply makes no difference. And if they ar=
e
> TASK_FREEZABLE then the priority doens't matter either.
>
> What am I missing?
under ideal conditions, if a userspace task is TASK_FREEZABLE, receives=20
the freezing() signal, and enters the refrigerator in a timely manner,=20
then freeze priority wouldn=E2=80=99t make a difference.

However, in practice, we=E2=80=99ve observed cases where tasks appear stu=
ck in=20
uninterruptible sleep (D state) during the freeze phase=C2=A0 =E2=80=94 a=
nd thus=20
cannot respond to signals or enter the refrigerator. These tasks are=20
technically TASK_FREEZABLE, but due to the nature of their sleep state,=20
they don=E2=80=99t freeze promptly, and may require multiple retry rounds=
, or=20
cause the entire suspend to fail.

