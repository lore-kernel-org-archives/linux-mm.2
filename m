Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0976C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 05:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BBD8E01BD; Wed, 13 Aug 2025 01:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604B18E01B6; Wed, 13 Aug 2025 01:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A0A8E01BD; Wed, 13 Aug 2025 01:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A898E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:49:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A90FF140218
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:49:03 +0000 (UTC)
X-FDA: 83770655766.19.C5B49CF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB9CD1C000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:48:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755064141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sp/2DxwarjNF30lY2ptWkoaiZI2yYME3mRN/j2MpIH4=;
	b=E8wr2cGGLVQJ+NB8RlRBmnyw4weuBMHHDKALZ2yrJgMAP4krWYW6ml3llpAsRhKzfmA3AI
	1lgVRlQHgfDpVe2JCObGIEQKAMTJLFdC3e8ezOwD9rLRzgp9+kycjYt/bslQ/X3QR89mm2
	L0A13Iw7pCUk4rzp9ylSxr+WBLfOSK8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755064141; a=rsa-sha256;
	cv=none;
	b=YgUuwUmz0A6qbl0531eRaTZPYWUzJCzZZ8LLSWHf0mm74nR8KGI+3qIfBpA8fjYp7aNYn0
	iTXYlBb0XCIHvZ+T34h2keV4nBCVGUQld1cWsMBUtm/8ptqlippeF8VTmq+Pux1l9qYmRi
	zOHDfRDxZH3MSUBup4GpbTvuW6G9xl0=
X-UUID: 30a643cc780911f0b29709d653e92f7d-20250813
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:3daa047f-cd79-47a5-8fd7-224c239c4ce8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:994f152d6c1a295ca93fe5963adb0ebd,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 30a643cc780911f0b29709d653e92f7d-20250813
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 54274607; Wed, 13 Aug 2025 13:48:51 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 0897CE008FA5;
	Wed, 13 Aug 2025 13:48:51 +0800 (CST)
X-ns-mid: postfix-689C2742-86747173
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 4E0DFE008FA3;
	Wed, 13 Aug 2025 13:48:38 +0800 (CST)
Message-ID: <8c61ab95-9caa-4b57-adfd-31f941f0264d@kylinos.cn>
Date: Wed, 13 Aug 2025 13:48:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jan Kara <jack@suse.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
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
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
 <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
 <aJW8NLPxGOOkyCfB@tiehlicka>
 <09df0911-9421-40af-8296-de1383be1c58@kylinos.cn>
 <aJnM32xKq0FOWBzw@tiehlicka>
 <d86a9883-9d2e-4bb2-a93d-0d95b4a60e5f@kylinos.cn>
 <20250812172655.GF7938@frogsfrogsfrogs>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250812172655.GF7938@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB9CD1C000A
