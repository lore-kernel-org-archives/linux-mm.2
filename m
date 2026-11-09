Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08653606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mxJ5f8vT
Received: by kanga.kvack.org (Postfix)
	id BC5F86B00EF; Sun,  8 Nov 2026 21:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DA16B05B0; Sun,  8 Nov 2026 21:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC3F6B05B1; Sun,  8 Nov 2026 21:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E63C6B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:26:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E486F1C3E3B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:26:01 +0000 (UTC)
X-FDA: 85413990522.10.1F175CA
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id C16DA1C0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:25:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mxJ5f8vT;
	spf=pass (imf21.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtwmJoa5jwRbvW7yFmjKyxfZjcIBewf+YKrRBbn3v2s=;
	b=x4drupnDqLPHnQATWX/9LGJOpAUhYsenopX7GDRnFOLGiyFhukpvlgZ39C8e7N0gcuKBMQ
	Ix5DGXCajp6zssMh52ctvYT4jpkLeEMoBtGeiSvtF1iDG4ZhAD1DXMButS2yyaDGq7uhdg
	IGluNdSS8kx0oFVDNW2+LCHWpDqG0jQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191160;
	b=RYEPLT23AuWdOkjSAugIgrKrdcTh7U0T7o641m5ncVBqh0EdsoIFqcIvDc7aGJASM8hzYw
	e9oAbp7UOIl8PXsuyYp49tv+ohy2UWICfY8gn893BiHH3Yg8KgsDIXA99NgXmxiXvU/7xQ
	MzhX0YTn+unsmoWY4fOBtja/PN2Ilug=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mxJ5f8vT;
	spf=pass (imf21.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3wQFNru/GSW5wMzbNQX/aezP9rAklvDUaKeBXnZI+gw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191158; v=1; x=1794795958;
 b=mxJ5f8vTD5vQI/xxFid8apJbYaunElojr7df5vF3uWKiE8sIfF7AXHUkOhzPmEzINJxLhVlA
 QB5jKEX5FmNVqABGE1BGcfxACrjburhNnxQzOJ1Zb90mvmrXxE12AWSIOAg8A5UukyrxkPv8ZCP
 tOv3XPDPn4x+AOdU9HhQ0lQg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1a20c7d2490421e5;
	Mon, 09 Nov 2026 02:25:58 +0000
X-Mizu-Trace-ID: 1a20c7d2490421e5
X-Migadu-Flow: FLOW_OUT
Message-ID: <a583bcd4-b502-4733-9592-58203e941d7d@linux.dev>
Date: Mon, 9 Nov 2026 10:25:49 +0800
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
Subject: Re: [PATCH 1/7] scsi: sg and st: account the command buffer memory to
 memcg
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-2-cui.tao@linux.dev>
 <sashiko-outbox-202918@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <sashiko-outbox-202918@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C16DA1C0006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a8fomddkp63shbuasm9fiw5pe6rnjx7d
X-Rspam-User: 
X-HE-Tag: 1794191159-450533
X-HE-Meta: U2FsdGVkX18vdxnTQE2hMDSwr1GWkD9eGKlc80gTo8F8cvIVu0kpn9ZA1a8KMFDWtBKYf0Toox8ax2C23LXl425KUMQBo88mwS7e/JwydbpKw9O5Thik1aEBMxA/OqwUhnftf9kCCaZYZyIRONRs1b+o5l2ZyfooI34pnyJqirmQNHuq0b7Jep96EtzkV5BaQ9HnvJy9shW9qqH7kj8X3lcE08lyK7NX91PlP2pe0gQPeTJro1pvvByyQLD/zV92gHbMe4A3weT9AuMjg6hstWA6zXUNRNqO/EYMdYc5EXa7EK0uJrFUcibi2kr9mN6CfHd0/Mvhr/AxYzlfEKqQGo/ivmMZv6KHQFWbymlE9kMuw7o4IS1k23e3fhiTMTJqdlu+HzDwoiWObXQEoojJEuFU811cG343UOvO1kBJqTUIroiGYUy6eLI/MYbB4us+akBGTOiVRtQjHZqTwJQHxic1BKroZjLaEgTWsgkav2mGd2JpVlZn/KOMcr4tvK9DoloHO5O3fx8p9SrizVkWPMhMSSvgj3lYiW1tuA1bTEFFsGGJZy7w68HB0IhHLcLre4Q+v17qcHuyMq6JkEHNR7z/xrcmn8bb/uy8pcYQTf9v7LTbIM9MeVN3sapayh9tYudJzKAskCGfSF1Y+L07Oi6GO4p6cj4H4Y1DJVT6e0MrONiUqyWCxG/F1cP72/HgWOKXGR6wjCjPql9rh8wkQActC1w/h06VJ11i3x3a5XpZcUiKzicqHM6JNXWfuEDEW8lDL4K6581NuLt+bciPq075hnyD2ZNxVLFW++KS8g9pdgoh2i+SF1UnEzVgvJDKO6MCfUFUd7NEa0T4DyWBtjChYQizoF4xr8hgZGPJwMK9uRNlxQfd91vjv0dvsYUcpoDYrYFwQDgFUelefRp7KHCqutMTSOwGyQ6MqQiM5vqiaFPzT/fZHN8LhPqb17UhFI5HycphBHlCW9g4lmY
 hIp+meWO
 Fg0YyNin/szXNOgWLYukVP2YMsQ+SIN3XzmswMRjeoO/yKNEiHrL8n5yiHQ6OXX2DjyZA6RpywkvNTp1TefyV4/vf77nx4KtBMCkcqWa0j3RCjH9XyAiqpbhKa3Mp9s9jLqoqVoQI7O0LDtDrzBPMt4fUlm6VVySR4ggM/1L0vgP3YvMNAavAI7wQCnROQ43Aya710tKp4Aqu58/NbcsEucewpTAxfnVO/6IN9fo/M5S4HhvvSyyHf3PQpqs3eiD0USUcf9FPH+nxKTS9ivogMqC3nwhg7pdRc/5itW+4AacqlfJ7XzKegAvyw4QaIq9bgQo+Eycv6Eke32mBFjVUx6sqdPYMEDksObhQ+8FKi7ZCKs+W2I5gS3D1T7MZmCT5koZqCvsDiOaH1TlN5tpsfBAVIy5RB8uRLrMj8YWg5Jlbn/+PeXvsxsYqkm4+Yk7+YJ1WxgNlieMmozE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

在 2026/11/7 21:27, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issues to consider:
> - [High] scsi: sg: GFP_ATOMIC | __GFP_ACCOUNT in sg_build_indirect()
>   bypasses memcg max
I'll take another look at the allocation context and whether GFP_ATOMIC
is still required here.
> - [Medium] scsi: sg: unrelated and broken blktrace CAP_SYS_ADMIN gate in
>   sg_ioctl_common()
The capability check doesn't belong in this patch.  It was accidentally
carried over while splitting the series and should have remained in the
separate blktrace patch.  I'll remove it from this patch.
> - [Medium] scsi: st: misattributed GFP_KERNEL_ACCOUNT probe charges in
>   new_tape_buffer()
Thanks for pointing this out.  v2 drops the st side and keeps the
accounting on the sg side.
> - [Low] scsi: sg: commit message cites non-existent history in
>   sg_build_indirect()
The commit message is indeed inaccurate.  I'll fix the historical
description and clarify the reserved buffer limit in the next revision.
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [High] scsi: sg: shift-out-of-bounds in sg_build_indirect() [1]
Thanks for pointing that out.  It predates the series, and I'll
investigate it separately.
> --
> 
> commit ec96b2b0cdd1df3575b4521cd9f81da9824bc2b2
> Author: Tao Cui <cuitao@kylinos.cn>
> 
> scsi: sg and st: account the command buffer memory to memcg
> 
> This commit adds __GFP_ACCOUNT to buffer and descriptor allocations in the
> sg and st drivers to charge them to the calling process's memory cgroup, and
> adds a CAP_SYS_ADMIN check for blktrace ioctls in sg_ioctl_common().
> 
>> The sg data buffers are unaccounted: the per-fd reserved buffer, the
>> scatter-gather page array, and the order-0..N pages behind it, plus the
>> per-device tape buffer in st.  All of it is user controllable.  The
>> reserved size is capped only by the device max_sectors, SG_MAX_QUEUE
>> (16) commands can be in flight per fd, and the fd count is bounded by
>> RLIMIT_NOFILE.  Nothing is charged to the memcg of the process driving
>> it.  The September 2026 fixes in sg_build_indirect reshaped the element
>> sizing and left the accounting alone.
> 
> [Severity: Low]
> Is the commit message accurate about the history of sg_build_indirect() and
> the reserved buffer cap?
> 
> In git history, sg_build_indirect() has not been modified since
> aaff5ebaa269 ("scsi: remove the unchecked_isa_dma flag") in 2021, and its
> element sizing has not changed since 10db10d144c0 ("sg: convert the indirect
> IO path to use the block layer") in 2008.  In addition, the initial per-fd
> reserved buffer in sg_add_sfp() is capped by min_t(int, def_reserved_size,
> max_sectors_bytes(sdp->device->request_queue)), while only resizing via
> SG_SET_RESERVED_SIZE is capped solely by max_sectors_bytes().
> 
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 5408f002e6c01..80d919fa5cf91 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -910,6 +910,19 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
>>  }
>>  #endif
>>  
>> +/*
>> + * The sg passthrough of the blktrace ioctls has the same exposure as the
>> + * block device path: holding the node is the only requirement today, and
>> + * a created trace outlives the fd.  Must match the gate in
>> + * blk_trace_ioctl().
>> + */
>> +static bool sg_is_blktrace_cmd(unsigned int cmd)
>> +{
>> +	return cmd == BLKTRACESETUP || cmd == BLKTRACESETUP2 ||
>> +	       cmd == BLKTRACESTART || cmd == BLKTRACESTOP ||
>> +	       cmd == BLKTRACETEARDOWN;
>> +}
>> +
>>  static long
>>  sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>  		unsigned int cmd_in, void __user *p)
>> @@ -919,6 +932,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>  	Sg_request *srp;
>>  	unsigned long iflags;
>>  
>> +	if (sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
> 
> [Severity: Medium]
> Does this capability check belong in a memcg accounting commit, and does it
> cause a UAPI regression for unprivileged users with access to /dev/sg*?
> 
> Despite the comment, blk_trace_ioctl() in kernel/trace/blktrace.c does not
> check capable(CAP_SYS_ADMIN); block devices gate these ioctls only on access
> to the device node.  Moreover, sg_is_blktrace_cmd() matches BLKTRACESETUP2
> even though sg_ioctl_common() only implements BLKTRACESETUP, BLKTRACESTART,
> BLKTRACESTOP, and BLKTRACETEARDOWN, so unprivileged callers now get -EPERM
> instead of -ENOTTY for BLKTRACESETUP2.
> 
>> @@ -1841,7 +1857,7 @@ static int
>>  sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
>>  {
>>  	int sg_bufflen = tablesize * sizeof(struct page *);
>> -	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN;
>> +	gfp_t gfp_flags = GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
>>  
>>  	schp->pages = kzalloc(sg_bufflen, gfp_flags);
>>  	if (!schp->pages)
>> @@ -1856,7 +1872,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>>  	int ret_sz = 0, i, k, rem_sz, num, mx_sc_elems;
>>  	int sg_tablesize = sfp->parentdp->sg_tablesize;
>>  	int blk_size = buff_size, order;
>> -	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
>> +	gfp_t gfp_mask = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN |
>> +			 __GFP_ACCOUNT | __GFP_ZERO;
>>  
>>  	if (blk_size < 0)
>>  		return -EFAULT;
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can the ret_sz shift in
> sg_build_indirect() trigger a signed shift-out-of-bounds [1]?
> 
> drivers/scsi/sg.c:sg_build_indirect() {
> 	...
> 	num = scatter_elem_sz;
> 	...
> 	order = get_order(num);
> retry:
> 	ret_sz = 1 << (PAGE_SHIFT + order);
> 	...
> }
> 
> On 4 KB page architectures, setting the scatter_elem_sz module parameter
> near INT_MAX gives order == 19, so 1 << (PAGE_SHIFT + order) evaluates the
> signed 32-bit shift 1 << 31, triggering UBSAN or yielding a negative ret_sz
> that corrupts the allocation loop.
> 
>> @@ -2146,7 +2163,7 @@ sg_add_sfp(Sg_device * sdp)
>>  	unsigned long iflags;
>>  	int bufflen;
>>  
>> -	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN);
>> +	sfp = kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
>>  	if (!sfp)
>>  		return ERR_PTR(-ENOMEM);
> 
> [Severity: High]
> Does combining GFP_ATOMIC with __GFP_ACCOUNT in sg_build_sgat(),
> sg_build_indirect(), and sg_add_sfp() allow processes to bypass their memcg
> memory.max limit?
> 
> GFP_ATOMIC sets __GFP_HIGH and lacks __GFP_DIRECT_RECLAIM.  When a memcg is
> at memory.max, try_charge_memcg() skips reclaim because the allocation
> cannot block and then force-charges past memory.max because __GFP_HIGH is
> set:
> 
> mm/memcontrol.c:try_charge_memcg() {
> 	...
> nomem:
> 	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
> 		return -ENOMEM;
> force:
> 	page_counter_charge(&memcg->memory, nr_pages);
> 	...
> }
> 
> All callers of sg_add_sfp(), sg_build_sgat(), and sg_build_indirect()
> (sg_open(), SG_SET_RESERVED_SIZE in sg_ioctl_common(), and sg_start_req())
> run in sleepable process context holding only mutexes, so using GFP_KERNEL
> would allow memcg reclaim and enforce memory.max.
> 
>> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
>> index f1c3c49466379..7083d37622c08 100644
>> --- a/drivers/scsi/st.c
>> +++ b/drivers/scsi/st.c
>> @@ -3973,7 +3973,7 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>>  {
>>  	struct st_buffer *tb;
>>  
>> -	tb = kzalloc_obj(struct st_buffer);
>> +	tb = kzalloc_obj(struct st_buffer, GFP_KERNEL_ACCOUNT);
>>  	if (!tb) {
>>  		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
>>  		return NULL;
>> @@ -3982,7 +3982,8 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>>  	tb->use_sg = max_sg;
>>  	tb->buffer_size = 0;
>>  
>> -	tb->reserved_pages = kzalloc_objs(struct page *, max_sg);
>> +	tb->reserved_pages = kzalloc_objs(struct page *, max_sg,
>> +					  GFP_KERNEL_ACCOUNT);
>>  	if (!tb->reserved_pages) {
>>  		kfree(tb);
>>  		return NULL;
> 
> [Severity: Medium]
> Does using GFP_KERNEL_ACCOUNT in new_tape_buffer() charge the device probe
> context instead of the process driving tape I/O?
> 
> new_tape_buffer() is only called from st_probe() when a tape device is
> attached, and both tb and tb->reserved_pages live until scsi_tape_release(),
> so they are never charged to the process performing I/O.  Meanwhile, the
> per-I/O page array allocated in the driving process's context during direct
> I/O in sgl_map_user_pages() (pages = kmalloc_objs(*pages, max_pages))
> remains unaccounted.
> 
> [1] https://sashiko.dev/#/bug/linux-ccac9556-cc9e-4b08-b44f-5f7ffb342827
> 


