Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39A7606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kA66ix4o
Received: by kanga.kvack.org (Postfix)
	id B3C326B05B0; Sun,  8 Nov 2026 21:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13CA6B05B1; Sun,  8 Nov 2026 21:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54056B05B4; Sun,  8 Nov 2026 21:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7EF6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:35:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3EB580279
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:35:49 +0000 (UTC)
X-FDA: 85414015218.16.D7F6930
Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE5B6140003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:35:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kA66ix4o;
	spf=pass (imf23.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8KACQV8GEkM7sg/l0LY+n4eIcnrDwVtQhDVvbChlsc=;
	b=Jwg35mitKCKZQs6XqwIyRpM40n1Rjymu0WMmOtH2q4Jmd/toiErESpijDIwEvklnhMwkG2
	7/Smv54Yho6YorWXRwhQ2r59vn0oSJdPZsAR8w8v+xCkHafoJmvwQN9L+9rC5WvCD0iXji
	lgjjJtPhP6WyW9ThJnXWow8wEJV0WfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191748;
	b=4MeHUAsGhiyZpnjWMk2U8eA2/21UTRk5cQPcMWSALKo1oXxiON/Tw+nldpYVXNw+pPhUT/
	8c9T8wuogZoHCcMOLLVMFGC+C0y5GhNCJOv6NkqGBYOOZlYem9IDsXQZKNiTdo9PpHOalZ
	bNCbhEuQfi18EZyxzD6oN3tXMExf7u0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kA66ix4o;
	spf=pass (imf23.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sahaBfdN8dM3MC+nyYsLDXJ4FM7JRPlU6iwwEbjUDHg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191746; v=1; x=1794796546;
 b=kA66ix4oBjp4zQg4b2a4lEPHHzpy24nuFI7y8yO2hI6FUE4lwNDQ4yKfibzsxPzpKvAAm4HC
 QpvzQ7yTyFe49ekLtwGNhR3XsjclCoZHSbmaKqV/VIQni7chUMraprKVvYsByyjWC7eHBibwRYi
 l0GmyOWDwLf66w6+eS5BO6OY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ccc0e3a2462894c9;
	Mon, 09 Nov 2026 02:35:24 +0000
X-Mizu-Trace-ID: ccc0e3a2462894c9
X-Migadu-Flow: FLOW_OUT
Message-ID: <f10075aa-0917-472c-855d-afabbc9697ff@linux.dev>
Date: Mon, 9 Nov 2026 10:35:12 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, linux-mm@kvack.org,
 James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn,
 media-ci@linuxtv.org
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev>
 <sashiko-outbox-202921@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <sashiko-outbox-202921@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4udfugp44n4o8tegj7mpoitm5jrgesqy
X-Rspamd-Queue-Id: BE5B6140003
X-Rspam-User: 
X-HE-Tag: 1794191747-720145
X-HE-Meta: U2FsdGVkX19bpg5DQe+hrRpw4TmvOFaayfi2n4oOwz2Pu/LJDfmwTPwH4R7PdjMMRRwD3nJkiFkk/8CnRzpTEM2R4UykhgdQS1u5TIF6Fl83DNwjxLMd/7yPF4ioN+KY8v0wwrKmrZYQ1cWeMug93hvZfKAKlXFgh32UIR7WU+Y/ddGtZSZNtyYyHtTMF5/mqDSxn6oOUXzGWszT3+WP+JcPrA230y8dqucjUmtIYuHzttz25KL/vQY9XIqsbKWkFFuYVBXLE6tfcK9i/8isdKRyryr07/sv6p947qoy2Z/PAebTP3NrOwG57Cui8YQOamscyJ6CmfP4FmSC1Xu9DwGjFu972RR87z1halr0jc/FlNwX4dMoyTS7dtmbWqe3fpYI2hINCI/ZwU5n8E+MWY5fxUb068TxwV04mR/+6X/zM8MonKkH8FEjR/AqcW5fsFTRDPnXgUGlVSB6bMYfR5sOmPfeGI1j4i02mPDBp32ZmSTx12K7ozXkUJ8cflRtd3lGlnMl4XnWG8wg8/BcLiWM9DQZej+A8LE2DrBdHGUvLrRqG9eMAlM78BRlNGpI4BqbOYmxwkzhKW6CGZbeDm+mX9vrIDNmJizAw5JqF7qqKWu6Dk+BPx6b43RQk+U61iMXKVlt1aIFZxU7uaIBMKvqrQlYbvFgaMdQXvNa5CMAXFppOtUtgSZiKTl8CO3aaRUUzqhr3dn9mreehmAiqvokNyhoXB8KegocOqVBjt5KOyeaFNmpg1CC1oNhIuCfJBlEHS7vdP3XM1esiYf6br8Ci7cqR2hLMYK9eTtygRh0Rf1Nb/3R1WRmDEUW4DuLJ1/EY+NaBeqgw6gxLyKMgiJ8AvHdAu9ix2zI/rRVLi0WwfHFDknKJBdz88GmUfFbPv+7yIgoZwL4u38zUWx23sk0WFjEY44Fl9cxOe9/6joY/Q2w86Sc9jRAorCiXmR+OP3YMcSCbFzqdmP/Ssv
 XQO7EVI/
 yZt5OsCukp3Lv06zDNb6Fq63rlgAIZd0XqDIqhTv9Yz7cXkq0y6Car7c+YwFa5XIDr9Xvmrk8xyEOQqTWMkUnnluhzb0hXRzoY1kwyG8MQx4ByzLfpZyXTX3fjFIh4BAQQpqBPczKoln+vfLZFnZHExjIx+tVfuRchMMq7Yib2U61ANxzu8rl+blrAguIYE3Ix9x5vCLLakMY6evt0utJ1+9MqQ89pOD8GntsWwaPdXLZiODx4qi4+q91wTU780HSw63EUpdroEWaWkQy2W9ts5F7jIHDgjOHAaLqHWXvoL6Cg0nrPcmAcYXb/8hztBc6mCUyVGu8W5M1WKLzrP2Ln7XYYQ8T/VYx7ZX0y0UjL7Tc7VrtDHyZ/6BGQixcQB3EAPKzX7bgEiCjN9dSXGHXNgZdYW0umqvazR6td0VNsnMmqKtTgPeStUgjgv+3IgvgMJVMXyxoOGoZk435quea59Il0No6cS4Ri6u7JZ9cxh/eyiceAI5icZEtCHK10thDkPaK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

在 2026/11/7 21:27, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] tracing: alloc_cpu_data() mischarges global_trace and
>   read-page swaps
Correct.  Charging alloc_cpu_data() unconditionally pins the global
trace buffers to whoever first triggers the lazy expansion, and the
read-page swap can move charges between the reader's memcg and the
ring buffer.
> - [Medium] tracing: alloc_cpu_data() memcg limit triggers
>   trace_rb_cpu_prepare() WARN
Also possible.  With __GFP_ACCOUNT, allocation failures from memcg
limits can now reach this path as well, making the existing WARN()
reachable from a constrained memcg.  I'll avoid charging allocations
performed from the hotplug prepare path in the respin.
> - [Low] tracing: inaccurate snapshot size claim and inconsistent
>   GFP_KERNEL_ACCOUNT use
The snapshot size description in the changelog will be corrected in the
respin.
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [Medium] tracing: memory leak in trace_array_create_systems() [1]
That one predates this series as well.  I'll investigate it separately
and send a dedicated fix if confirmed.

The v2 respin narrows the accounting.  Only buffers belonging to
non-root trace instances will be allocated with __GFP_ACCOUNT (via a
new RB_FL_ACCOUNT flag).  The global trace, read-page pool and CPU
hotplug allocations will remain unaccounted, and the changelog will be
updated accordingly.

Thank
> --
> 
> commit a11da3138f9fda850c1b05bae82b0be7e738b994
> Author: Tao Cui <cuitao@kylinos.cn>
> 
> tracing: account ring buffer pages and trace_array metadata to memcg
> 
> This commit adds __GFP_ACCOUNT to ring buffer subbuffer allocations in
> alloc_cpu_data() and switches trace_array allocations in
> trace_array_create_systems() to GFP_KERNEL_ACCOUNT.
> 
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index e760d2fe386fb..f925936378639 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>>  	 * gracefully without invoking oom-killer and the system is not
>>  	 * destabilized.
>>  	 */
>> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
>> +	/*
>> +	 * The subbuffers are charged to the memcg of whoever caused the
>> +	 * allocation: the creator of a trace instance, or root at boot for
>> +	 * the global trace.
>> +	 */
>> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
>> +		  __GFP_ACCOUNT;
>>  
>>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>>  	if (!page)
> 
> [Severity: Medium]
> Does charging every alloc_cpu_data() call to current's memcg misattribute
> global_trace subbuffers and swapped read pages?
> 
> At boot, tracer_alloc_buffers() keeps global_trace at its minimum size
> (ring_buf_size = 1) when ring_buffer_expanded is false.  global_trace is
> only expanded to trace_buf_size at runtime in tracing_update_buffers() or
> tracing_set_tracer() when a task first enables an event, sets a tracer, or
> loads a module using trace_printk().  With __GFP_ACCOUNT in
> alloc_cpu_data(), those global_trace pages are charged to whichever cgroup
> triggers the lazy expansion and stay pinned to that memcg because
> global_trace is never freed.
> 
> In addition, ring_buffer_alloc_read_page() calls alloc_cpu_data() when
> reading or splicing from trace_pipe_raw, and ring_buffer_read_page() swaps
> that reader-allocated page directly into reader->page while handing the old
> ring buffer page back to the reader to be freed:
> 
> kernel/trace/ring_buffer.c:ring_buffer_read_page() {
>     ...
> 		dpage = reader->page;
> 		reader->page = data_page->data;
> 		local_set(&reader->write, 0);
> 		local_set(&reader->entries, 0);
> 		reader->read = 0;
> 		data_page->data = dpage;
>     ...
> }
> 
> A host process reading trace_pipe_raw from a container's instance will
> replace the container's charged pages with uncharged pages and uncharge the
> container as the old pages are freed, while a cgroup task reading
> global_trace will swap pages charged to its own memcg into global_trace.
> Similarly, trace_rb_cpu_prepare() during runtime CPU hotplug allocates
> per-CPU buffers for all existing instances in the context of the task
> onlining the CPU.
> 
> [Severity: Medium]
> Can hitting the memcg limit in alloc_cpu_data() during instance creation
> trigger the WARN(1) in trace_rb_cpu_prepare()?
> 
> When alloc_buffer() creates a ring buffer, it allocates the first CPU's
> buffer directly and then calls
> cpuhp_state_add_instance(CPUHP_TRACE_RB_PREPARE, &buffer->node), which runs
> trace_rb_cpu_prepare() for each remaining present CPU:
> 
> kernel/trace/ring_buffer.c:trace_rb_cpu_prepare() {
>     ...
> 	buffer->buffers[cpu] =
> 		rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
> 	if (!buffer->buffers[cpu]) {
> 		WARN(1, "failed to allocate ring buffer on CPU %u\n",
> 		     cpu);
> 		return -ENOMEM;
> 	}
>     ...
> }
> 
> Because __rb_allocate_pages() only checks si_mem_available() against global
> memory, a cgroup with enough headroom for the first CPU (~1.375 MB) that
> hits its memcg limit on any subsequent CPU in trace_rb_cpu_prepare() will
> trigger this WARN(1) and crash the host if panic_on_warn is set.
> 
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 08614af8fad1c..fd1cfd1f66fbe 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -8677,11 +8677,11 @@ trace_array_create_systems(const char *name, const char *systems,
>>  	int ret;
>>  
>>  	ret = -ENOMEM;
>> -	tr = kzalloc_obj(*tr);
>> +	tr = kzalloc_obj(*tr, GFP_KERNEL_ACCOUNT);
>>  	if (!tr)
>>  		return ERR_PTR(ret);
>>  
>> -	tr->name = kstrdup(name, GFP_KERNEL);
>> +	tr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
>>  	if (!tr->name)
>>  		goto out_free_tr;
>>  
>> @@ -8692,7 +8692,7 @@ trace_array_create_systems(const char *name, const char *systems,
>>  		goto out_free_tr;
>>  
>>  	if (systems) {
>> -		tr->system_names = kstrdup_const(systems, GFP_KERNEL);
>> +		tr->system_names = kstrdup_const(systems, GFP_KERNEL_ACCOUNT);
>>  		if (!tr->system_names)
>>  			goto out_free_tr;
>>  	}
> 
> [Severity: Low]
> Should the alloc_cpumask_var() and zalloc_cpumask_var() calls right between
> tr->name and tr->system_names, as well as alloc_cpu_page() and
> alloc_cpu_buffer() in ring_buffer.c, also use GFP_KERNEL_ACCOUNT?
> 
> Also, the commit message says creating an instance immediately allocates a
> full ~1.375 MB per-CPU snapshot buffer, but trace_allocate_snapshot() passes
> size = 1 when allocate_snapshot is false (which is always the case after
> boot), so snapshot_buffer only allocates the minimum pages until a snapshot
> is armed.
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but in
> trace_array_create_systems() [1], does the out_free_tr error path leak
> tr->tracers when trace_array_create_dir() fails?
> 
> trace_array_create_dir() calls __update_tracer() -> add_tracer(), which
> allocates struct tracers and struct tracer_flags entries on tr->tracers.  If
> a later step in trace_array_create_dir() fails and jumps to out_free_tr,
> nothing calls free_tracers(tr), leaking the entries already added to
> tr->tracers.
> 
> [1] https://sashiko.dev/#/bug/linux-9449d18e-1233-4181-9199-09eaead7b576
> 


