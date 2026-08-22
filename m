Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826EEC5DF94
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 00:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427B76B0095; Fri, 21 Aug 2026 20:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8226B009B; Fri, 21 Aug 2026 20:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C72D6B009D; Fri, 21 Aug 2026 20:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082BD6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:32:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D0611402CF
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:32:48 +0000 (UTC)
X-FDA: 85127030016.21.6924C8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id F24D418000D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:32:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VsXNAyVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787358767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTtbBAC/D/yVNs4AHZW7PqQ57npjfBk80DwpOFSGqOs=;
	b=QrA6fu6E/K32oLhln+Bme6ghvca1+XF7Xxh/nAAJvLmGQerPrREzMCxTh2vRE+LzVQU/GI
	x04nb0MJNA9Wom0b0dwKoqI8vE8xY+DP3zgq5VA0fgAxK/l2vcAm8pk6UBoIa01Co1mVdO
	sn6J8jSVme1gxi0JswrfkIenQmOCSNw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VsXNAyVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787358767;
	b=p0KLIiYLjF3kA/Vz3YYnVOuuOzhxpoXSbnZDbSQfzIYj5QjiwLo3KkNeElZwhN21DccDyM
	5vQ+xutFkPmFsFZq1fr1w36UdwwXZeh0ld6UQk5olznC8dDftG5Adu+KxrBqdjhYr3SyRS
	UFuVz4rj3lzUFRl8w/KDfDrqaGYjTxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AA5861126;
	Sat, 22 Aug 2026 00:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952F41F000E9;
	Sat, 22 Aug 2026 00:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787358766;
	bh=oTtbBAC/D/yVNs4AHZW7PqQ57npjfBk80DwpOFSGqOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsXNAyVwCKVC8F3brKcjy2i0Q3Se1u9PLt8EMAuTPn4JyXMDXYdGOTYb4gOlC4QJW
	 hQ82+4E1eNEI2N2AXhljGYLhVXrAWP4MvG1nSl2nE4ACjjh97QVWZX2yk8Ig9csXd9
	 rqxRGlPy2yLut+EaIj/onPLhEw2F499Lj1i2s+fFIBd2bV4Cb5KXAjAgKcfXVwaGvH
	 WL2zTB1FcKCvo9uypuHEVsYMwRPotzrVeYUhmWcLfL2alnUa0FEZP0sT3Nq8pGoE1C
	 j7FncxtWhdfFvH9In36DhAXVEBSq/Y7Z6/7qmqXgaC6rol3x4E6yo1GNPRMboAI4PP
	 uVna5eMSOHB4Q==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	KunWu Chan <kunwu.chan@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
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
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
Date: Fri, 21 Aug 2026 17:32:35 -0700
Message-ID: <20260822003237.88274-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15zNhpubyH5GQgu_BHesrwRdH0B8k5cqT3o_U0h5A2e-w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F24D418000D
X-Stat-Signature: s1ymp379tq4iung9wf7jfh1uoqdxfikn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787358766-102545
X-HE-Meta: U2FsdGVkX1/E5IbrXpMZTAm2JZvQ+plQ7/CWiQRgCbx7ztqo0OPBRmSSHq2Wc8phKeQPrFMb8FzRD8j/4pTupBdnyKi0z3UQJVsG87XSJu/Z6cm8EMJnkWZMH82Gro/AgoNmUJ06/L25bTkyYCjp4PEnp4OUjrPOlnXZff7CJpqYkuTWEpibQs1UmboolEEZ/7jQS1KpOvzbBbO/8f5Wz0TSarL8Wjhlq4f9ANhM2TRRCZq2A9XX+ukWiNSflOcDo6IoTkr4BpSKOzAeSAYyUBkTJ1v65vcN06DN1q29x8HFqFmi8JZlmjOw5esm9WU3ZUr6eK0eQ/KNuy1Lz1To68lX/kg1AlfOMsxTzmXMgf8NQ91LLlWgzHAlg43i4j3DP1MtiyF6MCLVI54vvZS0t5JGsetRYeLnzIM9wkt8uyTjXBt0Gfe4Dr3QLDAO8tIII5v8FW9TRlE/cj5vu0FqgCm+B1beXdqAO2sCD6LvZZ2iH4cpf5RvXT/6Psn7xB/N6yQcg8nPLCn2fQbQfn2FMubwofGZtCc5UisjU0V0kleDgiGK9RksjNj13oWAvXbOYQ4oUPvznTAjZT6x81+pxDNUYHuB2zh3ud+Nh5hZycoSCgU01btiiX1OVRbsxzAVjwE4BqeMRl259xuXxD19L93MiwGcgzCGOc/LXJu0vPhMXyliM/PBd8OMGbJP0h+fmBgdUOxGJVnDRjO1UPiyNPFhckTRTjb6yYDVCsB6Vu0+NHq4PJsErYw16JZUd9kmHV2z9DoKtCfdOkcbNP6iL0p4DlUqcB1/ecd9DPhhE1Ii6wdqvC5zyckuv/74crxtTxBXpplhj5Ftel2eUclgWTL+y2mt3GgADEAmq5yHtsG9Eg6CA4XmLsgDDRn5TKZ/P2E3XTjFV0dAx3xk4biUuiaGMm6nfpy+7mPArcAmx//TetmvPIC0sd41Q/zLv8xBqn6ioS19zeqOh2yyk69
 hLh0BUFG
 Xg1bky15I7auTxkBP5LZeK1mA9j7/TWcndamwmv9pQjFOE4C8HtREZrcLSsEy2JBYNNaUx/D9H8IQm5xe2inS/nyy0Fkrix7qZ1HNZDlrXStYPYFzGJNTYvP64rJ5hYuESzmFpSfr0ydzPj53qD05eoh8cx7S8et87N3/x+XpJPudPKz6ukvmq8vXTiFvU3jBy+vVU06SosgWVEVBnAHQfLNF04mVGcOG0EHjEi7xT3r2B5BJpsE4yAxVUlMjMDpiMvAOpeNQzrz1NpeE2a/MZ1h2GyCUivgjJYIrDjJY6BAjNRhjWk6NNfj73gVBnLo//bej2gr51zFk/jAOy34s17akAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 09:32:02 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Fri, Aug 21, 2026 at 2:55 AM KunWu Chan <kunwu.chan@gmail.com> wrote:
> >
> > Hi Ravi,
> >
> > Thanks for the detailed reply.  The fan-in diagnosis makes perfect sense.
> >
> > > Your series is based on the v1 substrate, and the way an event is
> > > configured is the part that moves most.
> > >
> > > [...]
> >
> > Glad to hear v2 is on the way.  The probe-based model is actually
> > something I encountered while building the AUX backend. When multiple
> > sources can feed the same region (e.g. PTE scanning + SPE/IBS), the
> > question of how to combine their reports becomes interesting.
> >
> > For example, CXL tiering may care about physical-address locality, while
> > per-process monitoring may need virtual-address attribution.  How do you
> > see probe weights being determined — is that expected to be
> > scenario-specific, or is there a more general principle behind the
> > weighting?
> 
> Hello KunWu,
> 
> SJ can answer that authoritatively -- the probe and weight interface
> is his. Here is my understanding which SJ can confirm later:
> 
> Weights are relative, and only among probes. A context can hold up to four;
> each report carries its probe index and credits that probe's own hit count,
> so two PMU-based probes in one context are scored in proportion to their
> weights, and that is where a scenario-specific choice belongs.
> 
> What does not mix is a weighted probe with the other two sources. Any
> nonzero weight switches the whole context to probe-weighted scoring, which
> turns page-table access checking off -- so SPE cannot be blended with PTE
> scanning, it replaces it. Page-fault reports carry no probe index; they
> credit the region's access rate but have no hit count, so under weighted
> scoring they are not part of the score either. Both coexist with a probe
> only at weight zero, where everything feeds the same access rate and is
> indistinguishable afterwards.
> 
> So for your case I would read it as: PA locality and VA attribution are
> different targets and different address kinds, which points at separate
> contexts rather than one context with tuned weights.

Thank you for detailed response, Ravi.  Ravi is correct.  Physical address and
virtual addresses wouldn't be able to be monitored with a single DAMON context.
The user may need to have a DAMON context for physical address space, and
another DAMON context for virtual address spaces.


Thanks,
SJ

[...]

