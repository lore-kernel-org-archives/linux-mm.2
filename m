Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EAFC2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 07:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87F86B00E3; Mon,  5 Jan 2026 02:49:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65E66B00E8; Mon,  5 Jan 2026 02:49:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94F16B00E9; Mon,  5 Jan 2026 02:49:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A88566B00E3
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:49:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7230B1AD49D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:49:19 +0000 (UTC)
X-FDA: 84297134838.08.F52AC8C
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 422D614000E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:49:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zF8iXAC2;
	spf=pass (imf09.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767599357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwnJzjvPN5VkHF+hXu2VjijyXAYnkVzRVRjTTEfl1AU=;
	b=TX27Ir1gszJ+UjN/FYS9A4YJqS+nB5tEw2DOVOLN3gvquBFEFKLBIanTXuWvTVZYnK+FvP
	yuStSYhpAiVE9FggHplc/Xo9d76OVtoVRjC95n1jUDLxac/9oSS8YvivJod4IYSolzzyN+
	S+7Zbl2dCVLwKOQkGZ2JaBHASCcQ0ro=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zF8iXAC2;
	spf=pass (imf09.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767599357; a=rsa-sha256;
	cv=none;
	b=brkw7n6d7TyAjh+Q/ptfKK0A0kHS+WHBbyH/PVPTqFMjAH77oQYEBa5w98q1Sum4nffv2p
	uR04sEZc/SGrqU0YU6rEkCo4AqtgZkduYfvMyjezRPVsA65orScyFGMFG4PCbQg5zgAGqD
	lg/MyzNADmdBxTGqrOJ1ZiHgK5LG+eQ=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b73161849e1so2647292866b.2
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 23:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767599355; x=1768204155; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xwnJzjvPN5VkHF+hXu2VjijyXAYnkVzRVRjTTEfl1AU=;
        b=zF8iXAC2o4TptRnjNUFToeeCKAvsCk1ylOfD/+IT+W/DJjhL+zImPSkbObqGqaNZ36
         wVYMRJrYEn0U37+ULi/mOQNgZTIxKboayUeArd9ZFzMtOzY/bUk255i3WWuGBBi+fW1i
         7WdSfiJxT7u4UkUBfliUeFX1jxL7I2AIeLuJJz7TfcsVwBv7jOK0zLgOmKI6ICraU8op
         KL8YbU/FbWX0mOJOzN6jxE4BtMzikDtqmbJ1UKLMKzGCRQFdeit/oHzHnzxnNpo74NuM
         LHzpuFNvH24FoOdHWXR7kVCFS8g25Cmz1cO6x9LcEUPpx1KbkdJRJ+z59TqlchlEJn9K
         2hlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767599355; x=1768204155;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xwnJzjvPN5VkHF+hXu2VjijyXAYnkVzRVRjTTEfl1AU=;
        b=eGhLericJmzm9IyZjO+k2syOWrAGh8FgtMyhUYPNuNXy3v0YZW1jFlh4iqVYXKrf4J
         p0l0n7HzIEqICTtJ1YK2Angtl23gH/5ajxLMuKDNzJz1sVxKnySyFg9Z+7bb2Gl38aXi
         XaX9RVcTSjY7mgdHvPhcea+cv+R7I/T0eeUf5BtBZp7doUwbwuVv9BQGPnKqe43KtFQB
         ri4QUllpMRiWc9VKbtHnVxtFTz4dSpzv9tqcxchggpawPAnI0uCNgfrO/VZLJEqWiE+W
         7+xt0Lw2lYNt5O2RvaeueP+SoH1CRB3+UPB3IGRsiuT/G7vVzsJ8fcp+b2Ph6EssWW3z
         q/Tg==
X-Forwarded-Encrypted: i=1; AJvYcCWBsI2dhLQbae9GmBQG3ZUuaEA6ceAjMz4f4/BsRrz8la5qKQFKcfsQz25zsMkHKCeI1W08yd9zTQ==@kvack.org
X-Gm-Message-State: AOJu0YyMkvQdwuqCqehHb79EDjLr/TzMbc91pZSmTjaDE7UKMxSjvO9m
	hfgcxZL80BaUju1p+WY/fUoHjZpdaKHnbIH6feHXD4B1m6KowpLQx+s7eYajSM5c9Q==
X-Gm-Gg: AY/fxX73FYoNbv0oZ20Bj80zsu+KdcGK6SQeiLnGrx8vHRL3Xc2BGfoboZQGASFCa6Y
	j0XC38bOjV8r9I2LmniLIiDH+aVHlrvVjLokrd32SVjnAmpYqvPEFDRgtssXoyWy8biTPPDKSX2
	lzgSBMS3kVHoGO5rCLiGPf82ATMaD8CAm0XJdQpBatPuCOUWD/CnoTF8VM1eVO1qZpXrz+Ou7uL
	En6pHj3fWwgqUwCqwAC1FHphVjeEGm5ry1+y0X4qCy8lsCeI2rI4xWPpEZgQouAD66axdKPSSLl
	ZZ2gmvHcU4YTfWoAEFTK0aQXCQNazpMfd7aME0pohzMXEyq19saFGiG+LPUO0mnF/mC0JbtbVMq
	8rxpUNw5sxsfTezlG6d9FLaVoSYS17j7Yw0WyWoTmaWdPSUuc2au6umoGK+BwInp5wpdYJeicf4
	OtS/O4vOvODi6SgLZ71hbAjT9xdSQCY2WnRr/h0acyw6S4AG8g6dRwJg==
X-Google-Smtp-Source: AGHT+IG+sJtiRMznvJK7eAF3BfvksDE0W80LZT+rNRqafVCu95AAKjpXen+wQ/4SfBB9Uo3ubbufhQ==
X-Received: by 2002:a17:906:9f92:b0:b2b:3481:93c8 with SMTP id a640c23a62f3a-b8036f1d812mr4908758366b.19.1767599355292;
        Sun, 04 Jan 2026 23:49:15 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8350268f86sm3163336166b.16.2026.01.04.23.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 23:49:14 -0800 (PST)
Date: Mon, 5 Jan 2026 07:49:10 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, bpf <bpf@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <aVts9hQyy-yAjlIK@google.com>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev>
 <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
 <aVTTxjwgNgWMF-9Q@google.com>
 <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 422D614000E
X-Stat-Signature: khzf1fzy9bk4oirgms56knqheh45dsis
X-Rspam-User: 
X-HE-Tag: 1767599357-94804
X-HE-Meta: U2FsdGVkX19jREkBmPf54t5nCqVnJBOg7L72rEjRjkZBfOr3NhqFkgAFh6ieYy42+8+5lmIszMqQaURBveaDdygbtzozmFjffCPfuO2sMyEVd+5D0cJ4IFKuze5IuHL6kZ9milnr45l7OOYyndx5r3WCynlw/yA6RYrp2EPbBt0+InwbhEynncJaxhGrVDmMZDa4aXKWPugtLRoLxho2w39u6HTAn61dP1jjD0nDI/XVzYirLp7QzkVjksu922IwzjQopAz1GkpPsPEckjfki8YYS+MLersdumFQYNH/YhVmhhOPOEKPHzUE7AlQGdO3G5HgZRn8zAnkp7QCgyo11Vzw9+Xb0EW6z3g9vZmKIViDhnz0wuUQcGCvjVhZLilQAX9DMN/yqWhFyvukSCMNJsplX6YFGcltSEQRRt+K32OTuaPuu7YDz5ZzrPwrXnu14BssNYyv6dIQN6pRiyMI7HegOHyk+i/3xdsFC7/nav4ar6p2C8DpnTAlG+JAsLLYrTUdMrKy34poKEMoegP94WBzmcb+OLrvmSY6ydP+ZriLRTA7Yx7YEwrE7lDXZANe/Qr+HEUAHa8Aa1zPH+rFfe+7qMbaTQKgodxm1hXL5fsu56bPI+HQbK5n+kSXUh6pTG+ulRVFm0e1m3xY7ZIc1RQ2R88iMZP43HTQwDHylRJ0DW2taTSzB1a8wh+iF7YYpbnVbNOeTZeeS9vtu0N+Gt/wXd4xq7WbqGBe8yOpH3W90Apt3fe5dMTHK/v+QP44RKebC2g2sOVGcVJVjXfgPfR+e1NtwjznOlS7d/KDe0+LUszyRJElSuQ91dV/4N+2xdxWyOf0YyjgaN88zLeR5foa/Wj5PZUP8RIuLo48FKizZ75AJEIoWzPHZNDZB4ScRKviyahGuKYoPJ5EBg9GgH0+Bd1l9Fccg2h56mt4poOEtN0kxxBgYCE/ptnVZudxpiIuc/sNKmfa55G6LIU
 viiybWRT
 Gz+ODrX0oIq7zoznK9CkJC4ndxVEYwh63HhOjxVMVykFHvRtknSGXH7Ka8w0n5UdqbBcvmEmB8E4UQeyjPDiUvIs7FrbAUHKdsnyNSACJyW/trtqE4C2Db02Npu7RkZwn7zcoLeC9N9eSXIzkSyXhFLuSfPyQjDnT+Pyk/AI4p9AuHV9DrTeotaq6PVbFQH3iCl59sjdWh5Wl+KYz4DrlvNZh/AS/35pyEXbaAxY4t3hjv0YOQWugtTSQoY88DSZbVXYL9amziqin9KFSChkYiTJUfwftxUig/c/US6+vTeVgXJ4x74zJkm5riKOmssAjEL0BBudhH/ic6fu5de/clsqzmxqTjmgO45jBSZG6sZWFipi5FocFKxKpy1yt9wz5jOXGBLfCXLhi8+sHOW5n0lz6SSw0v5393tIjBAl6DjnvJ8ROeIPdbc3YN3Sz/epcYfLGakmC4EkRkxjNCWNDk7nQ8Vb+B6smZ1u7SKnUOiXIm6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 09:32:17AM -0800, Alexei Starovoitov wrote:
> On Tue, Dec 30, 2025 at 11:42 PM Matt Bobrowski
> <mattbobrowski@google.com> wrote:
> >
> > On Tue, Dec 30, 2025 at 09:00:28PM +0000, Roman Gushchin wrote:
> > > Matt Bobrowski <mattbobrowski@google.com> writes:
> > >
> > > > On Mon, Dec 22, 2025 at 08:41:53PM -0800, Roman Gushchin wrote:
> > > >> Introduce a BPF kfunc to get a trusted pointer to the root memory
> > > >> cgroup. It's very handy to traverse the full memcg tree, e.g.
> > > >> for handling a system-wide OOM.
> > > >>
> > > >> It's possible to obtain this pointer by traversing the memcg tree
> > > >> up from any known memcg, but it's sub-optimal and makes BPF programs
> > > >> more complex and less efficient.
> > > >>
> > > >> bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
> > > >> however in reality it's not necessary to bump the corresponding
> > > >> reference counter - root memory cgroup is immortal, reference counting
> > > >> is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
> > > >> memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
> > > >> obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.
> > > >>
> > > >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > > >> ---
> > > >>  mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
> > > >>  1 file changed, 20 insertions(+)
> > > >>
> > > >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > > >> index 82eb95de77b7..187919eb2fe2 100644
> > > >> --- a/mm/bpf_memcontrol.c
> > > >> +++ b/mm/bpf_memcontrol.c
> > > >> @@ -10,6 +10,25 @@
> > > >>
> > > >>  __bpf_kfunc_start_defs();
> > > >>
> > > >> +/**
> > > >> + * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
> > > >> + *
> > > >> + * The function has KF_ACQUIRE semantics, even though the root memory
> > > >> + * cgroup is never destroyed after being created and doesn't require
> > > >> + * reference counting. And it's perfectly safe to pass it to
> > > >> + * bpf_put_mem_cgroup()
> > > >> + *
> > > >> + * Return: A pointer to the root memory cgroup.
> > > >> + */
> > > >> +__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> > > >> +{
> > > >> +  if (mem_cgroup_disabled())
> > > >> +          return NULL;
> > > >> +
> > > >> +  /* css_get() is not needed */
> > > >> +  return root_mem_cgroup;
> > > >> +}
> > > >> +
> > > >>  /**
> > > >>   * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> > > >>   * @css: pointer to the css structure
> > > >> @@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> > > >>  __bpf_kfunc_end_defs();
> > > >>
> > > >>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> > > >> +BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
> > > >
> > > > I feel as though relying on KF_ACQUIRE semantics here is somewhat
> > > > odd. Users of this BPF kfunc will now be forced to call
> > > > bpf_put_mem_cgroup() on the returned root_mem_cgroup, despite it being
> > > > completely unnecessary.
> > >
> > > A agree that it's annoying, but I doubt this extra call makes any
> > > difference in the real world.
> >
> > Sure, that certainly holds true.
> >
> > > Also, the corresponding kernel code designed to hide the special
> > > handling of the root cgroup. css_get()/css_put() are simple no-ops for
> > > the root cgroup, but are totally valid.
> >
> > Yes, I do see that.
> >
> > > So in most places the root cgroup is handled as any other, which
> > > simplifies the code. I guess the same will be true for many bpf
> > > programs.
> >
> > I see, however the same might not necessarily hold for all other
> > global pointers which end up being handed out by a BPF kfunc (not
> > necessarily bpf_get_root_mem_cgroup()). This is why I was wondering
> > whether there's some sense to introducing another KF flag (or
> > something similar) which allows returned values from BPF kfuncs to be
> > implicitly treated as trusted.
> 
> No need for a new KF flag. Any struct returned by kfunc should be
> trusted or trusted_or_null if KF_RET_NULL was specified.
> I don't remember off the top of my head, but this behavior
> is already implemented or we discussed making it this way.

Hm, I do not see any evidence of this kind of semantic currently
implemented, so perhaps it was only discussed at some point. Would you
like me to put forward a patch that introduces this kind of implicit
trust semantic for BPF kfuncs returning pointer to struct types?

