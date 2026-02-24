Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A94CF4BB6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB43C6B009B; Tue, 24 Feb 2026 13:03:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C086B009D; Tue, 24 Feb 2026 13:03:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9A06B009E; Tue, 24 Feb 2026 13:03:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7D8B6B009B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:03:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 669A41B628A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:03:39 +0000 (UTC)
X-FDA: 84480122958.09.09F3ED2
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3530B1C0008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:03:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HRXRteL2;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771956217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4oIsYGmK/xdzzCq4Y4y/7a2RiK61m8snUa5jjavVTo=;
	b=4bOVsZfD5rGUdzib9BFO2gbROA+AxZroV+HFDhgvO+ZtmrWSnWIeUtfFYWrSndqYUQbh6P
	g95PKpeMMrjaYFgJxbpfS2rmh7bndUpkeTgdhmKeZcQeAsrCt6H662g7Lg+TC07hdPCgiX
	2JQ3KtF5syLhDSZjs3n9KiG0PMS6Jbg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HRXRteL2;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771956217; a=rsa-sha256;
	cv=none;
	b=q1A0UL2zA7XHBYpHQQzxWMEUvzAZUjrGsDw8B5zbxY8iCCl4njixlW8Ew3c5zZEPKhoM6o
	pcybgzftD98s52FVR3GtfhP8tghXmX5/TuPYFtYUCEyj0C0Q337XhuZtNUMED0zyzo7DpC
	9FIjt2aPatNQtr0QFzMF1i82gfQirGc=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a0fc5e2c59so1027384e87.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771956215; x=1772561015; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O4oIsYGmK/xdzzCq4Y4y/7a2RiK61m8snUa5jjavVTo=;
        b=HRXRteL2Uu89yK6G9rzFI3P/j8EIqrjQBCtgvez4W+q+2OODEPzkbwcP88GGLB7g+h
         DucM6NT8LJDzDz1jltby+YeaPKkp2UyG23Cx/S7XAZjBtkUJH+sgM81rSoucQOezpsm2
         lY2nzatEfEFVPtQkOTe3LwlbbVnXETrFB3FuLiPT6/unY0U42hrFiO2lG1vyGfzQjL4C
         3UGilW95hJc56gT3HZg5z9+pdTGB8RzVyuLvhKkXtojs0Ny8CIJD/YriA/O3QmeYzlEO
         60FApI2fzp/vZ8p5ZsE9bHdL1qX7sU+4SKoBovDgDYAapkgEMet5bw38IUMAWr8qSSzL
         32Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771956215; x=1772561015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4oIsYGmK/xdzzCq4Y4y/7a2RiK61m8snUa5jjavVTo=;
        b=E1wtffXHDPLhxpCRldMyqopP+A23hqhAaQBGY3BJGkA07+6hjqQ0OSGi++IFHOOCRS
         w6+lgXH+okWH+2kfkd92nCZMN/fVPWbiplbGAjQFbV21FMTI4tr0BbT9wkqNdK2vamdO
         SnW0jhWlrtU17Nql54l2VZfWec94sbNJG1xp8b//v8U6ftMuQCW1IbUYK45grjKgcLwM
         FP20zTmOjE33Ht/22yYE5L+STx+cscgj0qEOQI4gueuolwBs9YbtgsQSykfK78MOcoAb
         rZDKxXI8hNuiXkIVzWiyR4nCYQuzcRIhZKq6eI+ERFT4LBvvYPJbcz6EIFvvFrpLSF9w
         vXVA==
X-Forwarded-Encrypted: i=1; AJvYcCXSTqDbH/EQtC1xHJ4vLAfYLZkutJMgfh5KezJWtoRYPoiygXVsXz2wP5kVCn/pNHY9LgNsyBMoCg==@kvack.org
X-Gm-Message-State: AOJu0YxMUNsU8HrSzg3Crw8U6Q+WEHYa/yEyuhmaH5hi0hisB9GXtfEW
	FQspgMGaDaOa7kawt1W9KAwCP3+xlZA4mS/loQuhYug4+ubIhVosDiS12ipH53Ir
