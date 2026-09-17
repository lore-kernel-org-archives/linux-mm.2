Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E57AC982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 00:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377396B0088; Wed, 16 Sep 2026 20:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F6B6B008C; Wed, 16 Sep 2026 20:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2666D6B0095; Wed, 16 Sep 2026 20:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046286B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:45:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8394D801D7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:45:43 +0000 (UTC)
X-FDA: 85221411366.21.D1E8136
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CBB2DC0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:45:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HeoNV/Yo";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789605941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvTeJmFNZPYMWT61qKcfcgq1L4fEWGELOp4BeELaDsQ=;
	b=hEnGO01T+Ki8FivWrCt5143Fr9KInqAFEUJ5QrxgexaEc9nqZi8eZ+JFviqa75KHRgrK61
	vNtbSYmSMZYmoKIy7ya4h0ZICXuhmLidNBZVMhLOKBk8bgb1k96uiBLqvxHz9GX3EKtNil
	h30IXlGbyF+6lW0p6i8kCzEtJe9Fje8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HeoNV/Yo";
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789605941;
	b=V6yIblJzNY46ipYNZBIGW2/Y7ptMUn1Yrg3rYLI+/JZSZRpuSOGUgHVWPViRyFSeBBq8FY
	jeNz9SBCCE6Jlz7dGkd0O8Q6+2xY+pMHN+qut9C7DiNHK04g6FMFJUZdGIC1/3vg13nYA0
	bwr55Q4QF3GTXF+TbNfAI050dKzt8lQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC8F8404BB;
	Thu, 17 Sep 2026 00:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AFC1F000FF;
	Thu, 17 Sep 2026 00:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789605940;
	bh=RvTeJmFNZPYMWT61qKcfcgq1L4fEWGELOp4BeELaDsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeoNV/YontnZ41uoAbstSo7w3oewrxMhH9IUG0/JJWsuxlognqRKhtvFsaRmAeyI2
	 +7k7eV7VIHil2XyDImur2sVzI2S0p16+nkC1305mipjW1ylsIwmdcaUssQxwQMcFLD
	 pW/LdMyVWzrVuKG+tZGQWh+s8SuR7r6nT+qo5lsVihhFylOinaWe5zIYl0qlOPjO2J
	 LakPAMgbsRnVPqgYM3scZvGsEKNl9RggWtFr4XaNG/JJNWGdXzSVSELhY9DiZ7Zbup
	 tdaul1b+4PlK9iu3J7x0snqyVFYmTDBw9sXBcmh3VXg/poWhKsrvtoctpXDyWZy4z3
	 pVqhIiz2nNdbA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: DAMON reporting more hot memory on huge pages (was: "Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports")
