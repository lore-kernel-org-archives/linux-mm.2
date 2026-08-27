Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD76C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D96A6B0088; Wed, 26 Aug 2026 20:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463696B008A; Wed, 26 Aug 2026 20:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303D46B008C; Wed, 26 Aug 2026 20:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1CD26B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:29:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62BF48028F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:29:01 +0000 (UTC)
X-FDA: 85145164482.26.2D28967
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6479C20002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:28:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bNxOy+FP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787790539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cZqKKK1TDfNXpWdtR/tDO5Ky/FCuSlms00pdh6fymw=;
	b=IANUJ2gzNIvUX1zn1b4spSOTFsRZmIIvqmUNMPuzx8y5Sn2NW03BvA6PQvQF5IPsYVwSFl
	BgCIfCyuXiy/CmXZRxiYcQksgc92hPThikCCthTM9gjCAfpAjrGTlPz3cNnqunKbPyQ3T/
	Ytn561xEH4gRRsC0yHMoKqtC63/Fh1Q=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bNxOy+FP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787790539;
	b=P7csDHx6KLWzMNHH16y+9yjmMPmqKQqgXivuD5AQ2cMWjE5CFus/sIxh5R+Pl9THF9WtX2
	b7jmVZMi5Qb55taVCMqKtAPYXANngO7dMqQBpSKoLjeVnx8es5fU3FSU1aW2vWgZIJyjV+
	LrZzfx6A5EqY6SLwTxQ7C2KBDPqCpqs=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso1601345e9.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:28:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787790538; cv=none;
        d=google.com; s=arc-20260327;
        b=gVvQ+QZNQyqGVp2tCwcdxYYm2yz3+zapGYsg6djF8AmwZqbSh1+a44Y/FIgk3Z1nDp
         /fOZJxLqEqXJzFj8v3oLnAc+2NePEYbGQTWe6BBH2WUcROh3vh4dkuFBxy1AYoYwIIZt
         75wAXlYCnT8++O/IkatYT5PdiXjpQDNs0oCTVSPdZp6Q7xjAppDDpu8X+138+DDT61v1
         BmkXBuq5oxHx8kQL6pK2VIFkwK6uhZZfEgEdgy20hSs8JvfwYrslcngn+XjXK239c5Bu
         3aw9nmAJ+Q9n+wenC6GdmBoJug3opNradI0ES9O9yZIeX0PTGVCWZl+7axRag0926W/O
         i07A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4cZqKKK1TDfNXpWdtR/tDO5Ky/FCuSlms00pdh6fymw=;
        fh=o9DPlsLbXZDH2PIHrmEEKvGSC82qFKIbrNS02uHToGc=;
        b=EO6Hg4oQtTOP6t8l0FfxcRJ3aGf4o5ObouEsX+W45VRs3gwRnXuy6tmT+/rmDfmAI3
         /h4p13uZVt5HjKp1aYFMldM+I4S0oYj1uVN51jmxZRVjqjcjZc0GVKCMkcU/iWDV+9FM
         2hQqDEAZkqeVRCQTvUjjQpnKQjb8LAg613vcEMeY/JHBHurK1XM4f3nvPT27CBY51XeS
         rihvdHlHD2Iyt2u9fNIPW+zqL7va7tIiHhcf77U8btXldHC40VnegBfqRFsJxz+tPnvY
         9cpWzkvCP5BZUEylETOI5euMx58WxlLiLjmmBewNkObORP7NS7Pr6ICekGUYzPN3AZ2p
         ZCSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787790538; x=1788395338; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4cZqKKK1TDfNXpWdtR/tDO5Ky/FCuSlms00pdh6fymw=;
        b=bNxOy+FPz/qZLvGxMAm4YSAIjxSOlppaenPli/TNazSfeBsWYoYNaR2eNihTHFFyBS
         wuFM7teLtxHN6waZ5IHL5CWbsOL6wWiaej9xbPM0r8OM2IR9eVksOrAnRqFg5GToWc5+
         RkMV6SaG1iraZXzdAm6OvSE/MnlXaEP0r5knr3QzLljahLNJ1xj+91f1t3YdZmBFO1+n
         wTJ07GOJgaM9aeekGm6tS1+QTtZZlWa/+sApakvS77CFQ+npVwdJfMss7NW+xt114cY5
         ROUSu0v0lDOnedL1IAveojYH30YqxqrpBvegugRD1t6kgw5B7fQyNjpIrct5txERjOEz
         Ji4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787790538; x=1788395338;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4cZqKKK1TDfNXpWdtR/tDO5Ky/FCuSlms00pdh6fymw=;
        b=gqLsNcv07pLfxchyKC7X0OOwkNm5Dp9iEDSun9TevNNTrNnl+djKJUc7zihnU3/CRq
         uN7TWvqXHvvemNExlJp6Up8AEAZs/TN4D61Qs7LBTENTckxYLZT6VM/p2GgF4l/p0Kq5
         tRty7HwP5NGDWrGAERX/XEQLwIxJ421jzceVy0myIl1UNJUnfJJUPxQSjJm7HPvsYViB
         g6Nimy5VbKmU1JJhRFbMtpPYQSX8qc5gmYPdMS7sorCq3GnnsusT7NBu7Nb0XCpfdexX
         5qeORO/RabNbYiNz5MiAclMOJaAB9iaPjxmJjs/J6M3sqkdAGPCAeiTnqSpVQr8isQMB
         PtcA==
