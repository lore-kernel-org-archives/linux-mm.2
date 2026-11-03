Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC5E606A33D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YaHi5cR7
Received: by kanga.kvack.org (Postfix)
	id 766246B00EF; Tue,  3 Nov 2026 09:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7168F6B05B1; Tue,  3 Nov 2026 09:26:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6060F6B05B2; Tue,  3 Nov 2026 09:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33E716B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:26:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B199C140415
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:26:11 +0000 (UTC)
X-FDA: 85394032542.07.2A5E998
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf01.hostedemail.com (Postfix) with ESMTP id 70C7A4000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:26:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YaHi5cR7;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793715969;
	b=Xre7X/jgdSZmXPqIDs0xREQzdY1rHngcKlFSlwjv8l7EVfvkeZFhw4B60wb1BwzAHUWthN
	tlEMpY3Lnrra86e6JUpbTPXe12TE4X7M0wRYhCTQUHQzdRMHW3MZf3Gc/d5dQYP4vpdkVd
	osaSGcH557qb8aQchT8sKxu8rILj5hE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YaHi5cR7;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793715969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP+PsE8Ru4U+3pCKdB8/8ut6hXzWlTRuTLeApszTcIU=;
	b=NyexRupVMSVWpaXWL5lBdM/1SdaxgSuh2X/CuE4UyZjL/RGpaC05q3BLk3irboDDIaqPg2
	PYeMRPUCN7FvZWwHz8HGKVBw6Sv+fJfEivtxMgLYFAc/L1Q/UFU1bOalDeE50gvJT0k4Qz
	PGtFUbKG2cb0X8kXN7/XHCHJkyAPIis=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e4dRfO2AklgdwU7Ax1baawDTLW3B5X1MgsMszdfEn0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793715967; v=1; x=1794320767;
 b=YaHi5cR7BLL3kSm9QyMD6IvLgxrXUGjQG7/SqJWzCm2WzFzZhyONHi8FPdjtOJk4qBGtFzGG
 kUjC4kf2hI0RoP7sX43XiNI3hrc3E6tOctdbNbZyDbre2NqoFVOkam2lJx6loXVKlDQ2DE0i8lm
 Q9I7zUhYUe25GVDd/+Ls1CWo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 313b1a0531fdd4a8;
	Tue, 03 Nov 2026 14:26:07 +0000