X-Stat-Signature: nr533rb7pg7a51mf87d5zqttr8swneu1
X-Rspam-User: 
X-HE-Tag: 1755064139-201013
X-HE-Meta: U2FsdGVkX19J12OnPMN3qY7bh1lKrLCxxXEGsHfs4WDZzseSZY3YxbmIjAXp8L0bb3ABFMLrzwg2jkPL18A/kOuGkJqsmCUxdzapA8nnFpa+gVt2w/BrTvwnyGBTxnltjCORpdMUkmevG2+6zKBjSAS9TllIZfqVmpBGD8/MsG82xRYoWjdASFcQwN5AlCUMes6VB4vxnMk88kR2sYlvRhzm3XnIWPyMOdfuDwYwmjkQYes8kwrCTbKFVAc807BqPxZQLil4rn5mjXys7FtEz9KWiC01l6oacGW4XccT4sa+hrVZ53rRPEEO9G0QfvM8IiZ6ctXGxkspLJH1pHLyzgf8OZwPIkBdFGvInRfNnlaql1iCvbUwmn9ncI/UxgRPipOT8zOz0rUNefj+jqvpIf92OhVAeeHpNsSkEywJCcTvMQXjyYjbUoWGp4mh3qEon6y5qyKXCW4+V5Avm8+3gvgfvPZCdQW4Vk0O0PMzvZYUs3MZ9eyZx9TNJFzusJad9rALHRqldPt8KnJ3L7phwYSap2uVQd0T1ZE9c/m6g8zahvdAQZn3TQaLMTUq+B7tqRKeKIOyrs0wlkPD2c8hW3D7IleeJK3/jewwEXIgue/nFPBtQysBUugtuKrY/yHy1p5UvLk3nqbDI5I3R6vJLd5r2pq7naGzKy2FSWZDbz0G4Q5cpBbhKnNnpZak7nu5tG0ku8e/j0rbVix/bZbZ8sJRmDs8lcMO0WiGDQhxDunuWkg0kOk1FB9w7058pLWCy/tNp1Vz1cFB+Fmfmw9bY1h2FndtIR0TiWzOCabsd1jZAAVQAb/q0SdNXn28Jo7RnHhostwgXunrBojrV6nBV1y9nx4ZKFYgFUA8n0NV3YNbhnEXnxOYP5lT8zCz09MwpppOgHRQOC0erNvvos3zkcSmTXZvtZbELfSxyHf+J84rAn7eGPeKbC66FJQRhKfjZTArHALhUpIEf1J0Unu
 UX0NlOOi
 9LN5JQbcU7kga33enqz06wWXMxW/puhDxJ10toPqFEm31K0JBR+499/SZkiwUhT1kgToJjFyPJZJRRCeUnUwa3Av56Ustbi3NrabVJ3yiYjmzXLYQbjFXNNJ//w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2025/8/13 01:26, Darrick J. Wong =E5=86=99=E9=81=93:
> On Tue, Aug 12, 2025 at 01:57:49PM +0800, Zihuan Zhang wrote:
>> Hi all,
>>
>> We encountered an issue where the number of freeze retries increased d=
ue to
>> processes stuck in D state. The logs point to jbd2-related activity.
>>
>> log1:
>>
>> 6616.650482] task:ThreadPoolForeg state:D stack:0=C2=A0 =C2=A0 =C2=A0p=
id:262026
>> tgid:4065=C2=A0 ppid:2490=C2=A0 =C2=A0task_flags:0x400040 flags:0x0000=
4004
>> [ 6616.650485] Call Trace:
>> [ 6616.650486]=C2=A0 <TASK>
>> [ 6616.650489]=C2=A0 __schedule+0x532/0xea0
>> [ 6616.650494]=C2=A0 schedule+0x27/0x80
>> [ 6616.650496]=C2=A0 jbd2_log_wait_commit+0xa6/0x120
>> [ 6616.650499]=C2=A0 ? __pfx_autoremove_wake_function+0x10/0x10
>> [ 6616.650502]=C2=A0 ext4_sync_file+0x1ba/0x380
>> [ 6616.650505]=C2=A0 do_fsync+0x3b/0x80
>>
>> log2:
>>
>> [=C2=A0 631.206315] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.002 seconds)
>> [=C2=A0 631.215325] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.001 seconds)
>> [=C2=A0 631.240704] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.386 seconds)
>> [=C2=A0 631.262167] Filesystems sync: 0.424 seconds
>> [=C2=A0 631.262821] Freezing user space processes
>> [=C2=A0 631.263839] freeze round: 1, task to freeze: 852
>> [=C2=A0 631.265128] freeze round: 2, task to freeze: 2
>> [=C2=A0 631.267039] freeze round: 3, task to freeze: 2
>> [=C2=A0 631.271176] freeze round: 4, task to freeze: 2
>> [=C2=A0 631.279160] freeze round: 5, task to freeze: 2
>> [=C2=A0 631.287152] freeze round: 6, task to freeze: 2
>> [=C2=A0 631.295346] freeze round: 7, task to freeze: 2
>> [=C2=A0 631.301747] freeze round: 8, task to freeze: 2
>> [=C2=A0 631.309346] freeze round: 9, task to freeze: 2
>> [=C2=A0 631.317353] freeze round: 10, task to freeze: 2
>> [=C2=A0 631.325348] freeze round: 11, task to freeze: 2
>> [=C2=A0 631.333353] freeze round: 12, task to freeze: 2
>> [=C2=A0 631.341358] freeze round: 13, task to freeze: 2
>> [=C2=A0 631.349357] freeze round: 14, task to freeze: 2
>> [=C2=A0 631.357363] freeze round: 15, task to freeze: 2
>> [=C2=A0 631.365361] freeze round: 16, task to freeze: 2
>> [=C2=A0 631.373379] freeze round: 17, task to freeze: 2
>> [=C2=A0 631.381366] freeze round: 18, task to freeze: 2
>> [=C2=A0 631.389365] freeze round: 19, task to freeze: 2
>> [=C2=A0 631.397371] freeze round: 20, task to freeze: 2
>> [=C2=A0 631.405373] freeze round: 21, task to freeze: 2
>> [=C2=A0 631.413373] freeze round: 22, task to freeze: 2
>> [=C2=A0 631.421392] freeze round: 23, task to freeze: 1
>> [=C2=A0 631.429948] freeze round: 24, task to freeze: 1
>> [=C2=A0 631.438295] freeze round: 25, task to freeze: 1
>> [=C2=A0 631.444546] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.249 seconds)
>> [=C2=A0 631.446387] freeze round: 26, task to freeze: 0
>> [=C2=A0 631.446390] Freezing user space processes completed (elapsed 0=
.183
>> seconds)
>> [=C2=A0 631.446392] OOM killer disabled.
>> [=C2=A0 631.446393] Freezing remaining freezable tasks
>> [=C2=A0 631.446656] freeze round: 1, task to freeze: 4
>> [=C2=A0 631.447976] freeze round: 2, task to freeze: 0
>> [=C2=A0 631.447978] Freezing remaining freezable tasks completed (elap=
sed 0.001
>> seconds)
>> [=C2=A0 631.447980] PM: suspend debug: Waiting for 1 second(s).
>> [=C2=A0 632.450858] OOM killer enabled.
>> [=C2=A0 632.450859] Restarting tasks: Starting
>> [=C2=A0 632.453140] Restarting tasks: Done
>> [=C2=A0 632.453173] random: crng reseeded on system resumption
>> [=C2=A0 632.453370] PM: suspend exit
>> [=C2=A0 632.462799] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.000 seconds)
>> [=C2=A0 632.466114] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.001 seconds)
>>
>> This is the reason:
>>
>> [=C2=A0 631.444546] jdb2_log_wait_log_commit=C2=A0 completed (elapsed =
0.249 seconds)
>>
>>
>> During freezing, user processes executing jbd2_log_wait_commit enter D=
 state
>> because this function calls wait_event and can take tens of millisecon=
ds to
>> complete. This long execution time, coupled with possible competition =
with
>> the freezer, causes repeated freeze retries.
>>
>> While we understand that jbd2 is a freezable kernel thread, we would l=
ike to
>> know if there is a way to freeze it earlier or freeze some critical
>> processes proactively to reduce this contention.
> Freeze the filesystem before you start freezing kthreads?  That should
> quiesce the jbd2 workers and pause anyone trying to write to the fs.
Indeed, freezing the filesystem can work.

However, this approach is quite expensive: it increases the total=20
suspend time by about 3 to 4 seconds. Because of this overhead, we are=20
exploring alternative solutions with lower cost.

We have tested it:

https://lore.kernel.org/all/09df0911-9421-40af-8296-de1383be1c58@kylinos.=
cn/=20

> Maybe the missing piece here is the device model not knowing how to cal=
l
> bdev_freeze prior to a suspend?
Currently, suspend flow seem to does not invoke bdev_freeze(). Do you=20
have any plans or insights on improving or integrating this=20
functionality more smoothly into the device model and suspend sequence?
> That said, I think that doesn't 100% work for XFS because it has
> kworkers for metadata buffer read completions, and freezes don't affect
> read operations...

