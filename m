Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48E67D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF176B0012; Thu, 27 Nov 2025 14:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996916B0088; Thu, 27 Nov 2025 14:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885446B008A; Thu, 27 Nov 2025 14:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 759106B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:29:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 043BB13539B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:29:24 +0000 (UTC)
X-FDA: 84157375890.10.C36223D
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D8A94000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:29:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X9uDwWC+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764271763; a=rsa-sha256;
	cv=none;
	b=dsLKcLxCDMOnew93ag4KHFYqELYxhzOq+Nspjz1V4Zx6Wd0PWBjpvjW2at6+Mw1l5x/39k
	YWcPz6/aB8KW8Q7ANWUC6GmO5JbxcbT9SxR6D7YDG7oaR4dzaYmLhb+2/XTVCICZrIcyqW
	FyFpLmhDYNf2Hf9vEMgvAiF3jMKBQcI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X9uDwWC+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764271763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoIF1SGGEVRiz/EuDnanHFl7GK3C8LRxCxceA/BH30I=;
	b=5G9ila3fKlLXEWX3t0ixROrqRecTFWifVbHJcFI99CPhEoneUuwyaoGFXTm2qSDzktWm4U
	Hm6RBZEtyzio3VebZtAGyDWSf8ZmtC6826e254w0SiyN4cz0iU3ydJu4NHv0WfuCfuci4+
	YRa5RPTj4D3yWVbsro48w1Ovuj4JEFw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso289721cf.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764271762; x=1764876562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DoIF1SGGEVRiz/EuDnanHFl7GK3C8LRxCxceA/BH30I=;
        b=X9uDwWC+rG3ZwNV+H1+QbBeToiu+QzIylphmLLQOOBBmdUICc7h4GtMKbFWXh5EzYR
         KdHb425fGpBT3b7zzOd2Ga5GqipbDpe7ciYAe7Ea4IWHbCfE4RUJNm02OqOnxg+KXNAk
         2bEMX5jYsmSk+r3ppqCTtsBdmB/mqf0QCXQh0t6bymb+kXRn7Bp3qCSk6/r3h0GrUzHy
         HlPz1sI1DtoBUwpIYFfV8jZXS7aW/J0h4AMvOXTukB359b+YEx43v+qnKMaBRKDwmDzp
         RwIsO3YbY3aFFfyRnO2T44V8XGUShsibiwgxK20MrEkyxolUg6jxqUkbWYtu4WZR7vZu
         FRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764271762; x=1764876562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DoIF1SGGEVRiz/EuDnanHFl7GK3C8LRxCxceA/BH30I=;
        b=PxsA1fB0yOU/AT5dnsCHCBy/QD7sENeQyzB3Ucfq+aEViD/q8jZHg5UnGuKuTa8rJL
         bWJYEzHAFep1Ytg9pW0qVnaZF+sBcKfxAyN4lSLSma2o4D0hZWUpLwxXANJmtewhwUIv
         wJCU65SSOSPLzw9iFEj4zA0qebFGPZLjUc00vkKXCU+IZTm+qWg0IggpLJQhpXn7hevU
         CWZ4O91EHB3sBZRFdAU1NB+IoS4dpRRkQbLoHHJox7LAwjzXSUTw56o/8jc9WXmw+XKK
         gMtqE6z58ByDY7GvaFPM7xawk5HueuEER/49XIegOZpid0u5rasSIuzw3Rs2cgFQsn4N
         xsHg==
X-Forwarded-Encrypted: i=1; AJvYcCUd+gmJaOoJ+ub8ve6oG7T0i/NeSj9jsKvtoDUxsFs1dl7cDBcXoUlazLH1zA6b62xMNqBzd2ba5A==@kvack.org
X-Gm-Message-State: AOJu0YwKObDcFH5OoTsP02Pkb2PLNvoGpU5KBpAoYSPRYaEvhiqU3GfL
	NSv3yACpNwUX0c8b+IYi0cTMzX+l4zZwURCfYRuxeN8gFYYppLv1GZrh1jiqVBV/am1lnNrAKwQ
	XvEzUHqXLxftuOTEhSaUzgvuQxywgXseiYJ/5jJlk
