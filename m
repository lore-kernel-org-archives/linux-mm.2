Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4614CC44520
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399866B008A; Mon, 20 Jul 2026 20:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349FA6B008C; Mon, 20 Jul 2026 20:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BAF6B0092; Mon, 20 Jul 2026 20:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DED316B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:48:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 502201C00B5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:48:02 +0000 (UTC)
X-FDA: 85010946804.20.7406873
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB7ACA0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:48:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZ+JOotz;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784594880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BYYLROr1KG9jlLLfTtwXV9u2OCUpqCq1wscUtJCU88=;
	b=YU4Ma/KMAgtNZiB7io0xcIWW8yW5dUnuwZoltr3Y8RBFZ+uatBBU35Rv8DAQl9qkFN+D6E
	lTIY9B3dzatG9cG/wlUFMYxx0GNAex2JupNCbPwi91osdaHcTbRTT/GjGLe/xuHcL22MKg
	7nODuINMFNQUfKJqaobZ+ljLAJCiAUM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HZ+JOotz;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784594880;
	b=jTiCB4BnZ+FeWThEYDlhdLhe/w8yeDZuep/CuQpgE9yB7yp2PkpLMr+kHHmwZqfEYgiDcr
	KCq69wa8rk75BnKLIrLjwjNrQOFREiRRuSvPsREzPNyQRCt6Qs2pD8KgGQ7OQ0X/fS1/Ou
	qQ9vssoQyVad/junaArJFM/KIQEfxS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E19360A7C;
	Tue, 21 Jul 2026 00:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FB21F000E9;
	Tue, 21 Jul 2026 00:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784594879;
	bh=0BYYLROr1KG9jlLLfTtwXV9u2OCUpqCq1wscUtJCU88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZ+JOotzLCADPj5ZcLz4qpPhReX0z96lHAj/QsuIidRGnjPTkxvw7/2YObTqfndrF
	 SeqoFMMVq3fuDvXE2HYlDnC5EkoXzW/yN5Bwr7zgcDl27z8dN7kKcwA2SfihqsgKuN
	 JrNxYXkH73ogcRbEbUPbeVsOhrcGF4axGQF9+vjZ6/dMmzcP0qHDwRwi8e6yhg8q2Z
	 wKNXSHIUrmqb4YJ4/KipcPYAQpxyprzaJCwyQjbDQhqdJX0a8KUcsK69hNpZMogpOW
	 wM1aGiVY61F3NvJ4tZeCW4lJ313MMc9tMgBZ4K0K7/ZgY6GfiBzzBNlyjqd6kZxR95
	 sJw4M2TziIBNg==
From: SJ Park <sj@kernel.org>
To: "Zi Yan" <ziy@nvidia.com>
Cc: SJ Park <sj@kernel.org>,
	"Lian Wang" <lianux.mm@gmail.com>,
	david@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
Date: Mon, 20 Jul 2026 17:47:55 -0700
Message-ID: <20260721004755.93824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <DK3MYJN8KSZ5.1U0STUJGETSJH@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AB7ACA0007
X-Stat-Signature: 6ie67qf4pecikjygsiatrs7s65s5fe71
X-HE-Tag: 1784594880-930088
X-HE-Meta: U2FsdGVkX19Ta0P5K/zn8mJvb0VaENOabE9DnFqke+LTNZfONjUNU8gcHRZt/qJXjCrn8zRsg/uHY+z2/88paPLUj4k1mm3jwy+ovBv1Rkxwb4DS1waGsAmYbrg50nQjcczNl3jeumT00eTpWXzGFRK/qd4PWDYAJ1Uu50xlwpqHA0waR2yNWy70Z9lQ0H1ktaNQBdkzHCvreCXAYfmbnpjcYJ54v3CtxCNOgqKsTwqeV2OA/gFpAr56njWDtbutGpMt+IOdt8aGMjhKNwzQz1HfWqPE2jpX64JgTPW3FpmGC/HRZVflA++YqA26RzJJYoVJirbvyMABtUSQC+OU6P2ZovgoME+/FzHMY8srFJ6+gAZ4KCfuUSRer6ap+KASOwx5c0sKQ7jqEpCvEFgmYvviovaQ9QJRsH/0GUi/55tK3N0/WWC+6UNdcSYMjZz/CCwCw7jidgXM9151mncLG/t2r9/VWHTpRaO/uVXPt5uf9QeSyZg/Y+9p6SHR2gSfeizn4rJ7mkSwcDqY/I8gXqgcYh5uX8IKUptfUtPUO5LOeftHMqOcA3zTB9LE5DkI/9oe804zfpPN3JRCuuwzE5WcdPrPlWL4DWjjLg75sLDGE6S1UJPT1V6VrRvKUV6GNGap3svkP6/seMbji827QaYHXQHPwANENhnVQe1FCNF1rRPt4PDmnbqCpwdg5SUJ+gQTKGZtYlpN83nlJQjHSHOF4V4x2GCeTBasstOUYXTr7PyRk5eAPixNFH7avf4i/Zvgg2aj/gOy5l/uUyCHHypKnut/1U9LQcucRBZyq17zNi+RZXbvqql5cpcQ0uX0FjM/tPbTc06TijPa4hLjAoU9Eo3+kmgvjMJczInt4uzNSUtbqmRpOuE7AT3vpVwmmDW+aSs4YTR8GOX5N+9oAM/TjVNaw5H3QUI0JPdgfVy8yDbFHVMuEPKaLRfXftK9OhEMDi1SaI2tBxK0Mit
 fRtL4t24
 oTgbNlaun4Lv3aeygaMKF3S+aiVuqdQ0ULwes+559sX/2iq37OVe2XZQxuMii5VoSeXjHKFCYDjsEFf6gOKXwU5hwhGdVYuE2mYSM3+/86eIOZDdpZ6/Gy9TkFdbvb0UpulmTarF0EUtEjXrja5a8hkwdNrPg/2kjFX7q8em/DjnhpEdlRl110UG2qLlosteSqLSqckF+ICBaox7roEbJ/ZagmSI9snq5fGd3ri348crfHlykcRxZbCxoWxTW535edKlfghphyYG3ThHplh80N/a6h75aBGTxyJO1TYkANFZymM0uHrcvSTYUCVpKHQTCo1vWNdGaCJsptfuRIByzcVRt46LFuaZlYqJTMf09Da8z+5jaEsr7BuDh4qY0hk2gJSncMVly5mRXBofR+4ow7mJdjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, 20 Jul 2026 15:12:50 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> On Mon Jul 20, 2026 at 5:56 AM EDT, Lian Wang wrote:
> > Hi David,
> >
> > On 7/20/2026 10:44 AM, David Hildenbrand (Arm) wrote:
> >> you give no real motivation and evaluation why this is required or
> >> why this gives the user any benefit.
> >> A SPLIT with an explicit order is not really want we want and it
> >> does not fit the existing primitives.
> >
> > Thank you for the direct feedback.  Let me explain where this came
> > from -- the cover letter should have included this context.
> >
> > This started from a real problem at Sangfor.  The scenario is:
> >
> >   KVM-QEMU virtualization on Kunpeng 920, with KVM guest memory
> >   backed by tmpfs shared mappings (THP=always on the host).  An
> >   Oracle database runs inside the VM.  DAMON monitors the KVM
> >   process on the host to measure the hot-memory ratio.
> >
> >   The KVM process allocates and uses a large amount of memory.
> >   Under the same workload, DAMON reports a significantly higher
> >   hot-memory ratio with THP enabled versus THP disabled.  Direct
> >   tmpfs write tests inside the VM -- touching at 4K and 2M
> >   strides -- show a clear gap between the two cases.
> >
> >   DAMON parameters used:
> >
> >     operations=vaddr
> >     monitoring_attrs/nr_regions/min=500
> >     monitoring_attrs/nr_regions/max=2000
> >     monitoring_attrs/intervals/sample_us=500000
> >     monitoring_attrs/intervals/aggr_us=20000000
> >     monitoring_attrs/intervals/update_us=60000000

Thank you for sharing your detailed setup.  It is helpful.  Btw, have you
considered using intervals auto-tuning [1]?

> >     schemes/0/action=stat
> >     schemes/0/access_pattern/nr_accesses/min=1
> >     schemes/0/access_pattern/nr_accesses/max=max
> >
> > The underlying issue is that under PMD-mapped THP, DAMON's monitoring
> > granularity is coarser than the actual working set -- a single
> > Accessed bit covers 512 base pages.  Before SJ's probe infrastructure
> > arrives, there is a gap: DAMON cannot distinguish hot sub-pages from
> > cold ones within a single THP.
> >
> > Split is one possible mechanism to bridge that gap -- by dismantling
> > the PMD mapping, each base page gets its own PTE Accessed bit and
> > DAMON recovers fine-grain monitoring.

Thank you for clarifying the motivation of this series.

To me, it's still unclear what is the real user impact, though.  I mean, I can
understand DAMON suddenly reporting more hot memory can surprise some people.
But, why that matters in what extent for your use case?  You may not run DAMON
on your system only to read the information.  You may run it to do something
beneficial using the information.  What is that, and how badly degraded DAMON's
monitoring results affect it?

Overall, unless the real impact is serious, splitting huge pages only for
better DAMON monitoring sounds like not a good tradeoff.  You will increase
DAMON overhead and lose THP benefits in some extent.

> > It is not intended to be a
> > permanent API, and certainly not "the opposite of collapse".

Once it is added to the kernel, we have to support it for long term.  Let's not
introduce something for only temporal use.

> 
> If you just want PTE level access bit information, why not split PMD
> mapping instead of the THP itself?
> 
> In addition, the issue is about access monitoring granularity in DAMON,
> why should user care and know about THP split operations? I would expect
> DAMON detects the inability of getting fine grain access information and
> split the PMD mapping itself instead of a user initiated DAMON_SPLIT. If
> that is not possible with DAMON, an alternative is to provide something
> more generic like DAMON_SAMPLE, which does the split under the hood,
> instead of exposing MM internal operations.

Thank you for good opinion, Zi.  I agree all the points.  That said, I still
want to understand the problem first.

> 
> >
> > I did not write this scenario into the cover letter because our test
> > results do not yet show a clear quantitative benefit worth claiming,
> > and I did not want to oversell.  Without the context, I understand it
> > looks like I randomly proposed a new primitive -- that was not the
> > intention.
> >
> > SJ acknowledged [1] that the monitoring problem under THP is real.

Yes, the behavior is real and I agree your theory of how it happens.  I don't
clearly understand if it is really bad in what situations, though.

> > My RFC is a concrete proposal to start the discussion.  If split with
> > an explicit order is not the right primitive, I would appreciate your
> > thoughts on what the correct DAMOS abstraction for this should be.

Only after understanding what is the problem and how bad it is, we will be able
to think of different approaches and assess those.  To me, it is still unclear
what is the real problem and how bad it is.  I will wait for your further
clarifications of those.

> >
> > [1] https://lore.kernel.org/20260620203915.82947-1-sj@kernel.org/

[1] https://origin.kernel.org/doc/html/latest/mm/damon/design.html#monitoring-intervals-auto-tuning


Thanks,
SJ

[...]