X-Forwarded-Encrypted: i=1; AHgh+Rqq86IO9kOptEo/IXosZqERRnXx/Xr4a7QjIks2uFnGcuGyhm/EMagZFSg74ajCm9/Tk/E9aCLETQ==@kvack.org
X-Gm-Message-State: AFuF++lLgrH7wi7c0EEmeEMHQupZx+3wo1rah2WbU3XzcoB3g/UDszf2
	AxRNJRQyXAoDadPfuPwwoIRsl808RchQmvutBsOYnLfvqZXkpxOe0bUYAV+aCrJh9nD7JnVaB5h
	7cpHc1KpjxAXt1mAWTE3SlplxSMyXUv8=
X-Gm-Gg: AR+sD12XUDqwwRyKZvNZ/wMjQxc0Fi9z6JGaCzsFSYm+b6fARugpA+ucHn5CaDuhGU4
	81TJtBIwlIK/jO/yWxhQayya8qbG7BLAuFOxpQQUxeVg8b9eI7J9UfUxFS5l6znqpPgleBW7tsM
	VpNyrsTI+w2vX0f68icd4q59BNwaBk0piNiuYu3I8c3JBtkGlLBBQaUrBaft5+UM+EojoUiZ12D
	aXg/7lXWoZW+iAwTweFJX7/z64TiQHw+XQys6fUOyb2lJeLLiFi2d4hkHsXALqv15efdBdUBA/Z
	lS5iJ2srznTOSOPODv+ToR9Mh/ske4F5vVc9FhHhU5HQMj0uAjv7PXl7Cj+fyFd3zFvk3XkYp7i
	1sYQ6YJNCNckKRhAuxmojQxUO7pc=
X-Received: by 2002:a05:600c:3acf:b0:499:db5a:1049 with SMTP id
 5b1f17b1804b1-499dc70246bmr113665505e9.8.1787790537745; Wed, 26 Aug 2026
 17:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com> <anpsLy_pCanocgS1@google.com>
