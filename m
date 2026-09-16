Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78117C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552056B0088; Wed, 16 Sep 2026 01:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504566B0099; Wed, 16 Sep 2026 01:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419846B009B; Wed, 16 Sep 2026 01:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1146B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:12:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8043D1205FB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:12:00 +0000 (UTC)
X-FDA: 85218453600.13.32B558C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE129C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:11:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FLQGCWUr;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789535519;
	b=D5jGJe7bmqNrLaddwGVY1dzj3b/Whqvls02PksV9BzwVEKpIlbEZKd0T83lIr15MH0AsBZ
	xOLa0CR1Zo+7qXlHReAiudk79zseDQkzQG7NWK+/LeQK1AUsvNkuDKOO36STnd6Kd47moA
	05eUsIIQsP9LT/QTqxKZWBdIVMZR+6M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FLQGCWUr;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789535519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNEW7NhnOUY8v9q+C+Hpu+A+v8WziHcF3NFyEfbmrH8=;
	b=8DJi9fGrT/b/jjSqBBaw14SE82/LwKVcIHq/J2HHVXbw4WjLENq/pHoTb1rag/5BQvtNIA
	eVcOfRJaZ/imrNtL1qQu+fclUsdM88lTq/NtanYWq1yctndMnc3Jyzt/IbHGJEpAFafRIj
	0cuaZOQNXb5U9UF1cTk8sujizK29KpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE19D60008;
	Wed, 16 Sep 2026 05:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23D01F000FF;
	Wed, 16 Sep 2026 05:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789535517;
	bh=kNEW7NhnOUY8v9q+C+Hpu+A+v8WziHcF3NFyEfbmrH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLQGCWUrq4wrW/Oa3OqlQ5cNqAUaO3UEA49euXSpwoEG5p2n1OFcnoRNbwUgX7sMC
	 ln7tCuXC8SL1cuAcqZYIXev2KqfozXLELQT+Gl2IEqpCNxfbCpQ1k/aA0t21wKLm38
	 8NWpPW5fKFGqU/mQ7p/8x+Xw7wejdA0M4qf7HSxMnyV9HfeG4GF+4PjgTpQVU7IIDM
	 cge+ZUq7HpmCFI49B+HjLpo3ua1E5lNrwpFvHQtm40eNzy0CVXOZBQUjwATPyPRoQr
	 hs+HvFbzDzatb2hcwj3KioP8m1gbCHmCwbHCfJY83+/FpYjV+6miW6FNRXk+F5DaWI
	 jyesMs//9cc8w==
From: SJ Park <sj@kernel.org>
To: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
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
Subject: DAMON reporting more hot memory on huge pages (was: "Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports")
Date: Tue, 15 Sep 2026 22:11:49 -0700
Message-ID: <20260916051150.107931-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916034439.28517-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE129C0006
X-Stat-Signature: c3p6bbasgo4skprz1k9sj1thf93rp6h3
X-Rspam-User: 
X-HE-Tag: 1789535518-996628
X-HE-Meta: U2FsdGVkX191XpwtMdilzyFP4SwSlICuxpapH1W0NXNOxWkQtSEbuBknWzL4jB7+O4pf3EF6Kfc4VdRtX5RhNS7/iDiHAJTSDn5YamHdmhrtq0oHxU9PrCv8Vg2SrJXeIz/aiSp6P1KslGH8sR3vOjDQ+7v3TM/EkXosM1hkV0FDXfjcFjZII+EOvIz12gqH3s5v5SGGyfX9hPAGBuw2mTwKJZInbrsX/5dgCmyRaHLUAyw6xobINx5GaVCTJnX4k/7kjLE/9kIXfVMyDQQWeczyaAbiy5fn7VSC9rQJVQwrQEpQYBYos+zSNj9/ddE1ke+veU2vFqmiojWgSq3x5OybAGMFeuNQI6d6k3JtSrIZO1rSZb4vt4utHin3JJaCn+EknjYZKwBjtLDKVsGUStIPmPxs1QmBhcFRHkr3MbJ+FfW3ROUToVdMXj22OM1fbUxqwdvt8+oW2IZ22fVIc+PLBQbo5Ko4n0CHu+qcGiEzRp2y4zeryLAj1XlZwej5WAo7hm6i2Bb8ogLyrStiDMJCUTuKowFxbtGiaWanl9olOmwGFN4bL3DLdQtB/73y63SuqFO9y2UAjI+gNwxxA+isH2lXOc48NtaFmWbfDQvk1iCGWU+7kN43uQrb2FltsAA/h6HNq+SZ8E82hJNqbASZP64j4+O3Gbt+2NHEnGp6L+IkLi2ahxAZb9ET+k2gxqVcS7oRykEfEJ0OXjzXeWoHECvlcBEhEz5Pi3pYoOuD9HWZAfZbRHQhnEn/sq//B1/POMLYaeuxX5YWe5nOqTP/PiRNZ1BeUH+sNtGtzKiFC0hhH6TRtk2cnKkTSk51+JPMkbu+vRs5y1v7KjnFfnFLEZzgATydH/lQB+HjlrEYw4sZ9YwlgfkCdwNicGzn0pVB51oUFnc4KPcjMMeBb9dNrecPo1Ns4hfXUmfzjiSwhdZVSZmv+hzJwAFoAKTH2KPM7V9HkvP8TbC7HtU
 j/INFUcR
 rXgBnXvCEzQjTqbDI5vU+ZuKnJnjhuI7Et7Z48fju0ccMUxUq/Br6DjVC7Bb8JAPcyQK3C27bLZtnxRjc0VIwyW7RS7zdMe8rsQOo8KLNm6SxLF29/QpF6HbQf3z4sboK7tklI+FaAp0583bxtHcczsT4g2T7XQMOnyaIT9xLpVsEAZoW4197/zbKLZpKAO7TsjiiHBmJKRiMq3SZAhseXaSQVxDT2I39AgxRRUFyzx6ZqFjHpkkxb5owtVU4kGG6iKjy5qPlkhozHoohUFSq/ISVFrk9tLgXXfrfGyJnwIp57Kevs9i9s1t8Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 11:44:30 +0800 "Lian Wang (ProcessMission)" <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> Thank you for the questions.  I mixed the original field scenario and our
