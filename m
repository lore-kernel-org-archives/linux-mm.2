Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38B5DC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 18:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA77E6B008C; Thu, 24 Sep 2026 14:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58676B0092; Thu, 24 Sep 2026 14:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47916B0093; Thu, 24 Sep 2026 14:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A22E56B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:23:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AB7A1C24C2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:23:03 +0000 (UTC)
X-FDA: 85249477446.12.AAF93BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 060611C0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:23:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agYftme9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790274182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgeLELIzxZ0bp9TzTWk/96zvxSQJOk3kCuECklcXCng=;
	b=U7dOzJC9NlXLGX6klkuAwwDGis+WUNpfF2OyIYMV+7eIXtsJTjxglnb0l/pgPUgBoPAXk9
	3TV3wjtZQXE0gtjuiBsqVggzsVhpRqXVMRw9loORfPi3aD6Xz/EtCFddq2q22GktumkXsD
	0+dxurYLxYedB9abQTNqjTXo+Anv8ic=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agYftme9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790274182;
	b=OUQsLbuYTv0n2cUFH3GP//Jg0VVCUbZ09SIDsteNRviZdjn/ih6w9HedxBilJ4+VTC+8pQ
	qLQ/tcyZ5cdRwdN+i8uh1G5op0ZvM/QL3x/mVNCBZgnK7faSlF3/AIntYcIQ3hQVXjeeUn
	fjZA86HT4nJYACnDL1wVrbnjpdDeQkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1515843423;
	Thu, 24 Sep 2026 18:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8C91F000FF;
	Thu, 24 Sep 2026 18:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790274181;
	bh=jgeLELIzxZ0bp9TzTWk/96zvxSQJOk3kCuECklcXCng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=agYftme9qt93yk8XsoRWixRsLH9tG3aSJYeZ+s+rtAbGS93SnBVQHs1p/SOilNZtz
	 /OJtgxFJVIVFnkpVJSM/cgfX14JqpoHlLIHbw7wogTDO/lxAw8z/o9aSPceiCGJfK6
	 zzpXQ2zNZpP9MQRpkH9MwTu/WZWp10hAc4+Z9fm2sJZ+WDMhSmrtQB9oP1igactp2g
	 9ufQrGFU0LGoCAMhXsUQDxCscdgnzm3xe6BU9j/vDHMoqhLTASqbzVFxRT8XZSHnYp
	 Q+LTAwAJ8piVQ/9jRf85wd04XJuT+v1QzJvmQ7/0jZTifuUwIgF3Z3NCm6T/3DkUEM
	 U7qZteZ0mIeBw==
Date: Thu, 24 Sep 2026 19:22:58 +0100
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] mm/slab: Give bucket caches the alignment of the
 caches they mirror
Message-ID: <arViR2Miz61-3fV4@thinkstation>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-2-kees@kernel.org>
 <arEdcaJz4i5HP26a@thinkstation>
 <202609211620.342AAA61@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609211620.342AAA61@keescook>
X-Stat-Signature: g4s1qte7f3uwgr83xkptxxk398wj6z3x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 060611C0007
X-HE-Tag: 1790274181-917262
X-HE-Meta: U2FsdGVkX19oHcLI3xwsXEspqB5gA4MY9SSI2TjQf4kczUT1syZw87H5wY/fbiMm1BAg4ohHu4ZvxTfjU0YLcn/xpTlslnmoqPqF1seAip3hiMirX82AXY42Pe3MpVUTtqJYL4bZ/E1SXfogOrlS59X6ZdAqv67H+xOlhkBEBqOqAzYRBXbXF1Pa8FJWR+6Zi4Ifjhkk2I8exQkzEjrw+Kb3TWYbCFhymUjNN4miCWt/m6YEQHLBPLMXGX8JWi5J5+ulDtAGIhGnXhqVHN/6LdkgR1nP06bDsp0eAc86c9HrFhhlrPs86bGWB/pTzuhsnXLpxwjkXQJU3IiRTyFl8M+FMoHFQyKOLTlxu4YwxP6Cr9i8dG9tz60PUHFsGGVul0lOpgzzaE3z67D5FAEQS2ZyZCWyBqa9O1K/PjTb+Hj1P1QH8S1tCul2m1DqznlLI8OqQekzJuvN+gvuB4/dlEzTMYijvdkdjiWN+xd0nRCq7wOF7TOeyieQ//J6bOn2uPhApVyzIa2ulq5yMug3zcgdWzElSGdU4uJIm5y+2wMvlJtBQ0y/9VlItsiVju+RR6155YY5toX9j7J9T5e+zb1lHnzR1o4VWBeJU719jP8aSPKtHq7HTd0r4bDfvbacs0VzMi9DFM/HxZZFCM0XroHAsbO26baY2SSBapIvewZVjgIBxVFFa5DncqcHyk5EtbQ1/oHWR03RinjQlG1mFBBptUBm2VIFyJVbB5xPBIh027VQZQqnTu2FLTCUgVCYhiM9fmIUxaqbYi64clfnpHU7RqzMXxGG1wTD1gnl8M2B7pEqA7BIszhWob+BcWOXv3ZQ6HRNU3OA9QYbbzi1PY68Q6/P4Wk/ORXS+8uOQnCg+heBCKYEw/K70a6Cn/0iIHBV5N0qEDxbbllFzG5h9lxdMq++94u4HjfCctZ69WNTCvNh1hxjVdXWYMukVC5sMdm5UfVgkRb5PgEhPy7
 kiRQIx7x
 5aBiV0Sf029oHT0S3SYa7SdTzCzBZUgfBE1Xu+VUjzYSYAj54WEsjq6UvIKKgVnXU7roS12IsZ+oE5XFlScghjrRz0DZNJs9Re48H7Usf+dWf05yBBH+Xc1zp9y8Tacm3N29CyKbYM2jlQu/r0OYOJvpcE1nciGcn7nXo3je1XRAc/iPd/eh9o1vLN0mGYIXQB5EdJKSULa1eOb5C6NciEmDwGaK4jxe3t/N8uZFOG++0/xCr8fp8/8Lbnbk9tPl9tzdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 04:25:25PM -0700, Kees Cook wrote:
> On Mon, Sep 21, 2026 at 02:17:21PM +0100, Harry Yoo wrote:
> > On Mon, Sep 21, 2026 at 12:58:13AM -0700, Kees Cook wrote:
> > >  			if (WARN_ON(!cache_name))
> > >  				goto fail;
> > >  			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
> > > -					0, flags, cache_useroffset,
> > > +					kmalloc_caches[KMALLOC_NORMAL][idx]->align,
> > > +					flags, cache_useroffset,
> > >  					cache_usersize, ctor);
> > >  			kfree(cache_name);
> > >  			if (WARN_ON(!(*b)[aligned_idx]))
> 
> It looks "obviously correct", but I probably failed to correctly
> describe it. I'm happy to do whatever here.

That is correct, but is there any reason why kmem_buckets users should
not specify their own alignment requirement and inherit the alignment
from kmalloc?

For DMA yeah it might be confusing for every user to figure out that
the alignment should be __kmalloc_minalign(), but otherwise there isn't
really a good enough reason to inherit the alignment from kmalloc, no?

-- 
Cheers,
Harry / Hyeonggon

