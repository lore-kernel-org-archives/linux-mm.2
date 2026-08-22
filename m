Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CFE2C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 00:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D35A6B0095; Fri, 21 Aug 2026 20:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083836B009B; Fri, 21 Aug 2026 20:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB78C6B009D; Fri, 21 Aug 2026 20:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C689C6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:56:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56EFEC01EE
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:56:42 +0000 (UTC)
X-FDA: 85127090244.28.C6C39C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C475140003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 00:56:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrM3OspJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787360200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CM62hP7TchKZsO7+LTwedoiijiDofWqPPiRie7LOcU=;
	b=QQerp98279X8B5Fmn/823BPYq++NAXeEk4lGSPfzL8j2j4tuH6iUM4mr3mNLwkVf3dpnlU
	rmj+vAN5uYjsQZJVHTfBhumNSHjIZ3EAjOwnn8XRbZudJSRxy0WSqlZuh4vwsRmvjGgL9n
	qBWHamgABXpMu2vxFpVukOr7+Ryp008=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KrM3OspJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787360200;
	b=h/LNRt4IZVVQsp3nnYT+fZEnNArli8jVANsYyOj1sHTl9FD56MFpCrLXl/7FGtNBOBVGMR
	SB+lqtAnQ861UrAVRzEcfGUdB8923Mt0bkryOhbKZg5b/6xgZz+jq1M5KX+2lhqTf8hfTt
	gwcwXKh60h9v+oEr1kUA7M/kjogAtj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07C72600E2;
	Sat, 22 Aug 2026 00:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CF61F000E9;
	Sat, 22 Aug 2026 00:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787360199;
	bh=/CM62hP7TchKZsO7+LTwedoiijiDofWqPPiRie7LOcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KrM3OspJT80oWxJ2/CHfmJaXWll/DExYK3VXNfe30uSv4AH7YR6mnFhOKJX1NBb43
	 pDtl9taL/bLR1pB22gErT87IRcmCgW+d4wI6RXMrtsg5xRMPkfwOySZ2PcTeGuhJtY
	 TsawsQ0idlPnQkCv9MiAad/O2BAa54EQjeMpjuQGd81vHiDX5laLp0hfSoJJERu1mO
	 KY3WDiygTJvZCHe4U9F98qtZhaNAOER3HxLw556ZKSWilYwwm5GKU0se0NXjdAN7yL
	 5gYDD2m85lGpXblBZaxzZlLYMW8oQS/zFtZYLRO8bQCuzVnGUZ1KHF8khBbgkGdsL8
	 DXh8jQjHXGjiA==
