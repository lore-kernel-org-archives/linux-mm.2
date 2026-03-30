Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DDBDFF4959
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 07:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791406B0092; Mon, 30 Mar 2026 03:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7422C6B0095; Mon, 30 Mar 2026 03:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E9E6B0096; Mon, 30 Mar 2026 03:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57A686B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 03:42:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 048201A0755
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:42:44 +0000 (UTC)
X-FDA: 84601937490.08.C518CFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 603FD18000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:42:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IgiZ07Yx;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774856563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec3/Ia5o2x9goFiZ1cj/u/CCZTM4OjjTU8REmlmYmz8=;
	b=h1LxUPlP8gFT0+Ewt+2KwhjnnQmYhZeYNN1pcgSOFK687+ZijIwMPLor/NrYBlK6CGAX1n
	4AmZ87d5+tKJbsvSDFd66IogQKTch4kpPaYq/umQ+JBacayKif4JcK1SeqvkR3faBkZV7G
	RryKDnnupZs/4mhXNdVivwc9fVMXTog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774856563; a=rsa-sha256;
	cv=none;
	b=W8309ksKkBvdebUfXlOogCg4HSeS3rAkjf9/P4rDBb4CNuDN60i+yfntKX+FPipXjFx0oM
	zgRQo+/sDUg39WqbbZfCCCjwkOKi/i2BZ9LsHbIVZIJWrlfc/0MCoQmSVCMQcx0En1zq0f
	uNrHgfZbdc1qFHBlcov4lQP6gzi3xxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IgiZ07Yx;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98B3F600AC;
	Mon, 30 Mar 2026 07:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AB9C19423;
	Mon, 30 Mar 2026 07:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774856562;
	bh=YZjnuaPFGiOnM0MqhiVZ3M5vD4vWPEMm0WtxA72Qz+o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IgiZ07YxvdLGMx7yXuTh+8JUPCXPl7svHk9Bl3R0p0WDo12HRaSrLS5hcJ91dmNtR
	 u4AN4OHtUnMWeCrATQBsuLulkg71hKPs+v6DiCDH2gUoMNsxbJISIJsB8u9+0DHCcA
	 IXQ8f8Gb83YEURhy44H6ZmVuAyZtJZSneWXs3Ulq8SKwOWBOs6ypTVdD5nChFz/xL/
	 OioWdyfNckDLQ3mijrdTnPnofDwONulblvug1/h8tpxRq0sU62swOypAkTxeGhBNDn
	 aqrLLHUFgM4k4NNfvdIwxuDUXonbOt+3mQjjQ3KVT1v+uzwBQUgrV6DociJ5Mhn2WV
	 hRx02QMK/Iqcw==
Date: Mon, 30 Mar 2026 16:42:40 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS, mailmap: update email address for Harry Yoo
Message-ID: <acopcN-tICKukvU_@hyeyoo>
References: <20260320125925.2259998-1-harry@kernel.org>
 <3c59fd13-fa69-4b9e-9cbf-ee178aa0df96@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c59fd13-fa69-4b9e-9cbf-ee178aa0df96@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: my9a5ta7rt9uc8owd8ojjcy569aqaamk
X-Rspamd-Queue-Id: 603FD18000B
X-Rspam-User: 
X-HE-Tag: 1774856563-120379
X-HE-Meta: U2FsdGVkX1/Rxq8MVpisOeS0vYHxPF20avatxP/KqtA47HB/SimliIa3+PK5XcvvXSwOb4nyhc6nrAC4yQsavla9C/bRvjStmHQ0e1Q7l46eqtKueaaPKLJMzZycspQEWArEUON6EnAq1Kc6b/F3FGKlvdi1IeJOJxmGk/ZcuB+cIgBlLf5EDA+Ce0uyeQGOLE+tBpOxxb4mKv86nBwZOAL/8o+eAWWxoaNmAbBXmjzUSj+j8cTn46sm8Gcgp/phtzDyXAFl59ZSSaPJ5KvyS5Dq5ZqFU2qzhawZNeDoRfqKfJjvWilbGAq08YhLV0KABMREJuL/Ut7bzPeElEAqmattdONNSyWkbHG7SKYUuoeeMtfM4aIMvmo91emvje6s6gozYkITUvo3a+cS5MxqvzfvfzsNur+Lcwe4tNkuyb5mppmCrfsk5F9uUoN7BcRm3zvg8M3uXAmH2sx6rjN4dEXNSBP0i1buqNA5cAqH1KCqlZjqOtbWiXOC+GIQtg0bgAtjfvccB2W+G0jUIn8UW3xN4GsEnx2w00mKxuAR2xqEHkDG2C4YqSt9PAfqQ4PD6vIhF4D1aeu4L8cdLj+l2E2h2ThQgyx52jFAVM5pGhXH0Z6aVY4zJfCddjGutm3UsL/mTte2bC1JqKQdXNgBwe+BrtgdqEzta5Xmt6Xe1GCJKfGcjIUGTOXJ/DOlGQzJ2gBp+DnAmiYz+0+rlund1iLjKSfaq1F5gkbMdlAlG702t1YfMfHTPKc1j0q1H4Ee/1D1NHaEy5nDKs913j1EDsW3hzDZ6B//8GaYHHx31XJWEkNgADNrUjn2vX/Or0PUggLYxhIofNxcmJQXduZToGLP2msRMjwJvs+9Kyx2GtU6IWppdpX7SAb4giXx/IyYiTX8MS60gigvvlK0NAPf0otB8/8CFtXyVE02YsKdngu/0qNNcDl1Sqk40YhZV42ahc54tNXL6ahqZvBjauN
 IYhS8a0B
 7wpPl8WTgHgVgxZxQGVww9FYzWWArg/MjbYZbVIZA4ANPKkyo5cnUHZwzg713fk5cFBWPYfiilztlakmmlmG0wmVGA/piCCrUrLdxUv9s/g2MFM+mlsB5c0Dit7B2QkrCUfQMn2lwaduvrEFTVtbAHxFJ7dIpGpfct5J7u60WlQkEJAh7lrFY6sq+94DGir3oSJQUkM3QcJl6l0/vfPNx/fLYDPZ8xm3CLhd8qatUikHTPFIqlrIIoUhvK62KFWMbs16JZvKSy2yGt4npsGI1Lor3Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 08:39:42AM +0200, David Hildenbrand (Arm) wrote:
> On 3/20/26 13:59, Harry Yoo (Oracle) wrote:
> > Update my email address to harry@kernel.org.
> > 
> > Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Welcome to the club, nice mail address you've got there :)

Thanks David, and you've got a nice one too!
Interestingly, no other David or Harry claimed it ahead of us :P

-- 
Cheers,
Harry / Hyeonggon

