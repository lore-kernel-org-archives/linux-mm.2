Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839F4CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24FE9000DF; Wed, 13 Aug 2025 18:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFCA6900088; Wed, 13 Aug 2025 18:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39979000DF; Wed, 13 Aug 2025 18:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C26E1900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:40:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C5071DD678
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:40:42 +0000 (UTC)
X-FDA: 83773205124.17.B4AAED4
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id 894D280004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:40:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aNSs16S/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755124840; a=rsa-sha256;
	cv=none;
	b=OfPRCYu1mXCeeYZ6KpyqhKI+ScfAIqXyf3fKBFxICUT1QiQOuK2ZSQ+3VIoFn/jd8KmEQE
	KIJDSfLstfWf1hWbIOABf1ixbWKUTqhnnkyyHQzP0L/y2LLQS8GYAHOKLrW2n1UTb79ocZ
	s734Fm/QycgjacJ+23bivUj2LgQtT4g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aNSs16S/";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755124840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fKriiSQBfGyXODY51tO3BnmQCNOEIjvbaBUfVg4f+Xk=;
	b=Kjzl47B/tx5ZIiQT2+ghE87yOTcNOlG5bTfudEGemBMegY8IfvlQo+yR5bffWwLpQcQ31t
	qhmCYzjAXwu4j+IFdX2essa1Q3Cm7rxf/B4DkKaWphZ1zkmsJARIiD/LqZhvR5Fu2P1Xm3
	0utV+VdGkTHZV7dUPwJK9ctWqOUaatk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 6438F5C59EA;
	Wed, 13 Aug 2025 22:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF7C4CEEB;
	Wed, 13 Aug 2025 22:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755124839;
	bh=x+6Vi/XRLXHhmtIpq36fM3fBUFAdRIirEj2tBLR6nGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aNSs16S/O+GCzgCR/lVHsGqvnwDXgr7mkEgWPZzafz9LroGq4Ybv5WtgZnEnPvvAN
	 dxhZAZ4I55h/Ib8/IK/qHWr6vJL4iOCi2MD95zT5CvXkJkE+SNvYVqarZz5AsGSFzv
	 6ueF83Kdm+VdpP+y1r0Mxid/L/h+/69IbhaaXgWc=
Date: Wed, 13 Aug 2025 15:40:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org, LKML
 <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, cgroups@vger.kernel.org
Subject: Re: [PATCH] memcg: Optimize exit to user space
Message-Id: <20250813154038.dee67ecd858b7223d6b5cc6c@linux-foundation.org>
In-Reply-To: <hzvjjgzf4cdvj56zeysosb7otkvplbbozzcpij2yeka4a4kakl@4l26obz3karf>
References: <87tt2b6zgs.ffs@tglx>
	<hzvjjgzf4cdvj56zeysosb7otkvplbbozzcpij2yeka4a4kakl@4l26obz3karf>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 894D280004