In-Reply-To: <anpsLy_pCanocgS1@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 26 Aug 2026 17:28:45 -0700
X-Gm-Features: AcwNN1XMTGinUnlY4ug2mkf_JuHPFNH6ilizd91iZP4Nfao1NkxbweldZ9jzh4E
Message-ID: <CAJnrk1b5asARJ_g176DsoNCvf+iFqzPbOtVveeuPxTPZDmnuKw@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ngnz9qqe14b7g67y8wpoimx3jgp98n1h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6479C20002
X-Rspam-User: 
X-HE-Tag: 1787790539-87821
X-HE-Meta: U2FsdGVkX19M0ZSrSHaMI0HUFXrCoVGIQ5C+nU8jbNbBXJJgXTcNV8gloA0ZuoOUQGUmnolSo4Hb0pJh6ID0AYiYeGBUJ+8PnOPsd3+egjgiD2sGPtdWmrTNTQwiM1vX00S3UuTX3qC0Y7eFx3XCgWRsS2Z4ZXiI+/aO9nBa0leSBkHkMqmIUaWHBlKNclgBfAhvyu7RIU+pk1zU3rudUWPM2UispIL13RQWVrBcDTL6vyUk20j3CvZdom6czf82/xd1Hi12TnKJxSB8uYQPz6ph17/sl4BTnQJDyiI4SVzhznDTaPZBWcdbw1Cd73Lra9WPqatAFipSCrQZyf4jXmFS0fEEbbicgBWdhiTRTm9/i0xrW2r8F3XrYqmgUsHQONkyeelQCKrZGOVADiKZmT3WDUsKRphjsYZzIsXrv2N4hV/c9YqHllSGicbwEqKGJ8dnnTlkqwGExkrVNzlVxiJieXlqMObxmpNQ3GPE41BL3iniAS6FVNKopE0h6fV/gwwyrJ4dtW8iEGkKyPaD5YqOE9uD0dsZLLQKvi8eVu0IqFOoSHvYi4jwImYw6IiPNXYXc3Ojnz8cEUiUCcMqQlpdOoRFEsZf0Z6GzUKiK2JYu7vmvnRhGy/ggGXzbMiewYU+MyyfHdWlvdB++XVcyVl3mQD/Bv9z5xxKIdl7bSfo301ggOtxie6WX9Eg3FKbbddZNwSz3tmC2NKGca2qDqJ4oaja3WeCtZ9UrH+CS/kpOJKv6CQQZiTDzdfj50C7yn54g8Xl7zNKwFsXjzPkQzz9vLPeCDIsGQ+lgHmZ9cR4UZkV52ecpvMfYtaxHddzqojmkQsxuhy6bZsbyrhqKojnVdBXKTDK9OvtcKAwH9kMRofxK9nmwpcCasSX7J2vVGT6JENJ5tfN14kw8GhOHONH1A3ZcE3fa6b39UquxaSmkOxCRiSkUnhV4IJMmT3ccWUCgCftQtSEI+0LjIK
 jLUwRK2s
 sINFoR/rjEARMHwD2651156RVHHddvqyCAV8eeAypwiqoWdnqL0/p0aT3Rc9GTb+6IqJLI8Gds55pTQkddVVWZnTzdUMhMuwlUDe03vLhHuFgOCm/prsD4YeNHfwBrwONn63z+4c6xLo6EhlQhpTC59W064Td3e3pSh+P2DlY2y42N5kX9Su3e3I+UtPi6c25Ft0k2QXDMpVuVcU2KoyDVfkiP2FLkQ+yuj1hzLVGk0w2OeSo2MRjjXAQ1V9o0Tto5ze8RJ7yneVFBe9TykvuRZrjwZmQ/uvunU/DjKZ3r2JZS9iWWG6dT/Sy1ycRVk7am7ZlR9wy4jim57DOgjwDqR1a/7S35H/ZJe2AA/87uiBHqjWIRdw+pED6k94pzDTJ49nTADfSOCt+WHikxu4RaqnuUNykjhVBZnKb7Glzmu1mqZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 5:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Aug 10, 2026 at 09:49:31AM -0700, Joanne Koong wrote:
> > On Thu, Aug 6, 2026 at 2:31=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > For updating the stat on each parent and having the flush path only
> > accumulate CPU counters, I think this means we would have to
> > unconditionally walk the ancestors + update its counters on every
> > update, as we wouldn't be able to early break if the flushable
> > threshold was already exceeded. I don't think we could replace the
> > stats_update update, as it seems like readers still need some way of
> > knowing when to flush. It seems like this could be a nontrivial
> > performance hit, but maybe it's a non-factor in reality. If you think
> > this would be useful to get benchmark numbers on, I can run some
> > experiments on this too.
>
> I think we need to experiment with how much work we can shift around
> between the update and reader sides.
>
> Right now, on the update side, we call __css_rstat_updated(), which
> iterates the parents and puts them on the per-CPU rstat tree, then we
> iterate the parents again in memcg_rstat_updated() and:
> - Check if flushing threshold is already met.
> - Update per-CPU counter for stats_updates.
> - If per-CPU update exceeds (another) threshold, we update an atomic for
>   stats_updates.
>
> The flush side checks the flushing threshold and does an rstat flush,
> which will walk the update trees on all CPUs and iterates all child
> cgroups on it. Pretty expensive when the threshold is met.
>
> I think we discussed two different options:
>
> (a) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly.
>
> In this case, we can't keep using rstat, as we would still need to add
> the cgroup and all its ancestors to the update tree anyway and the flush
> cost will remain similar. So on the flush path we'll need to iterate all
> CPUs and add the counters. We can explore if use a cpumask can help
> here, but perhaps not since we'll need to update it atomically on all
> stat updates.
>
> I imagine that if we do this we'll drop the stats_updates optimization
> to avoid adding more cost to the update side. We'll be replacing parent
> stats_updates modification with parent stat counter modification. But
> maybe it's feasible to keep both to limit the cost of flusing.
>
> This only works if the cost of iterate the CPUs on the flush side ends
> up being cheaper than the current flush. I imagine the average cost will
> be higher but the cost should be much more consistent vs the current
> flush, so the tail should be better.
>
> (b) On stats updates, iterate the parents and update the per-CPU
> counters of the stat directly AND update a global atomic if the per-CPU
> counter exceeds a threshold. I think updates may get too expensive as we
> may need to update multiple atomics, especially when updating the root
> counter as it will be contended by all cgroups.
>
> The flush side becomes an atomic read, so should be very cheap, and we
> can drop other heuristics and optimizations.
>
> ---
>
> I think ultimately we need to experiment with these approachs (and
> perhaps others) to check what actually works in practice. You'll
> probably want some benchmarks or synthetic tests with many cgroups to
> exercise the worst case scenarios.
>

