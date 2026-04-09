Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50906EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93B96B0005; Thu,  9 Apr 2026 07:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44096B0088; Thu,  9 Apr 2026 07:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980D46B008A; Thu,  9 Apr 2026 07:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 890866B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:31:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41D0CBA77C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:31:55 +0000 (UTC)
X-FDA: 84638802990.14.51D66B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B12B040011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:31:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4nqKu9T;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775734313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJge8KwjpLLpH7tUzNeyVdjNENR4Hhc/QYGBFajPFwQ=;
	b=w1Ez3mQf60ktZnsq+zDQsOPevWZuad0TcCayyUxNI0UzRC1QOqfTHglNVpr/tbSWJaavq3
	AyZl7qFlYkteQ0cnIcxzDw0lm5deKlnUa4piVjDVU3/YHhizLlZx9CR15tokb4oXOvOkSM
	6FIVrIQkfiMQ7Oiaa+m0n+xB8WNTTA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775734313; a=rsa-sha256;
	cv=none;
	b=ADCPp2fyGs6NBoW67ZWDRmLRUYObwYWsfa9UbMR5qGG7RUNO3vvjR+p2RNHqbxvCBYe1Uv
	kWVg+f5MX51ufzRJ20DKmHT8mx0oKDwtsxiW6bjT430PnBb+m69pt1sb4QsQqIn/4Nt41u
	0juGRy9rnV9hqCID/QNw3sGIen3Bsl8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k4nqKu9T;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1679A60123;
	Thu,  9 Apr 2026 11:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD17C4CEF7;
	Thu,  9 Apr 2026 11:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775734312;
	bh=G/4ZWyrrUDrDjMueESr3dU0jG2H5a4pqPFRbf1vziaE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k4nqKu9TCo1Hdfiv7tmE1IswzVF0UG26f7dFH85NfZAliP31kA5i+hJq3AjPPT8+8
	 pMdbKqEhKelqBNKDDfl6a+QNQzQh/CeT0tJ7nznbo3KY13liEYweQEMxqiL61BB7OF
	 x1MQ1nGHYXovHupcFZtaNKSex5YnJxp4pBlFMCLVELbTCPjZMF1HRhkw58wODcaD0P
	 CgrSlj7auwcwirQFjAIEEtylI8aoreTHGpzf75RLNnTRAeXjsZtL3dLFJAUrWw9u+C
	 9pQdDo53iXiMwoxh3zGSLLDoDcqj3rAZ96xugMPrM2StWoSGGPGsbJjDb66jtY99iR
	 lLcOyEcHkzhZQ==
Date: Thu, 9 Apr 2026 14:31:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adeOIvNXFLTCXMcv@kernel.org>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac3paYh6sPHr3EJd@kernel.org>
 <ac5yKatsMxNp4G2g@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac5yKatsMxNp4G2g@x1.local>
X-Rspamd-Queue-Id: B12B040011
X-Stat-Signature: youwbhazoazwmsjg83y3hjxr7rh7cngy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775734313-298631
X-HE-Meta: U2FsdGVkX1+Vyw2VPuQfk+z9rjoDZpPm60++Dng9OidvfvXSv+vDYK1ZqHtOk9T5qmJmaLDHRJnCL2EBeXNRfiajhOFVKXuMSyqoTQ/jl/z3wN+1RCDybnEPfUbJ8zZhWu7YMRBZkyOi8nsBmcavjY+pBkuAIkKMpvFhfIp5cKA/lWttVXBM3fmuVMjOr6CgaeC9be874btspVbk8SmIe6VdR0sptv9DRRGHE28TGqsHJGGtEpuzqSOoGf5HVhDBqaU3TL3WcUfA5w+xwjxl4kOhD36Ce+R+dgVzdCTJlPPSbnz0Mq1I1B+R+JXWWRY22ZQN80DVlqe7gstt8U8CHty0RHP64dNYOIkgIV4n2kb6MxkCdPIJG8ktzs5oCawJx1DFh9n1/uzfPUZnxXe7eHDS/imCpq/+P03mMoXFGb28wbakHrbuSe3egm9XFjfwFnrBnpb9KGAeulDXpf9hI/lRVm2Vh/bEZ4P9zKeRVsVSTNcv1FAUM2KCay8wz2dj2nbWvgc/uauzHlmSW8yGvR61mm+zU2qTuMYRu7bnEDSfZieObu5atK2F0hJmRyH3CXkR1DFZljLlzGmRFFhCxl+WiU6PdKTxjenPWd3B4lrvPVxN5K06SLz8xwlFmzGAwdossh/FYWc2johj2YEhwLnX3H2ekitbSfgMq7GvPPoIls+3HjWscHnXyad3hVWjKvHnrNSQDxrVWczZKsi3GVaumZYD1K/iewJ5bw0aEv8IUwL3eSE/O13ftkJvj08gSDjZbetOGJoC79GNipzcghhTAaiNIykko25vPO13lIubrs7lpeV6jZP+b8hNvq+Rpbl4zofNz+sQWfBkb7yGD7Oh8UjvWVAAvp1+ZxPc0au4BUg8txfn/quVmkRD5hkoJWnPwR3FsgvfrGYK5Lu4yErHynM1ddVurlN69wKm9e2x6oYlIDuzjEnWMxyqsA5uUKi9PAa90b8nE2iZ9dB
 EYMwl6nw
 cSu9LtlMcFBtig528m7L25KmwFobBSbzXhdKUZWaxkWrA0nsHDOOLV34Rz1TNTX3dHlptKr2PIxIx7bxbvlK+qfdH4he1/PG3DCIx6tS64SsJaPLKQ9qsEp8J6hnL0SSiQvFM4BVHlb6WnOHZ8LTXwByegZ/otXRb7L/4a5syUnv8YEcBWZFRvoJLt8qCAPn/+euSaHLvMWHygNTlM/u4s0WO4sKhJkRKZMRcKDao4kXt/2h4terGJ5/JBGycy726epZBV6pqND1xv+hIQaGVDqxuudCeMUiQ4AeB6akOhJ/hdpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On Thu, Apr 02, 2026 at 09:42:01AM -0400, Peter Xu wrote:
