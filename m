Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2850CD0E6F0
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848846B0026; Tue, 25 Nov 2025 09:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8826B0028; Tue, 25 Nov 2025 09:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E79F6B002A; Tue, 25 Nov 2025 09:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 551936B0026
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:29:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EBB6E56241
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:29:15 +0000 (UTC)
X-FDA: 84149361870.13.B01272D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2D4431C0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:29:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QBKPnuqg;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764080954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=He0ThQf3M5MUM3It+fOM+oDwC0Yl+y0WTQSL3i3Mack=;
	b=58ajfMhhR9KTOlIYZEw8H7Lx7qi5JyDWkesawu1HoSn//Nr487Odb9ec3faJSxTYZpjSUD
	NinVvqMrU08G975AAHfh5deYGX6KTrCwA1NEouvOyRAS81RoohQO2EkhiRMdbGuKFdS5cy
	8pFewWArkzYXzhrClEcYK9tzlbdYIv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764080954; a=rsa-sha256;
	cv=none;
	b=tarDwTSocqiDDG/OexSQ+ryxEsZQ61JDtNZzjPb6H9n2QCZzeuebwrOeye0stoUxUDT6/e
	FMP0GMYxXHapFfhQIj+6MPEm96Fviox+DysR3yRlq6/GIb27no95MqZUzpkEbFGMGeoAYb
	tafKk0g8f4qDBP45BfasTRMthLJ7ydg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QBKPnuqg;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21C0C40A46;
	Tue, 25 Nov 2025 14:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DC5C4CEF1;
	Tue, 25 Nov 2025 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764080953;
	bh=QtIX7m37UB3jSsMIWRrcRctC3VHFDnbfN3XBMYjY5iU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QBKPnuqgEw3szxGkQOnxr0TMpZ/I3SfNa3fREd5sHp8tNCegHRljayZIIKjHWeZRx
	 LNFSWCHEtnVAzQ44+gTiYwuHP45oAoqYfcOcO1Jmf+ESzW4HMVxtPO2WqxraAGjxcK
	 NU190+XBXxcDq4qG70hy+0R8LyBy1sc0+HIXaOZihCDRvwK4VkvZBktyTpdch+MFW1
	 WJALRPtOUP6N7aTvT7sxAb9UId41zDLJ8llvhlk5UhGAaOcPlvFAaT4hhJ6qAcp6Zw
	 26pmyKLrpNOouIEegNgpIiIt1vncfTwTgqEFdr0049Fkv/BR3j/2aaosGBPrb5nEyL
	 qfD/kciwyAYJQ==
Date: Tue, 25 Nov 2025 16:29:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/5] userfaultfd, shmem: use a VMA callback to handle
 UFFDIO_CONTINUE
Message-ID: <aSW9MJJ1CF65m5w9@kernel.org>
References: <20251123102707.559422-1-rppt@kernel.org>
 <20251123102707.559422-3-rppt@kernel.org>
 <a06e57ff-b77b-44fd-9b69-929d7647644b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a06e57ff-b77b-44fd-9b69-929d7647644b@kernel.org>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D4431C0011
X-Stat-Signature: fj9fqzmwqeyqmqm7zn8nec77czqht5it
X-HE-Tag: 1764080953-756720
X-HE-Meta: U2FsdGVkX1/AVvHZNnu3D3+2Q5pePh260H4vGxM6lmvTVoHHXt1t3f4bpaFu25lYmlLvO/AwbfSRB/OTfhkAZ1qqof0fIqgBmqwZM8b1Bu0ejniFAT91zJSpD+0MmAlmynakLdKwZN2WWPMnjs6DoAFwDHcXAlrYDoDGfYYIPGJntwclQ4FZnVyvz1ETxmWvPfw50UsdZLg5FKe9Ce8CwQGVISvRyTOCf21Z+yjrSWntbpY1AbO9lvjMaUEw7354RfPA7aXwQoo3Wf1+38CquMJU7RI0naXGgLHODsPqFthi31HhRl4doOR6eDjgYqvfx01r+8eqTU4tzQoRjV7b71pajL0t67sgAD2EG7lxe4Y0zgVPElEy9lQhL7q2WReD1OD9oLuVJac0Q6te92PnAd+9Z0BSJz+KV8q0WWiFwQTOIS0959jeHNDJ0CqzuwnVEfPw8a4q0wdTtC3Z5cNhZd2Z5//B6DIPPsrsdMTSCHh4NlQBN+qz+4FmOYkhyKTS2+vIUaM7hudzpsNBqhAZ4RKE+3CupCM07L/Fto5B1mULw9sDQ9ZImN95KapnJHdvpkjm+subRw1j/8uIDHs6Y6laj1iuMXYXu3EcMWdi/42dXCoisWEOnxbxr8YYoJ2/PxOryzsNTNbCp16BHP9T/ySBzJkEEtLhyOoztF4onPDeK2uVIdrZsnU46UQ9vBMuWGbtFo0/jw+h6D//FJKPMIDaEeFgaliXxZx6DBa6mOEL7Kptn+dRRddzmAQK6jLiG72tHts56rcnpOQL/L4naV2dILV2Jad/AD7zSefcVkPgC/x7I9x5/jwgmbqH68dvE6m2vHTvqrQ5VYXFLbjOoqqkusxNhtvyfJMEgbHM66UJHHt0PZFGK/8UVzR8YGJ8JX7r92L2j1Gx+tI4cpKlYkdLMsj0g4eI4rMUBJ61+MITprAHxnjY5EY+gXbfXsT/QZas44ZDxt4YXeGSYiS
 3hjKtsYB
 8uY+GadSLRBqnoddJjyFx5LVUJmcKwD88ezyuqQLJczO1AZMhmVMhuKY5FR+oZR6287KJe+LpLgoDibVwPpGaPFZCfH4tz8eLV5xJXq2102UfSAB8CQDLFgnfHaNUBFcQQQWOILV0CawbiR5Na0IW0ccrVtLZuNeKsUz8iIFaKYqprdwmM0N73wwRyKcWbkdDWkkKrBtXVgG7fPbF6OgrtcSJ9Z/yaoI4farmnm7mzRErTrPIUNJG9roE+C0T1jd7MNEvYaS0qs6U/KazPaIXXtgyrqbi5E5oLpT/kI0eMfB26p7LZQbPVXec8xec3b7VWGEnlps/B2WLJcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 12:03:17PM +0100, David Hildenbrand (Red Hat) wrote:
> On 11/23/25 11:27, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> > it needs to get a folio that already exists in the pagecache backing
> > that VMA.
> > 
> > Instead of using shmem_get_folio() for that, add a get_pagecache_folio()
> 
> get_shared_folio()
> 
> Given that the helper now no longer receives a VMA, I assume we can just
> really call it get_folio() and the "shared" part would be implicit. (from
> the inode)

It makes naming shmem_vm_ops.get_folio harder, because we already have
shmem_get_folio :)
I'll think of something.

> -- 
> Cheers
> David

-- 
Sincerely yours,
Mike.

