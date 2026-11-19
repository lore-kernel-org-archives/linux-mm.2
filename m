Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA492606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BoTWH5Fi
Received: by kanga.kvack.org (Postfix)
	id B384A6B06F5; Thu, 19 Nov 2026 18:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10546B06F6; Thu, 19 Nov 2026 18:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CF86B06F7; Thu, 19 Nov 2026 18:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 715586B06F5
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:48:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EA5DA8B2D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:48:31 +0000 (UTC)
X-FDA: 85453510422.29.C1894AE
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3B10A160003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:48:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BoTWH5Fi;
	spf=pass (imf08.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795132109;
	b=MemeMGQC3F4uvccEtJvehCWv6whS/bLMQF/4ViPGFhkFW0zhRNxDBrE0c4YaESgg4OhobS
	UdWn42WK8xjH2Ih9+wGG/EH7u8RVPMLuAc4bZi9Q2Ff6EqKhnldCSpCGZF63kSYslxVF2A
	LtU/yggn6gvhoS7JfgpAZ/Wvj0tfehY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795132109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcj5h00JjVNcq5RcRanYbKv1qUq4spqkJwru3XjEgEA=;
	b=tWIPJd2NJun527yzhZ4kbqnab7UvYyNFlXQ6icIbM2NgrrkQc8NQ3ZMHFsWXRZs7swA+g4
	p8GbIkKtAFPyTUjjtUdZE50bgZlB7AIhGgRzjHDv8HkkWLy7IZTy9T6cLUHFlXjoNLeHKQ
	63SpCbNecqpVM3HAn3M/7G8Y+c9sgU0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BoTWH5Fi;
	spf=pass (imf08.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6LWaP9a799dRmXjPzl0gkWLih06hsrqQYvPtGBFxEsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795132107; v=1; x=1795736907;
 b=BoTWH5Fi1IZExkaX1UVG0UE/sKHeD7yr0JBoEA7pSxpIS9I/AG/d2puwMNbDLQzs2vT11U1s
 vASgSWckzezIb9s1Sd0vB6uxw4uXPLLwr5GKRk1rBj9hLubjulj4/oLYePkSmiMd7yc+crCqZM/
 4ZhHgjLXJXGKVDcDNMWg5GdI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a9882a66356e0e59;
	Thu, 19 Nov 2026 23:48:27 +0000
X-Mizu-Trace-ID: a9882a66356e0e59
X-Migadu-Flow: FLOW_OUT
Message-ID: <583bde38-c84d-41a3-a65c-d1365ea04f07@linux.dev>
Date: Fri, 20 Nov 2026 07:47:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, akpm@linux-foundation.org, dgilbert@interlog.com,
 mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
 vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
 eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
 mhiramat@kernel.org, jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk,
 linux-mm@kvack.org, James.Bottomley@hansenpartnership.com,
 sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org,
 joro@8bytes.org, will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
To: Steven Rostedt <rostedt@goodmis.org>,
 Vincent Donnefort <vdonnefort@google.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev> <avScKhR22kFOQ1z4@google.com>
 <20261111181447.3c483a50@fedora>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261111181447.3c483a50@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mgxa5y6aicm31brgwgpywhfmp7sfi6ww
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B10A160003
X-HE-Tag: 1795132109-801393
X-HE-Meta: U2FsdGVkX1+AiSuiSWNwSnPRHw3HFV7mS5PCQwM6o5/3ybmcJmxGgUfyGSzbVqXFmRluP87IpktETSR/0CgasN02m0OeIbFw2fE+jew1MKxOhn1iKmdrO2fXTKeQqYHybvSSB5zx6O/AMK3cCDadWiCPdAiZA3CZcpk1rQcOPRpS4cj+VZKi7taLf0IW4H5D1lnrCglyDcnnIriMtQLc29g26JJHeMNRGjAMGI1qtb9/WL8CwWxAusCHK0ENy+jjmiEk+7EWQur7JkcKpB3dAiX0bjLnmlk1eWR7BfimsOAvSXDVtWFEkoV2wAvVlS+UVIHYPDNh91AGjRSOG1YUJpnrYvHorqZrZA7ZIuAPS/ZGTedUwdPCJum+ebjKv9MHByReXq7gobyO1lcjQG3DjIp8Pjc4igMVTvJPYAdlOof02NN4sQWCSv9Fz/BG2ON23grh/mzW4IXBdZnIpD3iIbzMbjslq0KDPeWUq0PCWXoEfD5vix1s5CfAazr236zuGTcTQWBhfANamyA2ZlbV8yNgUAYKtcpnWpk56Tolwh0xi/OcGq2toUGZiC/56oMxPvr4NvXBnbAv4ApTR9mAxR97yNhfUmK1B9Yo551rQWkP9nArncgatLxsotyvIrz8K3g4Il8FKuvVuXLTBiJ98hv+GHZXKjLcjSR/Bq02zkDj8L5uRqBRgf8sDxawA4oiDei2T9Y0hdfxt95IjRCKmlZU9wcayWjvKmGJO58s+psE3bJIzpqBR1rRkAKxudwKyydQ4eIdlY56Wi1mzb+58Gknj7XfyUUy+Bgo4aePlaYECPik89h6amCVHghNc8ko5ViOcwvj1QGnMVcayV9iymhMfC+ZlAh5yKvXo9cecCMSvQTqfwZrgjhNW8Ng+m/SBfzC927q9SHN7zBGiFNlak3NHlFdQbAjxV8BEPw4kEXm91VdFrI78Gc0udHrrdzKhn4+QwJ9DAXcNVtPU/b
 MSm21pLa
 hXdglEBBXctySNScrIFCFSwobVwQvytDt+yatgXoW+qo5AcWDJbdGLWPTYV8ndoNHE0m40gb+UNyitjMFBz298tczkYlQMmXWa/cjELoSEUYBrd6xFz+7q9Kzj3ULa73UkAZne0VyG62oOggbBbJyBRLX2yaEZP8kS+GbLGWYooxBqSYrTh3RS84kBDV2fgsp/yWXF/tWpC2XMBSMpFcl1TFe3fcB3hZdUKHHB4gRxnijP7FrQ+XkwcWo+yHfuyEpVa1kY6M01o+0TQqSCDlfGGMKF1MjvaYWIO2Iufx6jnA4j7Nmo+tFMG9nTwtSqNsaRUIyk1wLExJYlmY4ljURY0/aIrUiGg8kSKyJMgKbkgziVaoqrOoQi7E88AFw5fEnZZPA2+nNf5pP1yI9K8/bRYVpU9sG+hXgB9u62tPX/jb5Au706zjNJaXtcHejEXAUt25aoQek9QIzGvTooyevCKKKUDzWxwFx/saE/3fMWTBuAHxRFqKfyk/uRB1vWnhtvyXmMyLm79J1vqEaiZ8HLKkAiHUIB+9osSlY3pcULbtuMAmlde2xfTr2QrqlYW71F1nboHZIeS3PRcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello, Steven, Vincent,

在 2026/11/12 07:14, Steven Rostedt 写道:
> On Wed, 11 Nov 2026 16:47:38 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
>> On Fri, Nov 06, 2026 at 09:18:26PM +0800, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> Creating an instance immediately allocates two full sets of per-cpu
>>> ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
>>> on the default config, plus the trace_array and its name.  None of it
>>> is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
>>> while user_events in the same directory accounts everything it
>>> allocates.
> 
> As the name suggests, "user_events" are for users and are special.
> 
>>>
>>> Instance creation is currently gated by tracefs file permissions
>>> alone, so a
>>> rootful container with the host tracefs bound in can create instances
>>> until the host runs out of memory.
> 
> You mean, "works as expected"?
> 
>>  Charge the ring buffer pages and
>>> the trace_array metadata to the creating cgroup.
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>> ---
>>>  kernel/trace/ring_buffer.c | 8 +++++++-
>>>  kernel/trace/trace.c       | 6 +++---
>>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>>> index 1fd28a72e6ee..676c059c112c 100644
>>> --- a/kernel/trace/ring_buffer.c
>>> +++ b/kernel/trace/ring_buffer.c
>>> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>>>  	 * gracefully without invoking oom-killer and the system is not
>>>  	 * destabilized.
>>>  	 */
>>> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
>>> +	/*
>>> +	 * The subbuffers are charged to the memcg of whoever caused the
>>> +	 * allocation: the creator of a trace instance, or root at boot for
>>> +	 * the global trace.
>>> +	 */
>>> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
>>> +		  __GFP_ACCOUNT;
>>>  
>>>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>>>  	if (!page)  
>>
>> Hum, by default tracefs is root only. 
>>
>> And even if made accessible to other users: 
>>
>>   1. The life span of a trace instance is not tied to the caller.
>>   2. The ring buffer is shared by multiple users.
> 
> Right. Is there a use case out there that allows non-admin to create an
> instance? Tracing ring buffers can expose a lot and should not be given
> to unprivileged users.
> 
Not that I can point to.  Instances are admin-only by default, and the permission layer is the right place for that.

> What exactly is this trying to achieve?
>
The series closes uncharged kernel allocations that scale with user input.  For tracing I misread the tracefs permission check as a gap rather than the intended boundary.  Combined with Vincent's points on lifetime and sharing, I'll drop patch.
 
Thanks,
Tao
> -- Steve
> 
> 
>>
>> Overall I am not convinced charging the creator makes much sense.
>>
>> Eventually a few allocations for iterators could be GFP_ACCOUNT.
>>
> 


