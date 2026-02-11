Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C30AECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 17:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CFB6B0005; Wed, 11 Feb 2026 12:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32ABA6B0089; Wed, 11 Feb 2026 12:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1E56B008A; Wed, 11 Feb 2026 12:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1BA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:05:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD9FA14049C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:05:47 +0000 (UTC)
X-FDA: 84432802734.20.6AEB37F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7111414000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:05:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SU+CS7BP;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770829545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhsgB31/ghAQLiMpXxxQYUueF6pRoQ5LWy5bH9EPYkU=;
	b=kxR+i5U2JV1701SqH852GXl/RcwnmbDAvI6pRNHJXPCuUTFVnnzD3fY6bI2HrteurDVEIl
	ni90u4tvykgrZac4mghxrkz9M6rItnBAd5p0kPmmeE6EuoxjxyTK+vAkkC81seN2Y8VZAX
	3lgL3mZnIhc5T3wM2dZUTBjJVimakV4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SU+CS7BP;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770829545; a=rsa-sha256;
	cv=pass;
	b=OQ+jG/N+gKznzPwYUT5iDSVHqE36cIuel1Z7aLygndGWnCdH6GwisSzSCT76Hno1rHpHlO
	3//L7JUsq9E7eXDOWFhurZcFfXbvJJ5JWhmcNkEAyCO8dSqeCWw3tmLOXVaIJEoqtxF++7
	4o5Rv0nulsDmuhHZtI4jwMsf65OjnIc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee76e8656so33044345e9.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770829544; cv=none;
        d=google.com; s=arc-20240605;
        b=eYyij8mUfR1xkwbdOAiOQtdXA43Vfxfq9ODoxVoAAaqjtPWFQveGONjhSX/XilSmmG
         ztoYWcJYzONFVC4D877a8FhvyH+OAj0IjCv9NEdpBGRfgpJpP9/NK/1rDcAgKUudVKU3
         d6IlaQDbkYgbunttcCaAmPeoJ7npIGk9LwUmMKFkOFUx8HoiUC0oSISw6ASUBjdgMO1I
         CpRCfccswvMaAxaZn+8lKxY5mcO7o4/BEMN26R8mrvRpi7Ohly3B53vtjHIHxcDI4DIx
         wMkJu225IaFidPJxMnOHG/aajHLH+pVvfVxCWW9Y38jPbuSwojHtADIrEZyduekMSf7D
         bGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qhsgB31/ghAQLiMpXxxQYUueF6pRoQ5LWy5bH9EPYkU=;
        fh=8bMPecGvL13bTFKkzwQIImd3hv3vuz5mXpw/z++6qpc=;
        b=BZeUCXXixZAz5xCxPm8WpTiN8RmwfdS/SRILV8bK7Zz1ojGzpDHLcjmQzWWe6zbpvr
         KPnH7T2/6NazMZ9xREhQrvoXXRB2DLr3MjtDK55A+G45iiVFvpvyoJIHdXhUqsKguukq
         15GCcedRWjo7MTKxHpxg0WyCwAyrYO7rvnkT0/6WPGN6oGTe1WlkVi9ld694QBpnHzGH
         Gu76oLG9NQjq2QHCwF0ZxC2adZGaoII6WvCXRCaWe4vjZo3Vv0f/fRamzGVa2XopgQit
         L1F2X1Uf7bkaranqMeNRUXNNqhhEriPf7fpu5jxyRZ8MPLBDyJXfKoK2FMK5JIV2nMs+
         GSCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770829544; x=1771434344; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qhsgB31/ghAQLiMpXxxQYUueF6pRoQ5LWy5bH9EPYkU=;
        b=SU+CS7BPs8MeN5vVrLOcdsaD1nAgM4dqffwv5yijWp+TZD2I4BAGzwXHqcJ8aRYh3F
         hrd3hFy5RpDAG8kdpM8APi3aa3JLLVvRiYaYXO3Rzp7ZE0C8sP8fvghlLu/HmFbfR9bq
         UHpzzpm74gtWOUgrLLWM4pwx8TRlxNbQxrGht3oP0z1QOr+VqHZR9vTs28Iq+vY3pYub
         bgAuIrpcRpMeM3gtFLf7xzFrMN5sXPU6v1s1fDmhRlLiTLQpWssJ9HZ5il9kOPoN8vfx
         iVS0Jgnu/IrJnCX6mfXTD0eUDw1gs+b+Toewm2bNMTh69vf4v/h17iTOiibDpKJ+uEai
         LAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770829544; x=1771434344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qhsgB31/ghAQLiMpXxxQYUueF6pRoQ5LWy5bH9EPYkU=;
        b=el1B8Qjg4NuXb4OBMGa1+seXwGITXNJKDEzdftrcgijDqCGIHPFd962e0Z6ZiMHpwe
         EzOxGNckWV9LRlebeZtJX+R+vaHtdmOdUWHuMh5nv/nir42fw/59yS7yg3uuHtKHs3vq
         BkDWMhLjV5y9MadijuZGcJQEBWgueNBqm1xT4s2k+7qIPWFtHdyyFSeojdxO7X8PaI+o
         ljCbG5SJ6EKLbKmbXhns/l/w5qicxRjTS9gigWRgc95TQVack5KNweAMejzxb+bOPdrZ
         cIQlb9+OWYQZwHpbrejbKu8GS7MzEEGFex+FJayLHJAhT2FqjOe+0Pf0bguw0RoL0gQ7
         KOLw==
