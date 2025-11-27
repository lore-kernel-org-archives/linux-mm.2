Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C9BD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30726B0012; Thu, 27 Nov 2025 06:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07F66B0022; Thu, 27 Nov 2025 06:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44CC6B002A; Thu, 27 Nov 2025 06:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92C6F6B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:18:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24C9813BF57
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:18:24 +0000 (UTC)
X-FDA: 84156138528.30.5DB5B21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92B5240003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:18:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnqFtZWD;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764242302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knHI4LCoYOCm7lwQ3FWEiwAFh6Y9pjycr2PvFvs1X4w=;
	b=Z8+lvqNxe0L2FLrRr8Y/A3KL6XRJmVFWrrZLJnMHJdvZO97ii388cBTmwS0QYvquP79lQ4
	fVQAZpXRDWRimW5wfD4DYA2347AFxxdqr/qL16x1kHLdRQ9bYUx3/haCwuqP+iEJ4puPIV
	o1+Aq66QIIxv7/YfQ/qMEJCAYp4WXTE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnqFtZWD;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764242302; a=rsa-sha256;
	cv=none;
	b=isHleORHpQUEOFSJ6Lhri0dYTHvr8hAIj6IY+LqHgOZjdNeUI1hx0U7VysIVNgCROZ37Kf
	tKl7n5SxebkTsaq2UlB9BIp/AmgYx8Xl1PeTVh7X1473iEp5nryoTmyeF4ufjOZEFUGsSV
	vj994rcn7aV53kFk74fzg+kT2QaGSr4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A09C60204;
	Thu, 27 Nov 2025 11:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAA0C4CEF8;
	Thu, 27 Nov 2025 11:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764242301;
	bh=LGIVtxajxKFoRcUUjJf+GTVcZh6OJXHRfbkkB9FrCW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HnqFtZWDotDk1h+8DKJczwnhvfeDRKlb5rj1/zSdBmYiKSz8nz78NxKpSyPtHeUdu
	 4n8L4Zd2gwlN/B7LPcFoZyS/zWBZXIv9OMpMIFYn71ZaER/U5xSNynksfK0sM/XxgB
	 YgehyVIJixQt0yYyutGkCdsw9Zd17a00okzKK4aj7IPBjRy0905NjNYpwyleZGqwYa
	 M4Dbkn+DHnFDyZ1VC9l2lWarWa6HrCoitN/w/rxXyKDjrYuxWaWBrZGdly1ctiDQMR
	 xF8qUP8fHzba9Df2M7ahFMZ3bMHUXoIpUZpDd3OPmk2ndqD0XUMvJBopJIapbLfyIE
	 BeUlxurO7d9Rw==
Date: Thu, 27 Nov 2025 13:18:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
Message-ID: <aSgzcpFP1qBda5ef@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-4-rppt@kernel.org>
 <aSYBrH_xfMfs6yDW@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSYBrH_xfMfs6yDW@x1.local>
X-Stat-Signature: sf4mt37ax3gnutsohpi9k87bxn7c5go8
X-Rspam-User: 
X-Rspamd-Queue-Id: 92B5240003
X-Rspamd-Server: rspam09
X-HE-Tag: 1764242302-317900
X-HE-Meta: U2FsdGVkX1/OFw8jQeTFyxZPBeKtSxN35mDOdVSp+lFzhPO2DnptaqL/s4mak1JqRzmnaHUQy9EnIROAuMyfoCUp0Td3Zt62M7FcN5PCC+rdrNrGNLRP7Ai93CFi+7AlIZ0IOpo/H65fPVfjqYjXIe97WLBLWXSRn9AsFE0tUSdeD+FJeasNIUqtYJenfM8WuEiyfQdF4uNpaDSDFQJnqloHPRBgn0/zglBOJxNeAy9VUVY+VO9H3ipovr0IBeJ0hlDjGZUQfAE5EjXoEuQyAFwA+r4U61X6Iw80Nm+eLUDJ1fw562WM1JEdi+atsA30ogyv6phldrZMw0pNg6Jg2Ai3U36jPNmgH6U9jE4ot2IheVc2Vn7RX1KblKg2IQiheyEEU7kk0VdH68+5obj3hv0I5KPq7lZUIJNNVQvNVLnrYgaQUNZHGtYJAt3MNMgdB4MrYHZ/gdHKINwEVQRR7GGh+RqT2t+eOzREJdhbgquPOGrHMafmCZDa9gkl5DzvFp9NzxZiRIjxY1nUaCxEsYoVxlOt3V4ibKDkdyOAt2JbWNMGVZ2+s+RNXEq8I7k8O1FtBe2DLcTsUKL01N3XPHzkEOdZW5cekjge5PF6OdITgWBqyBjARHq8gVI4xpUciNUNzttV5cDb6ke1S7JilIE0JevubYQHX9CZTZWWNKf9/KdiCz80qDkFtbKTNSgGxYD7PB36G76p6wa4bBULYYMkI9Q/wSaGmrkWpdONdVQq+dzNq045Jnoy6UoT2N/XaOOoRLBWQ2bmdqAZrGql14Je4Qajvdqy2A2ijwIDRXRfEhmeVh8xPEH2SertWWXXpCJ1LyThNVoAyDstuMI0A2OKlJqOILvUCBtgcs56H0Q8pteSC6dSOvE7pNVScWHmS6xy71QwnMOkIoP8pVMiHlD0LW1mbStnmoVdzW7Ln5hTgFmCDfNRyALVAUIIQZ33ShahD95IcMxU4wYWDIJ
 Eea2onZH
 FEuSbYkaHwzoEK6VURTeItnkJyp8oHwGf/p1dW6X8PNXiZyaNp1UIXcZ0lyN2Q0HJfYTdpAbCsz9wBsSR2Ql2Neyt44nzV5zqjPY3lrQ1QO+y8afEYIsPm9I427mTkLDn3Ppv98eY1EIPWt0ZulkZzCRQFmKO7l2eXXp6q/C9Gl9577zHmiEDNxJaHkmQHmoZ6EPtw2HNTDpilDNOBXAI5eDkJ59OUB71MXeVVczdxQ/ZXAjSCTQk07u3KaENus5S3Yrq9ik7mXu4cwYQdUatoSsDeej9/OnfHeFyaIjLqEegU6amM16uyOoysFpC7iw9m/udiBQPnUAIWU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 02:21:16PM -0500, Peter Xu wrote:
> Hi, Mike,
> 
> On Tue, Nov 25, 2025 at 08:38:38PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > When a VMA is registered with userfaulfd in minor mode, its ->fault()
> > method should check if a folio exists in the page cache and if yes
> > ->fault() should call handle_userfault(VM_UFFD_MISSING).
> 
> s/MISSING/MINOR/

Thanks, fixed. 

> > new VM_FAULT_UFFD_MINOR there instead.
> 
> Personally I'd keep the fault path as simple as possible, because that's
> the more frequently used path (rather than when userfaultfd is armed). I
> also see it slightly a pity that even with flags introduced, it only solves
> the MINOR problem, not MISSING.

With David's suggestion the likely path remains unchanged.

As for MISSING, let's take it baby steps. We have enough space in
vm_fault_reason for UFFD_MISSING if we'd want to pull handle_userfault()
from shmem and hugetlb.
 
> If it's me, I'd simply export handle_userfault()..  I confess I still don't
> know why exporting it is a problem, but maybe I missed something.

It's not only about export, it's also about not requiring ->fault()
methods for pte-mapped memory call handle_userfault().

> Only my two cents.  Feel free to go with whatever way you prefer.
> 
> Thanks,
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