X-Mizu-Trace-ID: 313b1a0531fdd4a8
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and decompression requests
Date: Tue,  3 Nov 2026 06:25:58 -0800
Message-ID: <20261103142600.279899-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shw1fycf8uqhajid8jn8nzgyg683684m
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70C7A4000C
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793715969-575619
X-HE-Meta: U2FsdGVkX19cyWi2EgD3zI6M+IpAnKp31LmZvz9G8GdGCoGZTDVmWuw2ikD86jdqPcDNG8b+LMIwJMpHRpjlKMGwq6JcW5Ic5ImPgh8K2lg4QtCjvn10jAepqhALNp5omHABhsNdaaIV8lffMAkLapIbQBJ/hqcp52UkvRDl8339vawV1pm0otiYDYa4npqdfQJuMSBI7EV9y74QcVxIO496nKy1kxaErXHqmy1+LioYEPRMZF+qXCfqsL2xP6XEfXeNfI3CXf51ZWvrtJfTrR8FIvzO5ITPA/X+vv7+nW8FYzTP+fwZOXv8oWrZGb+6l4KsY+hQ/EPoeQT+h5WjZdibRWKV9C8D6iI7hx26KXTcEggjCGOJt3yBkPmH/0J27mhupa62u2tnRNsT5YXSj8UoLs8btrw2WmSroLQMJVtbj2WwMA/2fuj728iDs6a94jThTDeUJwdC65uEm5BYxj4GOVD1FiVaxT43Ss6wEO0XUmzhgKvKVMwhzDkuGMVhh9K1uHJSIQmG3VFVJ9CdFHlSpXLwV9eKa4573rTLi7tSp2d31T20f2NWrdnm394ZZqbLqYFSfw/ET/S8Wu2rZFEoBRRlQeTh59w+R//usHmyNJDq03LWBtA8lO9nhIvFezl/XBKwcqthFR91b4sw9ZReyGinuk1Gve26mF5ejznBJPNdqiweS4y/UleWazw8vYBHTR6VVQq0W/w8lKXxwq+s3gIVE0+zEGoUwUtG5nMxtS7a87RsutjXS4qbhfiEeHU5wIF8EEGh1iNCo7JgK4KOI+SM/c5olpgXi+wk67FvUZ2uP0hsgJg7j/w0zVOp6CWYZPPl0ZRRhSWc2yt0gzqwv9uyZVgYIMTtzjNaXY3mmdZ+x6QzQxsNUAm6aU2CFyrrHRLXQkghqfIxBUdcPyavX0TG+F1vtVlMFSq4g2CPIU3otUs8QURIn6vw6LSJ9DCx6g4ASR1PJ54Adkk
 UoaXStEx
 /L2QfJcLNcqw/8d7R+frF4nMIfF4I8Wy+fw7kal5VTNGfHBDklusQ1kUrWmb68TqF58JeCB3ARBxEr/ow595c8wIXT/XcSBQGAZtSTJrgXaF+RoSl0Yg2a+8R2dxFQHjSUTckQgqUxCbKfwy5aMiAk95Dqq5Y/keJfFBg++C9tYXCVxC1xb3vittO8RuwJctzYw3NAv2n9esaiczaVnlPpO7djXvCEe77xhs24vEBzDw8rhldxCVM8sdaYJ4Bsl5PmM0467E6MpWKcnsWFd5/uM5WitcqFVCZbhniUhJv3D4531shyXdvlzu1SEQwKjngIcgK8pQVhBLpg+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 12 Oct 2026 17:21:40 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.
> >
> > acomp_request_free() ignores NULL requests, so drop the check in
> > acomp_ctx_free().
> >
> > This follows the proposal from Sergey Senozhatsky for the same split
> > for zram [1].
> >
> > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> >
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I have a question with regards to this patch. Is the intent to allow a
> decompress thread to run concurrently with a store thread for a given process?

The request is shared by tasks using the same CPU and zswap pool.
These may be different processes or threads of the same process.
Each operation still runs synchronously in its caller.

The motivating case can happen entirely on one CPU:
1. Task A compresses page X and releases the codec's stream lock.
2. A is preempted while still holding the zswap request mutex.
3. Task B runs and faults in an already stored page Y.

With the shared request, B blocks until A runs again and releases the
mutex. Separate requests let B load Y while A's store is unfinished.
The codec/driver still synchronizes its own shared state.

> If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
> penalty is worth it?

The switch to B already occurs with the existing code. This patch adds
no worker threads, forced migration, PTE changes or TLB shootdowns.
It avoids B's subsequent wait on A's request mutex. The 1-vCPU
benchmark in the cover letter exercises this without CPU migration.

> 
> With the proposed change, will zswap_store() continue to run on the "old" CPU
> (i.e. the one to which the process got migrated), or is it a requirement that
> the "old" process is in sleep state? If so, should we codify/document this
> requirement?
> 

There is no requirement for A to sleep. A can remain runnable while
preempted. Its zswap_store() invocation resumes in the same task, on
whichever CPU the scheduler selects. If it migrates after selecting
the context, it retains that pointer and the corresponding mutex,
as the existing code does. The same task cannot execute on two CPUs
at once.

> On the new CPU, is the same process "runnable", and if so, how do we ensure that
> the "higher priority" decompress is handled while the zswap_store() prior to
> preemption is still not done?

Normal scheduler policy decides when B runs. Once it runs, the split
removes its dependency on A releasing the shared request mutex.
A load starting on another CPU already selects a different context
today; migration is unnecessary for the benefit described here.

Existing folio/swap-cache locking still orders accesses to the same
page. The example above concerns two independent pages.

Thanks for the review!
Usama

> 
> Thanks,
> Kanchana
> 