X-Forwarded-Encrypted: i=1; AJvYcCWuUG765+sVGyfVW55ny9SD+9EnQBHjOuzPAKYY87PYoO772n272QBwLv1VtCh9X9dzb5xgJRkXsA==@kvack.org
X-Gm-Message-State: AOJu0YyGKyjZ3l93z6hkx1ofotwARzfq+3YnROUkhPL1y5Ed/WaqeG7v
	GlPbmDLxGnbU5ekOdP4l/ezvTK9Q1/6YA/EsuTsrYeDHIoB9jH69nfyT2yYaZpqDITpiWVM3LB3
	geA/bRcK+Ev4qZBBs+gObeGGQKcucrws=
X-Gm-Gg: AZuq6aJ6CcYvdqQCApkq3EtIzJ+xj1pCtp3ISxbnnOrhcU80MKcrsNnNvq5B+WKqcnw
	uWHlVBCk9Gj34EjFKEadDqt0nJOwuXCfi2u2bV3BHxy1SrPMWBWbWP00tEyYFuIFkMB+AneKW3J
	ERojl4e7Kw3BgWd6OWf2ZAXKkZ7oHWvMsIv8wtXn8TTQ7UTD0DKpYSJ+WbCXR0tfH/wxMbk0ZVq
	zqqRVh0YiuqjIxnqOw5L6Qg9uTZbQXsLQmU1eYJalU5h1+CkBdWmdSSDj1nYEcj71fFZyeaS5Pw
	AUpbthcxwCcKtBucVZUjVj4S6V6ZbroAaIgknrc4pUecbNfAl0JI+Zp2Nfy/XrL99X2zxGh6uES
	hNW0+zaBhBcQYqK8Wp+zK0NAlvw==
X-Received: by 2002:a05:600c:3e87:b0:477:76c2:49c9 with SMTP id
 5b1f17b1804b1-4832020025bmr266578595e9.2.1770829543582; Wed, 11 Feb 2026
 09:05:43 -0800 (PST)
MIME-Version: 1.0
References: <20260206093410.160622-1-harry.yoo@oracle.com> <20260206093410.160622-2-harry.yoo@oracle.com>
 <aYxXE6CC0XQr1KNK@milan> <aYxdleYc7_TWj9To@hyeyoo> <aYxfumz5IlwBDS4n@milan> <aYxnfk6kCZ66CaOJ@hyeyoo>
