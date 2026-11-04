Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C769606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=STWBsNjy
Received: by kanga.kvack.org (Postfix)
	id 6A7486B00EF; Wed,  4 Nov 2026 06:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656D16B05B1; Wed,  4 Nov 2026 06:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545546B05B2; Wed,  4 Nov 2026 06:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2BA6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:53:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2368D120693
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:53:38 +0000 (UTC)
X-FDA: 85397276916.29.89DF020
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf25.hostedemail.com (Postfix) with ESMTP id E164CA0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:53:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STWBsNjy;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793793216;
	b=6VzVZOBxN7A8uQVGkvlxovNSAM0Bx/V64YngEhrR0I9+bKPTrHNRowq7R1+eHoeLjpwU2z
	WVfDNpOPINIVF7ytvpQzjugHZukVKlf/hNrtm7WRjWMKyj9/w/13zDvsaIZYZx1uHkpK7Q
	tK4P5YmPTMvIsNjoV8/zUfmVVaX0jm0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=STWBsNjy;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793793216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I7g8O9XnBkOnRo4UInvEGJ58/pb8j1Hf4MI5iyCwU3U=;
	b=5DX8izLdJ4aBX/20B0SIvYgUoDRD1ziQYx0DNIbLV8uNl8tbKiKZRd1SuAb1yDRMlDJ8O0
	KVLNaByCyVPbA9vxAC1gQ4z/7HqEAJkqWpjN0dP/mE30k1yX/777javQjpiQp51vGc8xnX
	/4Mim2v9CCtwkgZQcGKX70ONkiQO6pM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ci2Pt7fChn/3//APtQJ06s/FAY3b1ZNy/PHgjeitdbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793793214; v=1; x=1794398014;
 b=STWBsNjy3OEtxWmyE5iaSLwm8DvkGZrHmsrFyq66NcpMmt2CgrDej3GNo9bb9XpKcUwddJn5
 TY1G23S7w4JmV6Adwmp02sV6HWQs3XoYGMIK9JkKINLq8K5r9E9IksdnvIKyK+g/LCUkocIsmYs
 iR8pic90BS8Z4GNlRrpQphpw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id faccf47d409c8a15;
	Wed, 04 Nov 2026 11:53:34 +0000
X-Mizu-Trace-ID: faccf47d409c8a15
X-Migadu-Flow: FLOW_OUT
Message-ID: <9a335f59-79ef-4c32-b6f6-1e66dc03cc2e@linux.dev>
Date: Wed, 4 Nov 2026 11:53:29 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, dsterba@suse.com,
 hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, kernel-team@meta.com
References: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
 <20261103142600.279899-1-usama.arif@linux.dev>
 <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CACpmpodmeJB5FssJdfFxF+A2PkrC+=hnWGn=F_fTbbEtDfRF_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cmjeeeef39hxou68dit47yu3isya78b8
X-Rspamd-Queue-Id: E164CA0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793793215-750336
X-HE-Meta: U2FsdGVkX1/SAvxcRX0de6fVtLFf0AIwOAsF9NpDu1S2icCKYtt7qE1+U0OBcaTw5AigP/qDlIq5MkWpxfHWw0wQ+DQUXDtetQOubVnEGemyjdL8sJtMrnyGG5y0oKzGCNgG7zSkwUnZz3xw5l/BoMNe6Nou8fi6EeqTCi/fpZsMtKkLxfVWCwfHzOaPQBrotP8TgXW3yPQf4ADAlrbpvM687ZrhB3PCHVtovHWhz1V5EwebnDc4QtpTRATr6vNwRnv6HvCQqqlAnXxsoO5/JGyFfQzfdvWMDufWq68jZnF3B6r0jXASu1DCzieLJXdYRCIa8Bw4ObyolDp9f8N9TBmomxhbbMvK1qFaDJU+V/60zhGWbo6kcGgsYX4rZH52xbCk5e70d3v/QW0bt+nRwCXDpZ4YiKkz+BwCsS2sFQmAmkdkcB99Cl2vqI96LuoDhTqXGOz+Z7tK4etz9MLiWhO9uf3bMtmGw1XBxfGGAO79B/cOIO4INm6fDfjvYMHdLyCUk/reeYSokYdo3hlBGSLwmBqO/IeQ3hRYsoAq3sM/2lzpMm9NCtQVIk68AD5YqnT8zs3lR5nCyWqjt8mkYKTfOpSyRB4kgDFnfMm9zm11OyRzxWTknwjTQ1u3vQRP0dgAHNB+UEEQmsgl+p4MZBPCYSTzrAEOjMNNS181WxryaVbBsG1PYdqgbGL2TmtolLV47tnjdKR3hB5DDXZytyrFHFlx1CR4zhaiyi/tGtanh2jbwgaBL9XpoAXd5ymB28/AKWKPHEXCt5iu7IMEZ44k31g29IS+LHzr/2n1HT6OSZ5f8DkY+Wy62cta9chRADsR86nauhh4ayhmhWR4tp46DyEYrK+SF7Iy/s9/M06mpW6pNV6BjEkfdnBYSIjQKAvf4XTvqDeLEKxQuFbhBSbZSazBfmV6JhLZHTL1EwgobYfMA1fX/YX6/Of7nu8nvHmaNIEbBvZzIe1zZLM
 gwn5aE9k
 TeVpOC0Q8GmtcUzu9RDbOz3ZB5Ln1Y09ujH72wkfkYdjGCjliPMU5+2rdr3xoBzw+QmRaYgbQ6ERNJoncgQrBIzVAX3I/rEjZzBxapu8Zs4DuIb0sRIbTk8Uw5AJarfUesNNKAgQDXlGi6+noo0f5FBFlCfwPXKte6otHIudjfjLiREPDuw2a8kPTHn4zzfnmJBy0D0LmJgc4Gvw6okBhLGhPqkz/L1KPViFs4P4pWMs/x/SPsDOdCOpebBN8+B20kXlfy+2ntkNIjtbmEv54IcZ1anqDKC3CXxoh5DbHs9i87PPePnEnEeFTTjSzO2WGe4YWFfg3adw85Ni4x+T40m6zXNFFsLI7LDVNopN/JEsVh7FHGBOjiIy7Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 03/11/2026 22:05, Kanchana P. Sridhar wrote:
> On Tue, Nov 3, 2026 at 6:26 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:
>>
>>> On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
>>>>
>>>> Stores and loads serialize on the same per-CPU acomp request and mutex.
>>>> A low-priority store can be preempted as soon as the compressor drops
>>>> its stream lock, while it still holds the mutex. A higher-priority load
>>>> on that CPU then waits until the store runs again, which can take a
>>>> long time when other tasks are runnable.
>>>>
>>>> Give compression and decompression their own request, completion wait
>>>> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
>>>> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
>>>> compression, so group it with the compression request. Independent
>>>> requests can share the per-CPU transform; the codecs and drivers
>>>> synchronize their shared state internally. Loads can still wait for
>>>> each other on the decompression mutex, and stores still serialize on
>>>> the compression mutex.
>>>>
>>>> acomp_request_free() ignores NULL requests, so drop the check in
>>>> acomp_ctx_free().
>>>>
>>>> This follows the proposal from Sergey Senozhatsky for the same split
>>>> for zram [1].
>>>>
>>>> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>>>>
>>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>>
>>> I have a question with regards to this patch. Is the intent to allow a
>>> decompress thread to run concurrently with a store thread for a given process?
>>
>> The request is shared by tasks using the same CPU and zswap pool.
>> These may be different processes or threads of the same process.
>> Each operation still runs synchronously in its caller.
>>
>> The motivating case can happen entirely on one CPU:
>> 1. Task A compresses page X and releases the codec's stream lock.
>> 2. A is preempted while still holding the zswap request mutex.
>> 3. Task B runs and faults in an already stored page Y.
>>
>> With the shared request, B blocks until A runs again and releases the
>> mutex. Separate requests let B load Y while A's store is unfinished.
>> The codec/driver still synchronizes its own shared state.
>>
>>> If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
>>> penalty is worth it?
>>
>> The switch to B already occurs with the existing code. This patch adds
>> no worker threads, forced migration, PTE changes or TLB shootdowns.
>> It avoids B's subsequent wait on A's request mutex. The 1-vCPU
>> benchmark in the cover letter exercises this without CPU migration.
>>
>>>
>>> With the proposed change, will zswap_store() continue to run on the "old" CPU
>>> (i.e. the one to which the process got migrated), or is it a requirement that
>>> the "old" process is in sleep state? If so, should we codify/document this
>>> requirement?
>>>
>>
>> There is no requirement for A to sleep. A can remain runnable while
>> preempted. Its zswap_store() invocation resumes in the same task, on
>> whichever CPU the scheduler selects. If it migrates after selecting
>> the context, it retains that pointer and the corresponding mutex,
>> as the existing code does. The same task cannot execute on two CPUs
>> at once.
>>
>>> On the new CPU, is the same process "runnable", and if so, how do we ensure that
>>> the "higher priority" decompress is handled while the zswap_store() prior to
>>> preemption is still not done?
>>
>> Normal scheduler policy decides when B runs. Once it runs, the split
>> removes its dependency on A releasing the shared request mutex.
>> A load starting on another CPU already selects a different context
>> today; migration is unnecessary for the benefit described here.
>>
>> Existing folio/swap-cache locking still orders accesses to the same
>> page. The example above concerns two independent pages.
> 
> Thanks for explaining the motivation for this change, and the detailed
> analysis! Is it possible that this could cause compression contexts to
> be starved of compute resources under memory pressure, potentially
> causing deadlocks with page-faults in the worst-case scenario? 

The split removes an unnecessary dependency between unrelated pages.
Under fair scheduling, runnable reclaimers still get CPU time, and a
fault needing memory can perform direct reclaim itself. Faults on a page
being stored still wait for its folio lock, so I don't see a new deadlock
cycle here.

> Since
> compression is inherently slower than decompression, could this be
> making it easier for swap page-faults to preempt compression.

On non-PREEMPT_RT kernels, software compression already runs under the
codec's stream spinlock with preemption disabled. The delay addressed
here is after that lock is released; the split does not make active
compression newly preemptible.


> On a
> related note, should direct reclaim (only) be allowed to use a
> non-preemptible context via a spinlock?
> 
I would keep the current split. The codec already protects its stream,
while the outer context must remain sleepable for asynchronous
completion waits. A spinlock cannot safely cover those waits.



