Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5618EC54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C566B009D; Tue, 28 Jul 2026 15:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDFE6B009E; Tue, 28 Jul 2026 15:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBA06B009F; Tue, 28 Jul 2026 15:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10B226B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:23:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EA2B1604EA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:23:46 +0000 (UTC)
X-FDA: 85039160052.27.0838460
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9675B140004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:23:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="JcZxpfz/";
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8qZfjaxhGbSgiZnpnKGN1HzCLFjiwC8FeQ/0VidGnU=;
	b=hIirzlWqJTWk0uC8H1+s7sbLRXTMyi5kbAyKBbXZy0yvX1+Xz6U2WtaXn22qAesIdUYlhP
	pztSZDRvr0GMpSPZl08YurUZx+D4s2ZWtO/xzZilYTYMT9twTLbWGxhlLSKYR4yWHLvcNm
	gr0Cx5tbGteJ3qtskFJRfyCJ3uIgIGI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266624;
	b=UEk3Splv7Layz0xMv7oz4NYuAboudjKrVIXnQ+er28Ws97DxyZjGjI5XPMK+ej5hG/s7Wh
	xDa8J5MXruM2Ql2WO5ryQ1mFeWKO/UoHxuE9TrT/luvonTFqI/VZfrcXce2MroCV/9Nzwa
	G4PtL0RI9m6GjHgBuaJ+JMeiAaPb2Cc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="JcZxpfz/";
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f633e6058so230197f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785266623; x=1785871423; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K8qZfjaxhGbSgiZnpnKGN1HzCLFjiwC8FeQ/0VidGnU=;
        b=JcZxpfz/8hEm9Zgfx6WZn7X/9rBTDCErfG/mZohHM9Od85Bl10MJN5wW2gr09tbRX0
         wuIeO2b92mgfMYTEW3ogFjtfZL/oR06nJBHFfqjbdsyW1QkjNQV5zaVJaSeXclesiWNe
         YDP/wmHo/+MJjcWYmOQBwoc9/kg4V39QRYU+Wk9hJz0RcX92gnyrW4osm8XHC6eY4ewI
         /HVNJbR70OLbha3KikJHPQaNYJnWY2oa4VsY5EbqXWDSLhWgZiieiXHefeBaeFQz+S66
         nabSE8yCzSHIWJ0QZL04CZrQ/kgAQjoEGCrBav2mSvOytMCZBZA7646kYeojx2/t/d5n
         cwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785266623; x=1785871423;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K8qZfjaxhGbSgiZnpnKGN1HzCLFjiwC8FeQ/0VidGnU=;
        b=SSRU+Dr3JDgyQqaChOtNi4O38ZM8lpUi2wZQVy379O8mf890sE2LxoyiG0UsVWHK1d
         IX4us+x/P0nXTmAtGORic6YLPIF3UzFu8rr/zUEzO/bvNPxeEI3tSvRHYe5nbR0gzza+
         IdfidH84xJj+BNdgo3l15xJq7iU6pPDQpwi5Q4i3hczM00aqki9qwcz50nQE3w1RtAHi
         3LTtSv+GJgmTE7Zjl+hH+KnTs+2Hmfjkqi/lzHnBVtBrXhHbQ4Z2I/2SKMEONLAdw+zY
         GMcOscauOgjNEILPoHSft/QiqYnwF95GjK2zp5GPk4KyIdwxlX4o7Tu1PpRHq0STTI4E
         D/lA==
X-Forwarded-Encrypted: i=1; AHgh+RrucDO7AuNHcRufq94hpXeoKKm9MvhodUfB2enQpZ/wB7Unm295vLVpO3jHhRfPBAbmHGw+WlcfAw==@kvack.org
X-Gm-Message-State: AOJu0YyQ0QjG8VszpL7Xg6cqfKyCP2/h7+BzUc0D/FkGEa93olGnnyah
	WFs3BIAJQnLl7PuZ7YY1RRHtvKPx3q5c570POUjolmgHPy3bvjZTbPM/FhB21s/3x/k=