> controlled reproducer in my previous mail.  I also jumped from the observation
> problem to PMD mapping demotion before explaining why the deployment needs both
> huge pages and finer-grained observation.  That made it sound as if our goal
> was simply to stop using huge pages.
> 
> > The observation makes sense.  However, does the sparse access pattern
> > realistic?  If so, what is the purpose or expected benefit of using huge page
> > for workloads having such access pattern?
> 
> The original case is not a lab-created request to use huge pages for a sparse
> microbenchmark.  It was reported by SXF from a KVM/QEMU deployment where the
> VM has a large memory allocation backed by a shared tmpfs file, host THP is
> enabled, and Oracle runs inside the guest.  They use host-side DAMON to measure
> the VM's hot-memory proportion.  With the same business memory use, they
> observed a much larger hot proportion when THP was enabled.

Thank you for clarifying this.  So I understand it is an issue from a real
world workload.  I'm still curious how sparse the real access pattern in the
real world workload is, and if there is a low haning fruit.  There might be
rooms to improve in their DAMON usage.

Could you share more details about the real world setup and findings?  More
specifically, how they define the hot proportion and how they collect the
number?  What is DAMON setup?  What are the real numbers they saw?

Also, I understand they want to understand real working set size of guests.
Could you further share what they are planning to do with the monitored working
set size?  The required level of accuracy of the monitoring could depend on the
purpose.

> 
> The guest tmpfs 4 KiB/2 MiB writer is their controlled diagnostic case for
> isolating that observation; it is not a claim that the Oracle workload is
> exactly a one-page-per-2-MiB loop.  We then reproduced and quantified the same
> effect on a PC and on the x86 server.
> 
> For this deployment, keeping large pages is a real requirement at the host
> virtualization layer.  QEMU owns a large resident guest-RAM mapping.  Host THP
> allows that mapping to use PMDs and allows KVM to use large secondary mappings,
> reducing host page-table memory, TLB and nested-page-walk pressure, and KVM
> mapping/fault overhead.  These benefits are independent of whether every 4 KiB
> page inside a particular 2 MiB range is hot at one observation time.

Thank you for clarifying this.  Now I understand why they use THP, and I fully
agree they should keep using THP.

[...]
> The performance requirement and monitoring use case come from the deployment,
> not from our lab model.  We will also report the measured Oracle/VM benefit and
> the production access distribution when those data are ready.  The diagnostic
> result establishes the observation mechanism, but it should not substitute for
> those workload-level measurements.

Thanks to your detailed and nice explanation, I don't doubt about the needs to
use huge pages.  So I wouldn't insist on Oracle/VM benefit from huge pages.

I'm still curious the real access distribution, though.  I understand you don't
have the data yet.  It would be very helpful if you could share that in future.

> 
> > I'm not very sure if this is the right direction.  PMD mapping demotion sounds
> > like you just don't want to use huge pages.  If so, you could disable huge
> > pages.
> 
> I agree.  My reasoning in the previous mail was too jumpy: I went from a coarse
> observation directly to a possible MM response, and that obscured the actual
> goal.  PMD mapping demotion is not part of our current proposed solution.  The
> current direction is to keep both the huge folio and PMD mapping unchanged and
> use a genuinely fine-grained access primitive to improve the observation and
> the stat-only decision.  We should first find out whether that is sufficient
> before discussing any mapping change at all.

Thank you for clarifying.  Yes, if you really need sub-pmd access, I believe
the perf event based DAMON could be more useful.  Nonetheless, as I requested
above, knowing the DAMON usage and purpose in more detail might let us finding
a low hanging fruit.

[...]
> With this context clarified, we will return to the immediate work: use the
> existing IBS/perf-event proposal as the concrete strategy under test, and see
> whether its fine-grained evidence can improve the observation and DAMOS
> decision for this case.  We will use the results to test and review this series,
> report both improvements and remaining gaps, and not assume in advance that it
> is the final solution.

That makes sense.  Because Ravi thankfully already implemented this nice
working version prototype, there is no reason to not test it right now.

> 
> I hope this clarifies why keeping huge pages and requesting finer-grained
> observation are not contradictory requirements in this case.

Yes, it is now clear to me.  Thank you for patiently englightening me, Lian.

> 
> If I am still misunderstanding any part of your questions, or if any part of
> this explanation remains unclear, please continue to correct me.  We will keep
> sharing our findings and would like to make sure we are aligned before going
> further.

I believe testing the perf event based monitoring with Ravi's implementation is
a good path forward.

I'm curious about the real setup and results your clients got from their real
world wokload.  But that's not necessarily a blocker of the perf event based
monitoring test.


Thanks,
SJ

[...]

