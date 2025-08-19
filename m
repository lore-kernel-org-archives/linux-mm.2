Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BE7CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBD68E000A; Tue, 19 Aug 2025 16:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CB78E0002; Tue, 19 Aug 2025 16:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA098E000A; Tue, 19 Aug 2025 16:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC4768E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:28:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 747BA160212
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:28:47 +0000 (UTC)
X-FDA: 83794645494.19.CB31C33
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id A77A4A0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:28:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A280hM+/";
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755635326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAopiF8dZ3zuj1vhkZjH8oqB8pGFDZFe8uogKHTUOSA=;
	b=QRYM8osYGnYLsuzsErHpjLKTArMWa+QK6ySw2g3gTrBKthsAPPIkQ/Y6rfCTl6lwbo77vE
	xtt7InQZH74EHpB6u+zHBKpmHYaKHYTbAkgxHTtLRDytxPNOtioCTybRaqKC0qffB4kEeQ
	UbwIWOwA5UEILtRJ2c5NRgZvFIqdplA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A280hM+/";
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755635326; a=rsa-sha256;
	cv=none;
	b=4iuRQQ4l7wesf/yI1xKAdKyi3UDGK+WhAI7q1ZCNr4dfR4rJ2l2k+gmoslJyXKUotevfw4
	Hoon+qXtwTZP/xF0Zc36W+IHUwKVZTmCE8cTLDGlERRxXddj/idZ0qnUzlyB0U5ViQhlmZ
	aFMwbjkUB8dtNZOV9d5VzsaA89eEw74=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755635321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAopiF8dZ3zuj1vhkZjH8oqB8pGFDZFe8uogKHTUOSA=;
	b=A280hM+/+Cp5IvWAcBP03DyjcxMnbwLk/dosmmaVKAzGKWQw3VIfAiDwFrHyaZRqkFdMDi
	buMBmtbkF2TzTr5bAJUuuGfKGlVhbnoRobmHoUI+sb2RSKmu0to8P1klPJKkRrb2EW8TYO
	zTcPtGpx3eTw0hDcSoKFH9pOHbgjuaQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 11/14] sched: psi: refactor psi_trigger_create()
In-Reply-To: <CAJuCfpH5cSDGmwBfEmiXkShxxdTEuoRXrTKndNwTMMDUzX8f3A@mail.gmail.com>
	(Suren Baghdasaryan's message of "Mon, 18 Aug 2025 21:09:51 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-12-roman.gushchin@linux.dev>
	<CAJuCfpH5cSDGmwBfEmiXkShxxdTEuoRXrTKndNwTMMDUzX8f3A@mail.gmail.com>
Date: Tue, 19 Aug 2025 13:28:31 -0700
Message-ID: <87ikijys28.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A77A4A0005
X-Rspam-User: 
X-Stat-Signature: pz1fq46n7xi7duj1at51ktmrgcopere5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755635325-764342
X-HE-Meta: U2FsdGVkX1/B8WJkbGhHbk0adYUn0e1ukUdYIcsChv+rtr1O7DrFAcWiOykXje9WtdZD+w7j6z2Ni6Dzcxy+WqWr+zA0PiAU4weTdY0aLn5TlTnPzkq3OG6Xlfm7zg84n3gcu1OZfg3q7gQ1fszkEmhRh/Wa+YIQfqrt0lTgMDuTu1CqatBxnShJjvNIKAvn8iKL6JPYul/NW56Jm1W5+r3ckUFIsok5VXVm3aESas78KRqG6yJZqDwWsMVyvQjVD/19X0q03VllV40lRxROwKQH0BAIv2T6wOMTTN4OcP+pCKrqvinxtx1bCqi1H4L6Xrj/29uRBdqqX0urL6W+RM/mKhyICQW2hP40LdBDKtxtWAYWhaZRWiLQd9qTlTO9VBwxDId4SehMT2lhV4qZW7dLYx0n/Y2hoRDHhWcB5NKyw0Cqsh+Ues2c27Vc3g8CIk75fen13YjzGSowVcNX2XeaX2ngdD3dtnLQ7o3SOdCADAKXjl4YvjGZYwWTY/ThIMlncS8GACJthX/C2uSg9f00JywdedqnJFERNNc0gIOJzoTqI1x6S97XsW6Zg82haLTlsQCs7qU3mo2Jx/QNdcUzSdF8bn9sN+FRDTArm+PCsd7hr8vmSSZ+QvFgUeio8IWDf+p9LxmnLVwqvSkgRxNGvDsxJ8x87Q+UivxpXHC8A6mJoKsTkDAu/Hcp36PIIiJMdLMd7pdRFYgBqabfKXvJCvjVt4doDqvahkOfmHB+/CSbUq4xSpcG10j7RctjPi800xGjVxKL9t1nCgR45W6n0TNPu/z4rUuuMeyk/RYyy6o6rg75dDStay9d43tamn2kShTJCHT/iNfWhwT4pIKcXBxAEiOvISfaJZPZxBiP7GPuu3FnaEAqCwXt6XJ94gd1ZcEwLFg6iEkrH3Is7KDJwVgauPFeQqEcjdtvtefLsJXxBPZp8nwEoL3nY6qdwGy6Wyv8NWvHs4txRrX
 E6HJ6Bu2
 F4mnZyXyd/3vI0T5bfosND6nSZXqwDpnIRRnJoluc8+kFiu8aRDsVzWWJet7H1vkKv9+RqeMpVbjVud+IgsDuuisL27wLehSM+6m8zAx8GmrQP+SEGd2aqXbw65tfXtS5dJ1/QVTrYtY7OE0NAaLG591yqYBU2h33ylb6Gykp5U5szQj92OdD66me0mGbFJxYCEWn2P924L0VNpxjYutofBhqtlJedG6ywTqyQcTJ2seEGSWhybcqh6vp8GvE/A/mHPjSEq8sNtwwzYsKFJNFvoOqFNzQ4Rs6DsLRXPOXGIxVd3bf66bPHLTHWxG0IShW5jno8BaQMe9Ge++0G3A46EOmbRWsGoOySpue
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Currently psi_trigger_create() does a lot of things:
>> parses the user text input, allocates and initializes
>> the psi_trigger structure and turns on the trigger.
>> It does it slightly different for two existing types
>> of psi_triggers: system-wide and cgroup-wide.
>>
>> In order to support a new type of psi triggers, which
>> will be owned by a bpf program and won't have a user's
>> text description, let's refactor psi_trigger_create().
>>
>> 1. Introduce psi_trigger_type enum:
>>    currently PSI_SYSTEM and PSI_CGROUP are valid values.
>> 2. Introduce psi_trigger_params structure to avoid passing
>>    a large number of parameters to psi_trigger_create().
>> 3. Move out the user's input parsing into the new
>>    psi_trigger_parse() helper.
>> 4. Move out the capabilities check into the new
>>    psi_file_privileged() helper.
>> 5. Stop relying on t->of for detecting trigger type.
>
> It's worth noting that this is a pure core refactoring without any
> functional change (hopefully :))

