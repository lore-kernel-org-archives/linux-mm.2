Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77988E7FDE0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 00:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CA8D6B0005; Mon,  2 Feb 2026 19:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8786B6B0088; Mon,  2 Feb 2026 19:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A226B008C; Mon,  2 Feb 2026 19:14:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622A66B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:14:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCC07B7F14
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:14:48 +0000 (UTC)
X-FDA: 84401224656.04.9BE12A7
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB5DF160007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:14:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=spFvYM5S;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770077687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UL5TkTKpwfsk57GsEmn4YJixM6/oQfn+MbPgW31S17c=;
	b=vcYVc3bqf6smkXCi6431gAGJML08wuDR0O9wbQaxo/crH6TmFJgeykn+8MiaT0zQb8W+TS
	RAh/l/xKGWEOE1KgoTMpPW+OUn4BjU3bSNvxvBxRqwT1kycxY6LPQ+mlfqaBox9l1dm4mL
	WdJoDAhSjjerAgb2GXwZnhee4fryTKc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=spFvYM5S;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770077687; a=rsa-sha256;
	cv=none;
	b=WS3KBXS3KqkLE1TiKwXIa0vW75hzd/a/d6n4W3NQNP2uoXI6yNgQrNGeyFlDILWOsV9c8V
	Lamvf6JzC++M2q5+sqHYt/ftBnaECSoN0d4IlrMxD5sfzEzWgCN7CeUS0G4FN+48WvRPEM
	I4hhjGccXPr8b8hbDHXq9BYr33oRiSo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770077684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UL5TkTKpwfsk57GsEmn4YJixM6/oQfn+MbPgW31S17c=;
	b=spFvYM5SuR1aK33Y9Zg7Cn9Xqh/rBPTDdvWHRoUiFbG0+KEXd75LEfzQmvuXRAP0CEMz74
	3OTta24r/6f555bLCbR79g70lZ2gIrFcrmQ6HQs8FkOmG6Ttzq3obI4umAEhraTtmKL+Om
	y2jvsjD0kO2WoqE56etQ/rIYmN1/njA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Michal Hocko
 <mhocko@suse.com>
Cc: Matt Bobrowski <mattbobrowski@google.com>,  bpf <bpf@vger.kernel.org>,
  Michal Hocko <mhocko@suse.com>,  Alexei Starovoitov <ast@kernel.org>,
  Shakeel Butt <shakeel.butt@linux.dev>,  JP Kobryn
 <inwardvessel@gmail.com>,  LKML <linux-kernel@vger.kernel.org>,  linux-mm
 <linux-mm@kvack.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 10/17] mm: introduce
 bpf_task_is_oom_victim() kfunc
