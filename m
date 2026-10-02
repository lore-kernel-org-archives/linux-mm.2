Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8A1DCA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90216B008C; Fri,  2 Oct 2026 18:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67D66B0092; Fri,  2 Oct 2026 18:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5326B0093; Fri,  2 Oct 2026 18:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A68CD6B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:27:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25815407FE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:27:08 +0000 (UTC)
X-FDA: 85279122936.28.C4D9D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81EB740008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:27:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ewi4IOFJ;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790980026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrFDa5YTwQsxjtBU29z2wtgxI1YYa8NMh9+Em7kIbVw=;
	b=sOUZ7zAYSJADQkSyBwM1liHRbM4gxh2AQ5qAeIPol6AU4xnxXG05J+5ihtlLfeY/r8nIPy
	bAVfs6eb0+KFQ+LVJsYzR7haBxog+M3hZYtquF8Bm07btUEZdXB/KUlpbAfPEdBC7bOrOY
	QM6WSNkE8XasBIv2PMCd7XrqvYwbdQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790980026;
	b=TdbG/0wWMJsOTULXS8HYmmlpyoTp5iEmkiWpJJJxqdYaaugzJmyKv+HoMTELPvPcn34Owh
	NJOWbgVBXtmeN5hqThb7FI+8SDYzE2dExsaNt2fWK95lBOfSPt4hiuYNV3k3zmQXzvszy/
	xvjE+81bjN3196UMPzhRPfruZeruiyc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ewi4IOFJ;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDDF66022E;
	Fri,  2 Oct 2026 22:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D61F000FF;
	Fri,  2 Oct 2026 22:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980025;
	bh=XrFDa5YTwQsxjtBU29z2wtgxI1YYa8NMh9+Em7kIbVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ewi4IOFJxxoQ7Qg9VWdgyzC60dmnonJEslzal0W/O13I2WiUEd2OP/DezZ5E4pgi3
	 7l1+sZFtSsPGxggjrflW+1IAZvAkZi2jJSVGKUYoRJlwBgQhmlb3UUY6La6gXNmPHU
	 A3USpiyM1HyNfkNSLVznW0/MYCSV8gEg/Wf+/wBwuJwFAdTtC8Doqh9yVInGN1L6HI
	 yS+4DARPK6rUH+NdAOIAkSrrom0PFGPpqiaJgzToMJAYeTKaK+YR96RrIeVOSR9Y2E
	 6rvOSb6NFJ9v5Xk/Jn3g4y5f5nwYLV6XRmOJH0rwuteh6/RKU9XZcTPyFeB0Ptl+1J
	 ePgpKPyaWT8Pg==
Date: Fri, 2 Oct 2026 15:27:05 -0700
From: Kees Cook <kees@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
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
Subject: Re: [PATCH v4 5/7] mm/slab: Provide kmalloc type fallback for bucket
 allocations
Message-ID: <202610021520.5A076C2A0@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-5-kees@kernel.org>
 <arJSz0r5u_78NWKe@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJSz0r5u_78NWKe@pedro-suse.tail5790ac.ts.net>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81EB740008
