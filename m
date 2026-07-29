Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D10C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 02:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0E96B0088; Tue, 28 Jul 2026 22:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291D76B008A; Tue, 28 Jul 2026 22:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7186B008C; Tue, 28 Jul 2026 22:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E49626B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:26:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81AD01A05BB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:26:15 +0000 (UTC)
X-FDA: 85040224710.23.2EECACD
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73EEC20007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:26:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tTFl/K8w";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785291973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BA9329Kf4/RFXsXBwIa0k4v57VQylo17hf2xN80X6YI=;
	b=YWps8bhuEfqN2MAPr4LlHH5pU1hlR18QC/Hwt3diBjr/c2sLu/yTiXKh2+yuj5MnQYO61E
	l6LZ37uTd1oFeteY1o7t0B03SawQ8lnLGkgyDfgSjNSuJkd1CJEkZjBCkapPhRSh3zIcxj
	Gno5z9IKT2Dx0eRpvDJ3MQEJsLqDMa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785291973;
	b=I1sbmX8zLgz4BHp1t2VYt1TQAxOH2brtyBqWfqypayucfvEAwW4SjGS5b4hqitEIhic7ll
	sa1vJA7PMrQgftnRL4sRYptwmyEpTlZifD+gAxy+FcmoxhgtcSFtf5XACRfdYAKAOrvQ2c
	O6iYOJnnMZc0dvB52CrL0oPTMP4zRO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tTFl/K8w";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 28 Jul 2026 19:25:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785291968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BA9329Kf4/RFXsXBwIa0k4v57VQylo17hf2xN80X6YI=;
	b=tTFl/K8wGvuA/A4PWUzcCngEwD5WbHGtbvNI+m/zYpQuyKmP+AwrT1nj7tHh6G0oVzIJCJ
	3CFKRzVZPtOV/sH/MnG6gKwX7T+SFTSAcPjmzErjOza9xaFUyHDBpx62Q7tkd2XbB9rYBt
	OElOl9Wa66QNIC1EQa8vdFHg7wEpeaA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amlkSmMZTWrT4rau@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
 <amkBvRSJm5rgiV5Q@tiehlicka>
 <amkjTk7Jc1q4ubxj@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amkjTk7Jc1q4ubxj@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 73EEC20007
X-Stat-Signature: fdtpi16un7k13jp4tsnsi4dagrqip5mb
X-HE-Tag: 1785291971-724799
X-HE-Meta: U2FsdGVkX18Og/uzaQp91YaKY310y5E5eOOWFmI+hWv7yAS7C9goDN5MWw0G2xlw4KVHrG9GeTu6tzv8AITxsSC4efe4fZxCO7IKat5SV/dj50HHjY8JjBcYp8iAfyxgGmxEMBWQaih+ua95he+hpfQXlJOGhx6XM0k8EM+P7L5SCh05yF1l8dtR3pJbp3dkSpMvHZUgP4Sn2vy1PGMmnIohYuvU0HSj2jVmiS9bN2hEzvK5uYk1h5k+MBCBYEmhIoSo7u8gsNCpdmXhJHRghccdXacJTIPAw8Ev6QtkYdE3gMoYKWLJ068yoQrkBbrzacX75b531ibyb89m7xGXKG2kLRhiQh5d0GMLTif6NsAQrJo9QdZGuC69BlHi3dvdiU+2QNSHCQkoyjOePv+yM7RgS0xdH5fEUk9dTgD9xBwrBTZrGLzF27l4nSHL9jOiJBoWIcXc3lYw0dXmUAQgvRtV7teE3euuAeORt56NM5tssp53zvxTii7d9TB09gja5AGkiLZDtfvXTQgSrMimdtBKv5WOx8PS5yG03mNi1jIj9QM45pmLn7aU668ts2BhxtXuNVq36rbNWcZr7OjZFer/mdbwTw1o+eRjMSy/6Own/5yu8KSJtNm3y/zGzRc805uVu0o0TvOFOQD4F9EWe+Bo8QA9BApKABI8XvxPOhoC9Ycvkyb7ikaprG0Q5bFvRTC78Fu6tT4BNtIL1FxxatBcuqH3u5efJppDPwHv5dxGpve7rFNQlJwu3T2tE/QfDtinLUmetCdTJKmpHuT96AjLBfPU4HdT1cAskry2/67e/rpr8Aak+GPA5JdaMpL8jrOy93iTjUF8ysm1P7Dkg1gMgjuDXWPM84Iug3xwFKZVZ8tRW0KhsI6LZ3KCaEcmMJ0mfrs5wcqEKUi7MLc/LsRHC0qN1vJefCjjsfGLwMYcXstZ/A+1+02Bw7MLDKwlx88Ua6nktSRM3USsdCQ
 6HGSzQDw
 M9gPYgdOpl4G5thNIlDQdNnEOWwSLXSTTVpYTwA2VJ4tpD0xqL6gS+rc5dOfJMpHfKik03MQhRgVtybyxaZ4o8bIT9f4gdZzYNC81vjBwfT8RawptRWpONEazUi2ugGmeONDVWK/apPMYWhsEFhNVIlBr11J+p8+UOEGNAWkS6aQ7La1745jsdBRQx027JUqMDIvALqI2sTAp7E0m5rQ7xuNa6CTmVkQDRQ8mam6oL03AJRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 02:57:41PM -0700, Shakeel Butt wrote:
> On Tue, Jul 28, 2026 at 09:23:41PM +0200, Michal Hocko wrote:
> > On Tue 28-07-26 09:55:21, Shakeel Butt wrote:
> > > On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> > > > On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > > > > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > > > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > > > > 
> > > > > [...]
> > > > > 
> > > > > > > 
> > > > > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > > > > It just makes it lockless. Assumption that a dying task will do so
> > > > > > > quickly and with bounded resources has turned wrong on several
> > > > > > > occasions.
> > > > > > 
> > > > > > That's why I kept it as RFC :)
> > > > > > 
> > > > > > > 
> > > > > > > On the other hand I do undestand the contention issues and I can imagine
> > > > > > > that the existing solution doesn't really work well for huge thread
> > > > > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > > > > nothing really killable anymore because they are the oom victim...
> > > > > > > 
> > > > > > > Would it be just safer to bail out only for oom victim threads. This
> > > > > > > would narrow down potential runaways for oom victims which should be
> > > > > > > more limited than any killed/exiting task. It would also give the oom
> > > > > > > killer/reaper chance to work. WDYT?
> > > > > > 
> > > > > > I will give the following patch a try with the reproducer I have. I am still
> > > > > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > > > > yet. I will report back once I have some results. 
> > > > > > 
> > > > > 
> > > > > I have some results with the reproducer I (AI) wrote.
> > > > > 
> > > > > Setup: 20k threads, each with its robust_list head on its own page in a
> > > > > large anon region pushed into a zswap pool (writeback off, so it's
> > > > > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > > > > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > > > > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > > > > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > > > > where the reaper was blocked and the memcg never fell below the limit.
> > > > > 
> > > > > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > > > > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > > > > drain the 20k threads in a VM (hours on the host, where each invocation
> > > > > was a dump_header over netconsole). With the patch the dying tasks stop
> > > > > entering out_of_memory and the storm is gone.
> > > > > 
> > > > > With the following suggestion, the threads of dying tasks stop entering
> > > > > out_of_memory but the exit time doubled as each thread has to decompress the
> > > > > page from zswap.
> > > > > 
> > > > > 	if (tsk_is_oom_victim(current))
> > > > > 		goto force;
> > > > > 
> > > > > I also tested by replacing goto force with goto nomem and the exit time halved
> > > > > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > > > > through the reclaim loops.
> > > > > 
> > > > > Just for testing purpose I moved this check along with goto nomem just before
> > > > > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > > > > below 1 second. I think what we need is to detect early that the cgroup is
> > > > > unreclaimable and the threads of exiting/reaped process should just return with
> > > > > enomem.
> > > > 
> > > > Do you mean, something like this?
> > > > --- 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 6dc4888a90f3..66f1eebf8c22 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > > >  	if (!gfpflags_allow_blocking(gfp_mask))
> > > >  		goto nomem;
> > > >  
> > > > +	/*
> > > > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > > > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > > > +	 * large thread group then all exiting threads might compete on oom_lock
> > > > +	 * just to learn that there is nothing really killable anymore. Bail
> > > > +	 * out early and fail the charge to expedite their exit. They are
> > > > +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> > > > +	 * further charges.
> > > > +	 */
> > > > +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
> > > 
> > > I simply had tsk_is_oom_victim(current) check here. 
> > 
> > I was hoping for a more specific treatment. 
> > 
> > > I assume you want
> > > MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
> > > this additional mm_flags_test() as well?
> > 
> > Sorry I meant MMF_OOM_SKIP there.
> 
> Here are the results with the reproducer I have. Ran the test 5 times and
> showing avg and std below:
> 
> Baseline (next-20260726)			36.47 ± 0.78 s
> early nomem (tsk_is_oom_victim + MMF_OOM_SKIP)	20.83 ± 4.19 s
> early nomem (tsk_is_oom_victim)			 0.59 ± 0.22 s
> 
> Since MMF_OOM_SKIP is set after multiple retries by the oom_reaper the result in
> between baseline and simple tsk_is_oom_victim check makes sense.
> 
> I think we can proceed with the early nomem (tsk_is_oom_victim + MMF_OOM_SKIP)
> change as it is more conservative unless you have concerns. Overall I want to
> deploy this in prod sooner to see if this specific issues is resolved or we
> catch something else.

Now I have much better results. Previous numbers were on a VM and now I have
ran on a physical machine and the results are much better and consistent. The
baseline consistently shows ~90 seconds exit time while (tsk_is_oom_victim +
MMF_OOM_SKIP) consistently show ~3 seconds exit time. I will send the formal
patch soon.