In-Reply-To: <aYxnfk6kCZ66CaOJ@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 11 Feb 2026 09:05:32 -0800
X-Gm-Features: AZwV_QiDUaUdudmrkVUWLFGKFv0zB3qmz_v6ysYrl7sGxUVKWt-RqFUZSJsWWZ0
Message-ID: <CAADnVQKk_Bgi0bc-td_3pVpHYXR3CpC3R8rg-NHwdLEDiQSeNg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/7] mm/slab: introduce k[v]free_rcu() with struct rcu_ptr
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org, 
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7111414000B
X-Stat-Signature: qzruodh5ecxcc5cpf9az37hahkgroqnh
X-Rspam-User: 
X-HE-Tag: 1770829545-269135
X-HE-Meta: U2FsdGVkX187km/7fKrvg3KKQ5sH0nknYcD5Lm0QcbD9PHJBZA9VdC0sLLYBCkan2pxTspbAOPZnyVy++e5Gb88K3gVclp8sZcP6ylXvNpR1ou0n8MjKs2oOn4vs0gez/8Raf2EZSsHUWAIQOsUcMSTPu80XYgRo9uGmz/IDzwRd7B+g+9hmZ5644YtLT6WtyyJ/Z+fY2XKmlsLow6HyRLfbFrOSI/st6S+TjKuXrkBEQVNMeaLArmZECfxz9ZMUdjtoOUdqDIXoc/b4dSWhVFNSiWrrPm5xVcMOBp8DNi5AFZk3Uv6lFCxy3/re0hCRp36g4qzZsyU2PfJ81YEEf0ilYsvAU8zDhLZ/NBVnUD2ZlSoZHMhLHv0bP25je3g3MYHRCNUpXqP5fiXVXLQ1Gy0H8nsaT1vKTfsw3ASOhKM8PuG2X4/M30ssQ3ZqV/mPV8mLOooFihoq0TtitOsYljScFS6emGh7hmJIzmOTNsd7Ik5KQsQtC0+KzV1iTzYFevkdIBma1MAeJdE4IWbRfLZEHTZ1eN9Te/q5PxQFNNbSH8I1XeTK6O0z3c4hfidWvmHnoC05SNq3mQj8/ZtATfFooJKHjH+dUXNSPw2qUuihDQ3foFKTvblLxmSVK0aTflA/lfVGWNjXFiHGv6v6UU2L5SZPLNMBddXc7quf1MDyhTFB7fiIiBjtVGxZcw8eKKlF0nyjkcmD+1LN4+mcCw7OlfYKHWpApBcHgXVirk5A3nKEgJPfjBkYhS/GL3JDX8CWZ0ewu4433nvNhgfSCGLjyViEtu6rZHSuyh1RhoP4EbFod8/F60il/YyLsejgeScbuPnfpa9njzDcZOcmssFSkP8BZipYxcJOVVn2mYogfMM8jM1jGleARcZ5pAZGa87H8i5jy0B34cibP6TVZPF+EajT2P8F5+K6AlAa2ZDDHQfZ/6iOoFrVyT5a1pzo7MdxXKw7tELldl1ipvx
 PPUHaJK4
 86cXH6zaLeI2J1sXSz0NoIwzpxVcWvoDfAIOUDfFxZgNq1iO7z4OiJkmowicr9sJHTYCZqS7J9tXlIFXo4IRIF1zVcYcUO67j0r8pF8d31YLkLql7FyiThLZoqUC3522FC8vUvKsHdpQU6TvOMtvfRwUbWXand6tbWtl13L0/6lrJNfuxkfdIWeq1tZgQ8foGSyA+E8TzCiOOXkLubupazZOBI+RBKMD8IFqYOEurvqUisF0nvdaYSl0mE0tKCL45B7fRVc1vCSRgZVDMBTe0MUrSkoucPOTbEKJ/7NTdK72PskQeicHJ0wdJYcCBQT0yHrzn2fx9cUYOYzRDDX99OSfwf3skKTazPp+dHmQmMcath+QMd+2IpAnMPUhqpVPwZr0p6+qVZITLV24oGHbs3eTg450MNd9cj9rWL5IZvvxivBJQOZiopj3XF/y/g+bbatvRZeWNRl5NNAzYwqTQ/6tYTg1LWDLqXpldG56H9kh5A3IdNWGZFzrmVrpA8wdVG8F8FLbNvnLLpZpxatnWFjOgYxFrkLQSVuIXoq2f5B4kmbpp6xyP0e7zPXRrSWTtjjdo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 3:27=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Wed, Feb 11, 2026 at 11:53:46AM +0100, Uladzislau Rezki wrote:
> > On Wed, Feb 11, 2026 at 07:44:37PM +0900, Harry Yoo wrote:
> > > On Wed, Feb 11, 2026 at 11:16:51AM +0100, Uladzislau Rezki wrote:
> > > > If this is supposed to be invoked from NMI, should we better just d=
etect
> > > > such context in the kvfree_call_rcu()? There are lot of "allow_spin=
" checks
> > > > which make it easy to get lost.
> > >
> > > Detecting if it's NMI might be okay, but IIUC re-entrancy requirement
> > > not only comes from NMI but also from attaching bpf programs to
> > > kernel functions, something like:
> > >
> > > "Run a BPF program whenever queue_delayed_work() is called,
> > >  ... and the BPF program somehow frees memory via kfree_rcu_nolock()"=
.
> > >
> > > Then, by the time the kernel calls queue_delayed_work() while holding
> > > krcp->lock, it run the BPF program and calls kfree_rcu_nolock(),
> > > it is not allowed to spin on krcp->lock.
> > >
> > >
> > > > As i see you maintain llist and the idea is simply to re-enter to t=
he
> > > > kvfree_rcu() again with allow-spin=3Dtrue, since then it will be "n=
ormal"
> > > > context.
> > >
> > > It tries to acquire the lock and add it to krcp->head, but if somebod=
y
> > > is already holding the lock, it re-runs kvfree_rcu() with irq work.
> > >
> >
> > Check no_spin on entry, if true, llist_add, queue-irq-work. Re-enter.
>
> That is much simpler! Actually, I tried this way during the initial
> implementation. I like its simplicity.
>
> But I wasn't sure about performance implications of the approach
> and switched to current implementation.
>
> It'd be nice to hear Alexei's thoughts on this; I think he'd have some
> insights on performance aspect of this, as we have something similar
> in slab (defer_free).

It's not a good idea. !allow_spin doesn't mean that we're in in_nmi
or reentering. It means that the running context is unknown,
but 99% of the time it's fine to go normal route and try to lock
and everything will proceed as usual.
if (!allow_spin) irq_work() will 100% hurt performance.
In kfree_nolock() (before sheaves) we have a fallback to irq_work
that we thought would be rare in practice. Turned out that even
relatively rare spikes of irq_work hurt overall throughput by 5%
for that workload. So, no, irq_work must be absolutely the last resort.

