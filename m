Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41B4D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21836B0012; Thu, 27 Nov 2025 14:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9486B0022; Thu, 27 Nov 2025 14:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EC96B0098; Thu, 27 Nov 2025 14:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8356B0012
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:04:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 123D8B7803
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:04:52 +0000 (UTC)
X-FDA: 84157314024.25.AB6791B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 75E1740013
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:04:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIycxaNB;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764270290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qMf29w2jprLuK6pR7GeMfN2wvvtMJm5oS00XyC83Ew=;
	b=nearfOq8+USM1uf73MRqDrVh+6FrMsKLE6HIG0Np8tadtMunGPz0Oc+rKTl4hBxDZMDxIl
	yXig0l7KLdzX6nKQVm2omgi0Dalmw2LBidCC7UCL2ogkkCmc9qo8ZCdRLoOX1MhEJnNnxc
	7yL/GUSVqeKjKf9j9uhVkYxqPMfFpXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764270290; a=rsa-sha256;
	cv=none;
	b=ZUHy+jOCcdO3c+e7om7kSjp8P/GE97opDce04j4AE2pezVxULYCv8I3Hm4vVT58sf/IYAq
	kMmEXnisUHruYWddys4kA2M5zB5Fl+wFHMthLbMknFgrlh069HiXYXRUPivIU0d9ceuTAo
	dm/0gAQMuNHXeV/bBWcg62mHPiZfqbo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIycxaNB;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF0B660144;
	Thu, 27 Nov 2025 19:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FE1C4CEF8;
	Thu, 27 Nov 2025 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764270289;
	bh=DKQJFcgXS2cAkuVWuUAaSZGMToD5A3+53/sdzCkk5ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIycxaNBmymUyYVPRVNpQfUciz6q+rLYzWJyLq+mNWaoVMAJTeg61TF8etU7tV6QY
	 sN0S0gBrAIJAlMdFdc78LUM48Wwy9qh70KqEcftBiR3FUbeSfBtye8DaQckUxi+SuD
	 qCdNyHiq5JiHjgSuOLpp5ECN1Ze3VIN+OmvaCLf6vd6nglkyyB2I3a6KhRuBBqPuKJ
	 vUnnFJKmPU0FNaAIlXFL+V3KGahD/iK8WsCI9JxKWVugqJVnDk+1N5Erm5ah3Rijtd
	 F3d9D/FtSTcQVWJkNax1JqCAC8hTJrqfS/cpz5elx84W7z2kHgbU2tPkJcxJ44jBUI
	 HpuljhS5Pe+hw==
Date: Thu, 27 Nov 2025 21:04:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor
 mode
Message-ID: <aSigyHj01snbfii7@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-5-rppt@kernel.org>
 <bafb0c9e-9ce6-4294-b1d6-e32c41635add@amazon.com>
 <aSgpo1_ZSmxf84-p@kernel.org>
 <13d3a7a4-5cf8-4fbe-8dba-d565525a71c6@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13d3a7a4-5cf8-4fbe-8dba-d565525a71c6@amazon.com>
