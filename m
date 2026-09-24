Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990C7C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69A26B0088; Thu, 24 Sep 2026 04:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3C06B008A; Thu, 24 Sep 2026 04:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5076B008C; Thu, 24 Sep 2026 04:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD976B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:52:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB27480232
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:52:24 +0000 (UTC)
X-FDA: 85248039408.01.41A8675
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 437F5A0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:52:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5mi1tiQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239943;
	b=lj2cF497kgq28SvrgtwN2V+Amoe6fJcEbG9ruSYOD8VbxZ7l54pj1WN4tXn/jbzPONd2zs
	t/8jhVRPj2DGHKmwkSsgmBVRx6cP/5byUEMYlDx7PkkRFwAeQuuKSWTBJ5tYEgdANk37pl
	GZQPDhcGOH9w7/XlCcBU82X9vmNuCOU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5mi1tiQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWMhh+Vr2gIxwHKH0IoyS9nRGOMWCcgjZiTj2nIYyiM=;
	b=yksLeiCWOXe9HsuxRIyaiOSXxyB0CcwhQQ6AVa6SzfEW6Big0qbz+T0UQC9LqM9ho37QJw
	4kiXkLgyz9vnzx52Eo4M7/pNLYoQShf0bWOHIaK1v0rHYlowvEho6BQulCfq5zsHRmMRrH
	OhTlsLKHhXjbkJEaymMtCIHAu5nlbRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75642406BC;
	Thu, 24 Sep 2026 08:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2116F1F000FF;
	Thu, 24 Sep 2026 08:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790239942;
	bh=uWMhh+Vr2gIxwHKH0IoyS9nRGOMWCcgjZiTj2nIYyiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5mi1tiQKGkktN6ni0msY6lIOn680upbYYmWPhP0bEoC4/sOKoPWa18jz04oK42AK
	 4w2hU0VgsSYfUsx5l9nYsMwwSy6fIspuaTRzFulowUKw+zqqVpvT0UqaQa3bzsCbNM
	 PNqbv+tv0GUXiIXwyMp4bviiWcHjWMSWxB/YgmB5kqv5snWfRICyLJrV4diYCPWM3o
	 YG+SL6YXwMA8YifrP1fuTsM1yVI6QnYPqVZ/ucWWEDbM+FPIKanV18ZDY0vvIhgp9f
	 eAUaTX/9ow46HrwcXL3emBRJ2UjO67+66oik/ixS14ceRCu0Qm0ffw2w1hHw+ZcnXh
	 UXKCgAMHr4Ovw==
Date: Thu, 24 Sep 2026 09:52:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	harry@kernel.org, jannh@google.com, liam@infradead.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [syzbot] [mm?] [ext4?] WARNING in __folio_set_anon
Message-ID: <arTiHRj-i_17L3qo@gremlin>
References: <6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com>
 <20260924065458.49698-1-lance.yang@linux.dev>
 <0a0a07f8-8ac9-4d75-b4c6-c403865f0be9@kernel.org>
 <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08bbb615-a054-472c-9873-787cc0f7a4d7@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: pyo49ia9m7nyo5xfug5u84fqz6y5n9so
