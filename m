Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6398FAD3EE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D266B008C; Wed, 22 Apr 2026 22:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E8F6B0092; Wed, 22 Apr 2026 22:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0236A6B0093; Wed, 22 Apr 2026 22:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E76576B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:14:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 795F11201BF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:14:49 +0000 (UTC)
X-FDA: 84688202298.15.25D2C94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D658E180005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:14:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtohxZ96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776910488; a=rsa-sha256;
	cv=none;
	b=x+fhlx21OPXGiZ7FYo8Foo3QVbTlgzr420svWN/9JO9JotY90T3O5gOeRAreZmemPgxXYs
	KykI4mUhDdd99Sz4fzHJd+8DPwy2sz26DG1/pD60DpCnaRwiQcB2Xwml72ZCSGr28cTiaa
	bDDpIWzySfZttlgqjUmSzOpj4/H9Zu8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtohxZ96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776910488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nvmWBE7p3mNyGjM84Mtg6hKNaeJqvODoUnH9Qe9p70=;
	b=71oeTRKVd3B/qRjh3BndqSj0WluoR+juEZJieopbYs2chx8iiLqKltfueJmc41mzL+gVVG
	b9OFm3SOhIdbwE160SfIC8pp9y3RoVsBiHtXL42e40NfHTb4v+sTC6edy9AyEiGgMme72T
	Q4cw0la9PsLe/Jbe3ytyaP4LIuuKaVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73D3040A66;
	Thu, 23 Apr 2026 02:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E883EC2BCB4;
	Thu, 23 Apr 2026 02:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776910486;
	bh=w+jgw7+Kepc9dYFzbTYrY6IcLLSgaQuTLOr35M233RA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtohxZ96b5cBJNzVWuN1KlMFfV8bzUz4S2Z3cc4VHRO92xjBes5Xd9TvclMKCyXqs
	 dACx334Bw1ZWDNoum4nQ6hCYEZtweXJOY6D/PPo6OO7s1eWDqYT+Gs8Pgc6bCijmX4
	 FHe7gBmrsiEcSoIkSkznshwyNLJ5F7WTwwBaW/5enxNvLFg+AHMNfagUcbbxdmIxlO
	 pAx5fAe3kRB1TJY6fLr9ZJwhkV+4DgZt6lJZkDNYNF1al6OtPMkB9sOxoW+t9jQ66g
	 xWhe90YqtmqZegKSnVh5ynbUEkgz6fiQvq/OZx3eiZDbOyrJdXbHbT7bE3zhhcN1In
	 6O397lYNVvYZA==
Date: Thu, 23 Apr 2026 11:14:44 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aemAlO9rhFaDPmKH@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
 <aelxH--hZkCahPv6@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aelxH--hZkCahPv6@hyeyoo>
X-Rspamd-Server: rspam10
X-Stat-Signature: ckt36u3nqaktnyk3joh9r799m8cz8aoa
X-Rspam-User: 
X-Rspamd-Queue-Id: D658E180005
X-HE-Tag: 1776910487-363385
X-HE-Meta: U2FsdGVkX1+WkGfIBpmCqI675XzTi32tusgqS80IqgrVcKEijmHiY+x9J75d2P3ubCdta6Eqyt2L4g4Xe9H6D9WCj/MktSAbqLmx/+hXZ35HEa7waMVxtNmdHvldJNlaEvs26TGFCMlf9NnWlKhAVfrXAYvxAYgbj/BLBRiSdQW0tXwsLwPOXYOQvVCZVctZS9YXF3a9m4kn4EP9bmmEZf/reU9IUZTWnQzqu34cua68omeH0cpXeImeNm8kcia/xvEzlN6KtZbxFLOMy3Fs+/X/mGKpSmqSIbFgege3LAWKpFbkOxLYmEGaRgLKCxwLk8baP9mKvE0fapVaQ7uge2cvSAhIKCW8Qhg/2UXgsnIGzQSppG3RDpSaPsWqYxQxGc3Hp8+kutkzHJJaBUATYoT+gWgXiKVzLlodkO+GSpee9/Wlhdq8ImLvZfPR8n+/fbyPYPaPE0tsRXVvpd6rNnISc6789ENUZFUhasvC8pIQmYM63pDvgktfj8SyWYx0i2wA65UqGOnAOfDE4t3cczzevEXqYI3CHirhJe2YE3z2fc5He1jglfAzcTgY0T365VBaA0vBzyV58wayGEMfjjbE4IYrQj41HXzRyF2MaJY3qey8cciPUB40WiuZIyo8e6OvX6vc/sx7qTOIAtgNWwCTfO0H0M5C4sjgsFB31cD1vWQ8kSYMbXE6NHyhbZnGawIMdfeSJ16JRpCxu9yRkovSgFvF4lqkzduEqibNTNTvl1128YzlCwj2FGLvD5aodQ7WwQMc1tHy86b0Gax9mOhoKCrRZ2g75h2WJNrdXZeqGl9lUJmMoLdDUvmlFI32sbDx1qmk9ljkFR4DvTcar/XLh59ECF2BzBU4c1C/oNMsel1AAbM6Sh6wpwzEy37Lgu2l+MOD/dOT13pF3TMWzvpOTnUDtRQQs+CFpX5HVvrbpm6SZshB0HIoEFt6FFOiP1GOF9U67I0cbuIX7IP
 CaT402yl
 7qb1iOTmp8Fg1VIRzB1kzQAVhdirJajywR5orL4H+0Kd1jvWgE+ce6mSZXkXxo2bfI4F9HZFJOciG+ECqfqJMJESfqer4U75dFaxoAMk9QxPVA4pW6HpvzoED4TWJq4KFZmBamvJjbJlVc+coMubk//nDqOCtVAun4J/VkLaZpPfrJekNrCxvAry0pz/hRsQC75B192CFuH2MRoyMDIk9WnpOMGhP/HwXefrREN2fGv3Wb8QeESnI5cCxUBQPfa23JlnpjM+5Lb644p4RKkZe3GoHIV7uk6O3co+jxmnuw0pHn7vsVHFqkri8VORqxCLNYgr5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 10:08:49AM +0900, Harry Yoo (Oracle) wrote:
> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> > On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
> > I think a better option is to add a separate kvfree_rcu_nmi() helper,
> > or similar, and avoid complicating the generic implementation. Otherwise,
> > the common path risks becoming harder to maintain.
> 
> It's unfortunate that I didn't provide performance data to justify
> adding complexity. I can try, but apparently you're not talking
> about that.
> 
> Rather, you seem to be arguing that you're against this pattern
> no matter what the benefits are?
> 
> I'm confused.

I was indeed confused, but before writing this, I should have thought
that you might be considering a simple but still efficient solution.

Apologies, my reply may have sounded a bit offensive.

-- 
Cheers,
Harry / Hyeonggon