From: SJ Park <sj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch v2] lib: test_vmstat: add synthetic benchmark for vm stats
Date: Fri, 21 Aug 2026 17:56:31 -0700
Message-ID: <20260822005632.88673-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <6136773e-b134-070e-36fe-2951aa25b5fe@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C475140003
X-Rspamd-Server: rspam07
X-Stat-Signature: zcinejitf8knwhpok3ycacz8ucr38bds
X-HE-Tag: 1787360200-878313
X-HE-Meta: U2FsdGVkX1+fzq0DgQo0jEefd+fjXEEr++haxYlgmjvZi9hlNq52K34MV9V+XyRKgCdbqlx2QV1hu4998qqupS2eB52ii063rs/jdVoyIPX33q234Z+aF/Wru2S0EEh01tzocHa1XWSM8IOelm2cti7TI54F5J7JMYw93+OmulOAnoCK8L4UMa1FWl3/otzyCnT4/vv/xnt2wJUxtnoDS1BHUBMPyqPIVtNrZIkV5PM7uh7ql3lVYRZFUbc1eTdjXhHjvsxx5kq+QbdhiFri3qmKyHhIrm/CGQ2fa9KydsZY4ZAg1C/rUlYRx5ZqYc535eG8sKVqlijC00xaQYztK1tJeVlCtKN24HGIhy0/FkEFpFuePv5y8Zi6BC4dc1cSlQZ/6cs1jpEoVeJE0+m8N8MH7L3QYONsQIysux0MBKojXxLMZSqsaw375EuZMr/Wjcuhh4rGWTX8YQk5LqM+ZJudBcrwtISUanc5R9x9I83WGbu0PzLYg1HLzGgKhexzHbtbrFuch83y40ftad4pH+OfQU3rdJ8Syw63feJD2DM14EV50AnMlJvklMTVqJFxHZ8SRFaOGFJqxoneo9zDLkv9s0CCHrtY9byDCrtFp16MO8WE24RMVLEvb0VbatBiOGC/hiU4kmUd07vHGh7iwaNguAlIq5bCno6eOf3K+DBBhY1vs2qkS/9EKtGsQfEKw1xUgMMXYl9NwBEy9EwX8/dMyiah7DJ7/o+sHUtLqqxi3fC4j+CkrLVDks5GEvvhJg6oPW+om54kiexG2TCEakLmJ+pvfXPsRzpJQGjYrajdSEYOQ55dKgxh8ZOGDQbMCk/PTUV8OaW8jTVfDpKryXip1vi/nGIJ0bqm7ugi+/ld/H2q7chDNhZCbW6zj6sUhVDV6SejbJJqkPZKeVXuV2PteYvURxyTALZlJMmx//ej7CVD/OD0IDBD4a9SXz/jsxgq9EgeCo43ShxkNNc
 TyrkyuSv
 G9HV0Lw6l4ehOy5oHx/nL69YoQ13/OXUgQDOl9qfzPOkEDC/f6LdyKIJ1bGTUESKVTYA05LyWjwwVFjXrvaTecRppUDAOTS+IAARqOB3CHWMkrzNqn1kca+Ons1QcT2vAS8wuY+t9klbghOjrwl/MsuFjNIvrO0VNubmaqpZ+V99EW0ZW2aQKVESKgyD+I0MPygj5dbBC5umjwiaoWsbJVUEKqF+d1oIZBBCqM28FvwDK1P/oFNDrHkuAzKIIeYBVxbsyg7kd1PCY9HNlM/UiDySkSlbJvLNUHw15Jof4s8OZAYKUYg+MAbZnA3+V46dMFyncASnSLah+inMdR9e+YZ7Uy5aDrCUnoJoyvABGxluE4Hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Aug 2026 16:52:17 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Fri, 7 Aug 2026, David Rientjes wrote:
> 
> > On Sun, 2 Aug 2026, David Rientjes wrote:
> > 
> > > From: Christoph Lameter <cl@gentwo.org>
> > > 
> > > Add a synthetic benchmark that can be used to measure performance of VM
> > > statistics.  This is used to analyze any improvements or regressions in
> > > functions that are frequently used in hot code paths.
> > > 
> > > The test is run by inserting the module: modprobe test_vmstat
> > > The module insertion will always fail so that it is automatically
> > > unloaded; the results are in the kernel log.
> > > 
> > > Signed-off-by: Christoph Lameter <cl@gentwo.org>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > > ---
> > >  v2:
> > >   - added bash wrapper to ksft per David
> > >   - integrated into ksft
> > >   - added MAINTAINERS entry per David
> > >   - fixed alloc_page() error code per Usama
> > > 
> > >  Adding single test for now to solicit feedback before updating the other
> > >  two.
> > > 
> > 
> > Any feedback for this one?  If this one looks good then I can also apply 
> > the same treatment for test_pagealloc and test_slab.
> > 
> 
> Andrew, David, any thoughts on whether this one is acceptable for merge?  
> If this looks structually correct and is staged for inclusion, then I'll 
> do the same treatment to the other two proposed tests as well.

FWIW, I found a similar high level topics including whether performance tests
should be in the tree, and where tests should be added, are being discussed on
another thread [1].

[1] https://lore.kernel.org/aogrd9knfBUGH885@gremlin


Thanks,
SJ

[...]