X-Gm-Gg: ASbGnctRK+fzQma/dSiXj+VTNkUHoiuE4oJs0EBU56cwNm/9liLlcJtTNnDdg3eLSZR
	nbOHDMQlAphWYMh/ST0+pZcQ7JtUzF+TYqfg7+uQOqB/RUKkWABSHFl6/gilFjE6epwIvdfMpSQ
	+JNnBsypK5Ep6/OzrVg2YMmv0LZE6yIPLLnSqBmFEtbW1adVLS/XPs28YCABaAwMTNghoLEkreu
	Cz1dWUedxl1NkPrcMxxnwAHlEat0tmsH6sXwYxU7ZngW6UOq7rlRNqohjV4r5KKdDyIFCIijhGa
	jjJc
X-Google-Smtp-Source: AGHT+IGxLUEzc3Reot726IcmLgjq3nKIC/pLTC27EX/OZL86TUpoASPm9EUrUhNIVGTyzCyI1smo65AvyrNtEbv7AJM=
X-Received: by 2002:a05:622a:346:b0:4ed:b665:3779 with SMTP id
 d75a77b69052e-4efd0cadedemr5566471cf.16.1764271761856; Thu, 27 Nov 2025
 11:29:21 -0800 (PST)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz> <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <aQge2rmgRvd1JKxc@harry> <1bda09da-93be-4737-aef0-d47f8c5c9301@suse.cz> <1c34bf75-0ea3-490d-b412-288c7452904e@kernel.org>
In-Reply-To: <1c34bf75-0ea3-490d-b412-288c7452904e@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 27 Nov 2025 11:29:10 -0800
X-Gm-Features: AWmQ_bnMUm6fpw8I5CiW8EnlZf9RdB2BGr-Nmfr3npUmVluTVAnisr9aMXu_kzM
Message-ID: <CAJuCfpFTMQD6oyR_Q1ds7XL4Km7h2mmzSv4z7f5fFnQ14=+g_A@mail.gmail.com>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() operations
To: Daniel Gomez <da.gomez@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-modules@vger.kernel.org, 
	bpf@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	Lucas De Marchi <lucas.demarchi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D8A94000A
