Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F0CFF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 23:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88106B0088; Mon, 27 Apr 2026 19:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38F86B008A; Mon, 27 Apr 2026 19:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B011E6B008C; Mon, 27 Apr 2026 19:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99F896B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 19:55:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 439BBC14DB
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:55:39 +0000 (UTC)
X-FDA: 84705995598.17.848957A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68F79180005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:55:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PR+Sx1fK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777334137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgEWh+XI0SPB+PinHXs94gFrx3gTRtQhlrntWyMIEwk=;
	b=W5VEvTzCoBYiYQAxdC4UweWPbOlr3+6YAmqdP1fSA5pY9OrUNL1JXJOodWmkJeqNLmaMer
	xQPliMRikGUfPfxznzS+2Egdr8jwt53nOZlqjdurMwi2UX+ArRlw+OVH3OTPYYDNWpOwWG
	QrSM52BZkjacKmTD7LvjJQh0h5u4djI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777334137; a=rsa-sha256;
	cv=none;
	b=qDsMFMZJ5aERWvNoxPeusiq+HVGjKh5G3I2IXd1L6VQFjVb4B533evo6XQrdGHXB0Sio7i
	Qkv/U6M9ydutKYLhnAawai6sbhqUgxRlfh78zDUDn6cNqtrHh7a9x59qv0CNS7dBFR1V9x
	QsnqEvpeF1qkt+ma6sVbFAbqtCkDUec=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PR+Sx1fK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ab39b111b9so44182005ad.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777334136; x=1777938936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zgEWh+XI0SPB+PinHXs94gFrx3gTRtQhlrntWyMIEwk=;
        b=PR+Sx1fK8/u59DBnFCc5Dv0tgdQJQHwt9fhd3W2uyNns2ARpxK6JowD+XJGzgGmyfM
         m7CPRBmdS5b7dyMQ6TUCwjXA+xwU8/VjOy9U+gXClVWAZ7+xTnvCUxBrfwmxDdXJRoc6
         M2SgUZxJwM4F/QSQwWL7ElrLwK1K7DKzszjBxrLfSLfZxiagl/U4t4DzzWYmGsXobnYL
         3sIwU01tU6lOf4JYZeZFo8Ou/c7KZ1T63wuQ9ITKyw5XrZgSfZUZ1RNh5a82KkZ0ptNK
         vFhA0Gjfao9AvyfHfW9QwC01ao39x+mO4O8O74EIM9TAX8FeKtR0WemvOcwwj9A8bzNm
         wbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777334136; x=1777938936;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zgEWh+XI0SPB+PinHXs94gFrx3gTRtQhlrntWyMIEwk=;
        b=rHGeEM1dsKbUVwMiYAyz1xmD4AbnX0xf7QKnqUZeF4euo77taNgeeU7XAvGR3I2WLs
         Tm3U1em+qZbHed8eXAMuA5Idr5HkN622GHwlz6COzdwN56AGVG8P9TRR8wI42uiE5sUR
         mPqy/JO2uyJyJDwkT6J0Xote/ocejcXSqStPUvhiwodS16QeilMW3//V2S1Rqd+p+dD+
         TDyYq7Fy8nKorjpXE9UzVg9CoHGGv4W99GpATqsNixDHnBq99yXmBTSJbuVTCZ4pPPE2
         8h/feGENbY1FlDk3e7iEKDSD8F5cG67O1BmaP0CSLLHNPUAkX6hI++8VsC8FtnUWJhLQ
         ZEfg==
X-Forwarded-Encrypted: i=1; AFNElJ+yDCqx28YFVdjC1mSExddlL34THolyJ8QAIPvIF/+5rgnF+8zY+cah7rXTyBY+rB1PAc3UALqRHg==@kvack.org
X-Gm-Message-State: AOJu0YyQN1AxYVtDqpMfScUA34EZCU/gWcUEzq4owkEGRRW8m0eLx85W
	MDZVoPhcrz1roaF4W70DKL7tk/B+MdXAXvBYnz19gFAVztZE9GpYiuMk
