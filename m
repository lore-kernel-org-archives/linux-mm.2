Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A8DCEB3638
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C276B0147; Mon,  2 Mar 2026 16:12:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEDC6B0160; Mon,  2 Mar 2026 16:12:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1556B0162; Mon,  2 Mar 2026 16:12:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486C96B0147
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:12:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C2CC1A0111
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:12:33 +0000 (UTC)
X-FDA: 84502371786.08.2153FF8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id E085B100005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:12:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YJlWOU4B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772485951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVVzxO6qll6Sq7IP7bDQEDa5PovQmboJcOaTVrG/35U=;
	b=2GQcW3IJhPXzz1n2hMojWJytVlTyYZKw3au9SApDqCuH3DY3ddvEzjHpi5Fobd5j+oVQT0
	oaVsElMelrMVbu0tGS+7nMA6RNd5CCBIbQcH6tetSLQO/vBY1Jym7Xl60JZADZkC42dXSK
	lykfAguDifVgytW0PVgVu0zJHWhRVb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772485951; a=rsa-sha256;
	cv=none;
	b=NS/4TCQH4FOG/52EsDTIDH4/l9AmC6ikhuIrrmjk6CelvS8QAFURuSM2LWciIpyRJELr02
	QaCW5cC8QzfzgW6gpvmHXAvu5tKax0N8FUPkzNWkLcpY3vBp3RYXNkU3HjGH6yxFkIOMkz
	gNsmpQQSF7hi41nv6zPSb95gT9T6S18=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YJlWOU4B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772485948; x=1804021948;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=e9qgGxTXyKZXvSTGsfRVSDjwwJy5ffmmFv4ZhQLLvXE=;
  b=YJlWOU4BECXPcrzntRomIaJk3o8aplSicADyHh+Drs7rv9TfROkzSRTu
   VKjdLCM6doS/4yg0+4z6Cc1iVoHvQ3pl3oBux6WiVl9HJFCzzqiktHRX1
   xDk5O04wtwinAQ8NfXuh83oBCipuQNIDL+x0dfmbeCOJ2EOmLDpX/n9nQ
   uhgIi/wtaki8MdyKYonrW2QUbNi5LXC57E8YmZDV4tjFrSNDDX7tHcVy9
   f0EVov9PYBTdNzu7SlE/jpzIq/TcdNqLgoGggG65w88sx0NWXiiZWgzf0
   XVta73rmVMuBgSdYFO6/EpsoH5GHFI8Pt0oirYsUBE+Ivzjl2lfcm5KMi
   g==;
X-CSE-ConnectionGUID: c+W2o+C3S3CbM1WT5FBrHw==
X-CSE-MsgGUID: kMtQ4ck6Qqyt973OjujVQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73376335"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73376335"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:12:27 -0800
X-CSE-ConnectionGUID: bZECGHLFQtaQhGl1NqFoQA==
X-CSE-MsgGUID: 6pvBMChqQv6fCsLO+LqgTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255644179"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.244.183]) ([10.245.244.183])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 13:12:24 -0800
Message-ID: <16bd843b09103e2b427b78bfd39aab2606f8627e.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>, Andrew
 Morton <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Dave Airlie	 <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>
Date: Mon, 02 Mar 2026 22:12:21 +0100
In-Reply-To: <aaXpgCUVXAKCfVCK@lstrano-desk.jf.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
	 <20260302163248.105454-2-thomas.hellstrom@linux.intel.com>
	 <aaXpgCUVXAKCfVCK@lstrano-desk.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E085B100005
