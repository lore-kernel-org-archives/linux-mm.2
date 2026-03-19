Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE4E109191B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F336B0507; Thu, 19 Mar 2026 17:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6D66B0509; Thu, 19 Mar 2026 17:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E846B050B; Thu, 19 Mar 2026 17:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0C856B0507
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:03:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BB4A5A997
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:03:49 +0000 (UTC)
X-FDA: 84564039378.21.CCED623
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id C57711C0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:03:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FwDtVO6p;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773954227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rvv7aCV1Zjgon2qQiEl2mtSdsKlc0SDViVfsxmkIzE=;
	b=Gkb2ow4DiGgi+kEg2wec+C6mO8ivgNueYLsFMsOlVoszlMBCkWVn0vRwImltIxlez+LbKV
	34NlvL2DE6csIj1AoBx1Cf9JQPEo/K+fgFjj0k9deoEmvhc22PlfrjQR3xJxm0nL+8zqLF
	A4IYoGyFqrHeDaW9wYZiue4gFxT4Hdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773954227; a=rsa-sha256;
	cv=none;
	b=2APS1kH1gCBxCJ+f7fgWSYD+qyiAUxpXDXjOpfV8L+4sWOJWVdZ+0/wItfCCDDhmJUfMqJ
	LSMykP8H7pgNwiNq5+0tumUoD8xEYJTPq0+7cSoQcGUW7Ejtq7GTn9Tvf7cOKS0951wiWk
	1eozAoQ5dR5D432IlLeS3iTtZlWKZSE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FwDtVO6p;
	spf=none (imf20.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=+rvv7aCV1Zjgon2qQiEl2mtSdsKlc0SDViVfsxmkIzE=; b=FwDtVO6psrwm3HyfFlsZB3+cxi
	4ESQHmvJpiItXpqmIc5tUF7I461OModDiHygNQ+t5xYXd8oWUTgF+pw10aZcZAvgCZxMbEHMkZ/47
	ucUcxdlT1pKawgJjtFtRSi8Gh/0gG4PkYDs+c42AKhIrWgTKHsqB21uDM/ja3x3FME1m+6OHX2qie
	5RVKmV1Y5FYsG0WLuzRcPhHXyfo5UgNJx/3RsfIb/69M/l4ttRMBAOhns/48es+GybKhyEu3boeGR
	lYUZqptfzyPxY9S7S01nmzA9Lf0wHtZg4VwiqKM3d5GP84CrE5+DkKksPdZdVc3xMAkSUBmTBcsq5
	W7grO4bA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3KWW-00000006hf8-1bpC;
	Thu, 19 Mar 2026 21:03:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E08433004F8; Thu, 19 Mar 2026 22:03:19 +0100 (CET)
Date: Thu, 19 Mar 2026 22:03:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz,
	weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each
 swapped out page
Message-ID: <20260319210319.GK3738786@noisy.programming.kicks-ass.net>
References: <20260318222953.441758-1-nphamcs@gmail.com>
 <20260318222953.441758-10-nphamcs@gmail.com>
 <20260319075621.GR3738010@noisy.programming.kicks-ass.net>
 <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C57711C0013
X-Stat-Signature: gh663sqcnfjynjqqxt3amswn1mfh7ncz
X-Rspam-User: 
X-HE-Tag: 1773954226-706989
X-HE-Meta: U2FsdGVkX1/Xbr0vA8Vngj7x1nQC4zXTtex2PpnIEpIdxk7VxoUzbIECFQumTN3GjPEoImzetJVCuEqTGoLIAoo8QeEWKfEZ3G6tVIWC8dYPoGiayrFQdpIFo3l9Xoj2xbIUTSXCOBOtvMFVkhwYSOfioS0IU2itI1MZsKPKaQCkgvqbjvtzWLcsoxcvMv+0GSU4Qrjlbtf/fqtlFGn/Q6zT3T2qWKQ+tEgP9jnnz7UbofA76G0LR3u0Po0AJNrrqg2kJ9DVaTunN/e56Jngc2WUFfwFe71lg3/AcDWvDgNOXEIiQXFFEl5Z2VOaoDWblhQ3RLTnECWd72rRBfQCQcIK8ikvAOhI+TawVxY3TAXBmIfnVcqc2gfC+dlRszj99cjc1BfBgEU2vPmNTElBba+j2pBGE1Cagm/3qugLAsU/Og9r1ga2I8rdhR1iA2oDUik5Rqk0HP+BKTk/upro3FlGxM2rN3MtbuKEyf6zPt0P+p7ay+t7gjYgchsusO+O7u0sBTjRx1xiVqEv2iEMcG+CycYNpW+xrBLe1yTr+DM1DnHUobWEFYFD8S1i1qTDkFwxhqKASkdnCm8OVzL6y9XQh+1TnlVvwefAiuLiTBKHjTwqsu+JXEW1TuArWTSICLmSagZLxpR+4Ud0Ua4X70WhJT9XfzTlT8gG7rfb8NxIL4A+0RFdohTc+TNZHnlfWzNAlEpTNW9/MWhDUme0VKsqA4NB8m59VnmGiCZrUt0BnbBGM2Rh+ZHnTAIW3MbAhyeq4I5EpFycGuHD0oG1bz2+ovLNwXVYH/Hnbyle/D1gTNwW0wPhRiAPzVK3Q90cFWiq0ziQ+bD5deXZ4IGzVLjs3I5nk4jnHFcvDd6HgWrPcDbOEGJHck0Oru2TJurCGYJtGi08n9r5J9Af/vb7NOq95SlbMd8hIdsPzZ8urEpPegMCEG4sFRc+gbv0z2XXCp4n8w34JR/qORKRjzr
 UnpIy3y+
 qSQu/IPlD98WNq55lqu6a04pYJyPyu+WigcfhNLt2HsOF6m+ZAVG5gSGK4xA7+AMxmJN+0gr+lYFXJ5c0zpUNtEYSa1Ou23NiqnMaD/HKmPzvkMai1a5/CKKKMZ8TrAVjqt7/Ehgr/TVA85DNrD/ju1m8FQa/Yt91Urmh4NsdfeN6zpp9G7WpFr6gu/ysmZvUynd9IaEZpEdigcBcfAfnuF5NztxTkhUUB4PLqMSeZqNGoIxdB7UbnDtDMsBXV+6e4mFBLlxihdyVFAQvV2ZSwOhbhaIM2zc7ZkF8QGs1JAcEfKmow1HTrKa+l66PQ/sUH9vYueNdGJskyL1dqPxA01dnat18HsayXKQ+GRNQfgMUP5HkX68ZGZooxhycyfs2id71YKu53q4aLGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:37:19AM -0700, Nhat Pham wrote:
> On Thu, Mar 19, 2026 at 12:56 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, Mar 18, 2026 at 03:29:40PM -0700, Nhat Pham wrote:
> > > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> > > index 62cd7b35a29c9..85cb45022e796 100644
> > > --- a/include/linux/cpuhotplug.h
> > > +++ b/include/linux/cpuhotplug.h
> > > @@ -86,6 +86,7 @@ enum cpuhp_state {
> > >       CPUHP_FS_BUFF_DEAD,
> > >       CPUHP_PRINTK_DEAD,
> > >       CPUHP_MM_MEMCQ_DEAD,
> > > +     CPUHP_MM_VSWAP_DEAD,
> > >       CPUHP_PERCPU_CNT_DEAD,
> > >       CPUHP_RADIX_DEAD,
> > >       CPUHP_PAGE_ALLOC,
> >
> > > +static int vswap_cpu_dead(unsigned int cpu)
> > > +{
> > > +     struct vswap_cluster *cluster;
> > > +     int order;
> > > +
> > > +     rcu_read_lock();
> >
> > nit:
> >         guard(rcu)();
> >
> > > +     for (order = 0; order < SWAP_NR_ORDERS; order++) {
> > > +             cluster = per_cpu(percpu_vswap_cluster.clusters[order], cpu);
> > > +             if (cluster) {
> > > +                     per_cpu(percpu_vswap_cluster.clusters[order], cpu) = NULL;
> > > +                     spin_lock(&cluster->lock);
> >
> > This breaks on PREEMPT_RT as this is ran with IRQs disabled. This must
> > be a raw_spinlock_t.
> >
> > > +                     cluster->cached = false;
> > > +                     if (refcount_dec_and_test(&cluster->refcnt))
> > > +                             vswap_cluster_free(cluster);
> >
> > And this... below.
> >
> > > +                     spin_unlock(&cluster->lock);
> > > +             }
> > > +     }
> > > +     rcu_read_unlock();
> > > +
> > > +     return 0;
> > > +}
> >
> > > +static void vswap_cluster_free(struct vswap_cluster *cluster)
> > > +{
> > > +     VM_WARN_ON(cluster->count || cluster->cached);
> > > +     VM_WARN_ON(!spin_is_locked(&cluster->lock));
> >
> > This is terrible, please use:
> >
> >         lockdep_assert_held(&cluster->lock);
> >
> > > +     xa_lock(&vswap_cluster_map);
> >
> > This is again broken, this cannot be from a DEAD callback with IRQs
> > disabled.
> >
> > > +     list_del_init(&cluster->list);
> > > +     __xa_erase(&vswap_cluster_map, cluster->id);
> >
> > Strictly speaking this can end up in xas_alloc(), which is again, not
> > allowed in a DEAD callback.
> 
> I see. I'll take a look at this. Thanks for pointing this out, Peter!

Oh, I think I might have confused DEAD and DYING here. DYING is the
tricky one, DEAD should be okay. Sorry about that.

