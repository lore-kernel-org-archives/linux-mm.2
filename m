Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633C0FEFB49
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFC26B0005; Fri, 27 Feb 2026 07:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D8E6B0088; Fri, 27 Feb 2026 07:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C876B0089; Fri, 27 Feb 2026 07:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 926CD6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:39:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 347E31B73C6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:39:08 +0000 (UTC)
X-FDA: 84490191576.11.6972714
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 48C691C0006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:39:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sx9uvzb6;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772195946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lagw43JwvowHFrojgNjKAjJ7QQwZVHMS96IQwGeM2pY=;
	b=3FOk76Y6ii1jhIfszumG09oJixLrFKN59N/dLcycmuoSmUs01sehwmZWm/sBQa7IQpCju8
	w9FULFZUs8ZKKTvFzxWt9D9bTUUazcgHzc58ZYv+uSPTTPJ4tnetgm0oBmV2VhuUJN/3ME
	YBygnRCJhaRFGySW5/nuOLjULxRhrAk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sx9uvzb6;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772195946; a=rsa-sha256;
	cv=none;
	b=34wQ5LDDd5PfkftT3xcjkmpCxKwnV6ao5qMgqyaCiEFMc2gpVkBsAvuKQqeysgb4XZEeqd
	m21fnLGqN0f1O4sLGU4EqxlQlR/P2qXKIlrmowkx8nIssmzWHlTnNdND/YDawFgzgeHEtd
	Q508q0vGTgW1nZV5b63glmvCkrb/wXc=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 66C23B2DDC;
	Fri, 27 Feb 2026 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772195944;
	bh=lagw43JwvowHFrojgNjKAjJ7QQwZVHMS96IQwGeM2pY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sx9uvzb6fY4BMRxlL73VCSdMzqVe0zeqoGpO1lAPnBmEbW8AbhPkSkGPuu4b460kI
	 m8BJ+MuG/RJ3vmuNA1EhDXrHF4vH8Cz6IEgFFDLR1qgBc+fEg5kSEb+okRx7bGt+Yi
	 ybSwmN9VBUS7VW1OG4Lw1HGV4ytlCNxAP9PZYpRE=
Date: Fri, 27 Feb 2026 12:39:00 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 5/5] mm: add tracepoints for zone lock
Message-ID: <aaGQZOk0_afa8SOk@shell.ilvokhin.com>
References: <cover.1772129168.git.d@ilvokhin.com>
 <378089dd269249d3d7981fe10eb8b49ad551d353.1772129168.git.d@ilvokhin.com>
 <aaCbMwGNuUO1SbUb@linux.dev>
 <20260226132501.5b70914daf9438a1103189ee@linux-foundation.org>
 <aaC7S2ensAGTyujc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaC7S2ensAGTyujc@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48C691C0006
X-Stat-Signature: e5j8uaxhk66hqzdd1imm8nm7x3z6jwei
X-Rspam-User: 
X-HE-Tag: 1772195946-823043
X-HE-Meta: U2FsdGVkX1+E/nju3DC1SaBZyMNKb/w+kK0s7vyqDelzwSjbb/aPgPoJBdaogx8E/rnh5LUsblJghyApREF6nuxFoqIba39RXA23VqKlWD1FWqSO8IWwlmSTHJkhym6TpC+XWLrq+yjCB9W8tKhvowFur7qBuKN1y7uoGqSEVGSlzRhHAgBDYjZkxYunJZOlE1kMUkwZFvkijmMms66HBX8Uc6v1tzPZ2I4pXNQwc1FddZf/XOhzT0YYSYN0Mc3cmR3S5hlU0IwrhT/BpHsHzLiRQKWLuBhlhYUBrEFC8s2fX8FW6TveieAoQgCfGpFDb0ZZaLBc+eWmJ2vkJsnUL8GtLKw5mFHVTN7AdAFDTXIhS7kY4dtK6Et8oHOulwf8jyZIZcSnUnSXzPnVjCE5u5nIm42emLY4N1vlfE4MCQgRpHEaJGx095mPdNZTxN63pD25kWzVmF4fBpcesspzz0iUYYY5Qy2n3XkbU6ypiPP0Ca9osK2Fs6wrRhZD8dPmfaabhk55kh/XpPKc0b9VXff9E8+vjPaYpVaeqhjNbXwRfM5rE+gK254u4S8yyLgWPO2ogwo4Fpo54hokcriHydokVxoBiVH8VtDmlSpis/iheUaynYTvCKUHtlLbnTuXn5OpoGNkOx5VuG4uw8y4Ap8Ye6r8WkPEONVE0uejCb3kjhy7VJNdv/Dpf1mYArKahTQoPSnuDpQQHfyZto6uWoYk2WM1nWziFpb3YQAJbIs731j7gyBtqXQOeAgGWVUnAmC7EVXQEMnjy2nficY2BJ9TpoudppI2Bo/QCXeCyaQzt/e2+QtnIwJvv2y0k4rIupn7djIwKIe9pcOa/HWTa5rfyXYxj6IKmn3wd36XX97YpTInrvMvw+ZuckrselSHbSch80N4230+9860zn1gRn4yPmq+uv2rHIdaaPq4E/G23tAVq+UoJv7tmVWrwIxCNgHXjUoEOQmET2AIOG/
 ht2o4+6/
 UglrXMXk5IZWoUZdiEhZgTzGcJuaoH6jKTE9CoxRxiM0cANCHbckrR1okvB8xtDmkMszmvclswudJMvg/BAJlUv8XvYSDShunFczQTFaSBbYx4Coy52dSWJ5Mwqwei3E5MDt0H40j+WBDVVOCDMqwTCI1ESeDjsHIMM0s40umAVfPx5NKqN3TbEEcXqBzNhmbbuFlEfAUdrNz4KmnK4xmoqti0uhYun4cHUKKvOnF0HjthyfYnaqR1EoFKoDPHzftAwgEAkEFh5gA6iclgFHGALZB65oaO1OSfJlo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 01:31:48PM -0800, Shakeel Butt wrote:
> On Thu, Feb 26, 2026 at 01:25:01PM -0800, Andrew Morton wrote:
> > On Thu, 26 Feb 2026 11:14:52 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > > On Thu, Feb 26, 2026 at 06:26:22PM +0000, Dmitry Ilvokhin wrote:
> > > > Add tracepoint instrumentation to zone lock acquire/release operations
> > > > via the previously introduced wrappers.
> > > > 
> > > > The implementation follows the mmap_lock tracepoint pattern: a
> > > > lightweight inline helper checks whether the tracepoint is enabled and
> > > > calls into an out-of-line helper when tracing is active. When
> > > > CONFIG_TRACING is disabled, helpers compile to empty inline stubs.
> > > > 
> > > > The fast path is unaffected when tracing is disabled.
> > > > 
> > > > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > > 
> > > ...
> > >
> > > > +void __zone_lock_do_trace_start_locking(struct zone *zone)
> > > > +{
> > > > +	trace_zone_lock_start_locking(zone);
> > > > +}
> > > > +EXPORT_SYMBOL(__zone_lock_do_trace_start_locking);
> > > 
> > > No reason to not have these as EXPORT_SYMBOL_GPL (& below)
> > 
> > Do we need the exports at all?
> 
> Very good point and we don't. I think this might just be copying the mmap_lock
> tracepoint wrappers which might need the exports as some drivers might be taking
> the mmap_lock.
> 
> Dmitry, please confirm (test) and let us know.

This is a good catch, thank you. I don't think we need EXPORT_SYMBOL()
here. Just verified it locally. I'll remove it in v4. 

