Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F19E63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 17:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CDB6B0088; Sun, 15 Feb 2026 12:47:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05756B0089; Sun, 15 Feb 2026 12:47:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A8E6B008A; Sun, 15 Feb 2026 12:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF6C6B0088
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 12:47:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20F22C2061
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:47:33 +0000 (UTC)
X-FDA: 84447423186.29.6AB7617
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87F6440003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:47:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbrYBjCS;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771177651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYNqRb5/SExj93Wn0ufGj8S+4ofEOfqonLngGkSFFRo=;
	b=abmMwvCZrJu0VWCbAgYteBbCRt+ErJ5j/cHrLw+HIorZ1mK35gbYUcbiSKRtC9G83RSFXS
	uKi1BWR7tHIlawDyidOBilngOru7RyT6RvOxKDvDVEQXGIZpGKyCwEpQNldWFw2Q04O+77
	NUSFq8ytF9Hm5dDF7aaZLaN1Hmyq/hA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fbrYBjCS;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771177651; a=rsa-sha256;
	cv=none;
	b=dNs/mWExeaekBiA5Ak5sCzucGeYEF0jz2oPkjzYBo19Ot5IjLi06VP4X4CUChWCCFMoVo2
	evmwxy+F0rLrWNAm4L5x8daAG/Dlje1c6Sm1o5G7ZLZl7EJRUE26vjX0e9jDPaMc2/2jTF
	6UGSwGlr8AgWyOaS325sYshXYG4OjRA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1FB560008;
	Sun, 15 Feb 2026 17:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B06C4CEF7;
	Sun, 15 Feb 2026 17:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177650;
	bh=WauyYvE1fxZu8CMoxtW1HF3J+YpjZ/sOClCwhExhX3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fbrYBjCS7QUw/rE+JE8LWK3tTpdARCB19ZpCOzFQFJYGvUsGOHm6o4hP+P7BDXHS6
	 1Ra7umuePXGYH6F/+80Rm0n5TmkfK14mAyS9ntBXHkWecssXL0KP48r5LlHdNKCB/v
	 Yikkfr4c84VgkViQbjDlEPjtnJr8q/+vckh4k7MX3co2ZRshjaZYmP5lR8kUhoF2lk
	 XG9vwuHdbwOddDuJB7oSLZ4+XvlH5VSCO7CBJdBL+lBg3Wv8xOtfQ/eBwGNFheDjU/
	 Eituud2nlH0GtfZ47cgpkILBkjYqEq3d7GDUZKTTTqcgd7VR2xlMlt0CBgwzA5r05Z
	 SFgCDu9R+kG4Q==
Date: Sun, 15 Feb 2026 19:47:19 +0200
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
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 07/17] userfaultfd: introduce vm_uffd_ops
Message-ID: <aZIGp0F7uuS9qYVZ@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-8-rppt@kernel.org>
 <aYEY6PC0Qfu0m5gu@x1.local>
 <aYhh2XzyFsJbohll@kernel.org>
 <aYzZ-zBipYQ2OA_n@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYzZ-zBipYQ2OA_n@x1.local>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87F6440003
X-Stat-Signature: s43cnrkfaipxtooj36ohxw9x769hehtt
X-Rspam-User: 
X-HE-Tag: 1771177651-462314
X-HE-Meta: U2FsdGVkX1+dII2/92rbUcFBJWaHzpcb5iX4mUF4mOhRwW4LsiRn9Uhnfup10xqGHTdrp+rGVEu8G0jfUA866vgQj5DaRhUrQsk8nBb87Cpx80s5Kun0U8p6eN9iMKKOBVLDRILgVs7/XxBui1Rz/mBqGiC4olam42FhiDtGn2OxBCDSMKPnxuQ/P09U5VH5dtFsbo/KLTz5YRBFHW6PRQXGgBxB8YqEaiuLxZXSbjj0mDsy9FXnm/CBGtL/dUVXEWEi7TCUEh6PBmz5Om4+XIx4HI0g3wrdFikfaWyHHq5kSp47MP+gQYOB2+BnVlVc8qkb3CUP5Jkx+YVNZuEfGyG0FfFKJvnzqSoDBaeGRCkOGiPHKD8/+xw/BauDmplFt7SYdZ3fSyMsdqhmXaVN++Dvhy5H3sQ4hYFo4IHwVjDAQ4K0651NKMSKOJpZOE7mSSuafExsAfZ18NAQnVi0TiORBggMbPq1dyvtpzaWSM9BkCS4SPNbRcO1r28w5A1yGJfzM6t5mKTjA6kv/jOPp9v0iolIwfLfShvi0q34C75k9oqSW0jUvkz+hjAJc5ARYM6+m3NgvFSmXjjLQk1A6kocAyIJ5AY5cizBOkq0ilGmakEIGE0iVnv+Z5cOMDBl/a6lz9WeR3AwY32Arg/s+EMnqAWRLf+FIH59IzXUU3IdBaPShxv+G5qeadP7QvXEwt5GwGUTospqSAwsglVVBhSXV9iLEsiVgT+QMWwnCJywElSEW19cqsd7wGg0i/9I0ntf3YbgRVnVnuk9J+Msot4OK5dwzahGz5s4AEcwEf4IrOe1ZMSSEeQH/J+oXRl179jj+D9bjuITLTnaCZuArC2DOvAvlzHEZAIZhilQWQB50saIRAiuwCsxgyxP9bJ0gl50ge1uvVu1AM84wJ6HDhYSg2QQOKckVo0cA+SbNqtbSJ/3BTVXPGtiZsDNuGhxWSVZKoY2b4r8miCZAKg
 1yd9wIZ5
 W9FfFac1EVrj91bgEsNaALoHsPlO5IqwOWiihZHSKJ83xIpodRGqGbU32FLPQ93nE3mXpFNiPg7mOQ6BaifoqLD7ApECkgsFebjzJa76azrTrS88K4D8LgB2F3o0PMs6Gl6QFkMZeFmw0tVv814ksf9J6xsdrYGksKMzJJIFde3kocb7E54JcknwY9hSgvkZW7FR31oClFw6yowDIyVVwUzDySu4bV0QsYPoWDjgTJty5HsKJJZSt/RyyaoRieHTgad2qIyM7BoLg8gZi8Vjgkw9csDmZ9zIv+WYBl5jeqzL5DxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 02:35:23PM -0500, Peter Xu wrote:
> On Sun, Feb 08, 2026 at 12:13:45PM +0200, Mike Rapoport wrote:
> > > 
> > > I understand you wanted to also make anon to be a driver, so this line
> > > won't apply to anon.  However IMHO anon is special enough so we can still
> > > make this in the generic path.
> > 
> > Well, the idea is to drop all vma_is*() in can_userfault(). And maybe
> > eventually in entire mm/userfaultfd.c
> > 
> > If all page cache filesystems need this, something like this should work,
> > right?
> > 
> > 	if (!uffd_supports_wp_marker() && (vma->vm_flags & VM_SHARED) &&
> > 	    (vm_flags & VM_UFFD_WP))
> > 		return false;
> 
> Sorry for a late response.
> 
> IMHO using vma_is_anonymous() for one more time should be better than
> leaking pte marker whole concept to modules. So the driver should only
> report if the driver supports UFFD_WP in general.  It shouldn't care about
> anything the core mm would already do otherwise, including this one on
> "whether system config / arch has globally enabled pte markers" and the
> relation between that config and the WP feature impl details.

I agree. Will move the check for the markers back into userfaultfd.c
 
> Thanks,
> 
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

