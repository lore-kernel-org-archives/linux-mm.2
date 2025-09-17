Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49EE9CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5138E000D; Wed, 17 Sep 2025 07:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8956C8E0001; Wed, 17 Sep 2025 07:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB758E000D; Wed, 17 Sep 2025 07:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 673D98E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:36:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C52F595BD
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:36:16 +0000 (UTC)
X-FDA: 83898538752.21.8CF58CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45945140007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:36:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SV9r/9JX";
	spf=pass (imf09.hostedemail.com: domain of "SRS0=/mBJ=34=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=/mBJ=34=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758108974;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1OMOMZiRUjcq1eNsbBbJF7XY5WcTli6XOP2C6Dv/Zo=;
	b=BwqDxBBCHE4j/SkU1qfLme/4VD08Zz4sq6FYHrF0eeqhbfVJ+IrmGc2rkvdnJSkyuyfsOm
	0EvIBShzE4HLQNWHtdHnCO/lxdlzO/YutA2hfKDt2WA76u3jM9l02XNQFMKO8UMVCS/3HO
	R+L6GFAE4JdUiq+MffM0xY28479SoEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758108974; a=rsa-sha256;
	cv=none;
	b=vgr1VNaX2Yna4DZTC+2oRsaLY3zoXbhSCIsK9I4Ac6DSKDySBVTJVc2jA14Djs5wQJ7iIJ
	XsEQ+pReBGKCdkrLuanEdgBUKnCm89g393K2wJ/UKKLTqiZF3meAd9C9oHtLIXHW/kt/a3
	2jUL9UyGlR4RD1rS3IzTQ/+KIsSYuVg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="SV9r/9JX";
	spf=pass (imf09.hostedemail.com: domain of "SRS0=/mBJ=34=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=/mBJ=34=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2EA143A9B;
	Wed, 17 Sep 2025 11:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2138C4CEF0;
	Wed, 17 Sep 2025 11:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758108972;
	bh=NwEiTfpgf+XTMOx0qaKYlHuyF0sM6sOxEUWxLoQPSSA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=SV9r/9JXKIcmnOEZMb51WiDXHCOhHj+aXNaj2OPTpFJO2xs+tVmBeZ13GVmBJG4HY
	 pYOPZQcL5ByXlhy9Ck3vCF3DjE6HbEDubm1VfpGdaHn/7P/bYRPm0y2m5oy+HwuO3w
	 suJ0Pfc2QadTM0xkTUuji1xz5ThlJelyR8rjnQu9vhCYeHSPKwiG17nCVR2VUFxUNj
	 omw1y/kq02xlQyU5VECjXEGwaG/XdwXYya9npYizCi6k8DJ6mKUAOuipL5Dnn4QuUV
	 Ts7drRnN0RtxIG6icTkn/3hWdKGyjJiESLomoQEK+xiT9nt3ZvJgEvRxYT2wB6b6Dp
	 jgq2ng2Rv6cwA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 2222ECE0836; Wed, 17 Sep 2025 04:36:12 -0700 (PDT)
Date: Wed, 17 Sep 2025 04:36:12 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <8e7055a9-f899-4aad-8ed7-6543077c05d1@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo>
 <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45945140007
X-Stat-Signature: peuftdzwnttmken4b3p5aqbxti9q6g3k
X-Rspam-User: 
X-HE-Tag: 1758108974-851111
X-HE-Meta: U2FsdGVkX19YACCZfP0nH8AAysl4MyYlvzLSk1bW0+pQEhxNt2epUFLFRL9A5kLcGQJRnzZm6vGewhQVoaNJuiI+Tq0YUkJIX9og6/JOsoWuEN36hXNeErsq/gOJfrCSSIZW+Sa4aLVA98idIXb0mGudaS6KZ5Rp5ZabgZE6SXde3yRCtpkiUPTCaX/Lzb29J/FTYEEfrSotUpJzzhMEFDaEkCQIg8ZqA7Gcjr+ztTfaX8YVVzjvGbbC3NGKJr6iSx+7zkgi9FRIsUFQk/WSN0cvEDgqycxNYPuWILYkNGqR9dJU4Py/n+t91XuvcBEXyGelkuSuKv8DeAjtKfPVzKTivf1VubWzA47X6HUNfAc346JIMbJNY302emZ0nLOAkO3CL4GeKlea3EzzJ6k/dRAfTQelh07BqRwcsCg70lGKZUQ4IBhVT4rQmjRnVZMB1jRzaCGHXSidqRV1pnN/hduU13+ngadOBkksMpExZv9whFgrfUmlHHywHuKLumi1H/08cATxL59FZyZiIm/TUL2CJiKxX5mozqcEeke61n+pQOl2NriP9WFlr3KWKtRSu10kZFL7vtGBgr+WE0RVnf96wBwV26/WFLaxsQIPCDwHe70HkP+/IcryLYgPL+Qn5FBzCutQyIG3LGbCkH2/53jTDgsTKJkSpWJq5cm1lCmA2lNaKpZPC2mmRcL+h6jekv61SYVZwEfz77vTLsH3Tf7BuE+Y1d8qM+iR5qe5zJ7U/jR2fP0XRuDrsMnMqnT2VTyTYuxe15up+7cfZ7jm+5rfYx/5NSqpHeSvwzEEv3G3P6iY03lXbnInBALWPyLt7JM46t115FVtC5hDe7clvbRyVfxC7o9VADFjHmJesw60vocm8eReLpW+nNLFhWXNlCebb1YvBKGQfmMOtLB6AgvvSixLWwEMp45QwazbdqgOXOkYklnejOz6FwXArMcj3oqZo89B4biz3v4CLH6
 uL0ucjWi
 HZ6pB4uUuIC2Brp0ATFJdSbva+5iydEfCBw58vi9mAJkpGpgqD/VyNKLNvvWLnLQwr6xUde09+k+XU7kMoq2/oY3PHgNLWhRhh00JHvWwDNzk+XyUAEwimW+z0JhDO/FkrMbrQB6at54jwW0E8EZ9N7ozwuqe2LFvFdIAqV9kTu/wCgR8jEOaW2BMx1qEm65Sk5sCYptgExMCEUIvOjWvtz5JyS9D1NE8grIulQOV4QVM2D9ZeLvU+nnECqQHS39lFhF5lYM+/RT+UhO0IkaNUJlvXwgaZnMQId0s+KtEk+oNRGqKdqujpqkR7E3ub98DNKSNwgKZ7XMAeIZkmLN8UR+e5kG4INvkSPZwI/iiKHEp+LDN2swtaFOWGGTIuqsL0WRjnyKVg5I0KVK2ZNlx7/u3rznKSngJKwfYLGxfigMPNt4LykKRvJYQ2vVtxWZC1N+gJJl4Ucd9Te2GS7qe79/XlmzumU2nS0oLQ+Q5CzWSQffM9VFiNQAQgoHTSvlOCKRHkIicXOgwW2vCxxEQjHOYNaKNcnn7EmdyCufWVk/OvU8oNEbYcLvisivKjhxg2v/chGYuv8GYuNT8NbTx212gclIEpLaYtfrWUn1UMwshEE0Z5CS1fTCbvhVvugBALC/kuJKXMAEOpOOg6bhnXzTub4HnGiALjOg0uE1Glgz+64INJMkd1Dx0XQkrtY6QeilG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
> On 9/17/25 10:30, Harry Yoo wrote:
> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
> >> +/* needed for kvfree_rcu_barrier() */
> >> +void flush_all_rcu_sheaves()
> >> +{
> >> +	struct slub_percpu_sheaves *pcs;
> >> +	struct slub_flush_work *sfw;
> >> +	struct kmem_cache *s;
> >> +	bool flushed = false;
> >> +	unsigned int cpu;
> >> +
> >> +	cpus_read_lock();
> >> +	mutex_lock(&slab_mutex);
> >> +
> >> +	list_for_each_entry(s, &slab_caches, list) {
> >> +		if (!s->cpu_sheaves)
> >> +			continue;
> >> +
> >> +		mutex_lock(&flush_lock);
> >> +
> >> +		for_each_online_cpu(cpu) {
> >> +			sfw = &per_cpu(slub_flush, cpu);
> >> +			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> >> +
> >> +			if (!pcs->rcu_free || !pcs->rcu_free->size) {
> > 
> > Is the compiler allowed to compile this to read pcs->rcu_free twice?
> > Something like:
> > 
> > flush_all_rcu_sheaves()			__kfree_rcu_sheaf()
> > 
> > pcs->rcu_free != NULL
> > 					pcs->rcu_free = NULL
> > pcs->rcu_free == NULL
> > /* NULL-pointer-deref */
> > pcs->rcu_free->size
> 
> Good point, I'll remove the size check and simply pcs->rcu_free non-null
> means we flush.
> 
> >> +				sfw->skip = true;
> >> +				continue;
> >> +			}
> >>
> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
> >> +			sfw->skip = false;
> >> +			sfw->s = s;
> >> +			queue_work_on(cpu, flushwq, &sfw->work);
> >> +			flushed = true;
> >> +		}
> >> +
> >> +		for_each_online_cpu(cpu) {
> >> +			sfw = &per_cpu(slub_flush, cpu);
> >> +			if (sfw->skip)
> >> +				continue;
> >> +			flush_work(&sfw->work);
> >> +		}
> >> +
> >> +		mutex_unlock(&flush_lock);
> >> +	}
> >> +
> >> +	mutex_unlock(&slab_mutex);
> >> +	cpus_read_unlock();
> >> +
> >> +	if (flushed)
> >> +		rcu_barrier();
> > 
> > I think we need to call rcu_barrier() even if flushed == false?
> > 
> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
> > be processed before flush_all_rcu_sheaves() is called, and
> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
> > so flushed == false but the rcu callback isn't processed yet
> > by the end of the function?
> > 
> > That sounds like a very unlikely to happen in a realistic scenario,
> > but still possible...
> 
> Yes also good point, will flush unconditionally.
> 
> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
> local_unlock(). So we don't end up seeing a NULL pcs->rcu_free in
> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
> but didn't yet do the call_rcu() as it got preempted after local_unlock().
> 
> But then rcu_barrier() itself probably won't mean we make sure such cpus
> finished the local_locked section, if we didn't queue work on them. So maybe
> we need synchronize_rcu()?

Do you need both rcu_barrier() and synchronize_rcu(), maybe along with
kvfree_rcu_barrier() as well?  It would not be hard to make such a thing,
using workqueues or some such.  Not sure what the API should look like,
especially should people want other RCU flavors to get into the act
as well.

							Thanx, Paul