X-Stat-Signature: 1h5xdfdytwe97wkc3ie4o7q643d5de31
X-Rspam-User: 
X-HE-Tag: 1772485947-310196
X-HE-Meta: U2FsdGVkX18IQT/I9GD2PusK6xBqk5lsD99YaxjwHqFIeD0Oe9n2YlT1lJgye6frfJY84lmi4b3KazXsnb24H46olwe39Jx4cMQiwE5ZUaergL78I6k7x7oQA9jppfnyi9xClkyE2+RbmnJuOAlR9u2ezwrdZ7IzmwLMR1CXns2eU8J/M0QEDH7AKIirQvx4L8eE+Qj09lqFVfn0VOtkK/6HXeHopWBwNWzUoUN3rm8GeSN1K0KBgHYWMa8Aj82h2/ejrM9m6hlyFJ0J0n94P4qxS8LhTdbkFqFutkBkeZbkbePymv8Qht8YkshhCXU2ieEMak7MYxkjLEYrCsvR+sjvnLuWQ/P68VGHn09+u+/sdH+CXpVxHRnOKQqNE0yKhnh/9XU2UiPYmeVn0CANQFTcykk6NEj5q6Umb9q7/u9yuYlrVjZ/G/XVt5wVnQ+l+l1IPgjEQxATCsluEghf4ZDllACinlUS1StCqCCiNQYpmHzOgZOjD1xMbZSk1WUkuDpLC2fYLvEC1xmoE72QJOZFymZoirq01gY+qARVtbvbT3BO+3QFevJ1E2FXApVhhN351ikelf3rkjoMpft87TaINnzx9/HAEiipTkh8yZ+3A+oFxUs9pkEjKNxlDLS75slby+eoGSGjPHYkh0MKfFj4wU3AwhSRh768Kdudc3FkHQLt5oGjj9OR85wQDkOKPFHrnSbVUigvHZqoO8PGElQhR+qemp5Utg38bVNXSkBv4RHhweGSHBWqn1txPDCo2S818QJhrTY7J1KRig65YPJCcVDFxurZSQl78xPst/xQYCUI7+OuiKJYbj+InEMCWeU00bw0DPVDeRevZLDD0mQoByQEuQ/24pBuhvLmZz7oAFN+76Xn1jRFSFI/bSFdupVVE4nKhpH0duwr3jeA5wwpWfcW9k6Gbm1UdkXVF5H7ovcWtpq1GocZgWtd2JrIoH5aUCuVgiItWCUkrgo
 ef1j0CKr
 WL6YzUKL9IxL1NeU6er4ZTh/eTpQC4xOtLw8QP2xZL3r7wwvM9kbVQZ9TeEdsKCEmMXPqbb/d2gIfMlFnhx8rpDWCPoYVuvSns3A4P7B3Wg2jqfgh0BeyJO3iGFoeRLNDew/ihh/ydedMOuR7KI4/FOJ0AfrjWQi4RN6MLZnrh+LhnFF6UNH9qGWRtKfirV+VglKfyEDZVflihW637Rv0i6oBNSlFdkBRlVjc5GpLWkOrifE2XS+LYf/uWALXWwR/el70+l6tWimlGkGx00vUJOVk9JUjRFF5dhY3lvx4t+GeA5d65dELikmyQdAmqo/1CAvjL3eJZPifYUfs+Vv9dBWucLfm68lDBx35LjfdtRIpGr5qAltL3mjNbRuK5BVnQRt1cuEIYQYyuRz/zZgof4UsDgClw+Ze9PKY9SJHJifLBH6Nml9W1Q0VkD/ftcw0ZnNB7ZZ8Gr6Xu/sYqiq0pFIyUP+oTG2yBJkJq9rCugZ1wY92pQJbqnejsqX/ClEkVMInF9E7i+7ZvXMt9w5h+C4/A2WQB1MGe/f2dHnEb++itS3K+e+R4MFqAxXuzRIvfy+96yhZGDPJkW5CNY+0zZjtw6QwqD2fe/40mHqUz4Qn4OoJeYHDBh5YFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Matt,

On Mon, 2026-03-02 at 11:48 -0800, Matthew Brost wrote:

Thanks for reviewing.

