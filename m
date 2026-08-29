Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB502C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 08:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725E06B0095; Sat, 29 Aug 2026 04:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF7C6B0096; Sat, 29 Aug 2026 04:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577106B0098; Sat, 29 Aug 2026 04:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 383D26B0095
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:43:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2BA1120664
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:43:44 +0000 (UTC)
X-FDA: 85153668768.19.7D5BC95
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76BA8140007
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:43:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZvkODfUj;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787993023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHtGfUyv+NDEIFhJ+rL3MIjkKe1E4CjtH7InBn8uMWg=;
	b=P11o3qp+8C8cbAIzzVWk1GInd9a1lAbFS2uwqG4XzFE6HgsBH8vqcbR0mNUTqGQIpb4+RH
	bj2bXZHSBf975FGWZGQqL6FiRNdkPS5r2RkPhQ0S7quF0oJrcGwE1imDFLS9ft3ab4F+rW
	1dPR5SmdmSQOYP3VwX7d2qw+i9XKY6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787993023;
	b=fPds+VqJigaE4UCUrR1GZgMv4gub55Cmc06VBSsBSzpxM5cHRKeJd78Lf3hhJQdiXEbSE0
	LETXVgVTyr5lyDxOUqGe0ehkKcYu49SfdfTu/xUW0aLhCIGPAXW8v4CdpOJAK9qaan76Xd
	EgHeGWXhDdhG81fanJYppAa77R0Xy5c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZvkODfUj;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eHtGfUyv+NDEIFhJ+rL3MIjkKe1E4CjtH7InBn8uMWg=; b=ZvkODfUjRXxzIXS3gx3ArInBac
	P7e8ollFJxQa2Sca0uHxuOn78euth+7/OAAiWvXv6gEwDtQknf7cRvXWnrXRC2yeBBdca7QE2cGUH
	JLa79YPVenz9rxuNyOEFGhm+ccbJeNvWEB/Z9nIUAC1YCfAmY55xMmC+9uUBr3nXDppmCSjZZpwnO
	vlJJLLxWzK+kbzE/MwrXBaW/lg+/Mrae2Kn9aV6xeIJ9gZQMa/vniKr1+V2AjwDvjTcBspOXTbRnY
	1xt11Kr2Yb71UtBujJZUKVfj22zEn/HMC9+E3dvI9A4FxgJ3Tw4qpqLo1axhRxTkOeP/iD7/GtYdA
	m4xg5f1g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x0Eew-00000008le1-27hC;
	Sat, 29 Aug 2026 08:43:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 63BD7300382; Sat, 29 Aug 2026 10:43:28 +0200 (CEST)
Date: Sat, 29 Aug 2026 10:43:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260829084328.GO788244@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828120408.GN687043@noisy.programming.kicks-ass.net>
 <CAOiLmNHWGSwAqH815X3JWMrQCc2nh-fRNsNZ0hjQGv8JvFndag@mail.gmail.com>
 <20260829083929.GZ776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829083929.GZ776954@noisy.programming.kicks-ass.net>
X-Stat-Signature: fgxzs796h4ajz7xk3qzgoo3yi4t94b5q
X-Rspamd-Queue-Id: 76BA8140007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787993022-762268
X-HE-Meta: U2FsdGVkX1+n3GoBUEwV10npzHp7zDzW/CUgKErK/5Cj0arMKrUA066CJXgwVNRdE/rs1BmxcXNzHTADyy+L9K3LKmtKi3YkYTrtgcbuvoft0ISldFZXIlxYkpmgP5RnTHc4Qqp47tMyuS0Iv3KCOIG0RGoreiiwhrfKA7iQz2f5i9HCoQVwqxe1489mnvXiW/oc/iWFd2jKNJNb8hS7O/p2XCTq/29zBA9Er+plqs+FYFTtsUeCVjinLJSZw8AdhPNsPYF6GSfN47uSyBUotxdkJJdFi63BhgixrnJld9O/ya/BI8INfomVBzhVOmYAAhnTvR5s/aVw2cAlxb8TZmP+1p+gyTPOOcUH4ohTyB/kIX98l91Y3uuRuIBQ54gRtAUxKWWfdo5I8lYcJUy6LbdHMdZxg5Cuy6TPJbZ74H4F/fL74MXjtksmuF/nekqlA/L4O5VQfgWhvCfVDuiVJnBTtDXFDE5wTvdrp80PgYTtN6JcHA7D6lQDDQTWgk/0ofPE6pZFdvyBDie/PFA28FjxdMdRhu/rTHpA4GlkQ0KNJN0XPjQVwEh3TWK2e/LPxau6mV4A5+sO7PTfJNdsfUK2bgN/nai7p3cnzHVK7gViZJmvyzC7exYpTQQgqArOsnaUjkuo9vLG4dneLprD3aqm3A/LcM9+3+QUqCjfPH3Z+scRCCHLajr1U7BBpvZ3wDJw+xGclpMeBLIyrSkNLs88hzeXE+UH88dGcY0gtWTQ477AY8zCLUyYPiWKwV9IQLm3xkmomg1/3bjvv4e1W2Qv3cQyJJlxLt+IXMtpHnIV1qgsJPQxzrpM7kY49ryl/e/OqOvyrdpp10dNaTOa/4d3N70X7NHC7mYiXTghvdDJ1LkiWLW/FvWC0cSI2OWbcFei6I7wDtAB8a9gayKWS7D3WrqtiFzJKSBlq6YYF9Qu2V9gPI5Ctue6N6R7yhBt+BO4YbNfmbXZVHaFRB1
 0skbuBmT
 bvrZVdKmuLxmYVAdXdUTIBNy0dpEH21pyf32zkMn0FCr6gfLfqnd/BQnJPsq5k8rgRK95we+YHw+nvxb4auhePqWIPA7MmIPi1+CoYOKnqsX0+tGh7+JTRCpon3yKdj9osH4dgJ1SWlDbaAnyy0HllyZteSxCu8fRdMRhLz0XsHeiI9ZA7JwugZeqBDyTWuDu6uYARGpXA48B2+kqQfTysiCQWtDO1iGnEBNct6bnMIJeq3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 10:39:29AM +0200, Peter Zijlstra wrote:

> > The optimistic fast path for repopulate_stack() could be modified to
> > try pulling from a pre-allocated pool of zero'ed pages. That would
> > reduce the function to a couple of memcg_kmem_charge_page() calls and
> 
> Afaict memcg_kmem_charge_page() ends up in a local_lock, which is a
> spinlock, so that cannot be.

Perhaps just don't uncharge them on reclaim, then you don't have to
re-charge.