These are the results I'm seeing from the benchmarks. I'm comparing
non-ratelimited rstat vs (a) vs (b). I'm comparing non-ratelimited
rstat instead of ratelimited rstat, because ratelimited rstat relies
on the 2s flusher and doesn't incur any additional flushing when
called.

~On the update side~
ns per update (measured by having a kthread pinned to each CPU and all
threads updating the same cgroup for a 200ms window, run on 80 CPUs,
computed as total CPU time / # updates)
depth      rstat      (a)         (b)
    1        22.34       32.49      60.10
    8        22.46       47.12      140.72
    16      22.49       70.96      206.39
    32      22.51       139.16    305.40

(a) and (b) perform worse on higher memcg depths, whereas rstat is
unaffected by depth level, which makes sense given that (a) and (b)
can't break early if the flushable threshold has already been
exceeded.

~On the flush side~
ns per flush call (measured at leaf of memcg chain, ie best scenario
for rstat, # CPUs on the system is 80)
  rstat                      10165.60 ns   (min 9924)
    (a)                       734.10 ns
    (b)                        4.79 ns

(a) is around 14x cheaper than an rstat flush, which I think is
because the rstat flush goes through every stat, even ones that are
not directly relevant.


Using some napkin math, I think the breakeven point for (a) is around:
                      updates per read
depth 1             ~900
depth 8             ~380
depth 32           ~80

eg for depth 1:  (10165.60 - 734.10) / (32.49 -  22.34)

This is assuming one read per flush, which is what (a) and (b) would
necessarily have to pay, whereas rstat only needs to flush when the #
of stats updates exceeds the MEMCG_CHARGE_BATCH * nr_cpus threshold,
so the updates per read numbers above are in reality lower.

Running a fio write job and using tracepoints to count # of stat
updates, # of reads of those stats, and how many of those reads flush,
I'm seeing:
                     updates/s              reads/s
flushes/s         updates per read
bs=3D1M            643                           119                 45
                       5
bs=3D4k            156,415                     123                 58
                     1267

For larger folio sizes, (a) is cheaper for writeback (since there are
4 update events *per folio* in the dirtying/writeback lifecycle) but
for smaller folio sizes (eg order 0 folios), (a) is worse, as a lot
more updates are incurred, and the performance is worse the deeper the
memcg is nested.


I also ran some experiments with Jan's suggestion of scaling the flush
threshold to the memcg's limit rather than to the number of cpus. It
helps the overshoot we saw and slightly outperforms doing a plain
non-ratelimited flush (100% of dirty limit vs 101% on a 1G memcg, 103%
vs 107% on a 256M memcg) but led to ~2.4x more flushes.

The initial reason we switched to the ratelimited version of the flush
was because flushing was expensive, but I'm not sure if flushing is as
expensive as it used to be. Testing the non-ratelimited version, the
flushes account for about 0.9% of the system CPU the write path
already spends, and I didn't see any throughput difference between the
two (249-252 MB/s either way), on a 32G memcg. With the
non-ratelimited version, it's also not a flush per read - it's still
"ratelimited" by number of updates that have elapsed since the last
flush (only flushing if stats_updates >=3D MEMCG_CHARGE_BATCH * nr_cpus)
which means concurrent writers writing back at the same time will
"share" flushes rather than triggering their own.

In light of the above, imo it seems to make the most sense to just do
the plain non-ratelimited flush for mem_cgroup_wb_stats() and make the
flushing magnitude bound again, wh ich also aligns with what the
global non-memcg domain does. The question is whether the extra flush
cost is acceptable, but the numbers above make me think it is.

Thanks,
Joanne