> On Mon, Mar 02, 2026 at 05:32:45PM +0100, Thomas Hellstr=C3=B6m wrote:
> > GPU use-cases for mmu_interval_notifiers with hmm often involve
> > starting a gpu operation and then waiting for it to complete.
> > These operations are typically context preemption or TLB flushing.
> >=20
> > With single-pass notifiers per GPU this doesn't scale in
> > multi-gpu scenarios. In those scenarios we'd want to first start
> > preemption- or TLB flushing on all GPUs and as a second pass wait
> > for them to complete.
> >=20
> > One can do this on per-driver basis multiplexing per-driver
> > notifiers but that would mean sharing the notifier "user" lock
> > across all GPUs and that doesn't scale well either, so adding
> > support
> > for multi-pass in the core appears to be the right choice.
> >=20
> > Implement two-pass capability in the mmu_interval_notifier. Use a
> > linked list for the final passes to minimize the impact for
> > use-cases that don't need the multi-pass functionality by avoiding
> > a second interval tree walk, and to be able to easily pass data
> > between the two passes.
> >=20
> > v1:
> > - Restrict to two passes (Jason Gunthorpe)
> > - Improve on documentation (Jason Gunthorpe)
> > - Improve on function naming (Alistair Popple)
> > v2:
> > - Include the invalidate_finish() callback in the
> > =C2=A0 struct mmu_interval_notifier_ops.
> > - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> > - Use lockless list for list management.
> >=20
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
>=20
> I thought Jason had given a RB on previous revs - did you drop
> because
> enough has changed?

Yes. In particular the inclusion of=20
invalidate_finish() in the ops, although IIRC that
was actually suggested by Jason.

