Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C680D172C3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1E76B0088; Sun,  1 Feb 2026 23:06:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480356B0089; Sun,  1 Feb 2026 23:06:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BD96B008C; Sun,  1 Feb 2026 23:06:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2440F6B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:06:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B93E8D51D1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:06:40 +0000 (UTC)
X-FDA: 84398180160.17.65C9F8F
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAC4F20009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:06:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="O/Kn3rTg";
	spf=pass (imf03.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770005198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NDqFnN3Ud68GoysowUDYBirFmO+BcmQLVFrXirUD0A=;
	b=mjS4bCifMwThRusEXRto59PodXcWfMlb3cRX1VD77AHVEylxxuCjhCx3rccf7jalOjcr1J
	2Yp7yA0Dr6tVddwxoGQWRn2vSFoQ/XK65yh87TLAIZSpJPqR6XcrlBbJ+HdY4/FsRqypYD
	fWUCAYSwzdl8xaaK2MqWXnQedrNfOJk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="O/Kn3rTg";
	spf=pass (imf03.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770005198; a=rsa-sha256;
	cv=none;
	b=tToh+TgwGlU1Btu41YnjRjiy1THAUs2EM8nru3J3U+NvH6sTbN5Xcuu6LaIO6ONCqPyENx
	aeTiHjgLeR60OD7xcQeti/2uY5CHkqmHWz5DeKJGtYiuQZxmUQrFwp2xEWS1HV7IjHxG7A
	7RQ1+5YJoUIr16sI8kiyn8AWAMJeHYs=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6505d3b84bcso5044456a12.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 20:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770005197; x=1770609997; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2NDqFnN3Ud68GoysowUDYBirFmO+BcmQLVFrXirUD0A=;
        b=O/Kn3rTgo3wj/ZFEqV7bJB7G0P1ukJC0611YzpltVbXCcj41nPHiQ0Ib0HOl+EQUYy
         n3IrSmCrPYg44riDe81usUd2Rhwyc3D1OoQqu/AYZK6BikQ0vLFIgRTX3m8apMz1wByV
         g222sSkz/3Ungnd16/nm3FClly00ZUHHcoelX+105O4eKrqHpDa2UogBr/VMK5GJVvVP
         W+25rAkPwdJ8T/oasRAirxgmstH78WTHEMxPdEttz09u/3rjroAhEGkVfVnCnMeJZio1
         bJYVEfkgRlO+NBMk6qY+MdecMwpKwxDND1UT2wevfXU8BRKicleslb8RZDpKXHXlrPX4
         mByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770005197; x=1770609997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NDqFnN3Ud68GoysowUDYBirFmO+BcmQLVFrXirUD0A=;
        b=QnGrHl9LIH+BZjQ6Wfg12Z6AxNGfFeZr4+CuuHDvWeRb7SMMfwIVnk11OjLmGPfdSs
         zvTrkb3dNAH0cOfmgWRR493d1RrQfbdBBybSFgVrhw2Q0EDRv9Gy/x+7I7HGggPeQuiS
         stSO9nfPYTgXFsgrh02WEASdKAECTgC77/trmPs+mSarYIet7G0wALo2d7nfsY2UMyYh
         y70JPaLpjk2ilq35cGc5vgi4OGG1yk8L1qQtjV48SgUMF5w1nHmA2b+4ldORljaq+wRu
         eg3PN88YUrDxLjnDRf75+r4H8V4fHJLCA2HnrM8TOwYHi0zFWu3uy2JEOh46AOtGEDbk
         FwlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJSh73E17IcA+m/F4q4AtTOaPBv3fEaGrlDuIwhHmPlJ8nWEegijIFyu9B429S7xHUpBwNksw8Qw==@kvack.org
X-Gm-Message-State: AOJu0Yz0Csc/QSbXgnIMxV4j3anTNSCnOqlmnysnbeGo3iAC+OYSyrnP
	Lx1kKyTGERhmuZG3jlTsjiBIF2aWLcDdwAjgEAzi7f0phY3cIvYOvbVRMNpirxaQ8Q==
X-Gm-Gg: AZuq6aKbYYdsfdLJRdW5ozWmlMoGHUFplCURpIunkfAabjRAzhrn1c8iGDeXBZH8+sL
	uNbFbQDLGpsDzZelYDg7Ol5HLwfV3QPHOqDXFQMeM/DXRVe9h81F7peB3FYcFFlpbt+y8O6fDSM
	eaBlA1QE6IPBcCHmyvX2QdbNxozufNpUoOSV3l51MK6nXxugIX6uySZbDGabmVvLnQCouMIDOAr
	4JkHUGcfSey6NvQDMlmu9fEgyODUrdcnHV32ABi/ni3Jo72/oDtisiaavZEd52gEZ8lDn4kWRwu
	0pHTw+ovhWk1jCLwDwJMzvAnaTvUyMFCp04kQJJPzHXcHk8wTlpK6x12e4xjnrqAuXlEjkJehpp
	Ipk7P0Xj+hTYS8Ox1tmrp6R2U027LJEgXGL1iFVsgs1zVWo6l2MMGJccIdTLVMN3PuAeJ8ce86E
	cBNuJD/hB5gSCxNrWPBoHYzUO7QIBIalw36w+4Wap+cPyPey1Mml1w351KqPhG6g==
X-Received: by 2002:a17:907:9814:b0:b87:1590:d528 with SMTP id a640c23a62f3a-b8dff7225cemr576539466b.40.1770005196652;
        Sun, 01 Feb 2026 20:06:36 -0800 (PST)
Received: from google.com (93.50.90.34.bc.googleusercontent.com. [34.90.50.93])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf184e5dsm822058166b.43.2026.02.01.20.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 20:06:35 -0800 (PST)
Date: Mon, 2 Feb 2026 04:06:32 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
Message-ID: <aYAiyKE-LWjQG3Se@google.com>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
 <aXiHok-3SKqLncCf@tiehlicka>
 <7ia4tsw6hi93.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia4tsw6hi93.fsf@castle.c.googlers.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 84uq34p76tit5ewayzg4fn5h8rukjsmc
X-Rspam-User: 
X-Rspamd-Queue-Id: BAC4F20009
X-HE-Tag: 1770005198-117235
X-HE-Meta: U2FsdGVkX19gJyI5XmRNci0L0oyOE/TOp66YLoFSopLBC5Bkf1bw9XHBtxbvprHDdfWSPDU9jIawNjtxvXWdvCBWwjDk6d84BUy7gf+891NQUfHqOT/KczuzpC0wOcvIzX1BSAhcbOkECQL83xoW9gF2uzsJG3ReYtsaElO3q7iyK1cBj/T/lxqtY9IbtuCWPp3QHWlW9tp6uNsnUw+RMYlmhI0OGRRi2UllPcLLN01nQmBsGwvwFQT6d+EbXmE+paenmxQKddACMTRJkMW26GnXHZINZbgMtyqyhML1r0GOIlREA89rlwKz02648ruQM1lctEAfv+jlHKkAYqCRLdkCmK+1xBOcTHp7s5Oux3w6r1TdXVW9ExGgIyb4YLwRd8vBl+nrn/Ga1rFBKl5yRr7X7pc9JLYq1SoKaOGDjC8E/wDX4qavIcAu52K5OA9DAlMNb/ZXBZj97Tj2fK8dsPugy7X6hR4tAxHSl/3FASnaZ8pPFygCiwdFx+/aquklWmcfnKr9yGDLj4cs9UIdZLzqPzk5Lb1fYfomfsiA6glzq7+Ju4k2Iq0TgxvCzam1QZE4v8eu3Jn6m7eFr9+drnmqwuauaz3rMg0Bmb2U7Uyd2NY0xjM9m1e1KysncI6zPXvtYsW0iuno5PwC3QJfKbyJB55Iy1r273PHcaxI+DkK9ouD2FIDtlJJVX8DIbzX8dKC1oNJcQj0rRExPxY0FyfKRZ2asSLcHVNAsjBu0up9aZv4ft9zi1Z4zpvS6Xm7ZZcJCDL9CCmQkSJOPWkW/vG/CN4YtgnKImpyfh4xlB/Z92aAxQtuCZ0VD8i6EUj8QPsmlNa0zq00QWiyxiZsniBMWL49TGgOvxkvPYcFfIZGwbohrIgOi7Uq2/keixFc5md/KX2597PxmojYEbxh7S3IsgP8TMSEkmIallsabS4xCZd1nW16ixBRbQgI5kcx/8AnQ0J4NtzdJ5ZIfRn
 mPSGFBqV
 mFkfsnoOWximw+xQKlNBN2JBOijRR7odm9NT4ylS1RMbqMeZf7afLRO2jNvRvjSjTs6iKHi+WR2mHzfoCMOhaV98R5ccAkMAUZKrgR9W/TeCm6+HwZQVCyaKr1GXTtH/yGRFPX/+2JKh8zHvgIFYU4mo8WMPZrU/sl1RvfIO9hnSxgMXRGJp44SGxfKqWPnFtViIdA5atO9lDJpCExoTcdaol4+NW8ZJwgmxWvEJQHkIGMQ5nwp1srIrRvOZO2Jwb/HNyMJjwFeEFFmxGkS+14IIGLhh/ZD6pkC8gysMsDbSknn8YUAe+4RPApEM2GrZH2pyg4Ity4TTQa5thjpJTsyNzoT5DvR4EUtJKeYW4ktC6NKhN8DU97xMgmjx2T6Wa5xA7zHZYW1Qbqo7DgAGJpWdmOldH3JQOlVLuy4LgHnOQewRBeHlQ2eXYkDPHF8bN3eWq3vgbODFf4MESHAD8WPRMwLIaVyYMS8RdoeZUhdve6WBQ60tDV07CDYEFkgP8dXKi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 09:12:56PM +0000, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
> >> Introduce a bpf struct ops for implementing custom OOM handling
> >> policies.
> >> 
> >> It's possible to load one bpf_oom_ops for the system and one
> >> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
> >> cgroup tree is traversed from the OOM'ing memcg up to the root and
> >> corresponding BPF OOM handlers are executed until some memory is
> >> freed. If no memory is freed, the kernel OOM killer is invoked.
> >> 
> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> which expected to return 1 if it was able to free some memory and 0
> >> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
> >> field of the oom_control structure, which is expected to be set by
> >> kfuncs suitable for releasing memory (which will be introduced later
> >> in the patch series). If both are set, OOM is considered handled,
> >> otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
> >> attached to the parent cgroup or the kernel OOM killer.
> >
> > I still find this dual reporting a bit confusing. I can see your
> > intention in having a pre-defined "releasers" of the memory to trust BPF
> > handlers more but they do have access to oc->bpf_memory_freed so they
> > can manipulate it. Therefore an additional level of protection is rather
> > weak.
> 
> No, they can't. They have only a read-only access.
> 
> > It is also not really clear to me how this works while there is OOM
> > victim on the way out. (i.e. tsk_is_oom_victim() -> abort case). This
> > will result in no killing therefore no bpf_memory_freed, right? Handler
> > itself should consider its work done. How exactly is this handled.
> 
> It's a good question, I see your point...
> Basically we want to give a handler an option to exit with "I promise,
> some memory will be freed soon" without doing anything destructive.
> But keeping it save at the same time.
> 
> I don't have a perfect answer out of my head, maybe some sort of a
> rate-limiter/counter might work? E.g. a handler can promise this N times
> before the kernel kicks in? Any ideas?
> 
> > Also is there any way to handle the oom by increasing the memcg limit?
> > I do not see a callback for that.
> 
> There is no kfunc yet, but it's a good idea (which we accidentally
> discussed few days ago). I'll implement it.

Yes, please, this is something that I had mentioned to you the other
day too. With this kind of BPF kfunc, we'll basically be able to
handle memcg scoped OOM events inline without necessarily being forced
to kill off anything.

