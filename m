Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DDFC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DAE6B008C; Fri,  8 Aug 2025 04:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF086B0093; Fri,  8 Aug 2025 04:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4A76B0095; Fri,  8 Aug 2025 04:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE7AC6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:40:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A3CC117B66
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:40:29 +0000 (UTC)
X-FDA: 83752943778.19.A90959F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id C6478140002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:40:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754642427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=junXdwx0TkSI7LNOYjpb9IXp+ymJxIevkjGvsBY0XJo=;
	b=2dysJeFJFW5h5D2jiWw/5Il/5PUBRXhWsSyTG2ctcQOobhMZP2IHrNvLMQkCrKfY3Cvru5
	YUgRRZ1XReAZQPZ4hJkuBO8Kg3eBG6Je0IXx+fx9HVvVgyK58ghH+z981C790qu6qBaWd3
	Rb/4BLdMeTJIBj/kLvPoQSkrKh1C4yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754642427; a=rsa-sha256;
	cv=none;
	b=24M8dc10tyx8Ks9RweOFOIiLAZB0J3VnstwM1JzczVL5PrSMO4H4daRjyQDB3AcapTSbbp
	KLAEJzBEpvBJ1acv+6mx/ZZ5Qm7/Syyi+W/weKhC2vSfXKFFUPwtT4DWhIA5rbJ2ADOI4V
	AIZpVtWEXJwz1B+PrNi3ygXhIqSCMjQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
X-UUID: 4f9d64ec743311f0b29709d653e92f7d-20250808
X-CID-CACHE: Type:Local,Time:202508081552+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:e0211e39-915b-47f5-8269-b2a5fc39732d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:12be9df259196fe631b2eedfa1e50959,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|52,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 4f9d64ec743311f0b29709d653e92f7d-20250808
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 516528990; Fri, 08 Aug 2025 16:40:17 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 29FF3E01A759;
	Fri,  8 Aug 2025 16:40:17 +0800 (CST)
X-ns-mid: postfix-6895B7F0-853165559
Received: from [172.25.120.24] (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 3E5B8E0000B0;
	Fri,  8 Aug 2025 16:40:10 +0800 (CST)
Message-ID: <4644c5ec-b74b-4428-bd14-7b50dbd22397@kylinos.cn>
Date: Fri, 8 Aug 2025 16:40:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, David Hildenbrand <david@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
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
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <20250808075753.GB29612@redhat.com>
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
In-Reply-To: <20250808075753.GB29612@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6478140002
X-Stat-Signature: yqj9o3pitaud6kzd96rhdha43mg9m67p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754642425-636729
X-HE-Meta: U2FsdGVkX18ZSo94+hGNaInthzcDIIwUHogSpbcQ0/7EEgfeOaUZKkqZe+AME0XK7K9v6IyTc3gP2BkBMBDayqsA6UdQjJG4cQhQXwP5u4UjwFLaR8yptXgnXfGaLSei/9Z/S5SLObMu9+py6jU88rI2CwpsbncSziPhOu791DQ+uGVAhaw4j3nk+7OnWArRZWdx36s6ErQhBMH+zEMS5i1kCfYX2GvZn8GcneID15d8HmYEJpnerwCJX0yNQRcXtiU1p9ifhyQA5SQpDCXyk6U+H+5rcW36btL8VY1vDrzxko4lxmEAUWu0RyZSpMIdFfk4RxLv0yzg5mB2il8cqvbNWF40w43ZjwXWXbkGvWaoCcr8uvj72tRom2S4CCAsxV9FkyuH0wu+aq+S+daQTNMheJmsXz1TvH+qIF9q09Hg/8wqbOdnBGYwwnKQkdK6a8ZjmYoyX4JMD1AL3ydJ4Kx0xezncvjOMjKlBsvt/mYdLEbvshSWc1C2kO8V57ocHPuqe9aRVu5oAZRdNt8qUg2s7fQCK92PqO8zS2NBjIk0LujixVHWFpPHanMaRtKmgqaUw5kWYyXpPgWfSdhbhH54sCCDNhiOuG7emLI+695/DjWpDxolJsCGJWXDTkTO6U1o71zfO7+jhGLT/IHhfE4JV2oXB0PpNrj3gve1qe8XedBo1gnZTr3WaUe+lfrpKwVyCYGOemZRVoFtPFDt+7y30zGN6HcnMPacMpyLFuqQDwoudxOCRewFuhvb1DiPnP+KIwC02unoEn5+Y7IB/WtuW0eU14nvZ8PGJBLk2TuELTBLT1Fu8YgWv9E1XwK0srm/+aOTerMpaNGg6VCDHyP/Gx0RJ+MAhw8PnwZb/3osYnFA7rUtMMdR9Xc9re21zji/kG19PhKE1/DTuA9mUTD6MuqJOT3eEKep56X22LcsmWjBWrYZyCF2M029UQb9QqfXjMwX+NfMKCGF5/T
 xEYNjaQN
 1Vnq6BF8ioX6/9cmXd/F44TBQQjQIiBXR9A+rJ2nv0lobaoLH2audR1SsxG+phERNETUzYtxI8XQ4qjuBsCpjecJTA+hOdNnMWiYq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

=E5=9C=A8 2025/8/8 15:57, Oleg Nesterov =E5=86=99=E9=81=93:
> On 08/08, Zihuan Zhang wrote:
>> =E5=9C=A8 2025/8/7 21:25, Michal Hocko =E5=86=99=E9=81=93:
>>> If they are running in the userspace and e.g. sleeping while not
>>> TASK_FREEZABLE then priority simply makes no difference. And if they =
are
>>> TASK_FREEZABLE then the priority doens't matter either.
>>>
>>> What am I missing?
> I too do not understand how can this series improve the freezer.

Thanks for your question =E2=80=94 actually, I just replied to Michal wit=
h a=20
similar explanation, but I really appreciate you raising the same point,=20
so let me add a bit more context here.

Right now, we're trying to address the case where certain tasks fail to=20
freeze (often due to short-lived D-state issues). Our current workaround=20
is to increase the number of freeze iterations in the next suspend=20
attempt for those tasks.

While this isn't a perfect solution, the overhead of a few extra=20
iterations is minimal compared to the cost of retrying the whole suspend=20
cycle due to a stuck D-state task. So for now, we believe this is a=20
reasonable tradeoff until we find a more deterministic way to=20
preemptively detect and prioritize problematic tasks.

Happy to hear your thoughts or suggestions if you think there's a better=20
direction to explore.

>> under ideal conditions, if a userspace task is TASK_FREEZABLE, receive=
s the
>> freezing() signal, and enters the refrigerator in a timely manner,
> Note that __freeze_task() won't even send a signal to a sleeping
> TASK_FREEZABLE task, __freeze_task() will just change its state to
> TASK_FROZEN.
>
> Oleg.
>
You are right.