X-Stat-Signature: cg3hbsfnxuyo7y5jrgp7wjaqmsyn5pe8
X-Rspam-User: 
X-HE-Tag: 1755124840-966112
X-HE-Meta: U2FsdGVkX1/WX0e5n9MxTUMLaYYjWghx1Pg5lQuGBpDn+91QkZncLMA2jo2eT+SoZO/6ON24sqDzbQVSx00TDeaqbhKw0vIrpxWxjYY1Aj28K3M/lQ+h1tXAtOERG9j4XrgL80LW4MaGEyGRrah6pD9Jff+hnVKYtQDf2O3qnQaBGdzmB0fMc2tUOaPdHs8SlcGBfEl3KPKnnGLZoFSrb8KlW5JL3muilSOi7jxVJMlvfu81PewRGYxivX2jwlVE6DWb5WE4yGjQ5ItFo+1w6bKWXHhmUm+n2YXkgOPTbbXUvFQn94ox8EAMM0mXI4Wolu1VQXGQUG9gbNEaVNTAAEdPvqGrDWiwjR/Mig2IPonH8KvlwstFyaCmnXIsyCboo4bLfcIzan8zM2QksCCAK+E3AjURtfs+goVgi8GUbi6FEmgnynrlMg1xn3Pyo7sFtnEEtVA9xdKjN0LwMmL8X95VbM4OoLCtFBjB2vNi7V8myq9/uXuhl86Sozaj7a8IMIujnJnXkd9yxBg+WQH1tEi90jwMnoEogsWB3rLKGpMUjHwwegLpOED1Juvf47SCCeqEt6kDM+xQduLTvfnDtt8R2QavZIWz6gCNFdMLpFtaiWU8IdXcmO52jh4iMiWWy7aOymJd3TUV4iJJBS2HHtxfwrhJlRMTqlOeRiIt4nu5EAbV3vuebeEAQ7g7NimHEBcaGoTQ2g0eLLZYowuTOE3jsgtvTppywMYu3IYKP1hzlDCEUXYPQ7elgyGMnaaACkegmAVN28DFsmA22BEHLg1rhB+LslCSZW+eoUPnMoyAmOYfcrmKY4OzR07yKbDFZOTSEbfPfKmVom5ghAPSGPgkDcvmWb7XY+jIH1rQKo1IISwAfBOKhnjJZdn6VLIjpiMmCNXJz7cqN/eZBEbn29O1GIMYVpa/I2pb7cVRx9gNPe0Syuaa10qxJ/ZcK2DSYeArnM331JrLgz7pEYT
 m6FEDfG1
 1kKoV0ZUNJfgpwer9LqZOjPkbPxuP8RDC4BndSKvW7Tdn+BrZ5aUV844JTgTHAJ9BrRV+3eq6oonsxU8isLHg+OhB4+/VcTWMRUn0uarE0w7MTkRkyTOgJY8caPrQmAY8nKjzLwXS1Kx1zs+JyNIy3mzxI0hDss07h3PAO6LmZWwsD3hJmcf5sX3f8m1otaNRxjYvXZWAQwNGH1nQQIru/T1cWr0tqjRswDiRnpI50PeA3PN7lPnE7LoV86YUwUidJyMaIeyD4jH/JNvpisAQEs1216BulDwH7KTGZnj3SxtkVuZ2UBV5RhHsv8zRY2GC7djBsTPftRcZsjm9jh3sLkKi1umH7NLcyIXy+hXgnqkvE5n9mkO2pKcgRWflanHTgU8qkv9OJu5mDJg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 10:19:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Wed, Aug 13, 2025 at 04:57:55PM +0200, Thomas Gleixner wrote:
> > memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user
> > space. TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by
> > other entities as well.
> > 
> > This results in a unconditional mem_cgroup_handle_over_high() call for
> > every invocation of resume_user_mode_work(), which is a pointless
> > exercise as most of the time there is no reclaim work to do.
> > 
> > Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised
> > quite frequently and the empty calls show up in exit path profiling.
> > 
> > Optimize this by doing a quick check of the reclaim condition before
> > invoking it.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Since this is seen in profiling data and it is simple enough, I think it
> is worth backporting to stable trees as well.

People will probably do this, but it's a big break of -stable rules.

If it is a regression fix (ie, has a Fixes:) and if it makes a big
difference (ie, comes with impressive quantitative testing results)
then maybe we could push it into -stable anyway...

> In the followup cleanup, we can remove the (!nr_pages) check inside
> __mem_cgroup_handle_over_high() as well.

yup, how about we do that now

--- a/mm/memcontrol.c~memcg-optimize-exit-to-user-space-fix
+++ a/mm/memcontrol.c
@@ -2213,9 +2213,6 @@ void __mem_cgroup_handle_over_high(gfp_t
 	struct mem_cgroup *memcg;
 	bool in_retry = false;
 
-	if (likely(!nr_pages))
-		return;
-
 	memcg = get_mem_cgroup_from_mm(current->mm);
 	current->memcg_nr_pages_over_high = 0;
 
_