In-Reply-To: <CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
	(Alexei Starovoitov's message of "Mon, 2 Feb 2026 09:30:23 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-11-roman.gushchin@linux.dev>
	<aYA4pH_nIBZ-ZhLL@google.com>
	<CAADnVQL5g8imKNGbHGQ4HA8_qNT4MYwM8P3aCTFUG7uwiuTeuw@mail.gmail.com>
Date: Mon, 02 Feb 2026 16:14:37 -0800
Message-ID: <87jywuwumq.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: rjgrwkq6g1d4n6aj4cnawxd8fryij5nd
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5DF160007
X-HE-Tag: 1770077686-33022
X-HE-Meta: U2FsdGVkX19jqnb4DpGw4Ogz0ov4SG2SmDUFsSBzglgjuZjn5RpqfhkBht1gpTgxE6AoOQHnN9coXg90f7kcJTVTARgF+iUzA4v9vnckMIEbC3qrwDUiP6iDmxTZJLT/gZjB+HfikRb64w9rfG6sB26fblL0o6Y6efhEoHgDtano+gT8x9TLB93eFv+y2V1VFeBZZyDP+9g7ypA//O3DhloYKqKCSb18/GHDRkVD6Uyi8c8fB3H7sVV15pO3B5acyvxUjJPQC05ttVfAw6eFTIZvPWMyE1Y4tYtFvNkXhz406IRZojQaZ/idZyqlCpuel3ZTD4xcmsXXTDvnZ8v2VfcdOPMK1xXgoO/zM1a1/zYpyQakngP1wR5cN8niEeE3ba+Pa15zutdyY5U1p7FrelA9OldB9TSoECtI2nTYuFiFrPtLHlHCjEkI68KbQFjXXgcYob6PWM9Xzk3qYJWCDSisfHdj1oVu4XkVmnOcXvATx9CaLtPmuLBDWd8gq6L7VV920eglv2eBLkaujOHnbDE5XwDY6pJ+DjyQ4eymDDvAUZxMNrxBB4VWHuIz3q1J+vD2Dw7FDCmbQFUzHjfMGREqc4C8/zQ+32vncfbAFwu2XlroO41rOja2nnZun7H3pP+i059LV46lq9hkRFxnzyWH7perHSfVL5P2fuRgaHhq18UK6Jsgm/uIKuRczTDPIHc3o0fOJ9Mw8eaKlk400VMSUdOZzbMo2G3kAKLaKKGUuQ7J1ZcrRAI7wWbjrOGjXLMCulFgfVuYh0nHsxVz7WZYgX75IiMe7bOEe7slVM/4ae8wzBd+LyPek1pD1PFKbogO/R71W/aOMX139pWTs2aCHhUPqBuWMFoaccnKQcVcsFtWdxjPKtKfNuKzLbyvCbfddgld2XaNBf/RT8d5DhFCt6BHmLzPS0NoqKsovsVZeRH9VnC9ZbEfUd95UkX2vFQzDvS+6SHAg40U6ZH
 XP0ElvKE
 MLvtZ4ReZtcoapZL2ZhT86M3gFtAajf5hc/8QcdkO0aaVrGcTUghMu8dL85kYXlKBMy4SIelLBNTyQy2j469j+3olbhjZM/XRRWE/2/iyWNQsSMZIj7fRj3XQwWNraFQM+Pwdj4rvEeJwIZcy+Ikf8ilRyIHDvCE5C641rg7kO2JV1C66dQY2Ax7UXyDD2Bkm7cgPvQfJwg36F/0oSeoJQ9G062b5WpXpjeEIZ6hP/449Z+bnA7sNKtv+gR1ddVf9opvTg1Io9I1Mk/zE7JfF5waCVpaZ/l4Udu7IQ2SPec9jnVQ2sTz1UdB2fUt4N6moxzTM98k4H7o9Ten6uR58gAlG1sSIdLBWNtS1F3Zwti9eTWv0W26Rue06RoqA7qkEJKw4QNb+8hX3pFwiGsZooaY0rvhxwIzt+NEO907zTe8N3DZTSqV7Dknf5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sun, Feb 1, 2026 at 9:39=E2=80=AFPM Matt Bobrowski <mattbobrowski@goog=
le.com> wrote:
>>
>> On Mon, Jan 26, 2026 at 06:44:13PM -0800, Roman Gushchin wrote:
>> > Export tsk_is_oom_victim() helper as a BPF kfunc.
>> > It's very useful to avoid redundant oom kills.
>> >
>> > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> > Suggested-by: Michal Hocko <mhocko@suse.com>
>> > ---
>> >  mm/oom_kill.c | 14 ++++++++++++++
>> >  1 file changed, 14 insertions(+)
>> >
>> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> > index 8f63a370b8f5..53f9f9674658 100644
>> > --- a/mm/oom_kill.c
>> > +++ b/mm/oom_kill.c
>> > @@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_c=
group *memcg__nullable,
>> >       return ret;
>> >  }
>> >
>> > +/**
>> > + * bpf_task_is_oom_victim - Check if the task has been marked as an O=
OM victim
>> > + * @task: task to check
>> > + *
>> > + * Returns true if the task has been previously selected by the OOM k=
iller
>> > + * to be killed. It's expected that the task will be destroyed soon a=
nd some
>> > + * memory will be freed, so maybe no additional actions required.
>> > + */
>> > +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
>> > +{
>> > +     return tsk_is_oom_victim(task);
>> > +}
>>
>> Why not just do a direct memory read (i.e., task->signal->oom_mm)
>> within the BPF program? I'm not quite convinced that a BPF kfunc
>> wrapper for something like tsk_is_oom_victim() is warranted as you can
>> literally achieve the same semantics without one.
>
> +1
> there is no need for this kfunc.

It was explicitly asked by Michal Hocko, who is (co)maintaining the oom
code. I don't have a strong opinion here. I agree that it can be easily
open-coded without a kfunc, but at the same time the cost of having an
extra kfunc is not high and it makes the API more consistent.

Michal, do you feel strongly about having a dedicated kfunc vs the
direct memory read?