X-Gm-Gg: AeBDieuxjSgh1zY3DEuj5m/+Cc5cDseclnVXWNnCDSk9zM0ZJZr2dGjovLVkleEvJlK
	Vxpjd2NzaaHFOQswaVPyTR+g+sz8yLvgi9HgEdWlxPHA3SIa5V4VOTa9L4YHJiTnFl56y2uFpSu
	n1htiwWA3HwmCYnfmifO3F0U5wwHd5Yq9ONjY22e9nupofJvZqfyPwQcZEoSf5J6r4SsU/MPmPv
	dp7FyOOcVuJZuNxDp2vDf8vVSzxrVDMK/ZLUdmlQeAIRgh0vxlYzyzUG5uHbmx+nd5q0ga9UNWM
	52l2mibMjzY6OyuY3/gQAuFCur5j+aYzRNBkXSUmMPWDvo0lrL7zzh3Po4FRd0uRKtiM4rSgT33
	YUmdjKHe+hhfEc48hfkSOkNYet5xPLr7yDX7AIBwDXn0pIL+Pwc+NyHafYjQwUHH7MylEZIUGf0
	KERSe3kPHoNSytR2iIj2rCo2mgYRW+tE9V
X-Received: by 2002:a17:902:76c3:b0:2ae:5eee:7a5 with SMTP id d9443c01a7336-2b97c43c746mr4936135ad.12.1777334136066;
        Mon, 27 Apr 2026 16:55:36 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97a96cc61sm6493415ad.0.2026.04.27.16.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 16:55:35 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking
In-Reply-To: <bb418f9a7bfcabc3070b412c745c5b6456d592b9.camel@kernel.org>
Date: Tue, 28 Apr 2026 04:56:10 +0530
Message-ID: <jytsrnn1.ritesh.list@gmail.com>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org> <20260426-dontcache-v3-2-79eb37da9547@kernel.org> <qzo1s6a4.ritesh.list@gmail.com> <bb418f9a7bfcabc3070b412c745c5b6456d592b9.camel@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 68F79180005
X-Stat-Signature: jownjfyqezrh7x1noetm9hqbt7kg9h35
X-Rspam-User: 
X-HE-Tag: 1777334137-423281
X-HE-Meta: U2FsdGVkX18/aEyS3X6zCZCM4t7HgmFbsDDEQqZvcMaCtF3HgJjq8AiCiAErNc2PgwiSm5clpWY4yc1p1lN2XF7GZhsvnooOwik320seLqKIU/i4XG2Mzegzsp1bP2fxw4D2+9wRxiUvAOHyD0tSU/WFxVKDmi1cIOAsE9oTgfep28CmmLB/2AlfcaynL3REelqzM9HetWwH9Frzr228kLaM26lHiG5bVug6ggQIv4vBTYCu+nOAjC1IWBT097/9PAC6T+AC2vA0pgl5aBEmXKreZ+hLuBTwE0cNZldG9CYfUAK1lKvHYCfEXaXG09ptSFvMwB8rmqxakVtj+oBmURlJao6xeMqzMlOmeIrXy43p722Gj/LDqvJ3uMFvKaX0diFM8B68ObpotT19vVmqDjUCqzucXPjsCD1PUnnaFzCRTBBbjhjBSMsPXEw8ACfrksMNNNMxxPwlPg0zf5oICf9FhmZv+uv6wbxwgOecg4lqhe5frgvfJ4egAoFJfnB5qHbQXTV3z1wz+zFLBITapF0jjZjZgqX9c/IJgfzGXZAYPrGgfOK2Lp8KLPYjLdWWLFf39GvBHnVpmQkMYKdZLNcS5F1p3D7cqB3MUZY2JoNu06vn8jRfqF4vZsulHKo+HY4LFHks5SVioBxyqHwuOPP+3Y+FrT2XVcKsHpPAdkZqApElboRS3mMm3nqL9NZ/lLFUo0YCuoFII7/6kxG0C6ku8vMzY9Twa89OMed/SD8PJFZ7mY0+hSvKyitBq2gYAIzxneaYEKeOdEuDk9ZItxCvDkTNrdr3eQvl8og/ycYXzqt+A5FUeXT6xEdfLn6RK5TTp5IIVrFtt4o20hmbUrqp1A+C6GU39QjoijX/PsZTMA4SezqeTKdSZjIPvDcYncE3va81aihwDeb7vi/PyrV3Bp1pAqnneByIPx5cHNRJzU1Gr+YN1EaIGIqi7OMbIUoRJhPhRJps0cRqNzS
 mvRB5Tp6
 b6lmtdg04ow26iqYXnsxCkw1dFdHEnMsrsDHBBtXXbB+fUUHj9ZY+A4YIq+jNutmDsupEjpxXb4LYKqHtSrAEE8+MLgPP+EImtMSBZV4fzQv7xbMG8znBqsNjDy8aZN9AeFarA54Kusd1OxrFRS/4vi8zKmLfYvpe4U+6jXmEfr6Xu+dj/s1ZyEm2nr9VI5O9VQipVqs3qX1bPrzTDf45OF3eFhvm6xgcOgIIyB2g3b0hhRO4S7AiHmbxAroWJxdODEfQJuW41t6T6uRL39vQOB/Kj8gJlEIF8fOFevXdZBUywXd3bNtxWcOgzd2fqNlEirLJlnY7rK1BArVjERAUrdSPXLuJ44KHTfJVcI6VysFxnwwjxNOK65AusTRdnUxjakD2k4cigCXDt709Q8DJcDaNeTBlFmusD2QTso+EWhDbOM9X+LTwltMqiY1214Gu2ELMiLxAXqq+zL6JtW+j7E75RLUal70BloN+tyESwi5QSkg+rXSCgpVdECmH98vD1bm6jJnBUbuYXqneQ3/povRT+bviMSWbkSjTWFq1lmaC67G9acliiRB1AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

>> 
>> Also should the following change be documented somewhere? Like in Man
>> page maybe? i.e.
>> Earlier RWF_DONTCACHE writes made sure that those dirty pages are
>> immediately submitted for writeback and completion would release those
>> pages. But now, in certain cases when there is a mixed buffered write in
>> the system, those dontcache dirty pages might be written back after a
>> delay (whenever the next time writeback kicks in).
>> However for RWF_DONTCACHE reads, it should not affect anything.
>> 
>
> Looks like DONTCACHE is documented in the preadv/writev manpage. Here's
> the current blurb about writes:
>
>     Additionally, any range dirtied by a write operation with RWF_DONT‐
>     CACHE  set  will  get kicked off for writeback.  This is similar to
>     calling  sync_file_range(2)  with  SYNC_FILE_RANGE_WRITE  to  start
>     writeback on the given range.  RWF_DONTCACHE is a hint, or best ef‐
>     fort,  where  no hard guarantees are given on the state of the page
>     cache once the operation completes.
>
> I don't think this verbiage is invalid after this change. Kicking off
> writeback is still just a hint, like it was before. We could mention
> about how that I/O can compete with regular buffered I/O, but it seems
> a bit like we're adding info that will just be confusing for users.
>

Make sense.

