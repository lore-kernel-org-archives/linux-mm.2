Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53BB4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489D96B0005; Mon, 13 Jul 2026 03:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462606B0088; Mon, 13 Jul 2026 03:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377A06B008A; Mon, 13 Jul 2026 03:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1361F6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:32:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A93B1169841
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:32:04 +0000 (UTC)
X-FDA: 84982934568.09.E60C6EF
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id E7846140007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:32:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZyRRVaaN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=d10LyRPT;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTEFeO/5EIAP2AE6MFktsovFd8RdOZrL0IsFXTdIgCk=;
	b=ynnjp/pG7SGrvIMfxzDR2BLhZmAdoXn7EQxFcpeSJQnk+u7kn5uugmq0F6zaHbWfhX01/Q
	odZQ3UFTjd11C3fLlIerLYiawhEbYqtXlJcatBRE4DLK7aXx8STkcNGLPkw8ZNsh4+L7Vt
	JdocZvwCYTVAtmSTi4UUj6lcrxnwmdI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZyRRVaaN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=d10LyRPT;
	spf=pass (imf26.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927923;
	b=jfhjkQkpzLSNcxEhhwPGJFv5HoOCrLiHkD2JyAT/x2LQbtnaR5KABngxqI8QxNvbbMPAHW
	OvmSDzTBBePBDMZNogb0d41fw/pb4QutU/6BVKw1Krh2FM6XIJwQOVjYilRLJZpVj8y3Oa
	UDh+QJp36PjUZwAqx+p8yGiv7R0IYYI=
Date: Mon, 13 Jul 2026 09:31:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1783927920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eTEFeO/5EIAP2AE6MFktsovFd8RdOZrL0IsFXTdIgCk=;
	b=ZyRRVaaN/a7Av7n45HMCnrFZ7sdvcF8hzCP7uNhbjBapw+aHEDtJjnEs1CrWFw+3ZF2hIv
	M3jHDVpzqCTVy5G9o5i9LomO/JobmAY9Pz7BMLALFhrVUWJDzrl6lnP1W5As75Uoio+A5w
	MfIcfb5hkJuJI5oX6N7sHyWavnOgSsI4N1ZJLcXZrbLDcwxD1dnFZSIRBJqDrLp8YLiJnj
	XAog1JjTU0XA1iv8403f5UcFofcWj69AZt78QBnKQa89hqhHGZGm8vFUTzlQKlRFYg+XoH
	2rfRcwR6Jvj2iu3gM56+RHj6Oz3Mvla6+PSMdIiAO+Vfsfn5CgVrCWF8RDyMxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1783927920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eTEFeO/5EIAP2AE6MFktsovFd8RdOZrL0IsFXTdIgCk=;
	b=d10LyRPTmTNrbrJWbIolbyfdJhyGilwIxdwRklGSZNFcKFiW1zxvaina3PckVO0/A6wCzL
	oy0ppVgdLkkzKUDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
Message-ID: <20260713073158.CHjwei-N@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-4-leobras.c@gmail.com>
 <20260520150736.HZnlFkv7@linutronix.de>
 <alQKlBaKIOAxMzc2@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alQKlBaKIOAxMzc2@WindFlash>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7846140007
X-Stat-Signature: brdqehzmcondy657dfi43zjipxos6zau
X-HE-Tag: 1783927922-167717
X-HE-Meta: U2FsdGVkX19+6wRVg/gCaWojogFxHd5OOLNCGpK0mV2R2wjrlMgcseTAc0vxSUxNkoJ3fDT8o3+FC90GcYI8UXO+YyafbbFT725a1NUwuLBPemeEOHyN+ifPJwrK6bss5NXkUJUURoGHBgH5xcY9pt0CsS352eOyxduapK2wgIwIFJ8yIiiDMbzBdXey31dapJUH2l79g/p+KklwqyytAVIyhoO+81rFujRQG5TnBaNah7iL5lhHt7+5rstqTZu55mxAnSRdbXix8zAffEwDOW9ftYiHi87Y2pRpSSUoi2DV4aIy76MlcnIiLoIAkOtguXQngFum962ssQ+xO5y/I3rwp+4tGle2lFfO3KgV1W2T8VeuM1RbKkoRVMNgzF90TVqXHvefjYzFjxiAONOLkbztBrRAxpJNMkWWAxUyDqBFwOkmWICYGxt0khve8iSZIiTJFeMlJHLR6PNl502aW0wibsN93vKgQCrVl12YYvAmacnkKXAVSYM3+nBa7Ja/NiT4Duqj7M29bDhRW1BC+rmmdNvAMD1gUGluwV+wUssLEpCuGVdZwcgBK4LVYoSczgm9RskK56GUCNrm/DgNzK787AlYQS0OoKlarMgSOQBfbpEr624TxRNUDT/WsEbASQJZOnUrV9r7B6hgEfq6aoM66f+vee/RAaICwlTux6gfTgtJQpNSB4NAoQAWc29KFK6AijLhHI2eUJk6IekzG+tBjDn+4RaWR8+J9L85usRmfqZDt6We6rb9HdRM9uLdVXBajtVgiX+DXeRGNYAn/l9cndOoXRxX8QvSMrdUP4CperYBo+T0AN0+mfBAkLPfJBdyq3lDQH3IgPPmyqObCyu+W6Nboz2FpIiXHr1NA64r4cPyTU0FFH2Nm736ot6ihYdngTALUTkmjdex7/N7OJrGfBvoPzIZ7d4GPFfPhKEkqa4IELyxCWe2czZYaTGhLje0FTP1tJXywczm0VW
 pJP1KY+M
 n76qlcInhyKufGe/y5aKUK1R15eWoVhkJSrQuwrZ8zii69rHMYaL4VVNIKFQ+1Ic/2+p05m/UZ++S+o6jZfqm/Kv7Y9f4+gXPyuZxw9WfDjqCJ9XAhi0JK5nLsbzACBFIPs3o7YmDceKrBASHe5Na5W0vtvkh6O9IhWXEjEbQ3qRFbYOvdYV1NYXsgDd/JR4+AzkYPRglmva6sH4YiXZiRyfoAYmmwr/xAbLHEuBcmjTF3RxzR0c4tV884V+MqW+/s/aPeoQdwxCe6ulzKIhn9MH2GI3xtpeXcFUwjNKOggI9cF4ndAgy6h4p8u8VFowFUQv9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-12 18:43:48 [-0300], Leonardo Bras wrote:
> > I thought that this improved since commit
> >   ff042f4a9b050 ("mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu")
> > 
> > Did it get worse or was it not entirely gone?
> > 
> 
> I worked in this patchset majorly after that commit date, and it was still 
> an issue up to last time Marcelo tested. Not sure of the impact of above 
> commit, but I suppose it may have brought some improvements without fully 
> fixing it.

It would be good to know what is still missing and maybe it can be
addressed without introducing this remote locking.

> Thanks!
> Leo

Sebastian

