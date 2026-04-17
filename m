Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2FABF8E499
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475A96B0005; Thu, 16 Apr 2026 23:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CFC6B0089; Thu, 16 Apr 2026 23:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362886B008A; Thu, 16 Apr 2026 23:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22F086B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:59:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D55D5C3343
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:59:52 +0000 (UTC)
X-FDA: 84666694224.19.C02E958
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4032740013
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:59:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7U3ZsGr;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776398391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHOhyVG1FFARqitKB0yG4f166TwTm2USk/lT7dFJCDA=;
	b=YXt7tzkHNq4KwBeT0iWAu4CcJkvt535tvslLx/5H6MNzGiU0JuEUExgb69Y+Q+C8m4STZi
	O3G1dca6BjsIG8NwhNG/b/gLI35Nsk2O2G2Opb2mNNTcbZNYGxuMIUImDStF4z2le60hgp
	HQ0iSRblINGEJWSxJU9T2DMWJKH7Jds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776398391; a=rsa-sha256;
	cv=none;
	b=FynWXpQ39Dm4f0XyfYzvIVzYiZ2cQiIAmpUe1suHsM1jhXc28q9tKYTHcBgpZDQTo1CkKf
	LWmzCkrZqTJuT6AOVKN5lHJwb+4Y9UPMedby8CTVzvMtNEZwVV2rc5IprKg9hY8V7TpywJ
	0Voun9trWJynA3znlYphTVroF/y91vk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7U3ZsGr;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51AEC60128;
	Fri, 17 Apr 2026 03:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1036C19425;
	Fri, 17 Apr 2026 03:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776398390;
	bh=FYMWlIv0R7SHlUNfyCiW5pjJHyGqG8EslRD+hgoM2sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R7U3ZsGrLgMgL9Zyy2JM07b0SVO5tpzNJkedWlWBu9Z4GH2l8UAehB8ePUw4lJxIV
	 ER8BrbhAkcLTYJifxrWDW8GMrj4T+T7C+Hi97jlgfJLYEQ+tQWKTCyU5LcqXxccEVs
	 DXcLeJ5WWuAvOMCFtYcv8lBvz1a+XFBhUx3Krv80oehO2MzmrlIPXzfKtQVf0Tbfqb
	 fnIJBR0vnOSQojETGU0HJa4/Rft0VHv3USIkkhAkj+lfEb9GEsre8+tXmXBsemhhwJ
	 DMfcIbPRB26gAU53LS/qocRQ/IllNnKNnh/FHGZEUQXk9ebz4A4sqUK9rv88ouTt3g
	 x51MvSMwedFIw==
Date: Fri, 17 Apr 2026 12:59:47 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Steven Rostedt <rostedt@goodmis.org>, Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Message-ID: <aeGwM6FPL-yJEs1q@hyeyoo>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo>
 <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com>
 <aeDzovGHlFmPFpNt@hyeyoo>
 <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com>
 <aeGcHXmbCuZ8cNis@hyeyoo>
 <CAADnVQKLNDitD+WfNCr-nB955GVO7YZeHMjkuOs-=sqnvYyTxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKLNDitD+WfNCr-nB955GVO7YZeHMjkuOs-=sqnvYyTxw@mail.gmail.com>
