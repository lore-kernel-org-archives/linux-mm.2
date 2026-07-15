Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C42C4450E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DDA6B0096; Wed, 15 Jul 2026 12:03:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E946B009B; Wed, 15 Jul 2026 12:03:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34FC6B009D; Wed, 15 Jul 2026 12:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD8A6B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:03:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1985DA020C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:21 +0000 (UTC)
X-FDA: 84991480602.20.97A1653
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52B7A4000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTe0PVEt;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4C6n0w9mDrtHRCnStTGRTvpeLhmwUbbHGkqcxBvTik=;
	b=6G2DRLRKkxCYDRPUJ7eCyQBYXH24idxy4q3P81UDqg2NcLNjsKPCL2FeN0AbDffF8p+JBB
	DuQ8iBis3ITOWeYKEgcD1Iix5JmP+TpaBzWlUYTHwnJiErJG3Zx6uZMFdcMqruCMHRAgKF
	JsH36JOOaJkV2/KgVLWjuk5ZgZjW0hY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BTe0PVEt;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784131399;
	b=lLHAmQmt+bvPU1QtBCqF3UfYcpasitD1XLHgpfMULoCQ004YzFN+4NHYOp1xoePT7Yhmwz
	rlsVG4ax7dn8Q5bQpgNbn3Of/oyIqQnJf6Srb+D7VCvlUYfeJmXYd5VVO1MAEhWqkgoZaU
	/e10lo2f3LDCxR7WQsdii2OeWJHeojA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A387432B5;
	Wed, 15 Jul 2026 16:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD31F00AC4;
	Wed, 15 Jul 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784131398;
	bh=f4C6n0w9mDrtHRCnStTGRTvpeLhmwUbbHGkqcxBvTik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BTe0PVEtIUgNNd0HJimWRQQVEEPMbL5+bzLWuypuzi9NIZDNIO6kUqirtSxlAWLFk
	 PrBLqf5Yq1l3QU6VH4iviptT0e9bRWpUM/uEXAasgR77pKC9z+vQd3N/ZT12gq+TOA
	 iSjdO6i4rRi3jSv2zcy+p4iHl9QURtzFzqcQgPTQEhJK2/xGqbUIZZT2Vi6+Rct4P3
	 d+GhP1nj6V3srM5djsFI26cexSh0CwKsIKZqFVpU6Sr6h376esJkNnOtKiwg2jmpGj
	 k+k3ZxxMJZcOYT4zJ80nQ91avqazBAS8yWXPX8UPGPMQCt3fqQNPTCHC8TVxaX0t6I
	 khlJo9zamFdrw==
Date: Wed, 15 Jul 2026 17:02:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com, 
	akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net, dakr@kernel.org, 
	jgg@ziepe.ca, kees@kernel.org, leon@kernel.org, liam@infradead.org, 
	lizhi.hou@amd.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com, 
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org, 
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org, 
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org, surenb@google.com, 
	tzimmermann@suse.de, vbabka@kernel.org, dri-devel@lists.freedesktop.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <alet21wLwM6P_Km2@lucifer>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alecaJ1FUso39D9k@skinsburskii>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52B7A4000A
