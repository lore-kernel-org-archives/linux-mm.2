Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBE3C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 01:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148B46B008A; Mon,  3 Aug 2026 21:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FDB6B0092; Mon,  3 Aug 2026 21:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0389B6B0093; Mon,  3 Aug 2026 21:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF6A56B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:24:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F51D1A063F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:24:07 +0000 (UTC)
X-FDA: 85061840934.05.E20132F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5A40120002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:24:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVE+bVkr;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785806645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6Nq6xJoAXoC/LygU8ixMhFIyHGQ4zkq0yWeBWhUdOI=;
	b=P169hz2lwYrEkzVeRO7Fqh1W3xxIMnt9znVv7L9YThXftyyrg9P/CgWN2GbHo2W7uw7JCV
	RSXeKMGuYKsUVWOjkVT8njdwpiJC4+eNTBAiFrgt8ZROpsldNKD9n7+rP4Pk7sfBS97bQv
	OswipzUba4AluQd+RWAMCHN1p21MZ7w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVE+bVkr;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785806645;
	b=bQrWesoNIBsmWcY9KexDwvOzEuSxwVrAAUK6/kvP+GLdGD7RqI7n0vnK0rRf9qLJnLI/fF
	cs40Gc2QJmWEHQn/2cmB4HBf9RH4dHMc09lwN7Zr4MROeJNUI8PEbWHFEVxkGRLDSVVMES
	VosDhbugE7ECXy7SuCszyUaR3aMw4jU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25F5460A59;
	Tue,  4 Aug 2026 01:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A9D1F000E9;
	Tue,  4 Aug 2026 01:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785806644;
	bh=a6Nq6xJoAXoC/LygU8ixMhFIyHGQ4zkq0yWeBWhUdOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVE+bVkr6+yjsaGNwMdTqU2p1gzA7cDkqkM6wfF4w66P8K0slCQMsEtm91ZH+RmfL
	 57eWLd/6h80PfSmERaktaO56Rbuctz7DsPi/8cidwGA0pu2LU1ko19AfPsZLjgFd8+
	 XW8RH9ZLIYRZj8WIMogWZ1ViuwANbiRAUfkn5YUsqNIiUQSG8Y2BTW3sJnkvQoWZw4
	 HAS07NjfcEFv+iziTL4UejfbsIRVpEQ99m5v3FiUQRD8uEyBytTKbPqmiGsFTD9WFZ
	 rtJfwGpS4PC7njpl9DeT9JSjwQgi2sYS1aD1fhGoypPRDVAKFqt2hab353uOuFFNcg
	 mv955kVKl4sPw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Bharata B Rao <bharata@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Mon,  3 Aug 2026 18:23:55 -0700
Message-ID: <20260804012356.88861-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729135419.87239-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5A40120002
X-Stat-Signature: ydhhq71tkcwfxtq9671h3arxmicrtrh3
X-HE-Tag: 1785806645-260446
X-HE-Meta: U2FsdGVkX1+L8EHSkcLATRzOM+zxFjBBuFuUA5bq/AbFKny1/56HZoyyAjsI3wwMNa0ubvYHvfhmGjOoJ7zgDsjJVSLQccRzr910E08crfhOxBYqU86keP+2JC34iLzSsGC3i3R2/5b74wP23iSEtJ/BOsYzt5Fz77pO2I5vLyPIN7rSYFaw9wBiavXC1JHVreqJrvyl3tQgEL8l20YgK0D6XM9/RWWD/3UnSmMrZyBy3woCK2K8RrYBjyeEFDIzWaYnQbpXk1UfwFYupy2O6jzeFklKRpta0I/JBSUpUBRLD8OkY/nWq2uSBZy6NWMgjNNzq9pawGScRfGC8nLwI/tD8Zv0hTwp2FhHKpAF8xtRKt8GmzBtiOmp53SL3rK48n/+C0i/ZUa+XP2olOrNQYBsRvoU6+YqUNivssD+4l3uObOQPKYGMHO+Ws5tl9mBoYX5VsR6j0orJuRmJKhHPTI/lLNTnVvhf2+7rmJjeHpi/ASp2BSJHe2trTHuaTXKgQsEStrIaK/eWZql1PQGz2aPxLPZQ/1/iu7wsAFrFeUD8maZLyNqPtdHzHYZn4bx5GNXRMOLJH3q27GKK1zfwQuB3cs1z4S381eouI+OPDZ9HKdKa4OXzyXEH9QJNtoyKD43bNWovvXhE1qAgryKTfpAIrg72suR3BAuvJWen8TPH2a6vsIrB07f2sYUx7OjPicxRv47v6n2H3JCjCbi+eN7jcPBNgoWlLDfeKKMuH89g623ahTKWWlLfkoXqQwcg2pUGVR+GuX8WC7Doqexo+RdbX5f1J9PNCJsVJGC7G/mpL3DNWyNqe0RGOSar4YWraigHcOYOa1JJFOu1kXMLmFNGbmr3UqGWhqISdqoQ8s9Z5EJi2zz9XBlvogIj2rQSfRoJBGlH16mzexB8n7WhRVVko/Q0fAdReEUVZxUdt+GpMseEq4jeBLNjqpCTUjp2L9n7zAYB/3CfN4dQXz
 5q9msYlL
 C3qrQWtAnid9IBYhHTVjH263rNIoZUz1dknKKBXvBd3FEpsRZbKLr7sKxpR6DPoLrFtKvagTscJsPQIeajeHHcjPnzTYLsmrx+iZZp5YNkghbyyyYWBFtXRvDljaBKLITmX9srvMN3mreYBY2qmtg+GCCCtaK0alC3bO6TA0TEgjrwE7+hOL9hGuedsAZMB8tHu67VwfGZYigge1rINalZcWkQbbV38uLVPRFS3pamaACuYnfpiat1y97xgtBWmZCzGprSQAhSAw+FtGmm+3PYQKl11Rpl02rgmChw9twF2uXKqwaWUkdlpMwhMvptkONV4W8/dB27e14rP6N8cM4W48Cn16Iv7f7S/pmA9FA7J4yFh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 06:54:18 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed, 29 Jul 2026 15:05:10 +0530 Bharata B Rao <bharata@amd.com> wrote:
> 
> > On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> > > On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > > 
> > >> This patchset introduces pghot, a subsystem for hot page tracking and
> > >> promotion.
> > > 
> > > Can DAMON be used to do this sort of thing adequately?
> > 
> > That really depends on the goal I believe, let me expand...
> 
> Thank you Bharata, this clearly explains me your view.  I find a few little
> gaps between yours and mine, though.  Let me clarify below.
> 
> > 
> > DAMON can indeed migrate hot pages today via DAMOS_MIGRATE_HOT, and
> > IIUC it can even do promotion and demotion together that auto-tunes
> > to a target node utilization. So for someone who wants to write a
> > per-workload, per-process tiering policy from user space, DAMON is a
> > good fit and I don't think pghot competes with it there.
> > 
> > But the intent behind pghot isn't really to be another migration
> > policy. It is to build a common in-kernel infrastructure that can act
> > as a single promotion subsystem, fed by multiple sources, with the
> > promotion engine and its heuristics (rate limiting, dynamic threshold)
> > living in one place rather than in the scheduler. Hint faults are just
> > the first source. The IBS Memory Profiler, which gives access
> > information directly from the hardware, is the other one. CXL HMU can be
> > another potential source. Hence the design centers on an exact, per-PFN
> > record that any of these sources can update, rather than on sampling.
> > 
> > The per-page, source-driven model is where the two differ the most.
> > DAMON estimates hotness by sampling one page per region per interval,
> > which is low overhead and self-contained, but it may miss a hot page
> > inside a region.
> 
> DAMON can do [1] fixed granularity monitoring, down to page size.  Of course it
> increases overhead.  A few people are using DAMON in this way, though, and we
> are working together to optimize it.
> 
> > pghot records every reported access at PFN granularity,
> > so it does not miss, but in turn it relies on a source to report the access.
> 
> DAMON is not designed to use only the single source.  We started working [2] on
> extending DAMON for multiple sources including AMD IBS.  A few working
> prototpyes are shared.  We plan to share the first version at next LSFMMBPF.
> 
> > 
> > The other practical difference is that pghot works with no user-space
> > agent at all. With numa_balancing=2 the promotion just happens, and in
> > fact pghot takes over the mode-2 promotion path that currently sits in
> > the scheduler. DAMON, outside of its built-in modules, expects a
> > controller in user space to drive it, IIUC.
> 
> For a level of auto-tuned hot/cold pages promotion/demotion, DAMON-based memory
> tiering doesn't require user-space agent, either.  Only a number of simple
> sysfs file writes are needed at the beginning.
> 
> > 
> > So I would see DAMON and pghot as complementary rather than one replacing
> > the other.
> 
> I have no strong opinion.
> 
> > In fact DAMON could well become one of the sources feeding
> > pghot, and conversely pghot's batched, rate-limited engine could serve
> > as a migration backend.

One thing to add for clarification.  DAMON is not only for monitoring.  It also
provides a general access pattern based operation engine, a.k.a DAMOS.  It
provides auto-tuned rate limiting (a.k.a DAMOS quota) and flexible filtering.

Hence, yet another imaginable way of the collaboration is plugging things in
the opposite way.  pghot's multi-source access monitoring becomes additional
access check primitives feeding DAMON, and DAMON serves as a migration backend
with its auto-tuned rate limiting and filtering.  I proposed
damon_report_access() in LSFMMBPF'25, suggesting this kind of collaboration as
one of possible use cases.

> 
> Makes sense to me.  If there are needs, we are open to add new DAMON APIs.
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/faq.html#can-i-simply-monitor-page-granularity
> [2] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
> 
> 
> Thanks,
> SJ
> 
> [...]
> 


Thanks,
SJ

