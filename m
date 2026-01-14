Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579D8D37E3B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 15:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95B4D6B0005; Wed, 14 Jan 2026 10:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E8F6B0092; Wed, 14 Jan 2026 10:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D296B0095; Wed, 14 Jan 2026 10:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71EA16B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:07:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17F3BC1F8F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:07:53 +0000 (UTC)
X-FDA: 84330899226.06.739BDCF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 613FD2000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:07:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DpI+2DhX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XVZv71+I;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768403271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C72mCKj6g75hWi4SDABu63k1LKvcFbsA+RvmMJke0I=;
	b=2HdVtxOE2HZqZIyxou2THVn2o2+OYB1XY/tpijjUR/hhur85EWo2fRSHBt7/btmOO5EoT4
	0UDj/xJWhN5UrSBTmyxxDMsDzQxHvbbiXdUNaOxcUdE01upQFlUdy8/L0yKdgdUiI6LQBx
	iPmEPEt/tKayOfbhxmNdYIqM9QREkxI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=DpI+2DhX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=XVZv71+I;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768403271; a=rsa-sha256;
	cv=none;
	b=x8OcTwRq5GskWnG3SJQggiiqsuj0eLXmbpHVuXLao3hhc28TKUIcede8j5OkfvlIG6Wrzq
	UywmZYmEZoaccX8xoqTdkC5BiGpvmXUxaBCY1BPJDJgZiQ1Y+87JMKTRgOnAKilhm59W+2
	AUBXfIU3skiplLzwhLQ6fdJ8Tr0veB8=
Date: Wed, 14 Jan 2026 16:07:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768403269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4C72mCKj6g75hWi4SDABu63k1LKvcFbsA+RvmMJke0I=;
	b=DpI+2DhXGNoB3K9LoI1svHbcKbv3kxb2YyFFdspbE5qXTTBPF+9h8s+FkerT3INURZk5p/
	kBC4L+PoGogVnYmWhgwtvG9+TCDDITAdJYtste182B6otosAomrdWroG5Tbv5B6Yc2uTQ+
	GJQFj6T9tnxuLbW1XUpoqfqjq0CpAV1W4jvu1ogkvswQPrE/c+QHamLYa+ZiRKeKtc294b
	psHNbgTT91lHQklnZcMYINuG1AtadMiWoojmUNN/TJd4ET2c0Qy5/mfpwRF+3VCRm8rnCG
	VZmF0F8rXveRojhDwnXI4kf8N6X2BFd5voVKrZT9HMRi3bv38Q+SGQg7TlZtLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768403269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4C72mCKj6g75hWi4SDABu63k1LKvcFbsA+RvmMJke0I=;
	b=XVZv71+IElwl1uhi03hZmyhqfq9kC8+MP1iK9rfNstyKTMmeHAzHgb7zHvRiRzgdQqo5vQ
	AO99yxFvYK6TmyBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev,
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Message-ID: <20260114150747.ziWhVVQM@linutronix.de>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
 <20260113183604.ykHFYvV2@linutronix.de>
 <CAADnVQK0Y2ha--EndLUfk_7n8na9CfnTpvqPMYbH07+MTJ9UpA@mail.gmail.com>
 <596a5461-eb50-40e5-88ca-d5dbe1fc6a67@suse.cz>
 <d8d25eb3-63c4-4449-ae9c-a7e4f207a2bc@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d8d25eb3-63c4-4449-ae9c-a7e4f207a2bc@suse.cz>
X-Rspamd-Queue-Id: 613FD2000B
X-Stat-Signature: wm7ia5pdppok8akziskq5etskze95mb3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768403271-671740
X-HE-Meta: U2FsdGVkX19CCfTxb8u8x2eIy92ok2GmXcXeahxhlRSjt6iJ0AzllTW9LppTqEEiB+kSQg9ag8yYc2WPMVPIJPjTOsS1n+MjSyC+6Xqpbh0PvDUEjDlUdmbSM0ZYAasSO9WBCt/VfcoLCH1po84MrkWtBeq7KgP+PYL5G11uIHUUanQql3T6/YOek8DL830Amkjn5iksBbqdpOJIxSu2n3RGDOhCRZ2A+oxZDApka4rOfEYu0YH1IEkRaKJsGVshwtr9+dIcXGNScNLiZOcG9ndkPBQXS7TveQwBNsaF2vgIFt6u9NYDTCofzTYg3S7HMVmzoTeRVrmVz9Hj7Zf2A1cDcLN47N4QIZDI6saU2CHyzfYHnBFfq3vlImYdVfVWpol8p7pBQui6J7cF5PPpyhQHj3Gy6gwtzRK1YSeZo4OL022+NZu29Kco9L1p+UQQEUvl8Et3/Poe3l/odAVBbU/04AuyEmW4YuCfWt/5dhnHV+S7conwVFvn+yPpG7lawuUBxSWOH7BmyUaz+lBUlMJ9V8oc41v9gLgig1pK6r6qXrUm9PdrIXQ+6PgH6QI2qfaFxomeEKYvsR1JocZwMKJ0647EUGtWqr/UIelS2+i8z74QauiAkU+sqjyJdhXE0d4Wk5LtIwIh0eE74Twyzaokz+ymKGzTH3ItlOaQhJo/QIdmJvGn9kXCt4d7fbxDUIFKOT8x8NivryYtx+Tk42LVdx/MWjvRdfm4aEeNZRAyQ5+JzBpbHO5RPJAQZW3+57zQaGiakhve2rpY0BMVGHqj5G969Av8RC/svo/lA+75Tige/yR2jb9oWX8WdMgMeJpf8869aHTJ9CccQ8Tlii8pOOV+zEpBJP3wqphjq0+A3ktnns4v9psBwTmBzeyUrfF0Ar4XrOKiMW2tFbLHv1WHt2Oi2PpYoKc4/766XDN/x4lKRQ6lIBZszi3gHGlHsbC0GEgwUB45B1MWULw
 xt7UlPL3
 Yr1JcQf9ZEvM7PDdP8uxicQKKTC/3wK2hphjc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-14 15:05:34 [+0100], Vlastimil Babka wrote:
> > Yes IIRC Hao Li pointed that out before. We'll be able to remove that
> > !preemptible() check that we area about to add by the patch above.
> > 
> > But I'm not sure we can remove (or "not put back") the "in_nmi() ||
> > in_hardirq()" too, because as you said it was added with different reasoning
> > initially?
> 
> Ah right, it was "copied" from alloc_frozen_pages_nolock_noprof() where it's
> explained more, and AFAICS will be still applicable with sheaves. We should
> add a comment to kmalloc_nolock() referring to the
> alloc_frozen_pages_nolock_noprof() comment...

Right. This looks halfway what I remember. And this was works in atomic
context on RT because of rmqueue_pcplist()/ pcp_spin_trylock() usage.

Sebastian

