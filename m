Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC4FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7036B008C; Mon, 20 Jul 2026 14:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7E66B0092; Mon, 20 Jul 2026 14:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 070896B0095; Mon, 20 Jul 2026 14:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF4FA6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4908DA0294
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:39:24 +0000 (UTC)
X-FDA: 85010017848.08.2AA1FEB
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id C02C520009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:39:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=OzPsWnZa;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21jF7uNT/UmoujGO3hllhCYF5UQ/NYJ1eORppVbnz3U=;
	b=D6lzKrlus+QtHC2SngoL78FJOxPjGZ3OHfIdsrwA5aT04idpR27aUkd6ZcURxQx/5enqqb
	1yMNALZBvOqDNsuu3NvedBouVs/P08EgBzTZc6+qMhJrhyV2vYCXE7L4xrhiW67ahq3cKQ
	nmfVuFrbLiS2G3lESsWV6FwM6p9JoPE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=OzPsWnZa;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784572762;
	b=5QBHqECbZs4E9vVxIShqptiHcnVqdSb2aJJky/qOtG5I9yB//yCpmM31zQRwl5FHrFBj3j
	bHY3EwNeYvutiZ8+pS8mMVOq8r3DLn+XoBT5SMco0+jzYHa4c0kirGbo64WorlRJgwCtam
	S/eAqRBzBai3rhjUyheCxZQ9Elx+16k=
ARC-Seal: i=1; a=rsa-sha256; t=1784572726; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=U2EgM9/PGsGpsyyKeNNu6jaQm9AzraiBZ/qzEN7iX/ESZa71d0KhTONzaf9D+qNC1sVXALdndY1BIoC2apXDmGASMt9NZW6pjufNqIkXS+5CcqFv+G2HYWf3qb/Z7+X/h/X8X+K3HpYHTigQwVUyn5EQy3M7793DYx0pDR7gA3E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784572726; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=21jF7uNT/UmoujGO3hllhCYF5UQ/NYJ1eORppVbnz3U=; 
	b=a39cNvHHF6/npwftmelrS7iHwHh7849NCClNN9lnGlDR+Y3ZTMroVa3NuU3wkEP3KpaeVMvN3dCrgOZI/ZjKQefipdxsHNuaesCKFrz1A1HucDs09yObReTgCKWwQsnOZiYE+WdS00RJyxfXHAtGkIB4KA8EylgdhYW9zx8XXoY=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784572726;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=21jF7uNT/UmoujGO3hllhCYF5UQ/NYJ1eORppVbnz3U=;
	b=OzPsWnZaTFinUg8fqmdvc4CoGzw2y4Q1rmzG7ffv6R/AiDxxENsZ4eYQ9hCEPsKH
	u7BRdu92RM9ztWderErMLNTYgQvdZCfJFAGIbXF7QBw5l1zF8Qyui0wpa278PWMpAef
	5X7mfHqjOg92+A5ZAFdLw7BjK1Msxzxm7eqebHS8=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1784572726154850.5205242083554; Tue, 21 Jul 2026 00:08:46 +0530 (IST)
Received: from  [14.139.128.24] by mail.zoho.in
	with HTTP;Tue, 21 Jul 2026 00:08:46 +0530 (IST)
Date: Tue, 21 Jul 2026 00:08:46 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "Liam R . Howlett" <liam@infradead.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>,
	"David Rientjes" <rientjes@google.com>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	"Steven Rostedt" <rostedt@goodmis.org>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Juri Lelli" <juri.lelli@redhat.com>,
	"Vincent Guittot" <vincent.guittot@linaro.org>,
	"Dietmar Eggemann" <dietmar.eggemann@arm.com>,
	"Ben Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
	"Valentin Schneider" <vschneid@redhat.com>,
	"K Prateek Nayak" <kprateek.nayak@amd.com>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"imbrenda" <imbrenda@linux.ibm.com>