Does read activity also cause processes to enter D (uninterruptible=20
sleep) state?

 From what I understand, it=E2=80=99s usually writes or synchronous opera=
tions=20
that do, but I=E2=80=99m curious if reads can also lead to D state under =
certain=20
conditions.

> (just my clueless 2c)
>
> --D
>
>> Thanks for your input and suggestions.
>>
>> =E5=9C=A8 2025/8/11 18:58, Michal Hocko =E5=86=99=E9=81=93:
>>> On Mon 11-08-25 17:13:43, Zihuan Zhang wrote:
>>>> =E5=9C=A8 2025/8/8 16:58, Michal Hocko =E5=86=99=E9=81=93:
>>> [...]
>>>>> Also the interface seems to be really coarse grained and it can eas=
ily
>>>>> turn out insufficient for other usecases while it is not entirely c=
lear
>>>>> to me how this could be extended for those.
>>>>   =C2=A0We recognize that the current interface is relatively coarse=
-grained and
>>>> may not be sufficient for all scenarios. The present implementation =
is a
>>>> basic version.
>>>>
>>>> Our plan is to introduce a classification-based mechanism that assig=
ns
>>>> different freeze priorities according to process categories. For exa=
mple,
>>>> filesystem and graphics-related processes will be given higher defau=
lt
>>>> freeze priority, as they are critical in the freezing workflow. This
>>>> classification approach helps target important processes more precis=
ely.
>>>>
>>>> However, this requires further testing and refinement before full
>>>> deployment. We believe this incremental, category-based design will =
make the
>>>> mechanism more effective and adaptable over time while keeping it
>>>> manageable.
>>> Unless there is a clear path for a more extendable interface then
>>> introducing this one is a no-go. We do not want to grow different way=
s
>>> to establish freezing policies.
>>>
>>> But much more fundamentally. So far I haven't really seen any argumen=
t
>>> why different priorities help with the underlying problem other than =
the
>>> timing might be slightly different if you change the order of freezin=
g.
>>> This to me sounds like the proposed scheme mostly works around the
>>> problem you are seeing and as such is not a really good candidate to =
be
>>> merged as a long term solution. Not to mention with a user API that
>>> needs to be maintained for ever.
>>>
>>> So NAK from me on the interface.
>>>
>> Thanks for the feedback. I understand your concern that changing the f=
reezer
>> priority order looks like working around the symptom rather than solvi=
ng the
>> root cause.
>>
>> Since the last discussion, we have analyzed the D-state processes furt=
her
>> and identified that the long wait time is caused by jbd2_log_wait_comm=
it.
>> This wait happens because user tasks call into this function during
>> fsync/fdatasync and it can take tens of milliseconds to complete. When=
 this
>> coincides with the freezer operation, the tasks are stuck in D state a=
nd
>> retried multiple times, increasing the total freeze time.
>>
>> Although we know that jbd2 is a freezable kernel thread, we are explor=
ing
>> whether freezing it earlier =E2=80=94 or freezing certain key processe=
s first =E2=80=94
>> could reduce this contention and improve freeze completion time.
>>
>>
>>>>> I believe it would be more useful to find sources of those freezer
>>>>> blockers and try to address those. Making more blocked tasks
>>>>> __set_task_frozen compatible sounds like a general improvement in
>>>>> itself.
>>>> we have already identified some causes of D-state tasks, many of whi=
ch are
>>>> related to the filesystem. On some systems, certain processes freque=
ntly
>>>> execute ext4_sync_file, and under contention this can lead to D-stat=
e tasks.
>>> Please work with maintainers of those subsystems to find proper
>>> solutions.
>> We=E2=80=99ve pulled in the jbd2 maintainer to get feedback on whether=
 changing the
>> freeze ordering for jbd2 is safe or if there=E2=80=99s a better approa=
ch to avoid
>> the repeated retries caused by this wait.
>>