Date: Wed, 16 Sep 2026 17:45:32 -0700
Message-ID: <20260917004533.89744-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916051150.107931-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBB2DC0002
X-Stat-Signature: 8yigz6ffhj9bb4h1dctwumujxa3pti6n
X-Rspam-User: 
X-HE-Tag: 1789605941-174462
X-HE-Meta: U2FsdGVkX18j2LDivfL0ILtwPWrDwF4H1ggKHCK0ba+8Ceg0KrxznWQhbOsihwMWTXjtgptQzLyI2IAnp8kOggpsPm1sE4S8Hj3rkP1q+eGCbHLcfyFI4gqL0ONdXQMCj/KJGkf8igczlHnF1acwM+fqkV9tIAB19AJ7t0HJixD7HkzYZcDcARxW0x7HpSEV0nNuN07G+jJ2lxpMeuu11tu6mmlySPn8eHN8HvQh9eVB1qrWbLNAsYkbnxybXXn09f5udh+mVO//soNWOcolK/S/oo6HQZ7TQzICLV8foEVHR4NBzGlje2+vhSW7HMD2IDOyBTKu17Ur4ZglWoGBg1MVdGJt+sjYU4G+qWEyYDoF4r4itGAFo7Dp1WEwrLnsurTCW+9EDklUwIVXaW9WLtC5jheCOPlafqEoaIVct72VD8ksV1XfcoG+5S6tlsXcRrF5YNQzwzl9/X7tumdT1hCIXo0n391b5GQqBlz/CT18EQqqo6uskqXseEXWaDVT9Sjw6p2gBKamGqImIeBpSmiVxspg+ZYlX67+8pdadzymi/vhbzubOCKYneMqE0GQv/6+6+1cECo51C/NV4kv5rf88RX/OUQSUuCrOUoTFcrQ2dyeSgK1ktyQMzopwJ6bu3OV3E+EtbNwuOafFFg5KMpLlCc3+hSCD6GwTaVANt48BM8RxaAby/C2vy0GxUdDQcR0aqJPpTesqImMOpAw8cL7lfJ3TH/CO8FwTazFVfqUFVEVgupT9bTC+8BWI4l1uQLzfXYrTLf1Rdzr3C5mA/6b084cu9h7ETkgUL3uZ0gOXdS5S7iAJDdcY6Zxcr+vyqaLYK9knEaEGtZagcMy7+1J8pLzUjFhOLPKnaqbwiLUdMm1M88sfTs10WsxucC8GHNSDbA3PR2eXS6RI5tYmZITk6LUKhfLD9RilxizRTuD3WT7JILiJ2E4ciyezIkyK0u7qCYGymogM52VDwK
 nqgLpaHb
 xclkpES1WonZj/TBsSq1dlgBxtT9dk/sT6lxQi/jp2ovqSotDpVPG/FIPhawqP4YbbrmhRQvHOkqlCJOFSz7uZwh1BO4VVUSG/cCvdyadpYACvnBi+C0wKqVIAUg/yHvABCbWymCt3XhTVT2bPTvNkF/lHgbKR1kkb54u8Y7auhLLsm7eB6dK0B+ODMEafHu68TJhNpVEb8gE1tiWw0PcMrsB5rbYQBQ+FNl/1ZtZsR73Xl6oV3eBugZf3cLU47hw4Kxdy+vmfWVJBkOHlqM5fwFIjNSkFdkFhjo6LpiLW6M37ImIs+fBCjERGCkPGlc58a7YJpwQ2j953d0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 22:11:49 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed, 16 Sep 2026 11:44:30 +0800 "Lian Wang (ProcessMission)" <lianux.mm@gmail.com> wrote:
> 
> > Hi SJ,
> > 
> > Thank you for the questions.  I mixed the original field scenario and our
> > controlled reproducer in my previous mail.  I also jumped from the observation
> > problem to PMD mapping demotion before explaining why the deployment needs both
> > huge pages and finer-grained observation.  That made it sound as if our goal
> > was simply to stop using huge pages.
> > 
> > > The observation makes sense.  However, does the sparse access pattern
> > > realistic?  If so, what is the purpose or expected benefit of using huge page
> > > for workloads having such access pattern?
> > 
> > The original case is not a lab-created request to use huge pages for a sparse
> > microbenchmark.  It was reported by SXF from a KVM/QEMU deployment where the
> > VM has a large memory allocation backed by a shared tmpfs file, host THP is
> > enabled, and Oracle runs inside the guest.  They use host-side DAMON to measure
> > the VM's hot-memory proportion.  With the same business memory use, they
> > observed a much larger hot proportion when THP was enabled.
> 
> Thank you for clarifying this.  So I understand it is an issue from a real
> world workload.  I'm still curious how sparse the real access pattern in the
> real world workload is, and if there is a low haning fruit.  There might be
> rooms to improve in their DAMON usage.
> 
> Could you share more details about the real world setup and findings?  More
> specifically, how they define the hot proportion and how they collect the
> number?  What is DAMON setup?  What are the real numbers they saw?
> 
> Also, I understand they want to understand real working set size of guests.
> Could you further share what they are planning to do with the monitored working
> set size?  The required level of accuracy of the monitoring could depend on the
> purpose.
> 
> > 
> > The guest tmpfs 4 KiB/2 MiB writer is their controlled diagnostic case for
> > isolating that observation; it is not a claim that the Oracle workload is
> > exactly a one-page-per-2-MiB loop.  We then reproduced and quantified the same
> > effect on a PC and on the x86 server.
> > 
> > For this deployment, keeping large pages is a real requirement at the host
> > virtualization layer.  QEMU owns a large resident guest-RAM mapping.  Host THP
> > allows that mapping to use PMDs and allows KVM to use large secondary mappings,
> > reducing host page-table memory, TLB and nested-page-walk pressure, and KVM
> > mapping/fault overhead.  These benefits are independent of whether every 4 KiB
> > page inside a particular 2 MiB range is hot at one observation time.
> 
> Thank you for clarifying this.  Now I understand why they use THP, and I fully
> agree they should keep using THP.
> 
> [...]
> > The performance requirement and monitoring use case come from the deployment,
> > not from our lab model.  We will also report the measured Oracle/VM benefit and
> > the production access distribution when those data are ready.  The diagnostic
> > result establishes the observation mechanism, but it should not substitute for
> > those workload-level measurements.
> 
> Thanks to your detailed and nice explanation, I don't doubt about the needs to
> use huge pages.  So I wouldn't insist on Oracle/VM benefit from huge pages.
> 
> I'm still curious the real access distribution, though.  I understand you don't
> have the data yet.  It would be very helpful if you could share that in future.
> 
> > 
> > > I'm not very sure if this is the right direction.  PMD mapping demotion sounds
> > > like you just don't want to use huge pages.  If so, you could disable huge
> > > pages.
> > 
> > I agree.  My reasoning in the previous mail was too jumpy: I went from a coarse
> > observation directly to a possible MM response, and that obscured the actual
> > goal.  PMD mapping demotion is not part of our current proposed solution.  The
> > current direction is to keep both the huge folio and PMD mapping unchanged and
> > use a genuinely fine-grained access primitive to improve the observation and
> > the stat-only decision.  We should first find out whether that is sufficient
> > before discussing any mapping change at all.
> 
> Thank you for clarifying.  Yes, if you really need sub-pmd access, I believe
> the perf event based DAMON could be more useful.  Nonetheless, as I requested
> above, knowing the DAMON usage and purpose in more detail might let us finding
> a low hanging fruit.

I still want to better understand the real world use case before digging into
the specific solution.  But, I was thinking perf event based monitoring might
not feasible for the case.  If that's the case, I think extending data
attributes monitoring for splitting pmd mapping be fore the access check might
be a path forward.

That is, we can request DAMON to do some preparation action for the data
attribute sampling, using damon_prep.  At the moment, set_pgidle prep action is
supported.  Maybe we could add a new prep action, say, split_pmd?  Then, the
following sampling memory access check probe (would be a kind of "allow
pidle_unset" probe filter) will be able to show the access on exactly the pte
accessed bit, not the pmd accessed bit.

Breaking pmd would cause the overhead, but it would be capped by the
max_nr_regions.  So the user could at least consider about the tradeoff.  I
think this is simpler and more intuitive than DAMOS-based pmd breaking, at
least.

> 
> [...]
> > With this context clarified, we will return to the immediate work: use the
> > existing IBS/perf-event proposal as the concrete strategy under test, and see
> > whether its fine-grained evidence can improve the observation and DAMOS
> > decision for this case.  We will use the results to test and review this series,
> > report both improvements and remaining gaps, and not assume in advance that it
> > is the final solution.
> 
> That makes sense.  Because Ravi thankfully already implemented this nice
> working version prototype, there is no reason to not test it right now.
> 
> > 
> > I hope this clarifies why keeping huge pages and requesting finer-grained
> > observation are not contradictory requirements in this case.
> 
> Yes, it is now clear to me.  Thank you for patiently englightening me, Lian.
> 
> > 
> > If I am still misunderstanding any part of your questions, or if any part of
> > this explanation remains unclear, please continue to correct me.  We will keep
> > sharing our findings and would like to make sure we are aligned before going
> > further.
> 
> I believe testing the perf event based monitoring with Ravi's implementation is
> a good path forward.
> 
> I'm curious about the real setup and results your clients got from their real
> world wokload.  But that's not necessarily a blocker of the perf event based
> monitoring test.
> 
> 
> Thanks,
> SJ
> 
> [...]


Thanks,
SJ

