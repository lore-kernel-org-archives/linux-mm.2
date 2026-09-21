Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4732C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98066B009E; Mon, 21 Sep 2026 19:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E466B00A1; Mon, 21 Sep 2026 19:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB926B00A5; Mon, 21 Sep 2026 19:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEFE6B009E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BBF6C01C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:26:43 +0000 (UTC)
X-FDA: 85239356286.11.6E1D1D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73A03C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:26:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsfpG4wq;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790033201;
	b=noRIkLAAQAlFvVpJRjFPxKeA6VaIp0aCst946MsmXWIURTghi9pie+KvFYOonHh2G3JXjn
	rFtNkWuM3vWt4PDfHtox4Hna1a/9baWMq78mFj8GLqvH/IeKwV8Yg3WfNhfzEdpdNc0ytO
	LjN9w/tt2L7KkNMEku+s1uW8So8T2bQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsfpG4wq;
	spf=pass (imf10.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790033201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hM5mTuDQ4dfNK5Z8XPoMxZFJdoiMu0qCdKMcLrxKa3Y=;
	b=DVP1Lriw0rKBtCExEDq9ZuXHJXtVMg3uc0I3kinAgnHfGDowfH3BH7cYPzUX9G/mkzbgfA
	7D69r9mYU6WGlXKfB5BY605SK5vwEnZhd77PoMI9RGB+w/W2P5t2AZKPQ9vf996GCf00nA
	Fm3lZ8wDRVVHmEXc2zVZWTQD/qesubY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B905460210;
	Mon, 21 Sep 2026 23:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF721F000FF;
	Mon, 21 Sep 2026 23:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790033200;
	bh=hM5mTuDQ4dfNK5Z8XPoMxZFJdoiMu0qCdKMcLrxKa3Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JsfpG4wqpOafQFBopqW3RNxUYW2gAwzPzWoeHVqBzw8tKKe1B0s4t63iQSWnV8EQ1
	 rSGPeW4M7vzIvlk+heYi85lhmuPaRw4CEYvxRFoMudbkW//0iO+tB/IICwZJPAYJR+
	 jf6H2CYP/ekh2L58Vi5xfINtZos2WrvrwYrJSBmFAMg8V9w/mUIXUsP6Dxb5kHLenH
	 ZH5/C25uUC4b793UVhAx4RRACAJzZdJaQQE08kzGuwQ5EgOcWrsH9yKQSPLFppbHHZ
	 dnO93SqbtdBPl863CAVJvqPS9wsaTfT7c/g0CxDGpB7QRrgYkcgDEiEi60mZ/7mBtZ
	 S8Oeg4uEOfhaw==
Date: Mon, 21 Sep 2026 16:26:40 -0700
From: Kees Cook <kees@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Message-ID: <202609211625.B1F704163@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-6-kees@kernel.org>
 <arEvspsSl3bLyYgs@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arEvspsSl3bLyYgs@thinkstation>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 73A03C0002
X-Rspam-User: 
X-Stat-Signature: xx1na7zm1p5d56qt3rihpokrtr7b6brp
X-HE-Tag: 1790033201-325881
X-HE-Meta: U2FsdGVkX1+8sth/vNtIF9WTbeKC7DnlxQIAsZMRu4087AzPe+hLKkif3FaFYRDwH4s14u60Fa6uRgf3q0m6fTLT5fOg0lIENLkrPWWEvz1rP1LHkxKIINCL8XuuzobJUHBDhLhXDkrt+1SpaDepEfRAZrmPqVWJDalBvWT1uaGS2tbfut99+ElOK4CI0SDv7IaIC50067buTfJSFd23Vu0KbedgnayYhDMDd/bx8Mkh4dB2vYGqRWr381eeDv84zgIldMp84X3+/xVpS0AbLVQJIjwJHO3Ck2FHRodwQi3HKWDfBJwkoA3ke3mXm8GIuWiagAhNBZW8ahEkpf75fMUNtZH0koM8qxX17RwHaWWK+a9Am3RyzEtM0XYhcuuxmST7MxXeW6XRBv0V7MJTpaTBcdNS5iE8zOscRf2tExtDvz07hRt+qFEaWr9ZvUogcfMMfgyeSBj+hJUzrcim+ZSz4AeET+SqEZSMEWtvdpHrqx6mTxpiIhaDtb0NH51ho8G26Ft0xYNs73yRm6TBufNlFJLZwgZALxFZpdZ3xw7e5UfWvvRo5zpuaGQI7x4HEAQO3ks4+xkDn6ySpuYXc/hcbBmOQFjpkppIJFIYpWg6KW9GhFZ/ifcZP9U0DcVsra7q2hP/8wHMH7QA7S7gWBcb2Xo+zVYZq+VlEy5j8k2AP33wp4PggjdFl02jC1vSyOKmRGIRQcD/CITUziieHm2Rg1a1HfpDl1zUhpkGVCzx+pbF3dCNaSyTZjc2ZFAqJB8/QKvoy7G144KstMZn6rL25tsMsVCdpvZwa2ylv2SwiFSFGjCVMIStO+v0Rir/a65PMo2wxXcRR+5uxcJjJhqi5PnuebQF5dL9I5l606Ph02JkZgEvjXeiHtsxFiFlkRx8s0d9uMFfDO0DnRsCaNdU3INRnQRh+3Wv9HNEV/vdPotkIbnyXXs4Veg62CtdlCnTuHzoepO0CteFqhC
 1xckk7E6
 uoiZpcEF54L1h/t3znx9un0weh7vRAPeJ231mlA9Atn+Hx0RCa/uoLtDp+3TwIKfM2D4tQLka8A0ymnCbQSEvACiJLM9nbuzy6i0X27hmrTTAO0esw/NZoz95WtHCPCn8fAEftydZjMx0FBjQNt5WCtURQSjAPPQpN061cm8tUdE1jRlZduSAElnCanbPAMXcCsZz1/hXfkG5K7nhxV6CzQJudKpvzZynH9OGTmgXtTsOUKqj1SaTMByyt10SIDp9kr231SNh4IffCNwpG8Q+pazvfHS/XHlh+YL5fR7M1Gfmo7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 02:25:57PM +0100, Harry Yoo wrote:
> On Mon, Sep 21, 2026 at 12:58:17AM -0700, Kees Cook wrote:
> Didn't take a deeper look at this yet but this is causing an error:
> 
> MODPOST Module.symvers
> ERROR: modpost: lib/tests/slub_kunit.ko: symbol 'mem_cgroup_kmem_disabled' undefined!

Argh, modular build. Of all the things I tested, I didn't actually test
kunit modular build. :P It's so easy to use kunit.py that I forget it's
doing a monolithic build under the hood. :P

I'll get that fixed.

-- 
Kees Cook

