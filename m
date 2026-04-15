Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0D5FA0C32
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDBB6B0093; Wed, 15 Apr 2026 02:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4DC6B0095; Wed, 15 Apr 2026 02:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411A76B0096; Wed, 15 Apr 2026 02:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3287A6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:35:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3666B89BC
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:35:06 +0000 (UTC)
X-FDA: 84659827812.29.300EE46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2EFD3180004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:35:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CuMkoXWf;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776234905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBIFChv5u3e0gIoiVcTtrpvSVwZSCR7TwcaW0HD50Jc=;
	b=dAPgFvEICB8G0Mqhn9gWrwjQxhbGraPlBCX/bikZXBUYnIeTZYVBozwbesTqEsxJ6dPiGO
	IU965hl4i+xXqPklxvUQkQDXoEvhoffcraTFaBMBBFPCEreHurQZOQdNxKvs864IOQKpmb
	tGiRQEK3PTw+Lx0Ru+Gtvq0+rStyeRg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CuMkoXWf;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776234905; a=rsa-sha256;
	cv=none;
	b=hBpZF0YovpaZBaClBP9Uq6Le7n1QjEtSQ0SWzUi/Y8DvDwHqXEQuazPyI7HBSlkU+dRjur
	tRylBkMRn2pIB/54xYftLjNJ2TW/oVVglnIUFwGeQCzX8TyGZyJYbDsbDtgY9MWpVTTx+e
	Itl5HjhHt6UoUCYU3bMUe62aVqn3zig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7740D600AE;
	Wed, 15 Apr 2026 06:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED810C19424;
	Wed, 15 Apr 2026 06:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776234904;
	bh=IBIFChv5u3e0gIoiVcTtrpvSVwZSCR7TwcaW0HD50Jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CuMkoXWfeYctFAhHSaDWr5eVIyKNfEmBqUXxPkd77WB12jVHe77dVOsSCvU9F/z+H
	 1ANcgUsodUH8A/f6bEh4rIfIHuqVhJ/Ds082W739oju9QtvT8gnHwKuuuLGn+bwOZx
	 hZ3gSgXwPsBXqJQb2PEdiPW4GMDvR5g+LjuezSw0EN6/5dCniB4tD55ZM8dNNFzp/o
	 VNfCPu96Qwr1+cnEtRlW5t2fEh0GVIxF1oVGFB3ucKA+olleQi1021qVU7aJUq4g/W
	 1IZiItoyll9lYZvslFLKUD1TffeuRbrmhL1wLdexX3/0nOeyiMcH6LxMPJ9hJ3o/S8
	 M+Yl5a+eNTdNQ==
Date: Wed, 15 Apr 2026 07:34:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Message-ID: <ad8xfnn05PtejbMP@lucifer>
References: <20260413105713.92625-1-ljs@kernel.org>
 <20260413221724.c939e483e83304fb40e3d6da@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413221724.c939e483e83304fb40e3d6da@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: txcb4zmxiutwb3qta88u7yhz8hfxmxbx
X-Rspamd-Queue-Id: 2EFD3180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1776234905-911096
X-HE-Meta: U2FsdGVkX19J2EcenlE/veZiz+wfualOmPrPncTFYHZdqliyS87E9hJZ+/2V/PR7KqjlUpButWAOXzcjx3UAm0V2DDhA+TKD1rllCBf805x2pdX8VREgVWkudsKxBgwj50xOUMjSjX6mebIB/deEdXA1lJNuw681ChS+Px4kmUlAnkj+3HqOXnWFVfSQ8sn5Ckz6G/gpawdNW4Mo0g7/DSFLuNZM12kTmRweesnQs2o6Vu85G2hKDFO0QvQdCYB4A6q6tcL+1a4mzMmJM3gkaIooYdvOdserbekHXX7Iktf9EDQ64O7u9+IftiL7LIi1X3uEXoeGUbdwdCcLcEE+BjbGoy1MRSPlPSXHTjl0Y+425/ZHvgCwzy0rMcWiVW043eRqLfgVQFR2i/24VC4QL1ziALDSF5G7fcb8ck6K8jXmfCrDlDJQzdbWy1aXnqYHEg1nKf/I7a21bAyTW/cUhVB4JiOMYBkPilOJG0knC7MIcHECB0K86KnyDQHcFzj5OEZKwn74Hhi7GN8zwOP6YHOb5e8gsff2bxL+KHvygOA+mlX8dbLYfQgtR+/WVWPWg4tPAOezL7U+Ii1TOWvsBfchY5C3ghEklggrvajJHgWfoU61y4sYtMFl7ydMxB7Nbyd0wE3oj0yCUPmPEheyYELUtu28j336tWvlYHlvnUIZFu1gKakUWOHDcInNl8JAOU1hSlRVxvQaskG3JHjZVxW8aXrxm/pHgESMoHRVyOFAvWsmVe/nsA07ARUt6EJ/4/f1LoXWGbgNfMxGD4yfkUG063uT0jQObvO2z1wKIi57oStajNsfcbvW5gmGmQU6BkRgWret26MDhfEhJThoGJvnsM03KAYtbnQy4RmlKAnKF+6JBpmjW6MU4KxRvKpc94J0i+fIfewh1iWesjaOdtUZfNyzu+LAoXvDuhgmrkSFMdqUkCRsOfwtYcd9qUARSJ82dAIOKCAzlKOlY85
 8pmcXBqr
 yrs6psQ550FuIfRpthW3Y0uHzHxSv3iKhqCLEgavR9dmpreKX/IkzK0EzgSkLXc1PxgpF8JEilYW5DkWEkPHdvYCM7aNUc5B8qWljfkwNysJOMe4xGcArNubIAxqGYKRnjm4u6a0NaKA9Z8gQn2ZvDkVTfUSdGQo6lVkDScg1qYnI8Ov1jwB8C6Ql1l1pY8885iCV5THpZT663S1fRylFozAY4U9Y+Wx0mOnd/eOvRnvqc7KFEDnGBtqJwKXi7Bh6d4oMEcXP/jX10V3MBrbM5SMWQ6Nr5CuWBrfIA/8R9WDxkjFkVGAx675vloNWmhdv1aWm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 10:17:24PM -0700, Andrew Morton wrote:
> On Mon, 13 Apr 2026 11:57:13 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
> > __vma_check_mmap_hook() in order to assert that a driver doesn't
> > incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
> > latter of which would not ultimately get invoked.
> >
> > However, this did not correctly account for stacked drivers (or drivers
> > that otherwise use the compatibility layer) which might recursively call
> > an mmap_prepare hook via the compatibility layer.
> >
> > Thus the nested mmap_prepare() invocation might result in a VMA which has
> > vm_ops->mapped set with an overlaying mmap() hook, causing the
> > __vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
> > operation.
> >
> > This patch resolves this by simply removing the check, as we can't be
> > certain that an mmap() hook doesn't at some point invoke the compatibility
> > layer, and it's not worth trying to track it.
>
> Cool, thanks.
>
> > Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
>
> That's presently in flight mm.git->Linus, So I'll include this fix in
> next week's second batch of MM updates into Linus.

Ack thanks!

>
>
> > c50ca15dd496 is in mm-stable, so thought best to do as fix-patch? Will
> > leave a small bisection hazard (unfortunately) so putting this as close as
> > possible to the patch it fixes would be ideal.
>
> Yep, I did that.

Thanks!

>
>

Cheers, Lorenzo