> =C2=A0
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Simona Vetter <simona.vetter@ffwll.ch>
> > Cc: Dave Airlie <airlied@gmail.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: <dri-devel@lists.freedesktop.org>
> > Cc: <linux-mm@kvack.org>
> > Cc: <linux-kernel@vger.kernel.org>
> >=20
> > Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> > Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > ---
> > =C2=A0include/linux/mmu_notifier.h | 38 +++++++++++++++++++++
> > =C2=A0mm/mmu_notifier.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 | 64 +++++++++++++++++++++++++++++++-
> > ----
> > =C2=A02 files changed, 93 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/linux/mmu_notifier.h
> > b/include/linux/mmu_notifier.h
> > index 07a2bbaf86e9..de0e742ea808 100644
> > --- a/include/linux/mmu_notifier.h
> > +++ b/include/linux/mmu_notifier.h
> > @@ -233,16 +233,54 @@ struct mmu_notifier {
> > =C2=A0	unsigned int users;
> > =C2=A0};
> > =C2=A0
> > +/**
> > + * struct mmu_interval_notifier_finish - mmu_interval_notifier
> > two-pass abstraction
> > + * @link: List link for the notifiers pending pass list
>=20
> Lockless list?

Sure, Can add that.

>=20
> > + * @notifier: The mmu_interval_notifier for which the finish pass
> > is called.
> > + *
> > + * Allocate, typically using GFP_NOWAIT in the interval notifier's
> > first pass.
> > + * If allocation fails (which is not unlikely under memory
> > pressure), fall back
> > + * to single-pass operation. Note that with a large number of
> > notifiers
> > + * implementing two passes, allocation with GFP_NOWAIT will become
> > increasingly
> > + * likely to fail, so consider implementing a small pool instead
> > of using
> > + * kmalloc() allocations.
> > + *
> > + * If the implementation needs to pass data between the two
> > passes,
> > + * the recommended way is to embed struct
> > mmu_interval_notifier_finish into a larger
> > + * structure that also contains the data needed to be shared. Keep
> > in mind that
> > + * a notifier callback can be invoked in parallel, and each
> > invocation needs its
> > + * own struct mmu_interval_notifier_finish.
> > + */
> > +struct mmu_interval_notifier_finish {
> > +	struct llist_node link;
> > +	struct mmu_interval_notifier *notifier;
> > +};
> > +
> > =C2=A0/**
> > =C2=A0 * struct mmu_interval_notifier_ops
> > =C2=A0 * @invalidate: Upon return the caller must stop using any SPTEs
> > within this
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 range. This function can sleep. Return false only
> > if sleeping
> > =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 was required but
> > mmu_notifier_range_blockable(range) is false.
> > + * @invalidate_start: Similar to @invalidate, but intended for
> > two-pass notifier
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 callbacks where the call t=
o
> > @invalidate_start is the first
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pass and any struct
> > mmu_interval_notifier_finish pointer
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 returned in the @finish pa=
rameter describes
> > the final pass.
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 If @finish is %NULL on ret=
urn, then no final
> > pass will be
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 called.
> > + * @invalidate_finish: Called as the second pass for any notifier
> > that returned
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 a non-NULL @finish f=
rom @invalidate_start.
> > The @finish
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pointer passed here =
is the same one
> > returned by
> > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 @invalidate_start.
> > =C2=A0 */
> > =C2=A0struct mmu_interval_notifier_ops {
> > =C2=A0	bool (*invalidate)(struct mmu_interval_notifier
> > *interval_sub,
> > =C2=A0			=C2=A0=C2=A0 const struct mmu_notifier_range *range,
> > =C2=A0			=C2=A0=C2=A0 unsigned long cur_seq);
> > +	bool (*invalidate_start)(struct mmu_interval_notifier
> > *interval_sub,
> > +				 const struct mmu_notifier_range
> > *range,
> > +				 unsigned long cur_seq,
> > +				 struct
> > mmu_interval_notifier_finish **finish);
> > +	void (*invalidate_finish)(struct
> > mmu_interval_notifier_finish *finish);
>=20
> Should we complain somewhere if a caller registers a notifier with
> invalidate_start set but not invalidate_finish?

Good idea. I'll update.

Thanks,
Thomas


>=20
> Matt
>=20
> > =C2=A0};
> > =C2=A0
> > =C2=A0struct mmu_interval_notifier {
> > diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> > index a6cdf3674bdc..38acd5ef8eb0 100644
> > --- a/mm/mmu_notifier.c
> > +++ b/mm/mmu_notifier.c
> > @@ -260,6 +260,15 @@ mmu_interval_read_begin(struct
> > mmu_interval_notifier *interval_sub)
> > =C2=A0}
> > =C2=A0EXPORT_SYMBOL_GPL(mmu_interval_read_begin);
> > =C2=A0
> > +static void mn_itree_finish_pass(struct llist_head *finish_passes)
> > +{
> > +	struct llist_node *first =3D
> > llist_reverse_order(__llist_del_all(finish_passes));
> > +	struct mmu_interval_notifier_finish *f, *next;
> > +
> > +	llist_for_each_entry_safe(f, next, first, link)
> > +		f->notifier->ops->invalidate_finish(f);
> > +}
> > +
> > =C2=A0static void mn_itree_release(struct mmu_notifier_subscriptions
> > *subscriptions,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0 struct mm_struct *mm)
> > =C2=A0{
> > @@ -271,6 +280,7 @@ static void mn_itree_release(struct
> > mmu_notifier_subscriptions *subscriptions,
> > =C2=A0		.end =3D ULONG_MAX,
> > =C2=A0	};
> > =C2=A0	struct mmu_interval_notifier *interval_sub;
> > +	LLIST_HEAD(finish_passes);
> > =C2=A0	unsigned long cur_seq;
> > =C2=A0	bool ret;
> > =C2=A0
> > @@ -278,11 +288,27 @@ static void mn_itree_release(struct
> > mmu_notifier_subscriptions *subscriptions,
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 mn_itree_inv_start_range(subscriptions=
,
> > &range, &cur_seq);
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 interval_sub;
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 interval_sub =3D mn_itree_inv_next(inte=
rval_sub,
> > &range)) {
> > -		ret =3D interval_sub->ops->invalidate(interval_sub,
> > &range,
> > -						=C2=A0=C2=A0=C2=A0 cur_seq);
> > +		if (interval_sub->ops->invalidate_start) {
> > +			struct mmu_interval_notifier_finish
> > *finish =3D NULL;
> > +
> > +			ret =3D interval_sub->ops-
> > >invalidate_start(interval_sub,
> > +								=C2=A0
> > &range,
> > +								=C2=A0
> > cur_seq,
> > +								=C2=A0
> > &finish);
> > +			if (ret && finish) {
> > +				finish->notifier =3D interval_sub;
> > +				__llist_add(&finish->link,
> > &finish_passes);
> > +			}
> > +
> > +		} else {
> > +			ret =3D interval_sub->ops-
> > >invalidate(interval_sub,
> > +							=C2=A0=C2=A0=C2=A0
> > &range,
> > +							=C2=A0=C2=A0=C2=A0
> > cur_seq);
> > +		}
> > =C2=A0		WARN_ON(!ret);
> > =C2=A0	}
> > =C2=A0
> > +	mn_itree_finish_pass(&finish_passes);
> > =C2=A0	mn_itree_inv_end(subscriptions);
> > =C2=A0}
> > =C2=A0
> > @@ -430,7 +456,9 @@ static int mn_itree_invalidate(struct
> > mmu_notifier_subscriptions *subscriptions,
> > =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct mmu_notifier=
_range
> > *range)
> > =C2=A0{
> > =C2=A0	struct mmu_interval_notifier *interval_sub;
> > +	LLIST_HEAD(finish_passes);
> > =C2=A0	unsigned long cur_seq;
> > +	int err =3D 0;
> > =C2=A0
> > =C2=A0	for (interval_sub =3D
> > =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0 mn_itree_inv_start_range(subscriptions=
,
> > range, &cur_seq);
> > @@ -438,23 +466,41 @@ static int mn_itree_invalidate(struct
> > mmu_notifier_subscriptions *subscriptions,
> > =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0 interval_sub =3D mn_itree_inv_next(inte=
rval_sub,
> > range)) {
> > =C2=A0		bool ret;
> > =C2=A0
> > -		ret =3D interval_sub->ops->invalidate(interval_sub,
> > range,
> > -						=C2=A0=C2=A0=C2=A0 cur_seq);
> > +		if (interval_sub->ops->invalidate_start) {
> > +			struct mmu_interval_notifier_finish
> > *finish =3D NULL;
> > +
> > +			ret =3D interval_sub->ops-
> > >invalidate_start(interval_sub,
> > +								=C2=A0
> > range,
> > +								=C2=A0
> > cur_seq,
> > +								=C2=A0
> > &finish);
> > +			if (ret && finish) {
> > +				finish->notifier =3D interval_sub;
> > +				__llist_add(&finish->link,
> > &finish_passes);
> > +			}
> > +
> > +		} else {
> > +			ret =3D interval_sub->ops-
> > >invalidate(interval_sub,
> > +							=C2=A0=C2=A0=C2=A0 range,
> > +							=C2=A0=C2=A0=C2=A0
> > cur_seq);
> > +		}
> > =C2=A0		if (!ret) {
> > =C2=A0			if
> > (WARN_ON(mmu_notifier_range_blockable(range)))
> > =C2=A0				continue;
> > -			goto out_would_block;
> > +			err =3D -EAGAIN;
> > +			break;
> > =C2=A0		}
> > =C2=A0	}
> > -	return 0;
> > =C2=A0
> > -out_would_block:
> > +	mn_itree_finish_pass(&finish_passes);
> > +
> > =C2=A0	/*
> > =C2=A0	 * On -EAGAIN the non-blocking caller is not allowed to
> > call
> > =C2=A0	 * invalidate_range_end()
> > =C2=A0	 */
> > -	mn_itree_inv_end(subscriptions);
> > -	return -EAGAIN;
> > +	if (err)
> > +		mn_itree_inv_end(subscriptions);
> > +
> > +	return err;
> > =C2=A0}
> > =C2=A0
> > =C2=A0static int mn_hlist_invalidate_range_start(
> > --=20
> > 2.53.0
> >=20