X-Rspamd-Queue-Id: 4032740013
X-Rspamd-Server: rspam07
X-Stat-Signature: xq9m86nqma8hw17fchpb8hxw5wdfeeo7
X-Rspam-User: 
X-HE-Tag: 1776398391-902060
X-HE-Meta: U2FsdGVkX182zA25Zg9QdfQMLiQp5UUpxtb6rvaDuZDmYLaRJw7i0gZwv2dcmBWHYJxxAphPLpnEtHOKPXez/TL7q50XJQKV0NVjGh9iYYYQSQXSX2gEbrHLY11adGxpg2FzW378DJn2BwKoxSYkd+918Kee0vRsHBn6d1/70MFEqzMFlO7eoEK1+g8SM6cV/aPez56ikrijAYLXluXIcNxFG6p8887ci2avBhwzlSZURNexf/9zDk8K5u9RJjrjJg+Ak3nQZP7uAlMlqOoJN3E9Acxvk6Lo8evx8xsnGCGVQoS+X6RExuRnwDlRNgmy3Z124OAJ8e4bXPh+Gbds7DYJ429/U21Tlt0BwpIZcHE/5dl0+pIHw6kd/z9wWUWT5+f+BXsEgHncjR35bw1XDZorf/jSYh2Q0bwCaQjoRe+HlxVgrBlyMvVOtdxIzi2TymTN/4NBObAqC+epWu5AtmRCeY9NxUpw+FPxIKvFKi+0E8WemZKkRQWAdgyiFDSymDPkX9XSiWbh4V+8BY4btaJz6dP1mwGTW1Ts1YkYsdEhAB2vDxo2FS/ly6bE5tfyuTvIoAIiLZhMC1p6cgbdWRLAxfyQV+AHTp6xdQAHmP7FC4E05fbEoKg5XctKS9Mt4RM2r3dYv6Y44Tf+OBb03No7Rfehi8jQUglA6Bwe/i5U6p6OMqOeId05HXOTSXhkaP+kzgaJYtomFb2fadW3lr8pluGfLhoiVAO9RS2M51tjNKlvSTRPayGzEYnfbJuYgmUL73h6Vu93RgDo3A0d1XwuYEjtJBJw+Kf9xMQ6hvZ0+dBYKiW3rx1PZh6+Xrdz5TvsEnhUmEDR2RFJdwMgQz8JhaEsunMQC26XThCIH1AAKn7NQaKbcc9eTymyabrXzV79V5z6Ve82EyYiCBKGHJKX/M7JfVwuLa6+OVE97GgY7V/NTuVqKoeFfwsJG2BDiNVWoOP4JhSpGxSDmW3
 1zDDR/Br
 KFrcy8rB5P9a3STyiJmdSOFzGWsDvpzcP0QKHEt0Gc50BGkLMLYz3lG9NCmnuyG6e7/R896v8tJ4sxFQcvIB8yCCy5eHU0QX223xADXc3IHkVLJmrIXriJnhVW749bqZgsuktHDYVIlr3DivcVq4mDAdQW+AkZKQiv0trHS7KD+TUkYg+peBrL1hKlq4t9F4WBWERgvgkTawjoJgjjG9USuFopCXaZdzBrIHLZoMIYcBQxvOhA0hFE2VWzLWz1naQauHe9kf6KYQ7YvXlxddT9C6fgHEX4wJZ7pSn1ZxWIJgGSKOfvbU/46x/CR2gvG6KfHo0mVSYC/mxhD5SXHwy9A4n7qLKNhCYWpVPqLGeOyxLLoIn6Kkdu28Vj+kfJ3HS7pvkOlp0qsi7HLGPQXN33iOG72/5ev7XyzSQkHct6cYd8Ze52T8uOXtsdKOBlLrZPX1J7z3IEAa4rD7iGW5zPziICpGCbK5rsrPDGpwHGRR79achpAuMQ4mI6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 07:41:02PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 16, 2026 at 7:34 PM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > On Thu, Apr 16, 2026 at 07:37:49AM -0700, Alexei Starovoitov wrote:
> > > On Thu, Apr 16, 2026 at 7:35 AM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> > > >
> > > > On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrote:
> > > > > On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
> > > > > >> I think we need a special spinlock type that wraps something like this
> > > > > >> and use them when spinlocks can be trylock'd in an unknown context:
> > > > > >> pcp lock, zone lock, per-node partial slab list lock,
> > > > > >> per-node barn lock, etc.
> > > > > >
> > > > > > Soudns like a lot of hassle for a niche config (SMP=n) where nobody would
> > > > > > use e.g. bpf tracing anyway. We already have this in kmalloc_nolock():
> > > > > >
> > > > > >         /*
> > > > > >          * See the comment for the same check in
> > > > > >          * alloc_frozen_pages_nolock_noprof()
> > > > > >          */
> > > > > >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> > > > > >                 return NULL;
> > > > > >
> > > > > > It would be trivial to extend this to !SMP. However it wouldn't cover the
> > > > > > kprobe context. Any idea Alexei?
> > > >
> > > > I think Vlastimil meant it'd be trivial to do:
> > > >
> > > > if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
> > > >                 && (in_nmi() || in_hardirq()))
> > > >         return NULL;

Just realized that it's unnecessarily restrictive to disallow
hardirq context on UP.

Tried below and it resolves the issue.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..777499f814f6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7798,6 +7798,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 	if (!pcp_allowed_order(order))
 		return NULL;
 
diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..522a0a0d7bcf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5304,6 +5304,9 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;

> >
> > Thanks for clarifying. You mean not covering the kprobe context is fine.
> >
> > But I have to ask; how is that fine? Wouldn't this leave a small
> > possibility for a kmalloc_nolock() caller to trigger
> > e.g.) use-after-free bug even without noticing? (yeah, very unlikely
> > for somebody to trigger in practice, but not impossible)
> >
> > If it's unlikely to use bpf tracing on UP anyway, it'd be safer to just
> > disallow that to happen to begin with.
> 
> Don't fix what is not broken :)

Ack.

> I'm sure there are millions of other issues with UP,
> so there is little to zero chance that anyone can repro such a scenario.

*wishes people running UP tests their kernel with DEBUG_SPINLOCK*

-- 
Cheers,
Harry / Hyeonggon