Message-ID: <19f80d2cb7e.2efd096643510.6776299399502503493@zohomail.in>
In-Reply-To: <ljr2jkxomq4ccgzq2ip3c66mjdryomhl2gxkswv4wzry5ye2ax@xaehxzjkkk3m>
References: <20260719185409.409685-1-adi.sharma@zohomail.in> <ljr2jkxomq4ccgzq2ip3c66mjdryomhl2gxkswv4wzry5ye2ax@xaehxzjkkk3m>
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large
 exiting processes to a kthread
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C02C520009
X-Stat-Signature: czjfocecsxdf9i415suy7q3w744z97k9
X-HE-Tag: 1784572761-524194
X-HE-Meta: U2FsdGVkX18LmkUMxl4LsnkuVRE9J8QjzbGVQIPh4nwAb/9WwYwOVBYb73qhjvefmgwYX1NA6STiOjkEVB1oh6x5h3IbpTKlUhM+ZdNUknndLVdFx87cWRMFr+5tDD01984ZLHlqPA9LRCCGpQP6J39brfyk52dxAnA4hqcEDQkudAf4qIlZib8IhjUxj9ZSzMMd/PcWsGERYrxaGIe0LAu7UuGTdAJSnVujBNEqs7G0KvlRaHA/kT3mu5ZX6IHDAsLQv/i+RsCIpmux7iMKigq9u9W6ykK5PwyMMg4Mn/jr4vQhyN75fAxNCZuzZ6ruI+b4pNj58pazv0ezwpzdjda/0EyiZhRT+GPt9+cms5EbczFjKoY6s9+uABpy6Pep48Jchpi5DdqIc00hzoq/OhL20QMNCuxlL34yjrJ0of/XlvjpZTfgksxZIZa3C5DAOepwv8GclIHft16jGIB+HEPoAJ/sL5kSZOn0l9W+enICzicwtdxfXG5zGc31clisb+xYvh3mHphi9I7feDySRBO7rg40R1myKQvSR9WDBYJJe4HDMdQV+/XZUJkcKYWkYlPmKR/SzhR/QF9699CCLtjDmafWRMNv5Cp2k2tyJW6BUBEAnSrvShVBML8T+PLHJV2ll/uWPs6chSGJfQq+uBdfZuNINZO1QWnutntRUPT2aX9/dK3E3To/eqJ4PqFYT4n87Oc7TTkyN/A3ZM3cuDTFOQd9I56wCMfYbiGrMZzKmqWLEFVVhiD1t0ZQSxxWTGAHvuOa9IoymgRfJ/oo2VqSKnIjsH7fzeDKIMzoByxHIKqh+ZhMQS9LdoS7sx2S0Euw1M++MKwsXdXld+re6rJU98SmzTy98eqWMYmKhiIrer4u/SawlMjp8t8Jse6Ams85tAMd/PBuEy51N3aA/BhXvTpXbaVoGXAQUTUg7V3j83L/ga56dIJfIjl8OwijB3UeYFrnIGYBCLLfXcQ
 CE2ApHUp
 OQKNcLaLhL6YIzck87l/Zh4DzU2aoNMdRkGPGRRp9TiwFM/YycTkG0C1yNFaIwsUUNBcL3MxusprXrx9cr7N4+arsYjP0YdCuicHafZUKgBBLsiUE4sxu9WJxzW4J1FaYL/VwXsluTzc4CxrvpZlop6fUoBUKltnpOwpywoq9k31v0iiYyB0FLekEMugnnHMD3IKmPYA4pIiMqSH0tKY1YImCg4hQCRYTJJo12KWpEpfKBqxqTP4EzqCOMZ4FQcnFaBFOvVOl+je4IYp6IerMUx+s4qtf/VunDMs7fWuCseZvYrKmfl67wMTt+r+VPg/efe6OcpAVjUQ5uq+Pe1GGBnVmNqTRnyEEm40Mn2/D0mvQ8eOnufnG9oKUDER2GfiOzBylVS1wBP4SPzzR7yzlJI1gGr5R8r4CyRJThn/XhwV/lHOr/rGxvKZ2hZEChQd9V9rGMcPlwrvtjH4MqyD2ZHKRI50Ap+XbE8OV7niJ6CNrvFmi+7d846TAVxOkZEkUV6q7QD36gPdjZ1hzxfeGou4cenrnatIdSfPqgX4pDrp46+CaIyK5cJmhWBIXs2HR6Xb6+nzSFO1xa7nDAp+2gyRYJ+uzVCfWbRQTvPyvpJVY/zeNJ/s8TXpIuoPO7T6PaBSB5d3zIRAiXGcWHYcFuLFPe4QpJb29nMf4FdqtbU4IGBipUfS2233pKZsc6+jVMFRyBb5xnxA6+Q9BsL+2YcF+yCglpYmPaGxkqJmSlVL9owFhxe4Okb2fS6pDww+viWcfIf4BPKBX4UecffpFa4cO/0FZ4xGi7a960wNgpTt3rKzTqCoXJc5A+abagcgHq1gC+cad0Li2wzhb/FywIor9/uzNmVhL11tFhUoZLEURQax/R081mx3vI6ZmHhZOBr/cdZORPZuwHgdWqr2VmyHLBksQROwwudJZ5u5heE/MYhwDwivNVVWDGQNtW8rAaAotoEXEu/Kdhe8wKIsRTT4jZrg+
 LAIzA1Ly
 xe5k/MMELwL+LfPj1XyE/hiBhE3ubwTIAXzwnwZ4gatOBpnh22eQOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Sent using Zoho Mail


