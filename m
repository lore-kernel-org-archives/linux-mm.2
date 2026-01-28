Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC826D46BEF
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F266B0005; Wed, 28 Jan 2026 13:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D24A6B0089; Wed, 28 Jan 2026 13:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DE386B008A; Wed, 28 Jan 2026 13:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5936B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:44:58 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2B055AF6D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:44:56 +0000 (UTC)
X-FDA: 84382249392.27.C793DDF
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 082EC1C000E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:44:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sHuIpmYo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769625895; a=rsa-sha256;
	cv=none;
	b=8ec8N7lQJLa4i7MqyXjwxU5k9pDoW1SGHfJB4blVY4AV5T/ZtmRYC+F4fxBBftwzmv/tRP
	r2oy2WrSp60cWYKsX4+oYZBARDgFia3m+Ba17KL1dTj1HKU53BdCahOWNbbKSEyfwKNf88
	oiyq3OmQz3+AD9GNb1tjNzCOAqXd9a8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sHuIpmYo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769625895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5y1bNb7lvbHRR7VjlpKpzTePa+b4b/b8DdQ3nC5MUWw=;
	b=wtlNGkZSwBKPCrkGzMmcozYp+M8VsITCjbj2KOW1OmmBqYauwVnOK8DbrhmTcGZFzEuCu+
	Bk+yrny5EjsvgXlJQypAP8V3wumS/6hPdcL6pcIo/CQvYQfQO1JPTSpqxB/hAnrbU05B/N
	jcrBumtKbSy5DVXdnp22qRd3AUuHTgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769625892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5y1bNb7lvbHRR7VjlpKpzTePa+b4b/b8DdQ3nC5MUWw=;
	b=sHuIpmYo9z7kkzEOrkG4PBrB9WkbJBfSf+hBFKQCQuLy735rFdhvO51Li+mrgo9MVbAjqk
	i5ianWzmsYMp2pgt1T9l33J1YPFHrFj4u8OwxCXJpBMsvs79rinw7lfyXdhUwSh2bOLsuC
	foIY8ZLyRYY1g9vga0xfuVYuzldFT+o=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: bpf@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,  Matt
 Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