> Hi, Mike,
> 
> Let me also leave my comments inline just for you to consider.
> 
> On Thu, Apr 02, 2026 at 06:58:33AM +0300, Mike Rapoport wrote:
> > Hi David,
> > 
> > It feels that you use an LLM for correspondence. Please tune it down to
> > produce more laconic and to the point responses.
> > 
> > On Wed, Apr 01, 2026 at 09:06:36AM +0100, David CARLIER wrote:
> > >   On Tue, Apr 01, 2026 at 08:49:00AM +0300, Mike Rapoport wrote:
> > >   > What does "folio allocated from the original VMA's backing store" exactly
> > >   > mean? Why is this a problem?
> > > 
> > >   Fair point, the commit message was vague here. What I meant is:
> > > 
> > >   mfill_atomic_pte_copy() captures ops = vma_uffd_ops(state->vma) and
> > >   passes it to __mfill_atomic_pte(). There, ops->alloc_folio() allocates
> > >   a folio for the original VMA's inode (e.g. a shmem folio for that
> > >   specific shmem inode). 
> > 
> > I wouldn't say ->alloc_folio() allocates a folio _for_ the inode, it
> > allocates it with inode's memory policy. Worst can happen without any
> > changes is that the allocated folio will end up in a wrong node.
> 
> For shmem it's only about mempolicy indeed, but since we're trying to
> export it as an API in the series, IMHO it would be nice to be generic.  So
> we shouldn't assume it's only about mempolicy, we should rely on detecting
> any context change and bail out with -EAGAIN, relying all rest checks to
> the next UFFDIO_COPY ioctl done on top of the new mapping topology.

My point was that this is preexisting bug and that we don't need to rush
with the complete fix that will extensively compare VMA compatibility...
 
> > This is still a footgun, but I don't see it as a big deal.
> 
> IIUC this is a real bug reported.  Actually, if my understanding is
> correct, we should be able to easily write a reproducer by registering the
> src addr of UFFDIO_COPY to userfaultfd too, then the ioctl(UFFDIO_COPY)
> thread will get blocked faulting in the src_addr.  During that, we can
> change the VMA layout in another thread to test whatever setup we want.
> 
> > Let's revisit it after -rc1 and please make sure to cc "MEMORY MAPPING"
> > folks for insights about how to better track VMA changes or their absence.
> 
> No strong feeling here if we want to slightly postpone this fix.  It looks
> like not easy to happen as it looks to be a bug present for a while, indeed.
> 
> It's just that if my understanding is correct, with above reproducer we can
> crash the kernel easily without a proper fix.
 
... but we do need a more urgent fix for the case when a VMA suddenly
becomes hugetlb, because that could not happen before the refactoring.

For that, it would be enough to check that ->ops are the same before and
after copy_from_user().

@David, do you mind to send a patch for this without waiting for rc1?
 
> > >   The vm_flags comparison was a secondary guard against permission/type
> > >   changes during the window.
> > 
> > Permissions should be fine, they are checked in userfaultfd_register.
> > Some other flags that don't matter to uffd operation may change during the
> > window, though and then a comparison of vm_flags will give a false
> > positive.
> 
> IMHO false positive is fine in this case when -EAGAIN will be used (which I
> still think we should), if it only causes a retry.

I still disagree, but let's postpone this discussion for later, when David
resends the patch that compares VMA properties.
 
> Thanks,
> -- 
> Peter Xu

-- 
Sincerely yours,
Mike.