X-Stat-Signature: b7m9dquyxfu4nz7khshbdtmfy3tzo7qw
X-Rspam-User: 
X-HE-Tag: 1764271762-72955
X-HE-Meta: U2FsdGVkX1/HsdDNV51Jfd+col8P6kLQcR6PiFIme2gvcNwtdttTyECciV5uO1Lwf1kXWmptDqVZDlEp2vt+pdIbv7qcNiDwqBoueCc71ucZL1H1LsCKy9OXGfjH7FgxomMyxkaRejo3CSY7hquku7HTgjfZPUH3tErAAJihQbMgB1ugDMSSNqQfQZ12k0QZ7Qjj3J4ZeM/7SqtC8zkOTmFkO7wKdOvlsudYXOZSVa1+yCy6ApgOjDNTzYM6hehfvXh4nwO+VB5YhAFrQR6kAGRx32NMjs8/KdNTlnzy73f6hIFMsJ1tOM0wZTs++zuDTjcASaeQWVGuOvLBZl/DUn6AF+k6G3m++tUspUpDXNrH1kVU5lgQy4SEWyWbyaac/TwspPKs8cmFKv60j1/v4H9k+vGbioMbGsNbA8XhlV5xAZQhFQE7gduQ2kUeWeHLWuDy+WzPoDcrPUlAJWvRDAdnvTk5zBvaGULVtLctx/3uFlxDxUXEjtb3j5O84UZ/RHancg1bqOWGPHSfXAdL9lyS7EDBEIu0lGqfB3BdcRD71l9xPOFKXtT1Sgi2EbHwbbmQTZvfPsRQzsy4KTa9hJjbc+JK38UuzFNXwdSOF8460/2VNCWcyXxfp79zeTo72QhF41wH2NQMIVsbut/uz1CqyiiXek11gCs3lgzNB2oVDxUC41JRwtsmkgM9/ky5WVnE8679Vb0XvVqGgSM3Nj9H3V3MeSnvIRs+Ci6e/7h40HElZzhITSe1TDveUgE+pEdRBsujYxY2P85LYcMAD1Rfly8usl/RKyJvGirQBat1Narn0qnxPiM5BzXCt2CHu+VftrcRGhcetbRmRVJMFyGT29YLrIYBTkG/ncwVjhSc8EHiRcl30B0ZGf2AKbFsnRTt6re0pQnOXMn5Io4sbOEimGxA3ObtB062t+bc4ocdo0eYSp7CDZCjt/GZLHfwaXs4dYfmK12ItWIOPbP
 wPYr0Bwj
 7AH8/5jkmU9lJyMCZuutsS4Eo5nNPKqpT+IV1luS2LG0w6CgINYK5mx027rslmNrGOaRG0Rp84OB+iQHBYCaUIBr9H0F9qV7sUu7MdSPbr+H2mWZEWKBPSC/VaVCVtpb8Q6UYKWtKwwSyoktZPhd7Zj3hLZNPFFWdD9iNQhgO5wzgue8aXqHB9IQ8fLEha3e4ly3e5q0HMGz+quUfaLwUc7BaNhpOTzebh4Q/sCkHUGJeapiIRQA681bX/399PMlg82rBDbVQ404MWwA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 6:01=E2=80=AFAM Daniel Gomez <da.gomez@kernel.org> =
wrote:
>
>
>
> On 05/11/2025 12.25, Vlastimil Babka wrote:
> > On 11/3/25 04:17, Harry Yoo wrote:
> >> On Fri, Oct 31, 2025 at 10:32:54PM +0100, Daniel Gomez wrote:
> >>>
> >>>
> >>> On 10/09/2025 10.01, Vlastimil Babka wrote:
> >>>> Extend the sheaf infrastructure for more efficient kfree_rcu() handl=
ing.
> >>>> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> >>>> addition to main and spare sheaves.
> >>>>
> >>>> kfree_rcu() operations will try to put objects on this sheaf. Once f=
ull,
> >>>> the sheaf is detached and submitted to call_rcu() with a handler tha=
t
> >>>> will try to put it in the barn, or flush to slab pages using bulk fr=
ee,
> >>>> when the barn is full. Then a new empty sheaf must be obtained to pu=
t
> >>>> more objects there.
> >>>>
> >>>> It's possible that no free sheaves are available to use for a new
> >>>> rcu_free sheaf, and the allocation in kfree_rcu() context can only u=
se
> >>>> GFP_NOWAIT and thus may fail. In that case, fall back to the existin=
g
> >>>> kfree_rcu() implementation.
> >>>>
> >>>> Expected advantages:
> >>>> - batching the kfree_rcu() operations, that could eventually replace=
 the
> >>>>   existing batching
> >>>> - sheaves can be reused for allocations via barn instead of being
> >>>>   flushed to slabs, which is more efficient
> >>>>   - this includes cases where only some cpus are allowed to process =
rcu
> >>>>     callbacks (Android)
> >>>>
> >>>> Possible disadvantage:
> >>>> - objects might be waiting for more than their grace period (it is
> >>>>   determined by the last object freed into the sheaf), increasing me=
mory
> >>>>   usage - but the existing batching does that too.
> >>>>
> >>>> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> >>>> implementation favors smaller memory footprint over performance.
> >>>>
> >>>> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as th=
e
> >>>> contexts where kfree_rcu() is called might not be compatible with ta=
king
> >>>> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> >>>> spinlock - the current kfree_rcu() implementation avoids doing that.
> >>>>
> >>>> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all ca=
ches
> >>>> that have them. This is not a cheap operation, but the barrier usage=
 is