X-Stat-Signature: 38c46k1ete7b3ot9isirbb9ex9pad15e
X-HE-Tag: 1784131399-871912
X-HE-Meta: U2FsdGVkX19lfVnjcg/WuKoBW9narVqnxSxbN/unoXUqk1JTGnpLq84HdSDwjl0QJyj+5ZPNbBVZflJFO4GHQwewdQ7TtWtVuEBcjPctF2flpjgHgwj8GqGot5S2tLTkOnNd/3mIgedHIjag9obFtrBcr0JwYwwNtYEHhVLfhkjXMyHu8eayyPE/ou2/M5PlebeYzquXw/7TWIkhzkCAmTWc7e8fVwksybERSYhhA31n6vI9yVdTGnuhu9d0lume4Q+NLHwkDgp6t/s0dl8fIFWv6G7ouAvyVgHfQTagWBNy4Sv5hOeUpivc1IX6JGn1Dz4BL28qLtZdHvsYbHbcTeni79MB801p93RDumHUCirlf6nBC+Zko4TUxpeMVyMfCgS6yosSyJg/P8X4fhpIQDyEhvMQPKCT6K+6QPSUEnveU+5GQrR3PRzpfJoLkWlP6cpVT2lCemmde0udYv09CwAH8LeA5QmWuY4drDathorb0lca+7yRRlCVWmuC/mXMefcFzmThkpEsokUbI/ktby0BtLy1PofYs6F+WQeKu6HsG5qVRFIf19gt2byel6eeEjMKijDOofLPUqdLYeat4waWMuva8DYu/t3hY3lUaFW72RvbeE3jXcDSG8PsBy+5mn1cUPZvugtlqfsKXrJzIOv1RLBk8QgAfzAbSdPmv0abDcZyT4kTm7WWks1dyljm1++qzZm2TJqtPd6HN5vHYLq0XZoF/Y0dvAkpDmDTV+IouCgGH/kyJimmt1Xnmo04Ak8qN89i0YFrNtV9/y7qBhMGAi1SCMQQj1T9Xwrr8Vj4qEbru67MFCdBhRl8juKun23xy7kbTTeD513Q1psiqy8t3Y1bVHE9eGBYEXLatNpIAO0SP4QF6uRb/hHc9TDUo+S8EvSOC7qJGJvfmMPOf2cmUJiSZFR/q7gYNXXQwVUDLFFRlPUGHL4oZ4Ct7+cymXOUz45XojH+kd4EaIn
 BGxakFhk
 pv/N6xNjHYtYjat3wUYoHooc6gCELnZ8ED9WH/x5d1JdztRGPXJpHohkewZ+fbb1aAYKeYwDY5u1ixOdVY4TIs0iLTUmlmR8EASVJAFM39WoGU2Dr7PZVIQICB9eLj03THTPz+ROjuwIOljmQQ7qqi9kzmx5nwlc1y4eOqFVXG4hHFdHzAw3SvV0xHQBWZBytqPMotinUxkUQvTmOgRSQsZs39wsgTicq9MhmC7QJrqwiLK0ePGhNnmQgpa6A2KSK54LkBfmoneGU7vBkJyrh37YyfJP0nTvwdPU4tMuaVuSC4M5Ve+/MbKVRBZRvb8hSxTmSMAx+lvNWxJ6xcts64qoTpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid confusion: obviously please don't merge this series Andrew.

On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:
> On Wed, Jul 15, 2026 at 02:41:43PM +0200, David Hildenbrand (Arm) wrote:
> > On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> > > This small fixup series applies on top of:
> > >
> > >   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> > >
> > > The first patch updates the HMM documentation example to make the
> > > mmu_interval_read_retry() state explicit: callers should use the notifier and
> > > notifier_seq stored in the same hmm_range that was passed to
> > > hmm_range_fault_unlocked_timeout().
> > >
> > > The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> > > timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> > > HMM retry budget. These callers no longer keep an absolute deadline around
> > > their outer driver retry loops or pass a computed remaining time into HMM.
> > >
> > > This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> > > HMM succeeds and the driver later observes an invalidation through
> > > mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> > > retry budget.
> > >
> > > Changes in v2:
> > >   - Kept the nouveau outer absolute timeout around the
> > >     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
> > >     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
> > >     fault worker, so userspace fatal signals cannot break an endless stream of
> > >     invalidations there.
> > >   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
> > >     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
> > >     never 0, which would mean retry indefinitely.
> > >   - Updated the nouveau fixup commit message to explain the worker-thread
> > >     timeout issue and the time_after_eq() boundary behavior.
> > >   - Fixed the amdxdna fixup commit message. It now describes
> > >     aie2_populate_range() correctly instead of carrying stale nouveau prose,
> > >     and notes that command submission still keeps its broader timeout while HMM
> > >     gets a fresh relative retry budget.
> > >
> > >
> > > ---
> > >
> > > Stanislav Kinsburskii (4):
> > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> >
> > Why a fixup series instead of properly resending the full thing?
> >
>
> The goal was to get a Sashiko review, and v8 has already been applied to
> both `mm-new` and `linux-next`.

Please don't do this, this is completely impossible to track for review :)

mm review is currently very difficult based on volumes, it'll become impossible
to manage if people sound fragments of series.

Please just resend the whole thing at this point.

>
> You can find more details here:
>
>   https://sashiko.dev/#/message/alaWmUEeIBeSkmO0%40skinsburskii
>
> Thanks, Stanislav
>
> > --
> > Cheers,
> >
> > David

Thanks, Lorenzo

