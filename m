Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BA3FE5202
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 11:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248BE6B0005; Fri, 24 Apr 2026 07:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8926B008A; Fri, 24 Apr 2026 07:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FB56B008C; Fri, 24 Apr 2026 07:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F11E16B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:14:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41CCD1601E6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:14:54 +0000 (UTC)
X-FDA: 84693192108.22.78BE1FC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5BA8AC000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:14:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uujKu3cf;
	spf=pass (imf22.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777029292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nxhobJIEqRPMXJNaKk3lQ6NoKAj8IkBVR0FHTowZBw=;
	b=Ui/61RAxqx++QNDg/gwU+VRD16D1kzAmO7SoLilm8b3xKa9JYZE1d2p6cMERHmHdw59gHX
	vYBmyjbw5HNzvWTmh3eaGbsMag8ENSYP8cXH9T1sMBD8XcjdvKwXWRQab0c7MIzi/h6Vmq
	CVdrGXCMapsaf7ye95+RGeHy6WRzMSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777029292; a=rsa-sha256;
	cv=none;
	b=LEcGcnRvvBlDfR8eW1H+zEk97fcv1cWugmxkg/8fBa0kt6wGh7Lz6ixhgJhu1Pi9Oh2jWQ
	oxwG4k1VjyP6QzZONNiD5XdObvMHhgei4KfYJqHEaCT3sr8bGd+ZPoM1hjD1yJMH8lUHey
	S9q0tp4WBI8oyjyoRRU6VRMzhpt+m+s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uujKu3cf;
	spf=pass (imf22.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 24 Apr 2026 19:14:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777029289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8nxhobJIEqRPMXJNaKk3lQ6NoKAj8IkBVR0FHTowZBw=;
	b=uujKu3cfZCrIAwlGqAVxSFfErknaSpXGBuDAe2HoHz7u9UEM1kaw9otuktgVxsOvP4LsIX
	DI6NDkjEvIcjxbFiv7WfScKJ0cklj79gzgNOzoaYIeqH93JAqkbzYZwjntCPMkfel30YRj
	SjZhjVufLMOW9iTxjG647Li6GA3+AB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Li Wang <li.wang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tj@kernel.org, longman@redhat.com, roman.gushchin@linux.dev,
	hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, mkoutny@suse.com,
	shuah@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <aetQn9H_0Hi-4jht@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424030605.6d0053c0df14bba325114e1b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424030605.6d0053c0df14bba325114e1b@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zxee9nfig3aat44gh87dazh6z9uymgs1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5BA8AC000D
X-Rspam-User: 
X-HE-Tag: 1777029292-123339
X-HE-Meta: U2FsdGVkX1+5R7Z0gz1DxeOGaSe7axkeP56m+T3H0msJArwGFfoJSyNIQAQwdaMw93VTfLaol/YxQsL5g4P8bHtN1ZbDfk/acVgseGrScKmMCwZ4r3S2mZA3r6hnQjdsd4FMKkBBigFHobuF9N7LXdbQ7r7uGBBrTl8uhYQcMbi0lvOkk5fCZkwFPbUQ+ElEUrP5uKXnPGqhkDo7JeCPcYrkmbV1TNFRamdLNcfvUA3j7BeJfb7kzWRB0ovrTAHUEqPakaBZAVDfJCz7VU7D6m0W7mv41UUHOL4Z1zD66kdIXgxVJH/lq3aSSEhq6mkNU9vC1faYPOi+U6N0pwOUZEsqfr5Q0u09ZBVNcJkqEsqdwYnZPj35i8Qr+VuhzwxEOu8ZprBYLoUru2dpkVPg6DwyDSTjTeFkc1u0chPoqDdITDtQAypbPCJ1WUJEbydZPep47hpHEXwhAyuOW0RwPR+o76N4M6UkYoSqlZpzmzHjjmDuqpDlTl/JLeT6fWDcdmTak51yGwJZ9JTjUu887LMbFgZaNLZeDNZGnSMZV3ZeSanAEjx0OOYj1rhAUpdvsUanLazdOWpQQNWIfHj5tiZuk1lyfdK7PD4uVN93WQ6yKhQdWd+TNIxXrpJVe4dVySwmMRfWHiQr6tCN3QXrRNIbH7yQtTdoEqUUUTbjJ66r8ai2RTqaCXhF53aUBPTSvNVgzHN47Vs7mEqQRXE0bnqvW5j6G+FfVy7/7j6H2wK5MmhHEnvROfwWwF+g/nlXixqx8P6QgJqYiMQUKAun3wlECqf7OqvjGqcQe6peQtlIHdk05vMqlsshnOYRwG3eWKr0cbvNTnLcFP11SCcZPk2bsouCW0iAWJux0zy/+s37C4mUhKWVEmvoa4CTU0ooRQk/1tTTnE2NvzKWSjOR7vPIsKfQiHe0n6mMHSW4m5PDq6Zj9XCkfRgxWxSNlbUkvARSO42E259YVzoI2pG
 nchsPO9p
 GSKcT3Dvn6u1A4q2LiViEECpuljMj/9lbZ3WjUABLwMAOu0I4IF7bD5yT4W57AhIpOM404ukRsW68+vSrPBby4hFcjOFk8IokEIwGJkSGpVOm65rZs8QA9hHJO47JCXd7gzOK/EwC91AHohONdRcswchO4RhaMpDyLsHsW1Vpyd4lcEJaNlJZW1LyUcxDuPfEPs7+drPsaxKUSKjGTuQCnKFWoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 03:06:05AM -0700, Andrew Morton wrote:
> On Fri, 24 Apr 2026 12:00:51 +0800 Li Wang <li.wang@linux.dev> wrote:
> 
> > This patchset aims to fix various spurious failures and improve the overall
> > robustness of the cgroup zswap selftests.
> 
> Great, thanks, I'll queue this in mm.git's mm-new branch.  Next week
> I'll move it into mm-unstable, where it will receive liunx-next
> exposure.
> 
> > The primary motivation is to make the tests compatible with architectures
> > that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
> > the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
> 
> Well that's an oops.
> 
> > On 64K page size systems, these hardcoded values lead to sub-page granularity
> > accesses, incorrect page count calculations, and insufficient memory pressure
> > to trigger zswap writeback, ultimately causing the tests to fail.
> 
> I assume you've been testing on arm64 or ppc?

Yes, before sending, I teseted the patchset on:

    x86_64(4k), aarch64(4K, 64K), ppc64le(64K)

-- 
Regards,
Li Wang