>> > dontcache-bench results on dual-socket Xeon Gold 6138 (80 CPUs, 256 GB
>> > RAM, Samsung MZ1LB1T9HALS 1.7 TB NVMe, local XFS, io_uring, file size
>> > ~503 GB, compared to a v6.19-ish baseline):
>> > 
>> 
>> Can we please also test parallel buffered writes and dontcache writes? 
>> Since this patch series definitely affects that.
>>
>> BTW - adding these numbers in the commit msg itself is much helpful.
>> 
>
> To be clear, this only affects DONTCACHE, not normal buffered writes,
> but I guess you're referring to the fact that DONTCACHE and buffered
> writes can compete now.
>
> Can you clarify specifically what you'd like me to test here? Are you
> saying you want me to test parallel and buffered writes together at the
> same time (i.e. make them compete?).
>
> I should be able to do that for the local benchmarks, but nfsd's iomode
> settings are global and that won't be possible there.
>

The reason I am thinking of this is: dontcache marked pages, gets
evicted from page cache after they are written back. But this patch
series can now delay that from happening when there is a parallel
buffered writer dirtying page cache pages. Because of the reasons we
already discussed...

Note that, this may not be a workload which matters in the real world,
but I was thinking, it will be good to know the impact if any, of such
workload with this patch series (parallel buffered and dontcache
writers).


>> >   Single-client sequential write (MB/s):
>> >                        baseline    patched     change
>> >   buffered              1449.8     1440.1      -0.7%
>> >   dontcache             1347.9     1461.5      +8.4%
>> >   direct                1450.0     1440.1      -0.7%
>> > 
>> >   Single-client sequential write latency (us):
>> >                        baseline    patched     change
>> >   dontcache p50         3031.0    10551.3    +248.1%
>> >   dontcache p99        74973.2    21626.9     -71.2%
>> >   dontcache p99.9      85459.0    23199.7     -72.9%
>> > 
>> >   Single-client random write (MB/s):
>> >                        baseline    patched     change
>> >   dontcache              284.2      295.4      +3.9%
>> > 
>> >   Single-client random write p99.9 latency (us):
>> >                        baseline    patched     change
>> >   dontcache             2277.4      872.4     -61.7%
>> > 
>> >   Multi-writer aggregate throughput (MB/s):
>> 
>> Can you please help describe this test scenario if possible.. In above
>> you mentioned we are writing file_size as 2x RAM_SIZE. But your
>> multi-client tests says something else..
>> 
>> local num_clients=4
>> +	mem_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
>> +	client_size="$(( mem_kb / 1024 / num_clients ))M"
>> 

I guess you missed answering this. The reason why I was asking about this is....

>> >                        baseline    patched     change
>> >   buffered              1619.5     1611.2      -0.5%
>> >   dontcache             1281.1     1629.4     +27.2%
>> >   direct                1545.4     1609.4      +4.1%
>> > 

... If we see the performace of buffered and dontcache in baseline case,
then we don't see dontcache doing any good. Even the patched version is
just slightly better compared to buffered case.

But IIUC, dontcache should really shine in cases where we have buffered
writers dirtying the page cache pages which can overflow the RAM size
[1]. The reason why dontcache should show benefit there is, because we
don't see any page cache pressure, since after writeback the pages gets
evicted. Also earlier in the unpatched version, the I/O submission
happens immediately in the same context.

So, I guess, isn't it better to evaluate those scenarios as well with
the patched version - since this series affects those code paths now?

[1]: https://lore.kernel.org/all/20241110152906.1747545-11-axboe@kernel.dk/

>> 
>> Nice :)
>> Some explaination here of why 5x improvement with NFS compared to local
>> filesystems please?
>> (I am not much aware of NFS side, but a possible reasoning would help)
>> 
>
> I suspect that it's because of the "scattered" nature of nfsd writes.
> When the client sends a write to nfsd, we wake a nfsd thread to service
> it. So, if there are a lot of writes operating in parallel, they all
> get done in the context of different tasks.
>
> My hunch is that this I/O pattern (writing to same file from a bunch of
> different threads), particularly suffers from the DONTCACHE inline
> write behavior. The threads all end up competing to submit jobs to the
> queue and that causes the performance to fall off sharply.
>

Thanks!

-ritesh

