Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACF010FC45F
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 00:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1766B0005; Wed,  8 Apr 2026 20:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03BC6B0088; Wed,  8 Apr 2026 20:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4856B008A; Wed,  8 Apr 2026 20:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 765886B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:00:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22B0CB7528
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:00:54 +0000 (UTC)
X-FDA: 84637061628.26.3CBD5AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 632EEC0008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 00:00:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n04EEiiR;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775692852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRSu2QWvv111P9ovZNOOU5jWRQQt/BPBHft0+vJIG+0=;
	b=kriuSeIeHPOzYgesiWsiK+276pj7aJA80UiRzBaLpljcOFLK3zncAsbvXTUQcIyKbbANtQ
	gEQLqu/Qt63wlmbTq3sT8EM83dUfnDLhYeWP1kgjom0cTJYE//Hll6LnQk9+Ak6NGvUocw
	MCbZFrxtwvbZGqn668LYf+Hr/t1w0io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775692852; a=rsa-sha256;
	cv=none;
	b=u80YkIY2h6BitOY86yOxJin8XFmbXnqKOpLS03ONvpn8tq5sdEyDjJM9k1WU0BhN8PSeSo
	+3iCz1qJVkr45m6TfpAlRzEJPqqQTmlyTNs0JvFDNdt6BOaGFs7jXX+70hI9VtXtjMDPkX
	St+m3W+C6Ji1AHqEWwb7rPXjRMxrZtM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n04EEiiR;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A28B4453C;
	Thu,  9 Apr 2026 00:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA1AC19421;
	Thu,  9 Apr 2026 00:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775692844;
	bh=qppp/68yL1FBDErK+oJASXFD51sGuVpQH4bDIkn6sd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n04EEiiRelmZ/SxG+FaURhv7uQcCIcGYP3/75s3NiC605Ngr69+aovYWbEwoH9NL1
	 yv4Xr9QeT2jBYiIIqk79Yj0PnEAaxmenTnicD0vVUJ2E/G1o+Q4HBV9EDvj+xAe4mC
	 LQRPF2G7satvRydNnV6IU0kpjz7z7my+VTNB/wVx8dt09yzYgiH+kH8S4o9koNhf1R
	 sK6YGvl4jitOVXt+b8jQQkEIWVLf9RiD+LM6JfkTNkKzwDaZ+GIe53rlkRPlku+kcl
	 2Fcy18YfoqTtqaHCs/Xj9Dn30F9fwUr1a8fhf9wszeQXe0h4dv/DoWtiqApmxw22Pb
	 6q4tylb2cHW9A==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 00/10] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Wed,  8 Apr 2026 17:00:34 -0700
Message-ID: <20260409000035.93742-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260408165001.8473-1-bijan311@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: e9so3dqh6bjkkbe1yd6917e5gmg1ouk9
X-Rspamd-Queue-Id: 632EEC0008
X-Rspam-User: 
X-HE-Tag: 1775692852-664047
X-HE-Meta: U2FsdGVkX18CznGhA6K/V5WRphPzMUSDzX7/MYjlVh2J8XwoDnQLxxe1gBAzwUuOV4Gnha7xmPTcFGk0LU4brG5XekdlZDQZ1v/9DuuzKmWjRYW3dnK+LrqZD31Tg5yd983727Eb4uaOUtK/xQPK4Tlx2Jf9Wwgkn38n0QvH0+lMidKY6PoCBlL+SUlU5TQEIMAu415vCg0s+QdteXcgoF59ebIZjpsMgc9BDNG1I56Vksglqz/0HxsQBtEOKB803KQe08dQz8Rv/fAnFQ816i5X9fh56g52mqAIR4JFBDkVG8ldUBy/lQ4tqTVg+ubtDLpnml0AEku0FjR2V9VsX6uvc4wasXbwSU0q80pxLzByQrLz+eZvwm0GeZ4XeNJYl28cxjj2EFvy33owv3akzGQMrYlhEAyMg9ccEi1mGz7/OWydGp40dBdhJ8dnIHyp4zB5Wsf/91JDmZPAt48sm+NIPjVdd7nh+DEvQJszsoooZ+I8oV5g2PlAQNUcDztQ3Nmx2Vyvg9rTHYjzBa+3yPNB82tkbRoBHqObadCqP5C0wyiuWxUOMH9rIjxjssm94LOtCKNJJKpimMbfv69s0+XPgB9/kUrHZzXnFxDK1osRXCqXagvGhtMlKmQU70Vd6vA+NFqvOxlB3EgG9ujwdYSqKkSABOehRQyX2qrDUSRXB8ENCcAuisdCdN6IlSSA5Q86iMcIFkgPcbGaX/Rw+SQnKkFyCWr7o7N0u4d3ayzs/dD8xYZKRFk/yTCHRK3Xo6NozxLxFKz/awWRczymXC+BMquPdffQRYTN81okEbib3gVmBL3swR48BIiJ2y1IWTZysqx/+f4HiyiO0wcUTX2ebIvzDxeXh9jgcq5uLG/PuwSXCt40omnfPPHI0AhgHogmhQDi8mbHA75Lv6kFs4vEBRSZZMA79zPFHPeqOEw8y4xJL7IB7ldHuHn4vz7FFR8rdSAJIckNboyPlth
 Vh+SGyxu
 /Er4NdzasoLP+W6ZXeZzWwJxognAwS3hp7hhqau8BExvcNfjM/eE3/GIX6JolyQsmNlSIlCFibVCgTdV9e5nwiAfePKSKk2Ts7fd2B/EoX5pdC9gFIfW/SF8Wy8TiH0ONtnXiwb8fHOmjXeRlKBLTTTj4djsLEq3R3uCUAVed4fcaz1PnovbGPXaRtISbGVkwsQdq0/MR/P4lxoPZyyvs723yfec0gZ2JO8D7MnxHkbEG3R37AeXBUN7CiwdJni5Fs3sD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Apr 2026 11:48:27 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> On Mon,  6 Apr 2026 18:05:22 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> Hi SJ,