From: Liam R . Howlett <liam@infradead.org>
To: "Aditya Sharma"<adi.sharma@zohomail.in>
Cc: "Andrew Morton"<akpm@linux-foundation.org>, "David Hildenbrand"<david@k=
ernel.org>, "Lorenzo Stoakes"<ljs@kernel.org>, "Vlastimil Babka"<vbabka@ker=
nel.org>, "Mike Rapoport"<rppt@kernel.org>, "Suren Baghdasaryan"<surenb@goo=
gle.com>, "Michal Hocko"<mhocko@suse.com>, "David Rientjes"<rientjes@google=
.com>, "Shakeel Butt"<shakeel.butt@linux.dev>, "Jonathan Corbet"<corbet@lwn=
.net>, "Shuah Khan"<skhan@linuxfoundation.org>, "Steven Rostedt"<rostedt@go=
odmis.org>, "Masami Hiramatsu"<mhiramat@kernel.org>, "Mathieu Desnoyers"<ma=
thieu.desnoyers@efficios.com>, "Kees Cook"<kees@kernel.org>, "Ingo Molnar"<=
mingo@redhat.com>, "Peter Zijlstra"<peterz@infradead.org>, "Juri Lelli"<jur=
i.lelli@redhat.com>, "Vincent Guittot"<vincent.guittot@linaro.org>, "Dietma=
r Eggemann"<dietmar.eggemann@arm.com>, "Ben Segall"<bsegall@google.com>, "M=
el Gorman"<mgorman@suse.de>, "Valentin Schneider"<vschneid@redhat.com>, "K =
Prateek Nayak"<kprateek.nayak@amd.com>, <linux-mm@kvack.org>, <linux-doc@vg=
er.kernel.org>, <linux-trace-kernel@vger.kernel.org>, <linux-kernel@vger.ke=
rnel.org>, <imbrenda@linux.ibm.com>
Date: Mon, 20 Jul 2026 03:58:47 +0530
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large exit=
ing processes to a kthread


 > This reads like it was written by an AI, but there is no assisted-by
 > tags.  Which AI did you use to generate these patches and/or cover
 > letter?

I used claude opus 4.8 to refine commit messages (the design is mine,=20
the model was used to convey the intentions concretely). Further, I used
claude fable 5 for drafting the cover letter and reviewing the series, wher=
e
it flagged issues (I fixed some of those by hand and some were fixed by fab=
le itself,
which I then reviewed). It also assisted in writing the benchmark harness
behind the numbers and did the litmus test the cover letter mentions. Every=
 numbers
was measured by me, on my hardware. I take full responsibily of the entire=
=20
series.

