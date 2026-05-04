Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F04FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EA86B008C; Mon,  4 May 2026 09:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E364C6B0092; Mon,  4 May 2026 09:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4BCC6B0093; Mon,  4 May 2026 09:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3B906B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:04:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7ED81120154
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:04:08 +0000 (UTC)
X-FDA: 84729755376.20.C8E5A68
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00730160008
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:04:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JL/XmGCb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vznWPr7E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JL/XmGCb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vznWPr7E;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBtiQAQr6P3N+MHRplixCzeobIB5oib2P5/9uPnbyH4=;
	b=NLtt0VqZRVTaZ8U71hRiu/AGv5uOX/PDX4AlOIfDNeT/ZcpkHNJGmsKXEZB+P90xNrXgG+
	Cp1xKDP9OUWpDfL24TGzCLxoeKTcOZGLWWH4SPURKOLbR9dCPgSRoBjQRWSY9z6SKj31h5
	uxef5qKvsGpDVF6COiyN8oHZfdAI8rc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JL/XmGCb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vznWPr7E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="JL/XmGCb";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vznWPr7E;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777899846; a=rsa-sha256;
	cv=none;
	b=orsKjfmY/ls61AUbd2swnc8MPKPetffHsdiKRr7M/WitUAiAZre4ANR3IMXUb7Xodn2FHv
	K4UIFt70TR6v8YoJ33FvMFsPpUy3ffEj58mh9jAnwmEUujND4HHa0knTYH28UdjNw8cFzj
	b8LC79BE0yidiaV7R0xMKsqxj6cwOLE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FB5A6B1DA;
	Mon,  4 May 2026 13:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777899844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBtiQAQr6P3N+MHRplixCzeobIB5oib2P5/9uPnbyH4=;
	b=JL/XmGCbCu7Pn0UFm+jahisb16WhHFai6O+3lv7XPFMu2xae2FLJC9y73Ya7QQ1c594PSp
	zIul6PJ51MjlwxJvLAh3JoWQaiH8bSjtiZuj66e8SanvgvDhY0yDxgFLxCNajU06uEybXH
	6z1rmn93QXxpKSaJmJiYKMHvK8WYKX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777899844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBtiQAQr6P3N+MHRplixCzeobIB5oib2P5/9uPnbyH4=;
	b=vznWPr7EkkLaMX6V8cqN+5Swo1ue1myMCE36D39F6CcK3OfL/g2gaHWLp5fMsKlngpFtjp
	hjbl6G2bCuN8gcDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777899844; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBtiQAQr6P3N+MHRplixCzeobIB5oib2P5/9uPnbyH4=;
	b=JL/XmGCbCu7Pn0UFm+jahisb16WhHFai6O+3lv7XPFMu2xae2FLJC9y73Ya7QQ1c594PSp
	zIul6PJ51MjlwxJvLAh3JoWQaiH8bSjtiZuj66e8SanvgvDhY0yDxgFLxCNajU06uEybXH
	6z1rmn93QXxpKSaJmJiYKMHvK8WYKX0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777899844;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lBtiQAQr6P3N+MHRplixCzeobIB5oib2P5/9uPnbyH4=;
	b=vznWPr7EkkLaMX6V8cqN+5Swo1ue1myMCE36D39F6CcK3OfL/g2gaHWLp5fMsKlngpFtjp
	hjbl6G2bCuN8gcDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EFD4B593A3;
	Mon,  4 May 2026 13:04:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPmGOkOZ+GmDfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 04 May 2026 13:04:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BFC89A078E; Mon, 04 May 2026 15:03:58 +0200 (CEST)
Date: Mon, 4 May 2026 15:03:58 +0200
From: Jan Kara <jack@suse.cz>
To: Barry Song <baohua@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <n5vsmp6ingbhfztl6wzcwmrz56gkkfbpzardk43scr7rcgqsw5@evtnov34c5bt>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
 <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com>