In-Reply-To: <aXnCLWYbQ8xZ2IyO@tiehlicka> (Michal Hocko's message of "Wed, 28
	Jan 2026 09:00:45 +0100")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-8-roman.gushchin@linux.dev>
	<aXiHok-3SKqLncCf@tiehlicka> <7ia4tsw6hi93.fsf@castle.c.googlers.com>
	<aXnCLWYbQ8xZ2IyO@tiehlicka>
Date: Wed, 28 Jan 2026 10:44:46 -0800
Message-ID: <87ikcl1srl.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 082EC1C000E
X-Stat-Signature: ttxg7jdmuc48udqwyifbmer9xq679utd
X-HE-Tag: 1769625894-85420
X-HE-Meta: U2FsdGVkX1/vJqBvf/IttJL80JAnQnFMZ3jOLGzfRQgJ4GrMuWgn3mzYAxcjo0FlK+vRVhh+YYJyS8KjDk0V68FO6wAx+ZLZ7vXIk+y58qxGEZH8jN/SNMQ1071h3Vb/CXKfp0xNA5Y4vFwM7VN+ToWoYNNKplbmgNfS9FjFl1jIU4J44JqLkzAP3/ttdxXF1cZp4cB9UTZjnwpxRYEKsvsiUzBQRtc0EXC6v56z3D0YoXC6To1OVle0ebNGxo7Ki6NkV2yT63sRMm9ADJeRq05GYRO9kxKBoZ4PmfvAseu2I3FQ592QsH6v2NjI7i3D5JZseEi0hLnaHHiXBb/6OEErai8P73lHoiPGnWqQ3OfrmGwhiIeD4Ran4St888HVhT70/MQqibKEHxejJZPbE/I+bGsQ5JxV/PAQsWY3Q615vzOencB2dh5UmyCcxWXpoMB5blaTG/o4DE3cw3Le72Hu/lTqwzqdAyFJWH27VFCpOx+FVPuxo3BGbjbnfp3HW+E9wtRaH4LNtseLc51ei7P6hKzJCrmsutu3GLeEmcPHtsmz4HY17oXjYjmvv4IQg0J7zaLoFBocSaG+xQBkLyd3IGh50VoAYSlbG/86wroh4/JAU9zcOFZjRI4ia5av9bUPpF4WWzM4y0S5HMHtC7z9ggz33BKW5gSGi/YZ1TpXDo7tSxSV/fEHYXBUZ3Ey8doBPXXHGsBNwxBknpgbBbcJ8ksda2AohXeyvjV6Pz7yj2UvaMlfAtBRQnffnQS0g43mJ0gufyy1xomLlnz8XjZjtaKvlpYiiC2vK3VuLut/gyTFyooxY2dG8kQB+y56KNg2FZinfMyI+OFQueygOgY8WUTq96IWDo8HLJ2tg1wM1sJEvWieX5GOaHlhYSG14zXYNDSsXUCFKyiSaXizem3GfEreN65/UvDpK941SMy1TzAlNPOzz6pQzfvonJcfHKNlXoxk3f6GdUGhQaU
 FWORHJu3
 DDj7BdDDvTyPBV8GxmukIrzh5HsdnJkOvEQM0c7UHxunbA2xYLkOQX56wFZBST39Gyk1/Xt11RZKJI3zWjXgACCh5dJwkmx/oXeWUZAjRYQVQykNuV/8ETnxjAXpA9GxtFb53zlXW1dqnxjmdB9w24U9NmatffN/TDOdyZwpAtRCTac/QiwaHVOLD2W3IG3BtcUlIiDlREfsT3Rnp/av4eq5GJo+Ew830W4EW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Tue 27-01-26 21:12:56, Roman Gushchin wrote:
>> Michal Hocko <mhocko@suse.com> writes:
>> 
>> > On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
>> >> Introduce a bpf struct ops for implementing custom OOM handling
>> >> policies.
>> >> 
>> >> It's possible to load one bpf_oom_ops for the system and one
>> >> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
>> >> cgroup tree is traversed from the OOM'ing memcg up to the root and
>> >> corresponding BPF OOM handlers are executed until some memory is
>> >> freed. If no memory is freed, the kernel OOM killer is invoked.
>> >> 
>> >> The struct ops provides the bpf_handle_out_of_memory() callback,
>> >> which expected to return 1 if it was able to free some memory and 0
>> >> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
>> >> field of the oom_control structure, which is expected to be set by
>> >> kfuncs suitable for releasing memory (which will be introduced later
>> >> in the patch series). If both are set, OOM is considered handled,
>> >> otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
>> >> attached to the parent cgroup or the kernel OOM killer.
>> >
>> > I still find this dual reporting a bit confusing. I can see your
>> > intention in having a pre-defined "releasers" of the memory to trust BPF
>> > handlers more but they do have access to oc->bpf_memory_freed so they
>> > can manipulate it. Therefore an additional level of protection is rather
>> > weak.
>> 
>> No, they can't. They have only a read-only access.
>
> Could you explain this a bit more. This must be some BPF magic because
> they are getting a standard pointer to oom_control.

Yes, but bpf programs (unlike kernel modules) are going through the
verifier when being loaded to the kernel. The verifier ensures that
programs are safe: e.g. they can't access memory outside of safe areas,
they can't can infinite loops, dereference a NULL pointer etc.

So even it looks like a normal argument, it's read only. And the program
can't even read the memory outside of the structure itself, e.g. a
program doing something like (oc + 1)->bpf_memory_freed won't be allowed
to load.

>> > It is also not really clear to me how this works while there is OOM
>> > victim on the way out. (i.e. tsk_is_oom_victim() -> abort case). This
>> > will result in no killing therefore no bpf_memory_freed, right? Handler
>> > itself should consider its work done. How exactly is this handled.
>> 
>> It's a good question, I see your point...
>> Basically we want to give a handler an option to exit with "I promise,
>> some memory will be freed soon" without doing anything destructive.
>> But keeping it save at the same time.
>
> Yes, something like OOM_BACKOFF, OOM_PROCESSED, OOM_FAILED.
>
>> I don't have a perfect answer out of my head, maybe some sort of a
>> rate-limiter/counter might work? E.g. a handler can promise this N times
>> before the kernel kicks in? Any ideas?
>
> Counters usually do not work very well for async operations. In this
> case there is oom_repaer and/or task exit to finish the oom operation.
> The former is bound and guaranteed to make a forward progress but there
> is no time frame to assume when that happens as it depends on how many
> tasks might be queued (usually a single one but this is not something to
> rely on because of concurrent ooms in memcgs and also multiple tasks
> could be killed at the same time).
> Another complication is that there are multiple levels of OOM to track
> (global, NUMA, memcg) so any watchdog would have to be aware of that as
> well.

Yeah, it has to be an atomic counter attached to the bpf oom "instance":
a policy attached to a specific cgroup or system-wide.

> I am really wondering whether we really need to be so careful with
> handlers. It is not like you would allow any random oom handler to be
> loaded, right? Would it make sense to start without this protection and
> converge to something as we see how this evolves? Maybe this will raise
> the bar for oom handlers as the price for bugs is going to be really
> high.

Right, bpf programs require CAP_SYSADMIN to be loaded.
I still would prefer to keep it 100% safe, but the more I think about it
the more I agree with you: likely limitations of the protection mechanism will
create more issues than the value of the protection itself.

>> > Also is there any way to handle the oom by increasing the memcg limit?
>> > I do not see a callback for that.
>> 
>> There is no kfunc yet, but it's a good idea (which we accidentally
>> discussed few days ago). I'll implement it.
>
> Cool!

Thank you!

