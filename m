Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E0F606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NfgfYDfC
Received: by kanga.kvack.org (Postfix)
	id F03CD6B05B2; Mon, 23 Nov 2026 06:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB7E6B05B3; Mon, 23 Nov 2026 06:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18D96B05C2; Mon, 23 Nov 2026 06:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5C416B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:49:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BDA7C088D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:28 +0000 (UTC)
X-FDA: 85466213616.22.DAC10FC
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5AAEA160005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NfgfYDfC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434566;
	b=Nkc1GBHGlqQW7gNErkPhl6Vrb/BAEqodpduSa0zJle5m3jAoglFhzPfy+QDeYT1IymlAC/
	d9n6v/mPTeQ6hBwqpTvpGrRLDCHeOAxJk21I0XX5nDFY7dG6T1Oac0VybocWcUIcRBjG8r
	Ju3exlFGqxVphaVuA6ypEueairWYzl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
	b=EPSbE5DQu7ALH1NCGAMNdrJYKOoJXbc39f55o+Ve2zZFoNWXLIBT+/0qlaG4SyL8cBUWEe
	ci7aQZ6m0sT/FcZTcnB2g2KTEoF7kxmtrSAqntiabWM2wm9UrDA0iFHQRC8z6IiogL+MhB
	4Q5mhfRd0fULpKr9ER8f5ym+N+DO2rU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NfgfYDfC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb6057b333so13340995e9.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795434565; x=1796039365; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
        b=NfgfYDfCsVYL8tUmzmTSKTSNkM3CNHpoqvqYpazuh71iv17IdmmtzDJL5NSmwkq2b6
         r3kQ46v2BrHJ4gX/A/kxlC6+Dg0O6YCT4b1MAiCzN8TVjfAm3P2H8L8WSfV2P6YKj92U
         MV5+jUxf0IyIXNn60MhfaZnZ2ghqXniTRwITAjfsqwSknj++k2+Pk4EQ0w5xW/+zS8UF
         U+1JUkT2pvkW1XE46RXZkpz4BFIcsfxLVmpYUuo2JiviePlVjMbkHt+rSBHLpR28expy
         fCkFGgcoKaOW6VLdMOJRP1worPRQHkNEO215fi1b52DGKYJ4XKutz/gGiqcAL9zfEkxz
         67sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434565; x=1796039365;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DLWiLwlOa1M+CGXscE3EqyDLFhF6yXj7XzInNLOita0=;
        b=sMkxHdcMn3I1fTtdDp/uTXMdA2oy2uO0+CKDiNeGvYRss10IWuUU24g0IskcUxTvDN
         KgSpVbG5zboqrN6VqH3TYcOYlkP6aEfUG9r/w/yawxftyBY87C48R75v65yZ9IEouM+k
         MeexhkTO7qKKxahsOfmXpls93KzZeBWV5X/6fUX6n96N+4IHfT4LSMbrYWhIRNhUrPDV
         HDpzUKWhiLu9yrji6wFSZSoj8ABR9wDtcW3uQYXOIWwDsjjUpAA6cyVZ+lA7tfKsHR80
         UebZSxqQxnNucpoIaowgnzx/O2oaFOyGrCMY/LkIyzDomvenUiFaaO0qQxKZnyd05Ikk
         WtqA==
X-Forwarded-Encrypted: i=1; AL+hErG+lopNShcijuJV/P7y7m8QVOtE6STaXt/AUtZLuTmPkc8eEM/BHBOVIQk2ohNMhA8EEDKSzFGm/Q==@kvack.org
X-Gm-Message-State: APuU4Z/llTckfjaf4qLPYpCezdtPBZ6C5jd2zHFu9dGnSvtv4L/giL3u
	rq13kO+cK/PT7JStqUZdNcLApkQjN5b9PwMDWN7wqWcqXo4qi9L8wbEXiU1tuSeQNIg=