X-Gm-Gg: ATEYQzxS0F30utieC51yT9AxdiVFyNoW592JjerkCOHThBxh1Yq1tRzTFvOWyDq8Ucz
	7uuCzz151PBJHLwKLUwH5hS729YtqJMOaye01nQpQgC/sz1Z0CCEmJAmxI0mZ6xwrDU1rLgtRE1
	YvOUmBJDXYyXxhXVRC7mTBklzD+Sxz3YUQJwR4Er2NHsyNEg5j0hIGwFUeXe3m8Fj94n7qRDECh
	uvX56e4RB8RLXjhTq0qU9eojSYrRiL2XCeNoVyP6cu8HIEFB2JgiApNENkmLdMSwW4R8xMgA3i/
	SZRhZ9GdsZXq7Gr+hcdUOBGc9K4HCNbm4omkYRw+LQvTC1ccRE6tZ+2D/MnDquYEeANQvyJGh7x
	G4wwmExvsXHcVOetvnC0JVsXvYs9qPI8hPoRsdP/xkbuNbyvR3U4/lW9mzepnGHU+3Uhb0UbPV7
	IOLNQZTFXCRSvj3dvDtnY8w+nk+wmVQzEGkjo87qkT65+zIZsga+EJ
X-Received: by 2002:a05:6512:4016:b0:59d:f71b:3608 with SMTP id 2adb3069b0e04-5a0ed99bdc8mr3767938e87.31.1771956215059;
        Tue, 24 Feb 2026 10:03:35 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb0b8b0sm2329602e87.15.2026.02.24.10.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 10:03:34 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 19:03:32 +0100
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZ3n9IL7P7jyxtLd@pc636>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <aZxymBwx67pMn1ZP@pc636>
 <aZy2SHbXi6qdGS0a@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZy2SHbXi6qdGS0a@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3530B1C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: aoy7j9fwy8iqrfjy9bfwniq4iqfeyowi
X-HE-Tag: 1771956216-959627
X-HE-Meta: U2FsdGVkX1+dPJWsLAhu75fSEtmsQeQM7hc6Oy7DPbzPcNRY/fFCcrL3R5Z/2sci5Aia8sgJJ8mqHgaopgh+IkLtm5AHybHXvRKAL/67O3NixxMQUQa6qJzQrv3OODYQeIfM7HIC6aH/nGO9No4eGtCsl1mkyvrPIPao+eTe3/WfeREUNUGnAmLAjovEO0iZuitIsp78EQDgjMiS7EF52b07RaX3ohoPnTG800gmOmfhWS/KTAvLU3b95bgeo3wqLIzpBaCd/glhvUDrx1hd5/B3buvh5yMH975tEPGGLHsY9SHw8apFsHU+GyVpHJcrziI7on9XCqodi5KlPOY40ZHWWxcNMj+AOTXwMn5Qw90KENbWrgaXi9KzQ172LLuW8gAxLXxtkEEpRBWBTZ9qDCgA9ujeAxkkPDcVgH8Nrkc5wqxSjM+k1DDbLN6kqwWO3Ns7qtzr5btuvNx/Ra0FyuR++LZ6pzPskSd/DGl8ujyc/XZJsLLXMHar3E5GQPwo9eDsfWmme6t+D08LaqKcQwjwAePSyh6AY2Kt4yDPi+qetrW4LTA9M1YEs9my1u9dxEKkFj1twylahV1JgrQhZTkgRtd50XtJtkg6a/zsBkeClgY0SxQ80Nn0RTO4AfRj2PHm8rfInrj9jr1UxlRuXEp7yMj7zclWVaLq4ffEPV/PGB4uTiZcKLYjIIu+JyPVsEZj2jeU3xNl8bYps3Qbjpq8dLxYFfyoUUkUY4DEDGlgyAoHAa2Xn0a8YBU2iikxN6Nr1LovtkaTELeHow7kjD7t4D7aFun2Co/eVuJussPDbobi46CjV5iCgqKyuOvFBC3fFBmUM9+rwlWk08XrlIKUyvYIVAC40VMEndzfby7x9VZZCtSMkoF4E+odlQXXk6R/kVOyfJmfHnQGZ1giFSikdGo745y6XbEX9d4BVT+wIxFx3PGedgoU11hyCP6M3bL71YvrHRrDBB5nwEV
 2HocAKmB
 jonBK4LCIVScFm2B0wXyRQKFjVICCaq9EwTn8Sf936LEu3On4LC7zXem8Bz3V1FoT7J2dx8MdQYUPmT9sCv3Y2v+Eqol1fwAWELRiA2lI+bK7h4QxY0U9nDqR5sEAUXCEL42JVvgu6dbcM5a1dVQcCRoBMLsvUhxoYprMF+an6uzMkhWgLEsKahj73jtk2mcoOtXVzVYjYgEVlMSnRIsdZTItr0MCOQRdBLu8i95WmkGE3cf6gst1ShiKqxtWgxo5wRmUKLI+l0IJsNhD3KbCuAWhwR52eDhwCoWTy+JQYflY+Ip9R/HHE/VQ+M3eo2Z7YR41uv4lsJKIQsq9GEM/jNWXKoucGc4z7jdIO8hYkPIYuzzMXp+z45c8vFNXK15W+INL0gjA5eP4fImvhVQ3RhwZunycjetskGyYZCvNDl3sSnref3xlDT19tn4J0JK3KbgtIrLpUUifnRMnzeI3aSG0lb+cigDoiIbQpj5IkHct4M0gXo2k8I7Sv4v8mXorwMePVHMVDrBKV00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 03:19:20PM -0500, Johannes Weiner wrote:
