Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834C1CD98F7
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A06BA8E0005; Thu, 13 Nov 2025 18:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEBA8E0002; Thu, 13 Nov 2025 18:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91ACE8E0005; Thu, 13 Nov 2025 18:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6BF8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:32:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3258412CB3D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:32:10 +0000 (UTC)
X-FDA: 84107184420.30.E1FFF83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 746C540007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:32:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DsvSKa22;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763076728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ROHQk+fol3lQxsTuKjXUjYmTsHOdhYS8qfsfiIH5Rk=;
	b=4SwygbDx+KljLz62Z6YN21tMq5rRDnLs9uU67MEoaZyqVWr/CtofxVnBso8HFQ4pUz9Xru
	9vWHlb1q6kMs/UQl4BOhJVhGcgy9b51T6nr4w9iBNW76/+4Jo5eDKzsTW+olEYjTKier5x
	QidvKoLxqO0EUNzBWKpQ/Cqj4mh811Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DsvSKa22;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763076728; a=rsa-sha256;
	cv=none;
	b=vOGEHN+FGkkOEwPgs+GrLg6Kj3d9sFNxO0ejsH28iqn0xrUpibAwzMpuCPnHaxdiep6d90
	blfjFjDI2Zl9/v3c1n97iFd5zLGrPsTAEZQAabGlSEiCwgb/MXxYG/H8F7H1eXKwKRbhcM
	fY5tVlGm6vQBYlHWkp98tPORo2aVXtk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63D9543BCA;
	Thu, 13 Nov 2025 23:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B28C4DE01;
	Thu, 13 Nov 2025 23:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763076727;
	bh=0/Wu2Fbf5XL6YXzMCsU9T/GGUPwbFh2GCmkLRrlFK+U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DsvSKa22dmOLI50W4oxTVoFKUf84nqZZR5Kh5pCAiFxU5Wy5G+9iOCJEJsNSksOej
	 T/LZE//2cuhxzpEMmDR5zf9vE5QUSJLH0h+MC5MLMsZSEbFyQmNbhuyjhLOHIzjjGX
	 8AuW1DiXEdj4xAwcqSJ35ghaR6Oj7If5wSIObnJw=
Date: Thu, 13 Nov 2025 15:32:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Carlos Llamas <cmllamas@google.com>, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, Peter Xu <peterx@redhat.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Ujwal Kundur
 <ujwal.kundur@gmail.com>, Brendan Jackman <jackmanb@google.com>,
 kernel-team@android.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, "open list:MEMORY MANAGEMENT - USERFAULTFD"
 <linux-mm@kvack.org>, "open list:KERNEL SELFTEST FRAMEWORK"
 <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
Message-Id: <20251113153205.6507ecb308e7d09362905da7@linux-foundation.org>
In-Reply-To: <b4291d0d-b913-4e61-9f9d-fbebd1eb4720@lucifer.local>
References: <20251113034623.3127012-1-cmllamas@google.com>
	<e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
	<4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local>
	<aRXyxWeh81-aTHaC@google.com>
	<b4291d0d-b913-4e61-9f9d-fbebd1eb4720@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 746C540007