X-Gm-Gg: AR+sD13N+SZI2GLc0ov/yfBMAb8CyivTVR0uB007MphpLhhaJYhJYXX5lH2ZB40wIM9
	cpqfN2Vv0ATLgyecSciWflxomcy4NqQ/RNEqE2RvChlCMWeCkcEL2SK/XMWSEv5mTy562dOy1ef
	ZtyTFNttbSKjv9SKeBqVgosQXAovu8n7PE4+BI7rfmphgmtyEp+9mh2eLlWCuhTdo2TugS351+v
	AHkPOkFxVrwL7ohcyhbjU7CMh9t5D2hZlW65ouGFq05fmOezNPIybrCrS3zq0WWWJFTMxWDlrUX
	Tk8dYbD7S0hCfzCbQg4vBbmRyU4O/CHDPpmKEJUhYFhemBuD1vYB+KCf6njEOFEsMa5zW0QO47u
	D9YgNpiegrdDmTWWa7rDs637lHXAan+wQmw1/Bli4MLoD0nN8fYodbb8FqUeDAVFBEOKSVCeOh8
	L/5QONaAmbsJ3433ONlaJMNcVSuFN3NwcfpIyPdKRAEEds/+x1RzKyOz6DHMrLhNP2IpAn
X-Received: by 2002:a5d:5849:0:b0:47f:8f8f:e494 with SMTP id ffacd0b85a97d-47fb1ec88d4mr4116620f8f.2.1785266622998;
        Tue, 28 Jul 2026 12:23:42 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b189fbsm1268107f8f.25.2026.07.28.12.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:23:42 -0700 (PDT)
Date: Tue, 28 Jul 2026 21:23:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amkBvRSJm5rgiV5Q@tiehlicka>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
 <amjeUV3dAn7KPQgK@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjeUV3dAn7KPQgK@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9675B140004
X-Stat-Signature: i9gztgdp8g9munftqa7br7944d1fu8p3
X-Rspam-User: 
X-HE-Tag: 1785266624-581385
X-HE-Meta: U2FsdGVkX1/ApFTWIw65fgbJ6Monq0uR9IU7umBMOqvS1TMgXrvD4sENYVuxn6E6TbokCKVQpKLyTecinOndnr75A4vBuSeEftM52fTUh1ELZiEOzRhfRLKFSzDJYQ+FdBNu672VA8sJZj0SwAvHy7AOpXz7Z0dnsVEvAMoSPHTY5sdQ3fsVndpCNJYPiWWjkkO9Tmw/ttEpzHfGYjftVxpGypcBVkziLqxZjlKcwI/2gaq/Dq8iy64YLWDUsGRPxyfoDAbcutC6osZ+VyKoMds1MUnjKAmkD6Q+MD/dXQcCtsuGYJsJ7yaldB5yupRM0VjfbB1sskJhTg/uK2fa87HyP/wg6TzcIVjYei7I5UkY0WnjA/u+AyAOzAe1ljOI5bo85mOFnNBFY1WQQze799g+si+KNBKj4ngI8gvMM3+zvx42R7MEpnGPGyXzjwWEdogXZwDR1n6Y3Aj2kwZzzbZG291LZIt38mufUo+Sblk9yIkQ+AEtBaFd4DAljGtQ+QcAXrOAh4ECHgoMotTqslSPiEe5D5wPMCt8vgSw5JmX/pcqKKrPNglD/tJKPAAZBEUmqhNdmTQW9UYV39ukRJr1QdhN0gNJPrDQmvN6rfMGRUNAdzItv//TBJnM6ymDm2jCoHFwZN6T8MdKaFCTPcHk65W6K3wn3+4G52R+P9REjH5sM8UgPUyFZzUqJt88inJmsLovQUbYMLVvbV+2My4IATNGOhQ5+Osn59cjkBK4mc4pQ5yOQuovkTrA3KPrrxO3TssJRKDR3k1lVMV8Jp/4TKVP3SM197jajUcJ8QYK2nIelrsTYMW+QsyDPXV4tXd28sywge0cLrA0ufuI0bgKPAdcq0A0A46o5aUHyrt7mvFgfqftaTbSp8ABIlET+HfdCyEz3GfkTdjNAaCTOyWg7Cb+7a8dMxAZSv21LC5p2oOrgMxgugHSxlJyEmqay+0wMMsdMeR6zGHVd7b
 3Po/RbXd
 44cPdvYD0IiBr8xacFyrn17Qk4xE7YA/ZghuVekSLoO9jiIlcY6ru7e+g0MsIdcp9Yi28o6FfnIiJOxMQfY1txfOhvcuwMONvaC0lqKwrGBlyPByF0+ESL1TBYsSydyg8ga09JFkRWSEC8fk0MbtNw3r1qt6peYfxPKNP+iAGvzliAHaByo04l5MCvDT1j3n378CbYtWZkkS6c5T3IWuoRzSoUJwrnyxJgsr+iuKO6zw3THnzf/NbsQln5Y0zL905wv1nkuplXMSIsIHIt/WbUfm+Rf8UJC7Sq4XlKAoEe5+Dc7JtOk0OvimWN+qpweOI7/VGHWMgPYgXGRNRmlGjzAswenP8TAriVph7b2IylftkSWIkCvUdzvAPPESnPT4dV4ImoFuwUBzH2J3akxYrEcMNwC9AZ4ZIGfPobMRysnIpRBTNHRf+z8LXoB7Pre6xHTBb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-07-26 09:55:21, Shakeel Butt wrote:
> On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> > On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > > 
> > > [...]
> > > 
> > > > > 
> > > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > > It just makes it lockless. Assumption that a dying task will do so
> > > > > quickly and with bounded resources has turned wrong on several
> > > > > occasions.
> > > > 
> > > > That's why I kept it as RFC :)
> > > > 
> > > > > 
> > > > > On the other hand I do undestand the contention issues and I can imagine
> > > > > that the existing solution doesn't really work well for huge thread
> > > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > > nothing really killable anymore because they are the oom victim...
> > > > > 
> > > > > Would it be just safer to bail out only for oom victim threads. This
> > > > > would narrow down potential runaways for oom victims which should be
> > > > > more limited than any killed/exiting task. It would also give the oom
> > > > > killer/reaper chance to work. WDYT?
> > > > 
> > > > I will give the following patch a try with the reproducer I have. I am still
> > > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > > yet. I will report back once I have some results. 
> > > > 
> > > 
> > > I have some results with the reproducer I (AI) wrote.
> > > 
> > > Setup: 20k threads, each with its robust_list head on its own page in a
> > > large anon region pushed into a zswap pool (writeback off, so it's
> > > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > > where the reaper was blocked and the memcg never fell below the limit.
> > > 
> > > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > > drain the 20k threads in a VM (hours on the host, where each invocation
> > > was a dump_header over netconsole). With the patch the dying tasks stop
> > > entering out_of_memory and the storm is gone.
> > > 
> > > With the following suggestion, the threads of dying tasks stop entering
> > > out_of_memory but the exit time doubled as each thread has to decompress the
> > > page from zswap.
> > > 
> > > 	if (tsk_is_oom_victim(current))
> > > 		goto force;
> > > 
> > > I also tested by replacing goto force with goto nomem and the exit time halved
> > > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > > through the reclaim loops.
> > > 
> > > Just for testing purpose I moved this check along with goto nomem just before
> > > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > > below 1 second. I think what we need is to detect early that the cgroup is
> > > unreclaimable and the threads of exiting/reaped process should just return with
> > > enomem.
> > 
> > Do you mean, something like this?
> > --- 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6dc4888a90f3..66f1eebf8c22 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  	if (!gfpflags_allow_blocking(gfp_mask))
> >  		goto nomem;
> >  
> > +	/*
> > +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> > +	 * help but it might fail on mmap_lock contention. If the victim is a
> > +	 * large thread group then all exiting threads might compete on oom_lock
> > +	 * just to learn that there is nothing really killable anymore. Bail
> > +	 * out early and fail the charge to expedite their exit. They are
> > +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> > +	 * further charges.
> > +	 */
> > +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))
> 
> I simply had tsk_is_oom_victim(current) check here. 

I was hoping for a more specific treatment. 

> I assume you want
> MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
> this additional mm_flags_test() as well?

Sorry I meant MMF_OOM_SKIP there.

-- 
Michal Hocko
SUSE Labs

