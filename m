Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC622C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D056B0088; Fri, 10 Jul 2026 00:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD6E6B008A; Fri, 10 Jul 2026 00:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFB76B008C; Fri, 10 Jul 2026 00:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5571A6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:09:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5908A0330
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:09:53 +0000 (UTC)
X-FDA: 84971538666.02.6179949
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50DE7C0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:09:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UZKgSZ9H;
	spf=none (imf10.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783656592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZ2ZKJwyH+czH0S6wCGrcRFmnJfF64txwylbTE5TD3Y=;
	b=60X0HjrnkCnp3EnllufyNVrh7wgDfoxrFgTKM/gUGTIMnOpnEBtL9bKKQWmfWOhX+66w8L
	YLA6K9rRNlR4Xb6Wopvf3nMmyxDkgrK1VaMMdDpNrSD2JiYj1gSB/w2ahpozzyDlSRZx0T
	0tIe3KZYsyj4xzTjFzBsBzelqsi5Zyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UZKgSZ9H;
	spf=none (imf10.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783656592;
	b=FGd4fSQHQnR1ncQi0it2bWcb96CDnjeydwtMP2LInCLCWhduSzzbm/mgrt4eDjGWPBRwOO
	mwpHxT1Iaqp9JTE2x5szZ7scP1YSP/XAsiIKyRJvkttP9MRscFQ6/5otXFh+od3gDkszjd
	Cf1xiRJXFZY1BiL/UCUUglhN+nBfrjU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XZ2ZKJwyH+czH0S6wCGrcRFmnJfF64txwylbTE5TD3Y=; b=UZKgSZ9HstM/m6zYkRbYa7ngfh
	DZ/56Ny6UarWRcWvOxILB52RdTY0S/lHv4mZLNuD2heZv5MHp43p74p7HIuDftdk55uB6CB1dDa3K
	jbkrEd87hXH4+3hLmn0IQwvXRw/c7ySwiiHkMFgXYVetbjUKqLsHBY1QS+vuGR6dG38TRnUY/Neoo
	XJlA7lXNLL8J0bmr4Y4KTj+lhtXLClFJ3OqTu6Z/Dkfng25d6iHRlJh/0nzLndSfFYKGT6Gf2BPMr
	PVr+yA/Fk8aBAZWsQVZ6SRgj7aGESs5Kjbdl/pHBqMDGf/0EupVJ0um+iO2M4vAGoq7t4phcoTnCW
	l0QHE1dg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi2YJ-000000044w5-0wtb;
	Fri, 10 Jul 2026 04:09:27 +0000
Date: Thu, 9 Jul 2026 21:09:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eugen Hristev <ehristev@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v3 11/26] mm/swapfile: Annotate static information into
 meminspect
Message-ID: <alBwd9ACdVNEucut@infradead.org>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-11-7aa5a0a74d5c@oss.qualcomm.com>
 <ak4AgXqMnkn8rVGE@lucifer>
 <20260708190535.fhqaddicljho44eq@hu-mojha-hyd.qualcomm.com>
 <ak-1HujOABoQ9wR_@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak-1HujOABoQ9wR_@lucifer>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 4xtcirg8yyrsark7wabq1xd8tswziett
X-Rspamd-Queue-Id: 50DE7C0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783656591-790039
X-HE-Meta: U2FsdGVkX1/aRHafubDj6+uGTZWRpY0UARpSPmxd4LCNKMGSWlXyv0uKKN6TBXvkdhtC9PNvXLQF1GPUlkSOvTE12CZFbo2KyzUKtWoZMR0YdfeHEu27Isqt4y4qraeuuzgKwvAl0fdJ/xBQ9cUq1xAzBls9SbXOeGsfNjJa3xCnvBBkPQY+Fm4CwD9dgkX0WfZC2IEXyqPWjCxFdpB5iTu7KD/Fl9QX7te81ZYo1Draiohd311olQ5NojFndAjEtlSULaBu+a5DyesdHzxCskMpS7yQJDgK7R1rICwFvcWf8qjmAvBl7snWTnhLaoWolq/s3GrS5JZ4eWyucLaYsqswT1QXB0gHJrfMDESSJQbaF7rRdTEhRpct0nprlkO8eXWa91ARU8H33nBcvNaIOAYGoV1bSCuGnogEc/LiBLfaKoiutG7079nEaqxwQNEYOpEBLOH2YrGr1OBrtnlmNqQFOiZK5pt+ZJMbldrdrFZ67xZl3KgtqM624r9GcQcr84H+v5qipUHTg9Uhy766Bv0edkfE3+MQM5L97V7BJz44Dn45mU3hobSQvM1t1lUMNCqFiJRX5aawB/1iU9sKtSAQTb4alWvPq/RrCUPf4xl8IrtLEhyCX4mH79vrjTJ4UjMdZfw0wcbXedowsY0iLl47o+cQkkW4NnjUjl2iwb84QGsDUk4WglvSokHJ3IyRpq8Mb3WlfIW2acvp+I20RDqm8D40O1MBVarQpyyCsTClhY6I0re30haUUjWkmVwxi/V2wF80ZssLRWslvZh3AWfpmlOrJLElv8mqIzHL+C3JxBFZ+lxMq5oD1HFekhOGR/AB1Ge2hH8PCTF+qKC1QAqgByw/PX48L1SFa2bRLt7fMXOwKRzReZqZnt82lmcCa1rKmmul4tfZ24jow6nd1CetDf1dOSWIav87Wl+/BGLltfsp9YIlpsCRg64v8KZZiOKlTJw4twpG3KEQoDS
 wvr4h+S1
 os6NDoe4BBq+9xVJaK/3JAPBp4N9a3f8U8tLWEUItIIXB+p6+Yp7yulXu3jeIHC5od7jb+Y2wCLhtl94g41Hn0nyQwRPIruunNCoAs1FoX9L3Z0cEV1wNXgUXPZ7Xh3oCgBUBYebCU6Xf7UZYAS+0qlevLrAG44zRdp5DFARGhwtFOLK8InQpVJpQ620e9aW7KzLJpe89R17oLmvwfNomOuvuGaNxBCA8Li2YYjsjF2tFFza8Yzt5CYLb/CX3ETc9ZDweoU5yU3KzTeqgRENG91BgKV22otVuq7iC167jxJe1Tzow7N/0iY2vTwpcAJ/Ekff/VwHkuo7esACT2YTZPqoX33trIp2DgBoKANXzrhU/PReSEPNl0RRYGsDzAELVfYztOXMVDjcifYHxsIWtB5OKjvpAugR8Se2d2qIZe7VepX0B39QRio/jKQ8PsbzapQOxisaQx6V8LdcbD0ymvW85RbnOZn7aBuPpYEX2j9e1HngW2t/ucOe2Mxrmky2DgBJy56AlUPJubvzQS+u8UXLH0cOeijLA1CAtQvA6WVt0/74abTq8rQbqYlu6kW2N85WrsaTMwVqa6XMHnJkXGfGtbnw8y8vTDbewxToIqHgVvPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 03:53:44PM +0100, Lorenzo Stoakes wrote:
> > The whole reason we had to tag most of the MM symbols is that
> > the crash tool looks for this information while launching itself.
> 
> You're missing the point.
> 
> EXPORT_SYMBOL_GPL() != EXPORT_SYMBOL().
> 
> We cannot and will not allow symbols that are GPL-only to be exported by the
> back door to non-GPL modules.
> 
> Meminspect seems to ignore all of this and just exports symbols another way
> overriding kernel mechanisms which is just not acceptable...
> 
> I also don't really understand what you're saying here either, what has what
> crash looks up on startup got to do with anything?

Yeah, random backdoor exports for a totally opaque facility without
good use cases that comes from a known malicious actor like qualcomm is
a no-go.  I don't think anyone should even waste time on this.