X-Gm-Gg: AZFdTZdhojpMe+fzfC9mHgTufJBEwdXJo0tjmmR5DPDDkJbKCdJSnqKXMB0yNRePOYL
	EPXffqrvwOLIjrW8X0rmgSNEud2SHnU0/0nJ2CawgPA7HMyoOfB4DA8zWahBrMUkKFCHOCUfCer
	oyjwsS5+dIqi0vaJGx2J8UrxDQ1ZeYG9+He49MxFQGq6QA5kmAELpD2rSs4sHKt649co3StKD3n
	B7Gan9QFcV6bxWW2eYlwY5JhCJMElDjrFytaZ3bcqPT56RwStMJAjI2tj2ipR6XTEG74bVBRXv8
	su3MjNTNegzpVagQfM6ABCY0aZwKaca6KwHKq3KHaoTApyfW3BqdfUQ17WGm94sAKf5CKjK6FCp
	Qp9pxoiHkI4Pvj3mzFYf5gE2EIuXNi+GZsrm60ULYctvno4cXojtaWBV2hiKKA9LiCduKamtJEf
	N+kHYIXftG4ABLTA4+F1dP10Ph0RD+eip6FkOCKpife/NWh1xExidq3FNtEYERXqgppuI/k1bay
	a7GWMAS0xeEYquoFzFnl4oVceXmM1TZqLV2Gac/bfqXruUytWB2L/YVXynFoDHjaxTWld+orzc0
	nk23zigDg0B1NHTk+BgFEcmwjfZ3ehWweY14UQiRiEo=
X-Received: by 2002:a05:600c:1911:b0:4ba:38a9:85e3 with SMTP id 5b1f17b1804b1-4bb8880eecbmr256789465e9.12.1795434564856;
        Mon, 23 Nov 2026 03:49:24 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865b1sm337727695e9.5.2026.11.23.03.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:49:24 -0800 (PST)
Date: Mon, 23 Nov 2026 12:49:23 +0100
From: Michal Hocko <mhocko@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, akpm@linux-foundation.org,
	hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, mkoutny@suse.com,
	chris@chrisdown.name, cui.tao@linux.dev, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQoQ4Ib9nCcK9Z8@tiehlicka>
References: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
 <awQRT7InNqEF-K8-@tiehlicka>
 <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5AAEA160005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: b8cgqmx3oxaxy7qf9icrpuqbnggu4ktj
