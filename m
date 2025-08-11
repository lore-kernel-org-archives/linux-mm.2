Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835A6C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248FD8E002A; Mon, 11 Aug 2025 05:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220508E000A; Mon, 11 Aug 2025 05:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F508E002A; Mon, 11 Aug 2025 05:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0021B8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:42:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA318140755
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:42:52 +0000 (UTC)
X-FDA: 83763987384.18.AFB9E96
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 166104000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:42:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fi9fIv4DylvAnNIGcP6TTQN27NE6Qw5b1cNAC655a/I=;
	b=6XXENZhP3L25SKOHcTyloKEL9Psw/qCCJMuTWBofvYGtFIWV7a8Vrs19Ii5ff4HoThBwFo
	qHsT6RSNH/GKydhRcNiRia2foF3k6bAFUHFpWk+Cp7Udm/el/UTPUXEiQLkYyJpU4LWuaM
	XJnNYvAxBsdHXBE313n8pc3oUqX3wGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905369; a=rsa-sha256;
	cv=none;
	b=Qr/9jIc9whq0jcDJlwRrPAFQ6wZnHCg7QBK/IjrVzTmlNXlqIQLc1WQk2e8ZL1+MbxztDt
	xJVcqOEaTCh57hwUsRYIwcQLSXmg4WO/F4libv3UXx3++nBU3sk4xUbsHLzrwlh47ZVv9M
	m95p8waFUR/roucX+N9pgYCMuWq8XxM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
X-UUID: 853663c2769711f0b29709d653e92f7d-20250811
X-CID-CACHE: Type:Local,Time:202508111725+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:8f82698c-6304-4797-b77e-bd9eadd96666,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:d6456464c6e6748e41fc8f4c855f847f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 853663c2769711f0b29709d653e92f7d-20250811
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 381576943; Mon, 11 Aug 2025 17:42:39 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 01051E009021;
	Mon, 11 Aug 2025 17:42:39 +0800 (CST)
X-ns-mid: postfix-6899BB0E-484419978
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id C8EA4E00901E;
	Mon, 11 Aug 2025 17:42:34 +0800 (CST)
Message-ID: <428beb0d-2484-4816-86c3-01e91bd7715a@kylinos.cn>
Date: Mon, 11 Aug 2025 17:42:34 +0800
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
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250811093216.GB11928@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 166104000D
X-Stat-Signature: qkkxg5bed76i5sbk16cfefeecspetaxo
X-Rspam-User: 
X-HE-Tag: 1754905367-894007
X-HE-Meta: U2FsdGVkX18sYFtnkClC3xWwJqK1z8bvelgM6WdFBtJgFRpaFUoaasAdd+phOGXce1e8Ltdy3mkJotTafayfq6CaMHPFxzpzO3ZweJUWSCsaIjUZYsLT3y4IKj51obT4F0UgO+5vJ2Njwa4vzVzgM2FUmBStRjYd7ZUDlC0og8MH1u3OjlmF/9mLoc1evR/lt9pOnngizAjyklj8lCjvNUakmxdDpIPPgJds3Y0X8uelL0hNWQGLyWwEhohGUFU7zFMPRaBt42SgEJhoupId9ZmZXCcy1wsMGDBY+6oqHA0363EDWMVEHsrYpfvPIPw1IdyM+zr84/gqc/TJ1Kkjy+morWgQHona9Y1Bh9BC0z40nDhtu+6TnXIF8GrDmARM62wfMZrcIEC2UWTC4lMdqJyxqHWsX9jpbJ2wMLf7ycyQTFzaOYKbvAlSzvFdEdIvhDB1hge/lnabMk9/WXpZci3MmDCbfEz17PWcD6aKv04PKEXmbbxVbfzrfKBQKhxAMWmlZpOuMIXI+OVrw2j1CMxXlCCB4HfiLBlb1K3M9obkmUaRD1WCkrYjNDT1ebc/F3+CJQVN3jzhMNJYfEnHdLOLaR7MvP9gfP89BquyZ5KC2soT7NT834LiURjiqs2ggaH9R8ggpcIgqGECsAXwmcUbQCzg8hqCzx1USY0tV7WKDlQXaveEo0nCXNOguvQm+2MCPpkdmg35T92+Q6Gbq4EYXaY5mxVn4wt/lcPTcjx0F8dMAjrG08Bt53Ocg+HVHgiyeJFTml5DhMWlnRex0pGeBQv10FyI/y4F3j/EHR3z4uS6WXXN8TTvlFZPWL6TyVLiSGaA3BZPIQh1b5w0AZj2sTSPhusAvVD+HOtObhPiePoMDz1ufwB9W8vuQo/eXLfucDU43PjtKIG8Qkvo6xfMX7QaUcbQzGHc6WVtG0FoVE3Ja7W9is1XrciDgW5S1PZZLGDqOfbhYBc7gUC
 PfrFdNOL
 GvG4gcMn7YVvDEpPJS8Uhfe1vVunAh+sWlpAUIhKt5kX2xaW/FtK88r3dvfMQmPR2bBKYO4PG1yN+M7Mm6DGM3oo/8cceNCCuYsKd0i5jubzlLlbK54cawdqnLZhokO61MqLF+AJR3dz4CMpuMsNJqilft1ZIuesQrO+8/eLOTWQckGvOOuJDZ3+oQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


=E5=9C=A8 2025/8/11 17:32, Oleg Nesterov =E5=86=99=E9=81=93:
> On 08/11, Zihuan Zhang wrote:
>> =E5=9C=A8 2025/8/8 22:39, Oleg Nesterov =E5=86=99=E9=81=93:
>>> On 08/07, Zihuan Zhang wrote:
>>>> --- a/kernel/power/process.c
>>>> +++ b/kernel/power/process.c
>>>> @@ -147,6 +147,7 @@ int freeze_processes(void)
>>>>
>>>>   	pm_wakeup_clear(0);
>>>>   	pm_freezing =3D true;
>>>> +	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
>>> But why?
>>>
>>> Again, freeze_task() will return false anyway, this process is
>>> PF_SUSPEND_TASK.
>> I=C2=A0 think there is resaon put it here. For example, systemd-sleep =
is a
>> user-space process that executes the suspend flow.
>>
>>  =C2=A0If we don=E2=80=99t set its freeze priority explicitly, our cur=
rent code may end up
>> with this user process being the last one that cannot freeze.
> How so? sorry I don't follow.

The problem is in this part:

+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (user_only && !(p->flags & =
PF_KTHREAD) && round <=20
p->freeze_priority)
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;

PF_SUSPEND_TASK is a user process, so it meets the =E2=80=9Cneeds freezin=
g=E2=80=9D=20
condition and todo gets incremented. But it actually doesn=E2=80=99t need=
 to=20
freeze, so resulting in an infinite loop

> Oleg.
>

