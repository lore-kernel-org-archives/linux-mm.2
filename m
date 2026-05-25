Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF239CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191BE6B0005; Mon, 25 May 2026 13:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142616B0088; Mon, 25 May 2026 13:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0583D6B008A; Mon, 25 May 2026 13:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E58816B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:46:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81FCCA019F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:46:51 +0000 (UTC)
X-FDA: 84806672622.08.095BE0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B480620013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:46:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Va0e+LQc;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779731209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dZDc9GDzI0pN6F9b1XKxluJTPGuu27MglLZ8HYeE1c=;
	b=VdJHbk/7hX8rDS/u/UAoF2FLUa7b6fAOD4ax6AHnrxmJ6DCr5UxcVSCVn2ZnCTy1Mp9bo/
	cu1wFEwCNDMKHiF5mG2iM3s6z1rmn6hOq7IUCnThPoEU+Z0nrDXtpLqfvrz3y5IobXiBDj
	bpm/0i17lP+EJEipZ9BPuxPDHdf9ijQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Va0e+LQc;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779731209; a=rsa-sha256;
	cv=none;
	b=jdajTQ9b9gFrpKgVPzzx367K4dHfpiNP3fRpm6qpCwLgMqfhREM5aldOJT6xpBsglvRF/l
	QyabU82TsCkd9z50E3UWe8tbfGhUW9YJ44ugxJuGtg7rxJjcAKycwNCOwMIHaFnZNgHW+z
	0z/l03M/GN9q1xuyi0Za8aY024RmK/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A9A940AB0;
	Mon, 25 May 2026 17:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05E01F000E9;
	Mon, 25 May 2026 17:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779731208;
	bh=4dZDc9GDzI0pN6F9b1XKxluJTPGuu27MglLZ8HYeE1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Va0e+LQckA05fwwX8igHgzU3UuDxvJM32eJDHqt0gHCr/h387ku0A94ouqy8H+ewO
	 cscPHOj2IZWWAFMsi1FnnqNC+6JmSSlmTP8xfc/gh7eQjPudTUxX7jbJMH+4KBRGo5
	 QQKrDgTb9X7LCg9JAz9vW2xjSA0mOI/uLA6SNw9pvQtHy4t8bWg3jSQTnC+Ni44TX8
	 QKiuS6Mbwfu2KjiceBCqEglcqCOZIpV75HziWeJxbh2wMgoSJgMqmOr+Aav8RLCwMB
	 a3a1QHBiDGIcZj6hJDKJP0H5nQUg2R0U0bk8vm/CV4437974Uf0x7hWXUiXwWqqUhI
	 +wl/XBPYAEQaA==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Lian <lianux.mm@gmail.com>
Subject: Re: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
Date: Mon, 25 May 2026 10:46:39 -0700
Message-ID: <20260525174640.9440-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260525144846.604907-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B480620013
X-Stat-Signature: x6b5yax48wg5yeb9c37qeiqm4yzkdh5y
X-HE-Tag: 1779731209-243635
X-HE-Meta: U2FsdGVkX18iW5u78HCmDsy+4b4pFXkPm/1roPhEd8eXrgr0hlnL6AQxSLoAIJZyH1LbD7r9vKedD89SGe5k04uQJsuv6yoQbuqqzj1wrkwU0UveJK8P57WWnvSJXswISWB2vxjFoYokCvjUcJhGARxshbx/Xjnob7299BcyXh9DsZnWfy+figenFom9uNac4pqNlkTKgS7JgE1NATHwlCOdg8qRrfr/XSct6DNWT6RxgHpXwC/z8pUNbGmbgLYNCo3stW4MRSjySq7uH3MjMe6oSch2T3ZcC46wuUXVnQSwHUzCNf7xBMa1mgoWD5i/DY1lGOKOnkWfcfsae1Qoh6w/3AJPGnWcF3LjaFeHMq/UAjebo5FlBuAYKeSKHVD5YNIbK1MmUHlapH09WzMcN+8G+ESmxm9nKI897C/bI2NdcnTht6qQNpGNID60Y863RMIXWf27ei8oGspL78aLXL71SGFKlyauCvFiXRbk2p8v6/iCSe0Ii9IfXZHBzd/cojC1k/EcnKJCC1KScHMvBH9aLqbmvmAoOg2WvO+y7UkCrPeqaZujjxzrIXq4h0TUURHUChxG3dW6cGGOmf/LheBjXiMHsUZ/bY5udDjw/4jFNAdzIwf4hYjz7GXaWJmvzxOfCb1YpuGddQLECWSD2pCm7jynNb+zDAV66g42SwiuV+Ts82d7H9eq5FEAN3iSFvcJ/Sl5oufLBb2MpO8w4PBXfg9IRLS1FXPqvm4jPFurlA7EC/kt67IjXjOBqR4D3FAm7MucyMnxBeLSiraQCqJ8UT7S5RXA1I0SOEdQC/8yN9H7Y825IutgaYE5NkpV1y5XCzThbCw9JcmKIRA/viapxUXA8ZuaZCF3U5grf7aSRSf2ZxIqqjK+sIiWQrZ8I9tmaxFjG6HfcPHRcNi3d/3TPSrzal9dme8+wJ/Z5JvZ20OIt1gNHMj68KYADoan6sVp9+f40NlTN6pVBQC
 iC6AJdcy
 7umwHFB3CAVOByAfXjTj9QXtZqQ6osDMYx9jlVmbKgiJ6mhQfj6QWL+uSjhKHQ8x0y6qwauE2epPZSsFT/YHtH2ZeiJQC9pvi3gqBWO7qrmLHvXHOdJbN89DMDJg/ckMSVmZIsuFPnL7TaMv4jVLnLCAyXlhhUjrn7T6Ckr0R4D4l9I2GmrhH5aSy1+7HvBAwOwB+1XF+oY69kBUbUwvFYMxYXGpb+vBtkK7RPYpY4LO23xPAyRFPGz/KehXasLZxdVyAhukatBXlKLJbnkEt0e0Kcskn9x5eZvpjDSsxgZZvjxV/kVUreyXor1106dbbNIUvmjbjQeFdyWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 22:48:46 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <chentao@kylinos.cn>

