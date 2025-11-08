Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C4ECCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 00:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6178E0009; Fri,  7 Nov 2025 19:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896838E0006; Fri,  7 Nov 2025 19:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D36E8E0009; Fri,  7 Nov 2025 19:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFEF8E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 19:02:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFB6BB990C
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:02:16 +0000 (UTC)
X-FDA: 84085487472.21.A4800CF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 23ADA4000D
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 00:02:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ls2OpTMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762560135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSP6l7mhg1u2uTbJjzva7r/QaQVEvYhyFI/ReZFQzdY=;
	b=nX404dN3RAMrEfqsmQwuegUZuTohs1o7wvL/gDiOkAWQ3NZjLvtf3rHwaDgrmlftH5SFZo
	d27ASwwbHI89qrwhVhxHvdE5OOGOlcptnsa206LaYnMykWdfElig6sRUWF8+qH3YZqR/0L
	LWr1BsJkr2yPbpuVAPmk/kRGNo4H058=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762560135; a=rsa-sha256;
	cv=none;
	b=GeMuL5VrwJ7wYDn3FGbqV0URmf215r8X9ET/kzgXoSwT+gZ5RcZr/AwwtZbgdpHVDPivjJ
	dExTY88uqT/9XKgOuZRvOXOE5WK7Mg1wCNSMRXzYmLmEeW8bVmTXVye218bN8QVVKc7oka
	PR2me00NlHLGL3su+FK6Spm+TA/EzbA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ls2OpTMQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 7 Nov 2025 16:01:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762560132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSP6l7mhg1u2uTbJjzva7r/QaQVEvYhyFI/ReZFQzdY=;
	b=ls2OpTMQSmOeDEfv8P4qyc8/YddPVMSn5fEKHSQCgSObawmV/H8+XLEyEdCwJ1VJ5+m8vP
	naNPEZNyKI71TjB5uf8JxOoTxnEzrV2YCeIg66r4rLFRe9aV/97y0MaYCrcsGSP0MbwPdQ
	2MxL91Ttu8ZaaQfhu6/omx3S+tOqz40=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>, 
	David Rientjes <rientjes@google.com>, SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <liam.howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao <yuzhao@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, christian.koenig@amd.com
Subject: Re: [RFC PATCH v7 2/2] mm: Fix OOM killer inaccuracy on large
 many-core systems
Message-ID: <ahtgrrgn4uwqjumr2blnnhyykow77weu3iuk2wqiimjhq4yset@5o3wls37n5pp>
References: <20251031144232.15284-3-mathieu.desnoyers@efficios.com>
 <202511061432.4e534796-lkp@intel.com>
 <6hmgutxgdchs4qz6hprwsecwoygwszn5ywixxrvnereilegcsx@mxroaotaw2me>
 <7732c2eb-e547-47a8-93b3-1d1b4d9c27e8@efficios.com>
 <7b76f0e4-6148-4290-a295-7ceeb1ef2feb@efficios.com>
 <81258c9e-1436-4a4f-9343-ef574b8b0de6@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81258c9e-1436-4a4f-9343-ef574b8b0de6@efficios.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t3cgxyk9fi4d4dczdkonnr54gmrr8eae
X-Rspam-User: 
X-Rspamd-Queue-Id: 23ADA4000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1762560134-763086
X-HE-Meta: U2FsdGVkX1/pEoZD3mQoP1DJd+qi3BdKkt61dq58JuarOiLIB1vwgBZ7wffFoXNSfija2m5B35BKVnladOSbCpqStMfNKEgtRPF6QJ2eDj/kicr1K+8+80eApUyLyg9WJr2gwKfOBD3ol+dZ9HvYahSkannnq9NrcI3l3Xac+5YPdxz/vBi+19Sx0SRV18nR8AqW8TSnq3qaCwWx43a2sqXAkOc16KcBWHw9CLAUDT7F28Opn67Xr1D4LqaaeuvMtDpQWl3PYcvJ4Zix6iO3RrY/Wdin6SK74YoYX+x2Ck/xA+DlehUP/W35A+9EdgeP2XdsHn/esbZaL+6CnLxuEhph5xW603BU5KxGoj8uRyjjODOq16gInn261M7ethCLG0Sw+yBtUvyqt3pm1qBNP2HsBXIcqoc7Vk2J/xIQvmWXg2F8i0/VnP/6Yun/3onZeXfkhhGNe4UbLYK+qtfcvTX1e5+UUoRM14O5pvHK0vJfkRq0WCIagabQ0klbkU9gF4DMVNrBLPXEuqVdXFjzsU8bdwdqJxb8pOpnO6oa47bpWn2ObJlsrI0zXjOaHay5hrl6zbVY3F2wxgiiSKOjxoaWYcZczzkpJIE1+Iw2ST33R7dXCX3io/qeLdkIJkO06AiPpaH2xQQoCZnPU/oD/K7kUfyh2QTeyw5uleKyrHbRf7NXPw5hnuMu1O3F8XEq0S8udiOllOoKpjqzedgot7tlEcVEog3Z/NOMS+ty1BHu3hiiHeRuJ2zy5aOgDTMF0N1OjMrvLc7pkYE0v6DrUxLsid2ZEKxOZeMikZ0/rVzNPkbVnUuPCpHBpWoxsV/mIxy5OPAYRLpNAgolnh2IASS+z89n0ppgTqSKSoUiT9LBpy4kueXkrKuSTzNZHpJbQHyTcvGVJEv1aZKv+JUJ8aKwtIhJUhHhxFXiTD9nXapcVrNjEGToXga5ODxhjWDOjpq+DJwNBgQTV2jMs70
 fe49KXfd
 67lqnbI8Zc9ymOSNcttwXq8CbyoU8fVshg099F2TRhRp5CzAiB4muYVVPw9JA/8wcaB9aoyp8fFANhFI+gvI8xqQrwmUIs9ID91LSZrgcl171KC+zyRP32Ac8glu9PRoYsz/U+V0R5440JPzX9HMcipGfN1DaZQe+Nj6eqMVqTOiHc+pA45D8egzD7UuYT8HG7f9TCT8dpsVf8ge3w2Dbn+i1iVF38PJptDNmEhWScT6/hpV0C09ClOKSfHYR4FFqdLntxx2WXeHZdHlF0TKiqhcP4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 11:04:01AM -0500, Mathieu Desnoyers wrote:
> On 2025-11-07 10:53, Mathieu Desnoyers wrote:
> [...]
> > 
> > It would make sense to call an explicit percpu counter tree init
> > function from start_kernel() between the call to mm_core_init() and the
> > call to maple_tree_init(). This way it would be initialized right after
> > mm, but given that the hierarchical counter tree is a lib that can be
> > used for other purposes than mm accounting, I think it makes sense
> > to call its init explicitly from start_kernel() rather than bury
> > it within mm_core_init().
> See the following diff. If nobody object, I'll prepare a v8 which
> includes it.

This seems reasonable to me, I see v8 is already posted. I will take a
deeper look.