> 
> > TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
> > action failed regions, for deterministic and consistent DAMOS action
> > progress.
> > 
> > Common Reports: Unexpectedly Slow DAMOS
> > =======================================
> > 
> > One common issue report that we get from DAMON users is that DAMOS
> > action applying progress speed is sometimes much slower than expected.
> > And one common root cause is that the DAMOS quota is exceeded by the
> > action applying failed memory regions.
> > 
> > For example, a group of users tried to run DAMOS-based proactive memory
> > reclamation (DAMON_RECLAIM) with 100 MiB per second DAMOS quota.  They
> > ran it on a system having no active workload which means all memory of
> > the system is cold.  The expectation was that the system will show 100
> > MiB per second reclamation until (nearly) all memory is reclaimed. But
> > what they found is that the speed is quite inconsistent and sometimes it
> > becomes very slower than the expectation, sometimes even no reclamation
> > at all for about tens of seconds.  The upper limit of the speed (100 MiB
> > per second) was being kept as expected, though.
> > 
> > By monitoring the qt_exceeds (number of DAMOS quota exceed events) DAMOS
> > stat, we found DAMOS quota is always exceeded when the speed is slow. By
> > monitoring sz_tried and sz_applied (the total amount of DAMOS action
> > tried memory and succeeded memory) DAMOS stats together, we found the
> > reclamation attempts nearly always failed when the speed is slow.
> > 
> > DAMOS quota charges DAMOS action tried regions regardless of the
> > successfulness of the try.  Hence in the example reported case, there
> > was unreclaimable memory spread around the system memory.  Sometimes
> > nearly 100 MiB of memory that DAMOS tried to reclaim in the given quota
> > interval was reclaimable, and therefore showed nearly 100 MiB per second
> > speed.  Sometimes nearly 99 MiB of memory that DAMOS was trying to
> > reclaim in the given quota interval was unreclaimable, and therefore
> > showing only about 1 MiB per second reclaim speed.
> > 
> > We explained it is an expected behavior of the feature rather than a
> > bug, as DAMOS quota is there for only the upper-limit of the speed.  The
> > users agreed and later reported a huge win from the adoption of
> > DAMON_RECLAIM on their products.
> 
> Thanks for this series. This is a problem I have come across and am looking
> forward to seeing this land.

Thank you for acknowledging.  I'm hoping this to land on 7.2-rc1.

[...]
> > DAMOS Action Failed Region Quota Charge Ratio
> > =============================================
> > 
> > Let users set the charge ratio for the action-failed memory, for more
> > optimal and deterministic use of DAMOS.  It allows users to specify the
> > numerator and the denominator of the ratio for flexible setup.  For
> > example, let's suppose the numerator and the denominator are set to 1
> > and 4,096, respectively.  The ratio is 1 / 4,096.  A DAMOS scheme action
> > is applied to 5 GiB memory.  For 1 GiB of the memory, the action is
> > succeeded.  For the rest (4 GiB), the action is failed.  Then, only 1
> > GiB and 1 MiB quota is charged.
> > 
> > The optimal charge ratio will depend on the use case and
> > system/workload.  I'd recommend starting from setting the nominator as 1
> > and the denominator as PAGE_SIZE and tune based on the results, because
> > many DAMOS actions are applied at page level.
> 
> This makes sense, but the quota is also considered when setting the minimum
> allowable score in damos_adjust_quota(), which, to my understanding, assumes
> that all of the all of a region's data will by applied. If an action fails for
> a significant amount of the memory, a lower score than what was calculated in
> damos_adjust_quota() could be valid. If that's the case, the scheme would be
> applied to fewer regions than strictly necessary.

Good point, you are right.

> 
> As you mention above, this is not a correctness issue because the quota only
> guarantees an upper limit on the amount of data the scheme is applied to.

I agree.

> Additionally, it may very well be true that what I listed above would not be
> very noticeable in practice.

I guess it is hopefully true, for following reason.

The score for each region is calculated as a weigted sum of the access
frequency and the age of the region.  To avoid DAMOS action is repeatedly
applied to only a few regions, we reset age of regions after a DAMOS action is
applied to the region, regardless of the action failure.  So, periodically the
score of the regions having the action unapplicable region will get low, make
no big impact to the minimum score threshold calculation.

But real data could say something different.  I will be happy to be proven
wrong my real data. :)

> I just thought this was worth pointing out as
> something to think about.

Indeed.  Thank you for pointing out.  Nonetheless this is not a new issue that
introduced by this patch series.  And the impact is not clear at the moment.  I
will be happy to revisit this in parallel to this patch series.


Thanks,
SJ

[...]