Thank you for this great patch!

> 
> damon_ptep_mkold() clears the PTE Access Flag so that a later
> access will set it again and damon_folio_young() can observe it
> via pte_young().
> 
> On arm64, however, ptep_test_and_clear_young() clears AF in the
> page tables without invalidating the corresponding TLB entry.
> Subsequent accesses can therefore continue hitting a stale TLB
> entry without a page table walk.  The PTE AF bit stays clear,
> pte_young() reports false, and DAMON treats the region as
> unaccessed.
> 
> folio_set_idle() does not help here.  It updates only software
> state, and accesses through a stale TLB entry do not clear the
> idle flag.
> 
> As a result, nr_accesses stays low regardless of the real access
> pattern.  DAMOS schemes fail to match, WSS estimation reports
> zero, and actions like pageout never trigger.

You are correct.  Nonetheless, we intentionally designed DAMON in this way, to
avoid the performance overhead from the added TLB flushes.  Meanwhile, we
believed this is ok in terms of the monitoring results accuracy on real world
production environment, becasue such environments would have large amount of
working set that flushes TLB buffers anyway.  We decided to take this way after
a measurement [1].

And apparently you found this behavior as problematic on a test environment
that having small size of working set.  We found a similar issue in DAMON
selftest, and we updated the test [2] to simulate the expected real world
production environments, rather than changing DAMON.

But, this kind of question is recurring.  In addition to the previous
discussion, there were a few private inqueries for this issue.  And though the
real world production environment is the priamry target of DAMON, I understand
it is better to support testing environment, too.  So, I think it is better to
make some changes for this issue, if it doesn't make other problems.

> 
> Fix this by switching to ptep_clear_flush_young() and
> pmdp_clear_flush_young().
> 
> On arm64 these perform the required TLB invalidation after
> clearing AF.  The invalidation is deferred, but still sufficient
> for DAMON's sampling granularity.
> 
> On x86, ptep_clear_flush_young() is equivalent to
> ptep_test_and_clear_young() for base pages, so there is no
> behavioral change.  pmdp_clear_flush_young() additionally performs
> a flush at PMD level, matching the existing x86 implementation.
> 
> On powerpc, riscv, and s390, the clear_flush variants currently
> map back to test_and_clear implementations, so this patch does not
> change their behavior.

This change seems much nicer and might be more optimized than my simple
implementation of tlb flush [1] that I tested before.

> 
> Reproduced on arm64 (128 CPUs, 7.1.0-rc4):
> 
>   before:
>     WSS estimation: 50th percentile error 100% (reported as zero)
>     apply_interval: schemes never tried
> 
>   after:
>     WSS estimation: 50th percentile error 0.08%
>     apply_interval: passes

And nice test results.  I guess you are referring to the tests in damon-tests?
Clarifying the context would be nice.

Also, have you had a chance to measure the performance impact?

So, I'd like to have this change.  But, unless we have very clear evidence
showing this change is not increasing the performance overhead, I'd prefer
making this as an optional feature.

For the user interface, we could add a new sysfs file for the option, say,
'flush_sample_tlb' under 'monitoring_attrs' directory.

For long term, I'm planning [1] to extend the data attributes monitoring
feature so that data access becomes just one of the attributes.  Once it is
done, we could control this tlb flush option using the probes interface.

I was initially thinking about asking Kunwu to wait until the data attributes
monitoring extension is done, and add this tlb flush option on top of that.
Because, otherwise, we may need to deprecate 'flush_sample_tlb' after the
extension is done.  But, we will anyway need to deprecate a few interfaces
including 'nr_accesses'.  Doing the deprecation of 'flush_sample_tlb' together
with it shouldn't be huge amount of overhead.

So, unless Kunwu and Lian has other concerns, I'd suggest the
'flush_sample_tlb' path.

[...]

[1] https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com/
[2] https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org/


Thanks,
SJ