X-Rspam-User: 
X-Rspamd-Queue-Id: 437F5A0004
X-HE-Tag: 1790239943-436569
X-HE-Meta: U2FsdGVkX1/venzhhuDVcDVSiIk69A0L22oHqgXGo6ecPrF8SUXBsI/ugBomHuZHF8X4ezz3AJVYRogHUKgvReP91MM7nQPsxIKkkA8Nid2GV/WC0Pdv1tFI33487yZ9VwkpUshegTktpDirOEfrSfjA75XBACg9FiK6Lcsh8cL8INJ3nD6G1MgYYI2GTmRluLW9uQW0w1IHGdt4z5J6PjQkNeEQylqUyTSLMQlwzgJmBEIk6V/xn4wbOH4qWd4h9hWCNpM/f+T1EWjVAJZAzwQbTvjg08Ss5Ilp17rDgqCZi8rInfOeI4Qk7i16a6O99tWrm6X7V7Ci3yDP8sMVc6UkqGxwwSu6tIpzRBH+tnZQbkZe1pXG6wDJ+BK4Sq2/IccIQJ29V4Xk2XToJ7sw8IwStQGWsOSEYZkQeWSRVcbeVv4NrcQBBw3fyUzEsmgoGoEFWl9MieA2laSg+hvjbM0d5cOalFKe+fJyYVYnEILtCUrpe7UdnWz+DtC6f0Z6iOuzV3wDn1AJcFNYY4dqaNY0iWEo7NbWFUIEaOqVcfjROw7N9ws5TUsN5Q/QlvIsomtrRE1fYQNSexRjW7Zls93L0Tj8MMsJkjNJo2GmswoO+u2DzH5/de+H/Vt635UKtjRaxG8Ki8zVq0FgNtVM1SYvIA2XZ6tOCpgceazKpUIcPAWUAO9YXNUaybInd3SLbUQxPrGbzijZ93NqrvK4m6SBi7CZAGuNagyzIzuHkSKl8gaQAqabINIxWvx16VqPBsEyxl3nL0oA/eugOq9kPnaBuh10Js1L3y1csa2BUTZRntXYxMGd0P3zC1Ob45q4qjuBuA159fgn8UgC/F9STQScrJVc+iGFR9fRaP1ww6wRP/f/UcDvoBFm5u5t0r2VPjxbfYyKyYzrbRUDzTeWps3MOzvm/EnmdVu5Udt/5DyPbeoHSrqjMfHT0suWhrCpFKg+ABJ3oZLX8yXyK1s
 YzApLVts
 Zkey42TVLB6G/befRzfDP8g8wGuoOU00pwaXgZk7QG4+W80JLzwuc5dCxgdEWoOLVyJ1seJ2qMl08mOnDL/KM46XF7G5+QWaIq/D7af4soWQ5Vt/ROQOg1WIWBsi2j81LLOm1YkNlX+6q66/NiMS2UiYYrQXY/+M2zPeg7jJYe1iW09r5GHuWNl/VUTQS+Hh+zgTqrvJCc0Jtqg02ytM/6VFrRf7PMKbksccj1YBD9Jxco9itOvhhGiDSXXcqQZS5ZWP//EYGhVqg0ed9SodHQMc6hqLHCUrdjnJmMp7JG4QVQLTcI3//QOAxRlk4QIlyMhwRuWDeozLXyZaZd1XrjbPgf7+fHV26JbFS5OkprpoQKQ1Pi1lALn/pFZQyKI5NdSp3zckexp+ChWubIS5oSjhxAQfZbfJ7qU3eLtlE5NepMrtZi7zS2+0cxhlG5LItt2NEkD7xZ+1tL+unXjSPkyatnPiA2p9mBYOHXGgig3h9sM5aKPj4W4ZujtCKLNyXViBFh2uQwtB/Bku4j0kT9n9HhCrJnB4rEwekpa6YK+FXtQRAm3+qnm0ahB4CQmqb+CqXJsQdEqHbaJl0d5kn3jTpuzGukHfybjjAiBZ6VrI5nQaVlP0nebkeb0zE4FBPTcEfrBTqz2eluIHwmGg8tIDawaxs4BJKFZnxxpYDlkA5kT7DNKUxnFb1TnPO6r1wRxfDP85LH7+ipqxqYKxLYLFn7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:50:02AM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 09:43, David Hildenbrand (Arm) wrote:
> > On 9/24/26 08:54, Lance Yang wrote:
> >>
> >> On Wed, Sep 23, 2026 at 10:00:37PM -0700, syzbot wrote:
> >>> Hello,
> >>>
> >>> syzbot found the following issue on:
> >>>
> >>> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
> >>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=17a44d25580000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=c181d3198e98f8aef8b9
> >>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >>> userspace arch: arm64
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a36515580000
> >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16dcf4c9580000
> >>
> >> Looking at the repro, emm ... the repro maps an O_RDONLY /dev/zero fd with
> >
> > Does this trigger upstream or only after Lorenzo's rework (not upstream yet IIRC)

It'd trigger with my make MAP_PRIVATE-/dev/zero true anon stuff too yes.

> >
> > 46827ac1ab221 mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
> > db7438ea23180 mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
> > 54e8e096ea86b mm: implement file_is_dev_zero() to uniquely identify /dev/zero
> > fb24843cfd9eb mm: move drivers/char/mem.c to mm/char-mem.c
> >
> > I assume it triggers upstream. Does it also trigger with lorenzo's changes?
> >
> >> MAP_SHARED | PROT_READ. do_mmap() clears VM_SHARED and VM_MAYWRITE, so
> >
> > Clearing VM_MAYWRITE for a private mapping is odd. Can you point me at the code
> > that clears both things?
> >
> > I assume we still have the file pointer, and as the file is read-only we remove
> > VM_MAYWRITE. But why are we removing MAP_SHARED? (where?)
>
> Looking at the code, it's the
>
> 	if (!(file->f_mode & FMODE_WRITE))
> 		vma_flags_clear(&vma_flags, VMA_MAYWRITE_BIT, VMA_SHARED_BIT);
>
> So we end up with VMA_MAYSHARE_BIT but without VMA_MAYWRITE_BIT and without
> VMA_SHARED_BIT.
>
> So it's by definition not a COW mapping. But it's marked anonymous and confuses
> the system :)

This is definitely a bug. And I added these asserts specifically to find
bugs like this with anon mappings:

	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma)); <-- fires
	if (vma_is_anonymous(vma))
		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address)); <-- would have fired

It's because mmap_zero_prepare() keys off VMA_SHARED_BIT when it should be
keying off the terribly-named VMA_MAYSHARE_BIT.

(VMA_MAYSHARE_BIT actually tells you if the mapping was mapped shared _in
the first place_ specifically because of this clearing of VMA_SHARED_BIT,
VMA_MAYWRITE_BIT.)

So it turns out forever a readonly /dev/zero shared mapping has quietly been
converted to yet another variant of a 'special' anonymous mapping that we
weren't even aware of.

And it's got an incorrect pgoff (but not anon pgoff now) as a result,
similar to the usual MAP_PRIVATE-/dev/zero case.

So the solution is simple, check for VMA_MAYSHARE_BIT in
mmap_zero_prepare(). The Fixes: will be in the sands of time.

I'll send a fix out.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