Added this to the commit log.

>
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  include/linux/psi.h       | 15 +++++--
>>  include/linux/psi_types.h | 33 ++++++++++++++-
>>  kernel/cgroup/cgroup.c    | 14 ++++++-
>>  kernel/sched/psi.c        | 87 +++++++++++++++++++++++++--------------
>>  4 files changed, 112 insertions(+), 37 deletions(-)
>>
>> diff --git a/include/linux/psi.h b/include/linux/psi.h
>> index e0745873e3f2..8178e998d94b 100644
>> --- a/include/linux/psi.h
>> +++ b/include/linux/psi.h
>> @@ -23,14 +23,23 @@ void psi_memstall_enter(unsigned long *flags);
>>  void psi_memstall_leave(unsigned long *flags);
>>
>>  int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res =
res);
>> -struct psi_trigger *psi_trigger_create(struct psi_group *group, char *b=
uf,
>> -                                      enum psi_res res, struct file *fi=
le,
>> -                                      struct kernfs_open_file *of);
>> +int psi_trigger_parse(struct psi_trigger_params *params, const char *bu=
f);
>> +struct psi_trigger *psi_trigger_create(struct psi_group *group,
>> +                               const struct psi_trigger_params *param);
>>  void psi_trigger_destroy(struct psi_trigger *t);
>>
>>  __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
>>                         poll_table *wait);
>>
>> +static inline bool psi_file_privileged(struct file *file)
>> +{
>> +       /*
>> +        * Checking the privilege here on file->f_cred implies that a pr=
ivileged user
>> +        * could open the file and delegate the write to an unprivileged=
 one.
>> +        */
>> +       return cap_raised(file->f_cred->cap_effective, CAP_SYS_RESOURCE);
>> +}
>> +
>>  #ifdef CONFIG_CGROUPS
>>  static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
>>  {
>> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
>> index f1fd3a8044e0..cea54121d9b9 100644
>> --- a/include/linux/psi_types.h
>> +++ b/include/linux/psi_types.h
>> @@ -121,7 +121,38 @@ struct psi_window {
>>         u64 prev_growth;
>>  };
>>
>> +enum psi_trigger_type {
>> +       PSI_SYSTEM,
>> +       PSI_CGROUP,
>> +};
>> +
>> +struct psi_trigger_params {
>> +       /* Trigger type */
>> +       enum psi_trigger_type type;
>> +
>> +       /* Resources that workloads could be stalled on */
>
> I would describe this as "Resource to be monitored"

Fixed.

>
>> +       enum psi_res res;
>> +
>> +       /* True if all threads should be stalled to trigger */
>> +       bool full;
>> +
>> +       /* Threshold in us */
>> +       u32 threshold_us;
>> +
>> +       /* Window in us */
>> +       u32 window_us;
>> +
>> +       /* Privileged triggers are treated differently */
>> +       bool privileged;
>> +
>> +       /* Link to kernfs open file, only for PSI_CGROUP */
>> +       struct kernfs_open_file *of;
...
>>         t->event =3D 0;
>>         t->last_event_time =3D 0;
>> -       t->of =3D of;
>> -       if (!of)
>> +
>> +       switch (params->type) {
>> +       case PSI_SYSTEM:
>>                 init_waitqueue_head(&t->event_wait);
>
> I think t->of will be left uninitialized here. Let's set it to NULL
> please.

Ack.

Thanks!