X-Stat-Signature: yt4wa4714wtd8fqdzyqr7n9f7k8xrero
X-Rspam-User: 
X-HE-Tag: 1763076728-221720
X-HE-Meta: U2FsdGVkX1+a40jH67hIVZz8r22tqqUmP2e74oI+vWJ+zDMfO7Br4oMZwW91zMvMnge5ceHY5ZsZCzxNcGQaDTQ/L+9gn7MpADISldMNClxWqKL6EgJXEN+kbxiBvTm+LU91cxi62E0msB/6gYrPpvICeav2V3Wc0SPxhtodEAUXViBb/mXiJJ3c3cC8sHo4jwo1ofmWonpNOHSbqa+T4dWUuFfeIuxiiw85nOj/uEuFD6Y8EtbHr21Rh1NuYoDoDZZ9JvGi15NjzehepUXizSAaIurCY0lpJy0SaD6ke0TbMA8BtVymU5+P+vIGtJ/fdtbY5/RdhqCDhiU/N1mnJyqJ08LpsRV/g/ixIiDD59kypVXhr7DobNN6NYCIdojLuYuDg/BEVoB5y9+wWBUNgvX3CkEmA273CXI+hpkLEAY4/hOF/GmtxLPU9ygGg4w7dkH9+nTsW5h8t5NgAOJw4SskfiTCCq+GSVzhuEkBTLa9nsHxKdronnrFkKSjVK5y17Q9TjfwdiKv1sANhCOYEUqZPlDlv0AsCrZ4Ikak3zQHO4gBjOOjLyNaCDJnQuvmLm8+sMBBcq8OEoeyU/dms/8lWTnA3EbFTrQ9mA87eFTWMzI6wFCmGjcotM9trConBGYicsJQ4W6+ACGtUXsEwjHCo84YV0dCN3AiBtG+EymkBdsrlXNMumzvwTuMug4vivW6lZDHqgHAT8+1U4xZm/01hfZ9uAKFiCVN7e3ywip3/UcdDKpKqWGdPGko499M3dGs7WoulrZJRqNUCJEGx7x99sVgEZ3JUs3/9qmAMlhW9n5CilTfD0vJxuY6HmFMCdq44JFdhyxR9z56Ut4ZoFRrXrpAtF+BOnl/muYLdvW/nP95R94dchTOrmNOvC3K9OVFZvwmqtY+inqKTMVINjqEpzmnNNT70iCb4Bxq5YN3pj85iuscaIefYJRLUnDfcy+vizAz0wzmwUTVf5z
 v+RrgyXZ
 Esuzhx9xcjcTgSqzYsbrVaYhgQyw9+bhyWrkjKCmFV/speG+WATaTEiPJdT+kQ4ND7t4CI9B1jjiVWTAc2LXw8JvzP0kmG9XKyuEnK81fSgJLNoGNmboPMzjuR7KXrGq3TOUdShrACW28Mm49s+op+GjvfmSpHr4SvWvwng5IzK8sGheJDDcy4HZMaPBi5S4Zb0ADwLMxm497iT+zMxFiJSaxfS9goUOhVRnnmT2AaIxMXb6HNy6YGdEfaI8i2VHBhp5pY64yTRCwlljIZlFhHiNL1tNxyIFS+FswNwyI3rMgj75bDGso0bm2MP9gZFDrnDUrEtKVjPHbkwa+pK38u9TJ+ypToMQhS7tUQyNJxgHm8U0NNAvNTsDG+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 15:03:06 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Thu, Nov 13, 2025 at 03:01:25PM +0000, Carlos Llamas wrote:
> > On Thu, Nov 13, 2025 at 09:54:37AM +0000, Lorenzo Stoakes wrote:
> > > On Thu, Nov 13, 2025 at 10:06:42AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > On 13.11.25 04:46, Carlos Llamas wrote:
> > > > > Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
> > > > > vars into struct") moved some of the operations previously implemented
> > > > > in uffd_setup_environment() earlier in the main test loop.
> > > > >
> > > > > The calculation of nr_pages, which involves a division by page_size, now
> > > > > occurs before checking that default_huge_page_size() returns a non-zero
> > > > > This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.
> > > > >
> > > > > Fix this by relocating the non-zero page_size check before the nr_pages
> > > > > calculation, as it was originally implemented.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > Do we CC stable on unit tests? From my recollection, no.
> > >
> > > Yeah please let's not.
> >
> > Oops, I keep getting confused about this Cc stable thing. Please let me
> > know if a v2 dropping the tag is needed.
> 
> No need, Andrew should spot the objection and drop the tag :)

I actually add cc:stable tags to selftests fixes!

Because why not.  Why leave people running known-to-be-buggy code when
our backporting processes are so well-functioning and lightweight?

I'm not getting the objection?