> On Mon, Feb 23, 2026 at 04:30:32PM +0100, Uladzislau Rezki wrote:
> > On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
> > > @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  			continue;
> > >  		}
> > >  
> > > +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
> > > +
> > >  		split_page(page, large_order);
> > >  		for (i = 0; i < (1U << large_order); i++)
> > >  			pages[nr_allocated + i] = page + i;
> > > @@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  	if (!order) {
> > >  		while (nr_allocated < nr_pages) {
> > >  			unsigned int nr, nr_pages_request;
> > > +			int i;
> > >  
> > >  			/*
> > >  			 * A maximum allowed request is hard-coded and is 100
> > > @@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  							nr_pages_request,
> > >  							pages + nr_allocated);
> > >  
> > > +			for (i = nr_allocated; i < nr_allocated + nr; i++)
> > > +				inc_node_page_state(pages[i], NR_VMALLOC);
> > > +
> > >  			nr_allocated += nr;
> > >  
> > >  			/*
> > > @@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  		if (unlikely(!page))
> > >  			break;
> > >  
> > > +		mod_node_page_state(page, NR_VMALLOC, 1 << order);
> > > +
> > >  		/*
> > Can we move *_node_page_stat() to the end of the vm_area_alloc_pages()?
> > 
> > Or mod_node_page_state in first place should be invoked on high-order
> > page before split(to avoid of looping over small pages afterword)?
> > 
> > I mean it would be good to place to the one solid place. If it is possible
> > of course.
> 
> Note that the top one in the fast path IS called before the
> split. We're accounting in the same step size as the page allocator
> can give us.
> 
> In the fallback paths (bulk allocator, and one-by-one loop), the issue
> is that the individual pages could be coming from different nodes, so
> they need to bump different counters. One possible solution would be
> to remember the last node and accumulate until it differs, then flush:
> 
> fallback_loop() {
> 	page = alloc_pages();
> 	nid = page_to_nid(page);
> 	if (nid != last_nid) {
> 		if (node_count) {
> 			mod_node_page_state(...);
> 			node_count = 0;
> 		}
> 		last_nid = nid;
> 	}
> }
> 
> if (node_count)
> 	mod_node_page_state(...);
> 
> But it IS the slow path, and these are fairly cheap per-cpu
> counters. Especially compared to the cost of calling into the
> allocator. So I'm not sure it's worth it... What do you think?
>
I see. I agree it is easier to keep original solution. I see that
Andrew took it, but just in case:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