X-Stat-Signature: 9r4tezp94w46c68aa761rhw1ey49iatx
X-Rspamd-Queue-Id: 00730160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777899845-980592
X-HE-Meta: U2FsdGVkX1+zkjkrhQh446kFHOF2ALPP1LTqXXSmoJU2md5pH/MAvBKv0qUesUnUKcI+okXyA3tbgZj9gJ9LN4X0eWu065gTItd9MesvukZezxGGEApuQuCxvxDU9Rn+391wxw0IwEg5D94JobsfIqa4ITvW9o7F6GF9WZoZPWqaxMSLEmI+g7M8D/Cc+1wD6cZIk5k6kFlj2XWKpNfqYt9xLE/L8EhNXmwdwVvG7/3fVpoUhYH2anSMtLPCFrGWGQsbp8ofjpV7M7xd6kw76Ige8EeAIBA2Wc/cdnepOwgR+yvegiGe27GC3JAMqhTBPe0ji9xUb2+BybiEcF96Vp1dtoxkviHukE+RL3WkD3+jTrAi8QriRRrVU2t4b1b8zHWazN07OZ1l4DrFyZrqkGkk3EMb8M5Km3U1OA3Zomwta7NLgAch9RpCrXdTkVnihr/15/YYxuF2WFVq3laBJXvw2i3cnWLQE8D0hhTSpSdkOFyfR0OatNT6/obq19a3fOE7gNlURhP9HxSbmnidxy2KMk+E4RvjpN4rj/VJBDe54N1a8wX8KoI5QyqM518FcYDND1AFKatZrPncBACE5ru+m5ZauNf/hPTiNdQpQzis2giK5orviKdP98zK1iRJzmOmbTNXek6/F/OxCOtIgC7LzDv+jI9R7g4zgRE+MZ1HuO8Fr4djqO/qWY/YeWfUbcv2irO/ek9ScGpvTgvvtbumM1eKMVGn4AeqEndPzKRJ8y0XkznWK5xFrJ9/Mu3A2gYnMAsIdPS0qv8LlaOtLEDHtzGXr0qdXv5zYy4FAyJ8qnistf4gv6hhA/D02glN5MQSiuApRkDmWfENmNgkxC7+gyaWRwnsJPzDkvYl9M/gmuBvdF0OjTV4AO7tEye5d5t/MXzWgfqb066nYrSmrZunvNouelsL8rcA0PdTrdFcSf92EaJCTNETuf6CNLnYlqoCor/x4WBZjVsQCBw
 3q4PmVKP
 FnNtCG1Aa4esuxOXwc9j5WiEFHLbaNA5M0sqDBSt2Nt7kXYGZpc/9JYBMtB4hoWVWDp2DziRMcI06THKLOseLzyrMlx5USpxSePfzIuoCvlDTgsx6npbTl7yADH2T9yuXpiMne029amfLJtN5qO23k7mMogDzguT2tNM3bo1+KXhagFaIekfEStLVhHYeqmkl9hvO49zrUb5ITQ6IJAWGHSjWhepKWt0jaQ73tf3gsRoV2PdgeG7OjsVIQH1ruWAa08uzlMw2KKS370FisE4Q1wb7/3R8RJknkE48NvHebScq6Z9ZIfGlrsJwH53VcozDCK0gkUcfLdaSGYfEFGxbW23ou/SyRmIrxZGZix1sVHJv6oxIx3bolCLUCM0l8lZqOXH62GeCdADyLQ1zwlazhkfbks2WKb5c5gaoBAcBkxDHyrlIDKBY23M4pTdw8PZHKvhx2MIhhIGwPOgipF6AYTh66NAJW09RFvN3riZmG1yEd/l7wgQMWTPDTTzatvQNpVI7vGilGsAriRRAA7detMwYTdUJtSCSswU1vl+Kb0544rE9k9uI139WNwLOBqc+zTM1l2dbOK99c5ThEOGKWV65m9FI1LXZnVjOsy5FRygHWEMNAjcQBUwS6MtOxKs2A3pLhj12akONCpQYc2Kb1dG64CyJIRI7Z7trQUkEhE1dMHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 04-05-26 03:55:43, Barry Song wrote:
> On Mon, May 4, 2026 at 2:17 AM Jan Kara <jack@suse.cz> wrote:
> > On Fri 01-05-26 18:57:52, Matthew Wilcox wrote:
> > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > On Fri, May 1, 2026 at 10:57 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > > 1. There is no deterministic latency for I/O completion. It depends on
> > > > > > both the hardware and the software stack (bio/request queues and the
> > > > > > block scheduler). Sometimes the latency is short; at other times it can
> > > > > > be quite long. In such cases, a high-priority thread performing operations
> > > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
> > > > > > for an unpredictable amount of time.
> > > > >
> > > > > But does that actually happen?  I find it hard to believe that thread A
> > > > > unmaps a VMA while thread B is in the middle of taking a page fault in
> > > > > that same VMA.  mprotect() and madvise() are more likely to happen, but
> > > > > it still seems really unlikely to me.
> > > >
> > > > It doesn’t have to involve unmapping or applying mprotect to
> > > > the entire VMA—just a portion of it is sufficient.
> > >
> > > Yes, but that still fails to answer "does this actually happen".  How much
> > > performance is all this complexity in the page fault handler buying us?
> > > If you don't answer this question, I'm just going to go in and rip it
> > > all out.
> >
> > I fully agree with you we should verify whether the retry code still brings
> > in real-world advantage today with VMA locks. After all the retry logic has
> > been introduced in 2010. That being said if there are realistic loads where
> > one thread needs VMA write lock while another thread is faulting the VMA,
> > then the latencies can be indeed extreme. For example things like cgroup IO
> > throttling happen on the IO path and thus can throttle IO of a low-priority
> > thread for a long time.
> 
> I’m quite sure that swap-in and VMA writes can occur
> concurrently, and this is fairly common. For example,
> Java GC may use mprotect or userfaultfd on a small
> portion of a large Java heap while other portions are
> still under do_swap_page().

OK, makes sense.

> If we start exploring different approaches for anon and
> file, I agree I can revisit this on an Android phone if
> there is a real, serious case where a file VMA can be
> written and a page fault occurs at the same time.
> 
> Please note that, as an Android developer, I am particularly
> cautious about priority inversion. A recent issue causing
> severe priority inversion is zram attempting to support
> preemption[1]. When a task performing compression or
> decompression is migrated to another CPU and then preempted
> by other tasks, high-priority tasks waiting on the mutex may
> be significantly delayed, impacting user experience.

Well, container people are concerned about priority inversion as well. But
usually this is with coarse lock (such as global filesystem locks) but VMA
lock is specific to a task (and a VMA) so there the opportunity for
priority inversion looks more limited.  But the example with Java where GC
thread can presumably have higher priority than ordinary Java threads is an
interesting one.

> > BTW I'm not sure I quite understand Barry's priority inversion problem
> > since I'd expect all threads of a task to generally be treated with the
> > same priority...
> 
> Exactly not. Maybe these slides[2] and this project[3] can give
> you a hint—they aim to standardize things on Linux by
> learning from Apple OS. Basically, tasks are classified
> into five types:
> 
> USER_INTERACTIVE: Requires immediate response.
> USER_INITIATED: Tolerates a short delay, but must respond quickly still.
> UTILITY: Tolerates long delays, but not prolonged ones.
> BACKGROUND: Doesn’t mind prolonged delays.
> DEFAULT: System default behavior.

Again, this is a clasification of tasks but not really of threads in a task
so at least for VMA lock there's no inversion so have?

								Honza

> [1] https://lore.kernel.org/linux-mm/20250303022425.285971-3-senozhatsky@chromium.org/
> [2] https://lpc.events/event/19/contributions/2089/attachments/1797/3877/Userspace%20Assisted%20Scheduling%20via%20Sched%20QoS.pdf
> [3] https://lore.kernel.org/lkml/20260415000910.2h5misvwc45bdumu@airbuntu/
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