My bad that I did not add an assisted-by tag. Should have added it to v1
v2 will add it to the patches

 > I do not see a benefit to running the task cleanup 'off the side'.  In
 > modern computers, that may mean switching core types that run at
 > different speeds.

That's why the reaper's affinity is a preference, not a bind (patch 2).
It uses kthread_affine_preferred() with housekeeping mask, so it can be
re-affined. kthread_bind_mask() would have taken that away. On a hybrid cpu=
,
it can be affined(by the (super)user) to whichever cores are appropriate.=
=20

I do not have numbers for P core and E core teardown costs. Will measure an=
d
send them.

 > Regardless of speed, the CPU that will be doing the work is remote to
 > the workload by design, (or may be, depending on the scheduling?).  That
 > is, you are tasking another CPU to do cleanup of local CPU-aware
 > information.. The ideal CPU to do a task exit is the one that's doing it
 > already.

Yes, it does cost something. Five consecutive 4GB inline teardowns in my te=
sting
costed 372ms in exit path, while 440 ms in the case of kthread drain for th=
e same
(five teardowns on another cpu). This cost became 1.18x. For multi gb mms,
the memory to be reaped would be much larger than the cpu cache can hold.
For small mms (< 64 MB, configurable by sysctl), the teardowns happen inlin=
e.=20

The oom_reaper already reaps the victim's address space from a remote conte=
xt,
as returning memory matters more than locality of teardown.

 > There are hidden costs to your approach and I don't really understand
 > how this could possibly speed things up - even parallelized tasks will
 > take more CPU time in total, even if locking issues are avoided.

This is not meant to speed up teardown. Rather the latency for someone wait=
ing
on death is reduced. Killing a 16 GB redis cost 292.97ms before returning t=
o
waitpid(). It costs 0.24 with async teardown. The memory itself was returne=
d
in about 300ms.

"parallelized" - This series does not parallelize the teardown. The design =
is serial.
N procesess exiting together today would tear down concurrently today. The =
reaper here,
uses one thread (nice 19, affined to housekeeping mask).

The numbers in cover letter support that this work is memory bound rather t=
han CPU bound.
In sync case: teardown is around 56 GB/s on my machine (1GB in 18.01 ms and=
 16GB in 282.16ms).
Thirty two concurrent 0.5GB exits reap in 157.42ms (around 101 GB/s). So, a=
 concurrency
of 32 gets about 1.8x. The single reaper thread takes 650ms to clear the sa=
me (about 25 GB/s).
Thus, this serialization took 4x the drain time, but takes peak concurrency=
 down to
one cpu. Memory actully comes back later. Whether that's a good tradeoff, d=
epends on=20
what else we wish to run on the box (open questions #1 in cover letter)

 > Sure, the task waiting for cleanup to complete may think it's done and
 > continue to do the Next Thing - but if it really needs the cleanup to be
 > completed

It is off by default and opt in (sysctl), so anything that depends on the
current semantics, continues to work exactly the same by doing nothing.

Also, mmput_async() already defers the teardown to a workqueue. So, in the =
current
kernel, there already exists a way where continuing to the next thing
does not necessarily mean that the memory is reclaimed.

 > completed then you've just made it impossible to know when it has
 > happened.

There are three vmstat counters and two tracepoint (patch 6).
Someone who opts in to the mechanism, and does need to make sure that the
cleanup is completed, can use the counters and tracepoints.

 > Also, you've just made this extremely hard to debug if something is
 > missed.

There are reap tracepoints that carry the pid, so we can get per pid comple=
tion status.

However, there is no number indicating the current depth of the queue. The =
series addds queued,
sync and rejected counters. Will add a reaped counter in v2 so that current=
 queue depth
can be estimated. Please mention what else tracability can be added to this=
,
and what senairo do you have in mind that these counters and tracepoints mi=
ght not
cover. I can add those to v2 as well.

 > The work that is done in teardown is necessary.  Your time (and tokens?)
 > would be better spent trying to improve what we have to do instead of
 > shifting the work around.

This does not compete with with current teardown path. it goes through the
same exit_mm(). Any future improvements there, also improve the reaper's dr=
ain
times.

Thanks

Aditya