X-Stat-Signature: u9mgeyw1up93j6rerqppxgp1bcroyy4y
X-HE-Tag: 1790980026-957733
X-HE-Meta: U2FsdGVkX190JMMoPnIT+TNU5M096TzfhHlQS1blJRdnih8X2dcNpgFQaHsk+/5j/Zy6AH0iTawyvT0RvJd9IH7oMF8CCKvLF9/qch/lvt9qhIBRA6OYvWueSF8nqHo7PYUVw/1bfOi716W6oxfxUvkZFjg049iBHD06yo/qGjMXCrpFdffBBWj8Mqp13xdMGitWdIWySp02UmmVTLt7lWwcVul0PI4McHH9PBXU56epXPDbn9dKNARHyO46dgpuaB5eq4uUUeqNOf8vfZTOtd7PJTZCGjY0doSkLF6jAY8xmNh4AuzwUY/akEVV1zDFGLO9Jam5JWMdAR/ubxSFcRpu/yA97VMsiXdCILY3Iqvj4OT4GwYODG4xM9Eq6/T2vg4eis+41ohC/lQWdSsFgEROMUF4afSTu/o4W1pAyoqEhUL5qDjt27zRnKAtEWJqVFOmTbbOSuYa8wu0JjfxRGHCUJmCJsFi/wSjYInCNDqt3lE8ULnkD6VxRIxpdwGe7PK4vEX8LkdPE9vm1g4uWLRi46OMfCo+YPBLEa9jWuovfDywG0QYeLWT2lHV6PZIoO+E5qpL1inMGTb0+YDscK09koIFQ3bAcKTrzUDZmQqLdqO7rYgk6a1NGwB3CrjzaTzzOl7OH3NN3HZTJrwBLBoHr8sFK294BPTfxvjIC1p+STDKQh35RTJ0mBvtwrh3obATBmQ9y6dKibXPTiiGaq1hzgTZIxeejvvekBMranaIJdtp4v6F3dKlycq9+7vtzdS8mVKtsF5brybFxpaQpilMa7G7/eaiJqZMHMFwnumsjYLQcYTHaim51WSh48dMq1i9IR3OhVgQ+bySFI8Wuk++AcayhLekXnI5bNEXBTci8Qu0GbD2VvFVGeNZbMfwNruBH2C2Q62jZTYaMu9eS9+Z1olb79C/0d1YnHoOJ9bVuAsIPpZCfUi3etGG/Ea5GB78BQxnCvP7UJ+ULbl
 0jLQ1wpv
 fOh70PtExAep35Cd24LkDi6SHJk8CoP9n3HcqmqZjcA/rpHCUf0yQGoYAODNlKODkOeObOFOwku2XPaX9IHD4sNDhYH7mfP9MwrRZMnyyix74BfM9+kq+nfgO7rD+jEjU5SStE0nqswONJs2Kif2J/kyhAxJ+SItxI740gTz9RZatgpn3XKBI27sO4sA882LyqS1+CFdPz4y71qxIGzTmSuuPiawh7Usg/vmG9H06cM0+Q9KMmg0tcLLy1waKBzuSvlJK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:11:58AM +0100, Pedro Falcato wrote:
> Big thanks for continuing this effort :))

Thanks for starting it! :) I've had a few folks wanting it, so I'm happy
to help.

> On Mon, Sep 21, 2026 at 12:58:16AM -0700, Kees Cook wrote:
> [...]
> > +/*
> > + * The kmalloc types a bucket set can hold a copy of. This is deliberately not
> > + * enum kmalloc_cache_type: the KMALLOC_PARTITION copies are all "normal" to a
> > + * bucket set, which already separates what they were there to separate, so
> > + * indexing by those would mean up to KMALLOC_PARTITION_CACHES_NR unusable
> > + * rows per set. Allocations of any type not listed here are served by the
> > + * general caches.
> > + */
> 
> This sounds odd. Is there a good reason why KMALLOC_PARTITIONs are kmalloc_cache_types?
> Perhaps that bit should be reworked instead?

I'm not sure I follow. Do you mean the partition copies themselves
shouldn't be kmalloc_cache_types? That predates this series. For a
bucket set, they're all the same "normal" type, so a set indexed by
kmalloc_cache_type would carry rows it can never use: on x86_64 with
CONFIG_KMALLOC_PARTITION_CACHES=y, that's 20 rows (2240 bytes) per set
instead of 2 (224 bytes). I've put the numbers in the commit log for
v5.

> [...]
> > +	if (type <= KMALLOC_PARTITION_END)
> > +		btype = KMEM_BUCKET_NORMAL;
> > +	else
> > +		return &kmalloc_caches[type];	/* No set holds a row for it. */
> 
> Hitting this case sounds like a bug in the kernel. WARN_ON_ONCE()?

The next patch warns where a set could have held the row but wasn't
created with it (an accounted allocation without KMEM_BUCKET_CGROUP).
What's left here are types no set can hold, like DMA and reclaimable,
and those already come from caches of their own, so falling back
doesn't lose the separation.

> Otherwise LGTM.

Thanks!

-- 
Kees Cook