> >>>> rare - currently kmem_cache_destroy() or on module unload.
> >>>>
> >>>> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fai=
l to
> >>>> count how many kfree_rcu() used the rcu_free sheaf successfully and =
how
> >>>> many had to fall back to the existing implementation.
> >>>>
> >>>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >>>
> >>> Hi Vlastimil,
> >>>
> >>> This patch increases kmod selftest (stress module loader) runtime by =
about
> >>> ~50-60%, from ~200s to ~300s total execution time. My tested kernel h=
as
> >>> CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what mi=
ght be
> >>> causing this, or how to address it?
> >>
> >> This is likely due to increased kvfree_rcu_barrier() during module unl=
oad.
> >
> > Hm so there are actually two possible sources of this. One is that the
> > module creates some kmem_cache and calls kmem_cache_destroy() on it bef=
ore
> > unloading. That does kvfree_rcu_barrier() which iterates all caches via
> > flush_all_rcu_sheaves(), but in this case it shouldn't need to - we cou=
ld
> > have a weaker form of kvfree_rcu_barrier() that only guarantees flushin=
g of
> > that single cache.
>
> Thanks for the feedback. And thanks to Jon who has revived this again.
>
> >
> > The other source is codetag_unload_module(), and I'm afraid it's this o=
ne as
> > it's hooked to evey module unload. Do you have CONFIG_CODE_TAGGING enab=
led?
>
> Yes, we do have that enabled.

Sorry I missed this discussion before.
IIUC, the performance is impacted because kvfree_rcu_barrier() has to
flush_all_rcu_sheaves(), therefore is more costly than before.

>
> > Disabling it should help in this case, if you don't need memory allocat=
ion
> > profiling for that stress test. I think there's some space for improvem=
ent -
> > when compiled in but memalloc profiling never enabled during the uptime=
,
> > this could probably be skipped? Suren?

I think yes, we should be able to skip kvfree_rcu_barrier() inside
codetag_unload_module() if profiling was not enabled.
kvfree_rcu_barrier() is there to ensure all potential kfree_rcu()'s
for module allocations are finished before destroying the tags. I'll
need to add an additional "sticky" flag to record that profiling was
used so that we detect a case when it was enabled, then disabled
before module unloading. I can work on it next week.

> >
> >> It currently iterates over all CPUs x slab caches (that enabled sheave=
s,
> >> there should be only a few now) pair to make sure rcu sheaf is flushed
> >> by the time kvfree_rcu_barrier() returns.
> >
> > Yeah, also it's done under slab_mutex. Is the stress test trying to unl=
oad
> > multiple modules in parallel? That would make things worse, although I'=
d
> > expect there's a lot serialization in this area already.
>
> AFAIK, the kmod stress test does not unload modules in parallel. Module u=
nload
> happens one at a time before each test iteration. However, test 0008 and =
0009
> run 300 total sequential module unloads.
>
> ALL_TESTS=3D"$ALL_TESTS 0008:150:1"
> ALL_TESTS=3D"$ALL_TESTS 0009:150:1"
>
> >
> > Unfortunately it will get worse with sheaves extended to all caches. We
> > could probably mark caches once they allocate their first rcu_free shea=
f
> > (should not add visible overhead) and keep skipping those that never di=
d.
> >> Just being curious, do you have any serious workload that depends on
> >> the performance of module unload?
>
> Can we have a combination of a weaker form of kvfree_rcu_barrier() + trac=
king?
> Happy to test this again if you have a patch or something in mind.
>
> In addition and AFAIK, module unloading is similar to ebpf programs. Ccin=
g bpf
> folks in case they have a workload.
>
> But I don't have a particular workload in mind.

