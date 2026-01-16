Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C107C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E006B009B; Fri, 16 Jan 2026 10:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8266B00A0; Fri, 16 Jan 2026 10:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA9F6B00A1; Fri, 16 Jan 2026 10:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 965F36B009B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:57:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48C59160197
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:57:50 +0000 (UTC)
X-FDA: 84338282700.14.5421599
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71C632000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:57:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="vR/nqsXE";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gEt4DiTq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768579068; a=rsa-sha256;
	cv=none;
	b=MteHt+cImKKzZpGbIox50GpMkIIyu/FGYOnhmVxrDM8CtPnt7rSnpbHNR2ZRSlyBMQygaI
	e/nwAi6l70auyoiSEF1G/Ca1jfU/7EiEu0d/+qISEcu4k4GnbBAUIFL1eUvT5c6yf6stPA
	duD+88D0wEos7Oaw2ONVZMifisc1DCs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="vR/nqsXE";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gEt4DiTq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768579068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9etu3sCjCjTSqJooigB4P2AvUUWV708r9U+I1MOI/Y=;
	b=k8aRVInr6mfcMcarGMQcctonApziQyCO/kTlWi0kXavIJ/93bL3u2lQKn0OUp20mkGgRCx
	R3mpAviVHh40HbaQeDT9KlY3RRWP8Kaa5ErGbs7HwrOnNTFTbG+hcZvL+uVatMT5WTqkRx
	7am1HpSUX7fy2myfMfyd3s2Xnh9L70E=
Date: Fri, 16 Jan 2026 16:57:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768579064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9etu3sCjCjTSqJooigB4P2AvUUWV708r9U+I1MOI/Y=;
	b=vR/nqsXEkrmj920u4bSRlsg8D3RS5CLxH6+3Y3x4mGfnNhgVONyOrOCuM5Vwi6Nf+MOwvW
	hbzgjfqAfJfMQpEnXb/aoJCtEfA4H3dy4czCbD1dR4AG2dMpcygEITq80PBX9lGmLeK87u
	CXk9oyHMgXWQkzZb7t/1OYdOFV0d6+19Fd5gKygD/xly8P3t07enM6sMkn21vpF8tURjCn
	vw1eoPKrScIxMy8PV/NiqNQK694r61tw1HG5gmmrFWYf+xP4NbvZuJMWSO4VBg0hDeTjC+
	83zcWJ/4FQZAjTpPGfMG5bVz3myy4MclmipJBnLWwVj6xKFdwZoXAGM2MqelYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768579064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9etu3sCjCjTSqJooigB4P2AvUUWV708r9U+I1MOI/Y=;
	b=gEt4DiTqASRp7Z/aRq58bV9igLDbT8eP3Ad+TbHeuHcOcmClxTSb4LPcO0wCm9loMmeqGl
	M4ZTRH8MP0SZRwBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <20260116155743.AuMKcTAO@linutronix.de>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
 <20260116151215.GH831050@noisy.programming.kicks-ass.net>
 <99818e30-9f88-4751-af82-0bed019156eb@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <99818e30-9f88-4751-af82-0bed019156eb@lucifer.local>
X-Rspam-User: 
X-Stat-Signature: 97cbumnx46frzqr81eia7j8ok9oniuub
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71C632000E
X-HE-Tag: 1768579068-18563
X-HE-Meta: U2FsdGVkX1+9YOfRT/xfM8MP8EWw85xKZ6MPgbuImN+HqAqZxln3GX8y56Kn7FnCQZHdSYvJgRsfEOdCuvHvFIIyfvhprGDewHt9yw30k/Y+hzPtMaTVO2KCab1bZKqS+T3mNTdJVLuOvMgyFWy+iKC7Y7mhlGftSso/JCN+1+g0saCpz6/OWW8ZC85Cf/d8q6MGqpTHTkH9VR376shHNYcwyBTI3RZK8QbEYvESQcG365VnqEP+/+B2my0r4BS5f1ivw8H7OkG43kOTFTsHfc1F+P43ttXu99WrplvRhjcMYG8yPW1LmSocydk+Xe44baPlK+ckQKi5QtnCIuObBx+E1JA4tzogrF8OfxHvHf8RsYezhvoIVb39Pxk7F9QePnIvJccpaucDLqZIX66Ynhrmn7ZavW7QnuaY5ZwmpmhiW54588W7uiYZaw5a4XyD8yzx+6N4ZuZhMXSG1c+D5AJbHT9Fq+Y75uliutnlhxSNdlFS3GqI3Dw/3q+vq++L8kgkRQAPEnOnPNgwfg29cVucE2DPLYx+6ugvCa8j3H7fV7wU06MfWyPcj6/QjwYmz0gfhG0DrxolQRCISJKbWxSUAtdKH1zsxiZmFnj6634GFtVKQqraITLAHj6DYElHym7ORoK98sCefqodlmKxrefN54X2tCZ+X4fdnl2ncbaQ/sHgrz0azD7DIEIJDVeR7pH/uhyP//MHSLzpHj3T7QxaBsQTtZzIoy/0JKvTc3h5ATmaeIGvu4tb0k2w36X4wo2169np2Pqsa0rjeXIEecicfNO0rK9phpT59SVqazuTJs4Fpp2gv9VqNt3omrKKPCh0yNbTJxhwELmzdeuGZj6nYnSRU30JuVSzDG6FphhODV267Yc02C8U8QBboOeRIW88UJaUe6O/n9U2cmZ/56q0HWIEtbqZDZs1h+C+zDVqQIc7BoTZEli6WGIGUxJ7KTjp9EtsdSuP/zGl60f
 3zuDrK6N
 HmJnj1wvkV7kPixWZvj4J87D+Q79rMGXIJLrp+sN9qybJae1Bfn2YRKUHaKBg6y6jfdaLTt0tE2ZBE8SJCeLEHNAJJppJxZddZeaJ8Fn9moTwC7j79dEzPSLeZItrdn2w9npbWV/kOTKZoxMoZF7iMR7cb6AKpM2Y6BntKPwH9gpJjiq/hojG65etEwQbh8JSqOBnXl3bP9NTTLjZF8ztR7KCPeJSksYAi0Dz/Ty6B5GRHnNWsvEznn+mPzwU1RXdclsVusYGKrs7SyZTroR5ynZs8dizT6kNtihK0F4tqblPuNxtKd1baz8mqS2RCw7eunjo0eNeLMnPs8czDcrb60Ckgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-16 15:50:24 [+0000], Lorenzo Stoakes wrote:
> No, but we need to be able to assert that one of two locks are held and we
> don't want the failure of one being held to cause an assert when the other
> isn't.

But why don't you use the lockdep based check? That assert only ensures
that it is locked at the time you did the check. This does not mean you
are owner - it could be owned by another task which is unrelated to your
cause.

Sebastian

