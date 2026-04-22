Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14BA3F9EDFC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4ED6B0088; Wed, 22 Apr 2026 11:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCAD6B008A; Wed, 22 Apr 2026 11:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3099A6B008C; Wed, 22 Apr 2026 11:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FF5F6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:22:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50D578A6E8
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:21:53 +0000 (UTC)
X-FDA: 84686556906.07.A0A7D47
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 950BB2000F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:21:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VnN8966E
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776871311; a=rsa-sha256;
	cv=none;
	b=Da/Sjq84Tx3B3M93XsnXRWN6niTOLQ5Dmmlj9CxcZ48MLnuiuWaYJnqsAzJ+9oxyOD7iHA
	ahj4rDynPWtUt3iADWuRd0ifIXbUqFpVYqD/xn6freQr3P4+6hBx9NUXbm8a995BWCwI2Z
	tdh7oE6wF9SLxSXa1WXGQRh2jVq1J50=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VnN8966E;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776871311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64iQhIM+mmjSkPwwk8v33f79twI+c/XscbZtrh5IQG8=;
	b=VCtPMysjVkYizEdTdiuqXLmru3fZxCelv71e4zfXoYqs1BHyKYxPLdsCC00yKH64TZ9JMa
	oHazm9DCOwtkoQqo0Bndhxl+day6pi4wYYxo16GpOkbkLk4+Ts26+cVYQd2HN68sGkxBhH
	7OtljfEwmL/tb4/PxPKpGtHXF3/T1SY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=64iQhIM+mmjSkPwwk8v33f79twI+c/XscbZtrh5IQG8=; b=VnN8966EV0wQ8VFsn+Qi46AhU9
	HPFetti7INJlHnxxfV2EB4TXDDgAt0c1KYZHWe2gmu1hZX2DT1R7ZVxqG9qjCXz/wJVIuwvOcnSRH
	3HGoW9xjJMko4kWbPWHwwUZ7iV/yYEaNPDcZumfAQbtWpSs+vGy3eidjmiZJyhxaYZmaiCUVemhTH
	jWnR3K0ea0uTSV7kGTdbsP4HblyDnvoOgyCndvBQpRJMoeTcN0e12J6VvTXkgW5wwan2QHSKwfh+y
	j0DSg2g2JtQyO0Bed2JREvV27ZtVYAKbtIXQL1vz0cCMDyw70Z4A+kfhPpbYuL63kIAqcJOm8E67w
	9oNovOWw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wFZOa-001iHE-04;
	Wed, 22 Apr 2026 15:21:44 +0000
Date: Wed, 22 Apr 2026 08:21:38 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <aejlg62nxcF_5g2v@gmail.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Stat-Signature: ynx37ibh845w53p58n61ab64pre3knya
X-Rspam-User: 
X-Rspamd-Queue-Id: 950BB2000F
X-HE-Tag: 1776871311-803429
X-HE-Meta: U2FsdGVkX1/FGmssgr25Pww3DfLPGbG1FT02EJ0Xp5HdOUXOHB29lDkosF29T3PYkDT4QhKse2KEYuWh+uNdjkvNzu823LNA6MzXEdyvHaY/AQaXAh1qlLJFe0Tu5H3bsbmmKz/1DXTp9EfoHCtZA47BdyHEmd9X+IRcgd1RfAGOvcuCd8SM+Z/D7DiKTG0CPUP1bqH2ifhF7sJzKKJ6Mgcro3Z9vf0WF6eNMzcZtAlV1ErKcVxNaFu8AWe455jppSiOXLzuV1ywWVKqLX082hagCXl1o7sEb6ehRNVRQhLTg8ejDwKclxVq8MgPfYSrAx0V5HsBWQ4toTkx1R1dTWP59xfklwreevq36xwW5DS+xg9rV6iVKKpNMFsgt+kjseCCLa399GRYBqn/owWYFRNZIYdNy/Q5kktYXB5d5LyUNr6/tBzglCMnIPlk04YeLSmACPMHuAdeEQ6bvNQdXTHlLPOEhyZLtP8XEztZfCnx88R0TPy+0ELKp19b7WxyVKqaWDoED2LTa6lJFaT/gggzTmychhPme8KNJmON087sV34wN00zTiVzApiSq9k3Z+p95aQh4bS6i2BlMhivTQPNeyGfIXdz1TZxzChXISOrl3FqVun9RuPcnvKbEQVjSfJw4LHiPzOZ3Cc2a6k8RhuyTVP3eLRvS4PdVlC+c1zXCdJv6DIfq2KpbPtVvPyNNsF2pirOhpTHd0s9+Y4aWPzlfGzWpyMALkTGk/h4hA4jMlGMPbJNsquDZ8fe+PqK4f2YXKpCOmdjaiSH8jnq294zO5UZCaxbD4cCGXZ7Y9y2Y7JaTB8gs9MvCNx43RvdRlRBCVTlY0vsSJCekLQuLW8SlXnBTYsI1f4P9Zrd/0oKJhWCx3z6eelhF9XbU9nHLgiB8wZgpDdHOlMQl2UiKKY7fqK+1e8I83LM0OV7VpAoYqPp2P76X+OwPZ9G4QSP4W3c5sugAxmOStB+E6A
 T3+yM4CD
 Ta/jLTr0Q2jspLRXIVoqv/MCs+0NQ5ZRjPCHQCAcSGRtnOEEn+icqZPS1YPh3E7wqe7ST4tOEBXzm4qHC6vLbxeHkDdedRpJnT9Gjr/pzbYnbQMCXyGjfOLxPdHX/UQ8gbINrlFL6UlVQDXStXHfF/1O7QIwd4fx9pPqxsFFCfKAhqVQFiVhOJc9EhuNij11D4i9gOto3YEEkLWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Miaohe,

On Wed, Apr 22, 2026 at 11:36:11AM +0800, Miaohe Lin wrote:
> On 2026/4/15 20:55, Breno Leitao wrote:
> > Add a sysctl panic_on_unrecoverable_memory_failure that triggers a
> > kernel panic when memory_failure() encounters pages that cannot be
> > recovered. This provides a clean crash with useful debug information
> > rather than allowing silent data corruption.
> > 
> > The panic is triggered for three categories of unrecoverable failures,
> > all requiring result == MF_IGNORED:
> > 
> > - MF_MSG_KERNEL: reserved pages identified via PageReserved.
> > 
> > - MF_MSG_KERNEL_HIGH_ORDER: pages with refcount 0 that are not in the
> >   buddy allocator (e.g., tail pages of high-order kernel allocations).
> >   A TOCTOU race between get_hwpoison_page() and is_free_buddy_page()
> >   is possible when CONFIG_DEBUG_VM is disabled, since check_new_pages()
> >   is gated by is_check_pages_enabled() and becomes a no-op. Panicking
> >   is still correct: the physical memory has a hardware error regardless
> >   of who allocated the page.
> 
> What if the page is used by userspace? We can recover from later accessing.
> Would panic here be overkill?

A userspace page should not reach the MF_MSG_KERNEL_HIGH_ORDER branch. The
branch is gated on get_hwpoison_page() == 0, i.e., folio_try_get() observed
_refcount == 0, and that condition rules out a live userspace mapping, no?

are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
will not hit userspace pages?

Thanks for the review,
--breno