X-HE-Tag: 1795434566-345710
X-HE-Meta: U2FsdGVkX1/jRJYBlJ+D5ylWe7H0U/3AQ12hGzGj/Qu9MfRoI+RpKljEqvjnvYdSuR6Ugs5e/7ArnIk/TiTlXsYrQTKyhfMZaqZI+JvqS9DMUI3mqsWeRB86NmYeJLRJ3TBaSyy6/jVx22/1vCOJ+iGVjUq5EKOt5Wyv44pf03Wom9j7bWpxKv0HxcVYqULEtsIeQ4n6mvgR6Bti5pwUO3JWgbsZ92y+7MqyBrxgV8fML2TjwAl927/d0cKVZTlghENgN3goH70yG2edyZvb2AJE/7ZsL10ZKIA0W7cQTGoDqI0czOfPZhte1gV/ghmZZVQh1Ovi7mP9uutOP+ZtA00yZCCIby4cJvUOtdut5TT4vg2Y01gVXubaoXuEPD88H9pV2h1MfRLyX55Gjqrr7CY3uiepqUbPYbjjXn44YH8ZBd4D2tFy/krZDxkDyDMxk5hdMtFJSomz0U1Wzgc5YhPYhRkxAY7jvP+oFINJeHUWCkAZev3mxNOQekTLBEEMLO3yiL/mTxWxo+Yso1UFPL+01tSBsmoQG8249ZyQdNRAyjoAVDdjHO0A79gbeQL64egUHxNGwNuFIpFZkCcwy4upyWPWyCjJ1XIM9U6MssnJV6OK8gQOqO+gwIdGF93d+HFFWbdSs/RoUmEAhw1V30hlv5LJPSBZcle/ZIc4rPLsFORu5RquP60Hgrf29zBD8WScCnPAyq6hA0yvzffdMOLzo0R7p2vYC4ywktYvpTS5yKA0E+N0W1qv9hhplo9X55m/707w+/VusR1q2oY61C73/CqqlqP/OLxxwh5LYEJvBBWSqyJyaoB0I0rV8LN+5hhvX1FE+TVS9BuZqj7iFkYX6PNl7GSPa0n8QMP42GtAWKTAnAF2Gpy0CDs2eHAk3QONEKEiRwJbY6n+Er9I4G2fpo5UCS0HnWVQYiztH6aL3QuH2oY6YdHgY3eHdoH+604PuI0ePARzZRDWNph
 TQu8dYow
 D6w0C9cUg0mIZ+MgMSTiGdBmTmIx9ENzi2/Bx+4d/5QaVcdROHp6rTyzf3Lbabq0+h2/QxYUIS5eCqLbqJUPncgL/Vv1f/MxUEUwZs8aJFWvNBQhsFIdpjYzDTjQpbfqDZ8mPMJVuN8YeAqKBtNHaQNwzsaQ3Bcp72Y01Qt+l5XGA0crGHteSypgS2dmljlgsHr7u5J+uzG8BeLNcAzGQZna+Cz7AJ68AczzBWdpa89ZBR+BljRu1J/X8AkSi4lxZc9E76hLBoKLm6XQtgEplOjx1aeIZcszlaEoHe9GIUQDPtA9KylSJIqtC6/ptWTq2Ejsr6j/wj+9azol50g7ZeDmtQ2ZOxoPjUwixrbAqFq8IJxaYXvuLDALlKARZ0hHYqtbhCnhIe99oZeHKDSCEAy3ZqIWNU4xdiNnjqrmgyby4OSO77uPJHMLL8R22O7OzhGE8M8fwSRbhvvBRxQ5a3AansOrjin7P95OPCeeycffzFVfAnBY9ALeRCpaHhaiR+AwLQxgifxSBc1nRSOrqWaoehQO4Lat+R4yV4chQDg9J53ioyPVrI84dvgLS8vr0INXExmf3f2V4y1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 23-11-26 01:13:25, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Nov 23, 2026 at 11:11:27AM +0100, Michal Hocko wrote:
> > Tejun, is there any strong reason to keep the exiting thread group
> > leader in the original cgroup? This makes CSS_TASK_ITER_PROCS iteration
> > really tricky and error prone as above examples show.
> 
> No, and I agree that the leader should follow the rest of the process on
> cgroup.procs migrations. It's this way because controllers primarily care
> about resources and exiting and zombie tasks don't matter much in that
> regard, so migration skips them and controllers don't have to deal with
> them. I don't want to change that. It doesn't make much sense to teach
> all controllers about them.

Agreed!

> That rules out the full migration path for the leader, and moving it
> without one looks fragile. If cgroup core switches its css_set without
> involving the controllers, ->release() sees a different css from the one
> the task exited in, which breaks e.g. pids uncharging, and that still
> doesn't work for a leader which is exiting but not dead yet as it's still
> running.

I see

> Maybe the leader can pretend to be in the new cgroup instead. On
> cgroup.procs migrations, record the destination css_set in an exiting or
> dead leader without touching the css_set it's actually on. When a
> CSS_TASK_ITER_PROCS iteration finds the first live thread of a process
> whose leader is exiting or dead, it looks at the leader and visits it
> there if the recorded css_set agrees.
> 
> That leaves the leader's actual css_set and everything that the
> controllers see as they are now. Only the iteration changes, and exiting
> and dead leaders are handled the same way.

Makes sense. Thanks a lot Tejun! This would allow to use
CSS_TASK_ITER_PROCS for the oom path.

Thanks!

-- 
Michal Hocko
SUSE Labs

