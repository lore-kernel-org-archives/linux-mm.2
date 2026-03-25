Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0001109C05A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 19:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669FD6B008A; Wed, 25 Mar 2026 15:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641406B008C; Wed, 25 Mar 2026 15:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F666B0092; Wed, 25 Mar 2026 15:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2D56B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:02:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2131FC33BE
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:02:25 +0000 (UTC)
X-FDA: 84585506250.13.199F981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A6061C0018
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:02:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PJmscyi/";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774465343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS8uKOK0HYrP77y2EG1MIvPB2h0CJZ2+5YNh60SHFC8=;
	b=1QActGL0RgIR+BQ8SHTbTLFD7ocG6WkGeRslZf1q2osJlOFl0ydUO8IWy3acUgR4E0Ia0t
	MW7HLzf+7Vm9tJvtZDUgAaEGq76CEtLcQTNasIcAl39oQdem+CP6dmI2XCjCvfQWftjMMh
	5mk2Ny0WbblvaoHLvSy28H3n2b/ZSdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774465343; a=rsa-sha256;
	cv=none;
	b=FA6En6HiXv3O/NvWRDQ0vp8DhcETkUMjI3wBfjU9TmtN1ruFbWQZFrCkLta9UF8rPyj24x
	LXTk6FE9UkpH/RvxjblraQVGNv2JXWHow8H1WvL/MaRzg01aAo7C34+OSJMh9zw8kySXUD
	uQqL7Yf4PLQh4Zr4LtJgcTTAZ7a/JJc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PJmscyi/";
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D15EC60053;
	Wed, 25 Mar 2026 19:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CBFC19423;
	Wed, 25 Mar 2026 19:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774465342;
	bh=+VWz5tWUvCsex+dbkwWF0LLb0MFPoXaOB8REka4tMV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJmscyi/Idy7S9h1NBn1IL+49mdMhklSh9xur61g0VumrBhg9J7QWsKsVuMes69v5
	 yCTsxPp1kmOOLrgRdNhnaOf83qFghqzJwXkXHMFzILzdTt8toLqSXb8reo8XREfTxJ
	 v8NjofJDJiJ6p2ykVdL29HyUmXqaJsa2s39wGgUdjUlfamzMLZfLrpJhqXIyds73rc
	 f8GdYEzgK1o5psoiuSAJCoyJ8wZca27mcAprvqu/02FwbkDoda+8us2qfGUaD+Hn+Y
	 FcNlcuPQ+u8mkuYg5EShDzuSUzQuFwEzHeNxsuFHUzhWp+DYno1E5y5Vpd5C9iTjlk
	 dY8r1+DQgLU2g==
Date: Wed, 25 Mar 2026 21:02:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jianhui Zhou <jianhuizzzzz@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, jane.chu@oracle.com,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	SeongJae Park <sj@kernel.org>, Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] mm/userfaultfd: fix hugetlb fault mutex hash
 calculation
Message-ID: <acQxNa_VJNmaFkfy@kernel.org>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
 <20260310110526.335749-1-jianhuizzzzz@gmail.com>
 <12e822c4-a4f2-4447-80b9-2eec35a03188@oracle.com>
 <CAEgWzV5ryMBgJWH3QmWfr9LaZoihXcffFWKjK6OfJF=pDF6BtA@mail.gmail.com>
 <20260324170311.dc5b54fe0765f2e680e3cc90@linux-foundation.org>
 <1075f7a0-232f-4268-94b3-573d11c4203f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1075f7a0-232f-4268-94b3-573d11c4203f@kernel.org>
X-Rspamd-Queue-Id: 8A6061C0018
X-Stat-Signature: 1fdf4hgti9edz4rppdxytuizrfh9oqfu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774465343-3485
X-HE-Meta: U2FsdGVkX1/emkGxJnkXKt/g31CdFkpFvyhpkS1Aswpv9lDZFsWt6Ij5Sojj3TEfeC38UXYGOJx1TirhdjqvRsDVGtXl6MlKbwGxcNXAG928oDsDaU9y7FjtVvFZp2vBVxaWmRl5Zd3r/VJKZK6Cc+4d4dSXRZrg4ukAxA48qIDiA6e9Ov9BtdVgnoPO4IgjPxSs2ThFBNW+w228ueLYXt8tINoOHC+2rtfS4bGZKBAqhZsX8G1ow6PB+mBZ1+AgCH+z9tXTkTN6O2HVpxCPrpd9Fi/PKd7BN7owV2CNm5vdSzlTbLr+uHgRoyKAti3T3MnCySeC+JSuj+5HFeW23WIdCcPozG9Tvkjl7Q6rzD/LA0gdw++C9ppUSJcXSH9LVX+RH2FUAs29WFNrngpITAQkWAxzQSEqCWx2m3hsdP0SMV6mMmmdybD1Kb8KrNrUEnKVTeqaDPqiCzILVK8d5M7G6OTQwxM+W2xckhiUcCU0lfZkhWSKAEKSgLURakrhEsnB1WvEsoZyG8HE5zn4n4nJG0zgGMMSntR4oDwRc07Bo9x38PEvdm7iVZPk52Cf78+mxGdibvH9lfLeEk8GP7xSLAfsrF10vYJowyJcw0w/I5qaoZX2A5i5r8cpy855PQXEgdGFAvGNiGdBUTAR6++nmNX4CXvVPYQcSrn1Rl5P6A7u9/gzDa+Y9sjFssqg6aXzv7/aPqJrFa4gXEz0qz8uiP7fP+a9u3GNviO0iJjLrHxtK3GLlDoDtsu86uJ3KV1DHoHzsKe8aHwBRzHbjhQnQauM8HFwY1eK6CYetsW66ww99FginujexMxhG8/Qdf+eZG3oFlOK/9S8+CVck4Jz968mNpEXFzlNfxHeA/IUPqHXSCe3A1vqVZ1bspTJ/p0IeDMBDsFjnZ8/yQx5cZyMLK9JBD52HJ1X/mBfxDKfiaQg7t2+Pfntw28s1U7nXHBXidwwnS5pRVUgimT
 qIcjveJe
 tyZjmfih+3ocVbfLfJ/rNhVdbomKaOMedcA0v19lZf47DiYjq6u52owj3MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:49:09AM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 01:03, Andrew Morton wrote:
> > On Wed, 11 Mar 2026 18:54:26 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:
> > 
> >> On Tue, Mar 10, 2026 at 12:47:07PM -0700, jane.chu@oracle.com wrote:
> >>> Just wondering whether making the shift explicit here instead of
> >>> introducing another hugetlb helper might be sufficient?
> >>>
> >>>      idx >>= huge_page_order(hstate_vma(vma));
> >>
> >> That would work for hugetlb VMAs since both (address - vm_start) and
> >> vm_pgoff are guaranteed to be huge page aligned. However, David
> >> suggested introducing hugetlb_linear_page_index() to provide a cleaner
> >> API that mirrors linear_page_index(), so I kept this approach.
> >>
> > 
> > Thanks.
> > 
> > Would anyone like to review this cc:stable patch for us?
> 
> I would hope the hugetlb+userfaultfd submaintainers could have a
> detailed look! Moving them to "To:"

Wouldn't help much with something deeply buried in a thread :)
 
> One of the issue why this doesn't get more attention might be posting a
> new revision as reply to an old revision, which is an anti-pattern :)
 
Indeed.
 
-- 
Sincerely yours,
Mike.