X-Rspamd-Queue-Id: 75E1740013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: pzsw6zfpu6rmkhkc6a4yn136bctor8if
X-HE-Tag: 1764270290-725657
X-HE-Meta: U2FsdGVkX199PiuaRAl1oWQ1BEzE/rqsE0u0Ghefjwmlw/O9VShv2fksvWY5gW78aP1tCFHbGwW9sXPXNHMUAr/BqAKFjGoTpxABD25PjWSfS8l1Q5vTHn4n7IFbeCf1DIWAv7tIp3EhvVZonwUHw8dTEYe0zOH55j6JmVsqOxexLV90Of5cDI8oDS2F9JnN2Gf6001zA3yzqAS8ykGmnF94wIKYoy5BCfijg6QykQ4UcmZi5M49Ff3DGXbdhpkUi82tll5o8DdaTYm/teMp+CNFnwTz0GpjzLpON/Hv1eLBjbKamVWt9Am+hEQpt6C8f9JGwDy+0jcsMGcO0/zyx0ZwNkMyDlA6WCqwajL4J+jgCKiuOQ7Xw9/Mbw7/R6tVlNN+zUyCjoWLHK47rxzdOKoVKnat4qha/b553jvo4k7GOuXNn2+aZmSOl8FJp3xvgthSiMXvbOt7VowIMXPZaanF4QB1IHX2pg1W95pn/Lc9LJnMtvI37nJkQlMbr+jl854Vhw3hlIPC9qW0+ur4VYV1CqoeGL6GTMa/IKULVpvuQpw2ZdZee/SS4tjwSZa88Uyp33Lb6G05t6cDoNfRtBFaKNCQzgqe+g8KLoPWP+IV2a7o54cSzYAB4YYLG2iFUn4HWNaYva9AvEEjaPOBmVFj4/hEL92X1u6iJVMOfxjTOAluzaSzuBEzh3r/HXoEtZcQVqPQFHwIwvdPcuKUm4o7N84E+9eLpzd5OpgUi/A1zhI0U9yWXD/J1L3c6xX+NYJZWR8PS4SZEMkiT3kwUd6V0qX6K4wffYslFVMowyxK5XU46hL9553vNI5jQIITyEFl7BkCL+tiFRQkdMTuJX16Ma0Bec2PH8NmuYbu4yQblA87rWVfAViwTe9+vKXRdppWFkqEUnSCwIOWspn5DcL7hLivDJ1iXI6zDODeTnSIgowcjtwZuGyd5grVwc7Y/BhZK8ABUVlg4FDywz+
 xPHY07EQ
 9ZRzHxYWlsaxi6oGDoH6il38RT/kwLM3rXwcmQEN+TSmCTsEO0ERwYQ/GFWtxT+zV039tF9GhV7g/I0ImFctnIUdghjYYjxS368FHxB+YXlq581qm+oHirtHq7DXccuDE085vkaosAac7RtvlPF7krq6jb++UUlLsOM93Xvkxa1e3ZqMgEQR6B8ZqBzdsOqYDXOXjiIvR0abM561z3a/YhKsiuFwTeSpVP1aFF41MGR09vykBHBs41gQv/dCBvGir/q7dfK3x67Ngd3ysbtuu3JN/hWmnsXDs0OVkG2c/6k1yj3Qwmo9nPMQXTaXv4W/TnJdM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 11:19:35AM +0000, Nikita Kalyazin wrote:
> 
> 
> On 27/11/2025 10:36, Mike Rapoport wrote:
> > On Wed, Nov 26, 2025 at 04:49:31PM +0000, Nikita Kalyazin wrote:
> > > On 25/11/2025 18:38, Mike Rapoport wrote:
> > > > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > > > 
> > > > +#ifdef CONFIG_USERFAULTFD
> > > > +static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t pgoff)
> > > 
> > > We have to name it differently, otherwise it clashes with the existing one
> > > in this file.
> > 
> > It's all David's fault! ;-P
> > How about kvm_gmem_get_prepared_folio() ?
> 
> I'm afraid it may not be ideal due to preparedness tracking being removed
> from guest_memfd at some point [1].  Would it be too bad to add an
> indication to userfaultfd in the name somehow given that it's already
> guarded by the config?

Hmm, shmem also has this clash. There I picked shmem_get_folio_noalloc()
because that describes well what it does: lookup folio in the page cache,
grab it if it's there or return -ENOENT if it's missing.
That's also what hugetlb does for uffd minor fault.

The guest_memfd implementation I copied from one of the older postings
allocates the folio if it's not in the page cache and it seems to me that
it also should only look up existing folios to keep uffd minor semantics
uniform.
 
Then it makes sense also to name the vm_ops method get_folio_noalloc().

-- 
Sincerely yours,
Mike.

