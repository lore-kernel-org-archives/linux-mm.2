Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 224A7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OViB9yQD
Received: by kanga.kvack.org (Postfix)
	id 2A7116B05B0; Wed, 11 Nov 2026 03:24:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256F16B05B5; Wed, 11 Nov 2026 03:24:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D8C6B05C3; Wed, 11 Nov 2026 03:24:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E629E6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:24:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7985AA0236
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:24:01 +0000 (UTC)
X-FDA: 85422150282.28.F4550A1
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8506620002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:23:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OViB9yQD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794385439;
	b=DFWUknU7g8BfbqKfiuH6lrzHwsfC/TAferCfsgKWVaxfsVuPMYhYfh62bzo/TyVKjnCPTO
	UwI8cSWxua7JtiB84Lu4bsHVeb5JuokkOQltEoBAlPKiUoMEA2+0kytgk7ZPoNuCJGOazY
	WUyt55qNLoOUBbS1b0YXh/7pwLmrdSE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794385439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1L3k0WCxEQM4MgkhzRov27MMiEEbLO/b0x9n2s0dbXg=;
	b=DdZTkAmHQpxMeSoazsFVC3kjKHhI2J4xJqBmXjg8hT5dmNtTJYlTDYn4+Yl96gP2B5ybWO
	/yQMgucgGbieQIKsc9TogvjkVBWajN8HIZ7nHYZLpC77GAf5UCGYX4FQXR1mVqK6hhaklo
	33HLArrxt1+oVX7FwbONx5pZm5ZsakY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OViB9yQD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2a1uCTTqQgMgnglTolQFYLYOCZnjaTu0ja8XTo4UI8w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794385438; v=1; x=1794990238;
 b=OViB9yQDa9oR9BNbWZeyfr0i3TkhY0DKdIYxCAoW85Fm+rVoc9rB9No28BBCRQiWouU4xRiM
 36rYEn55/N7f0iTRLAGRdkAmERJLijPRGmu+6vddtFGlwF/f1+KrNWyG9ni7L+crU72jgslvrwV
 dE5ru9su7q8WCPejFag+8/pc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 6852131fc591cc1f;
	Wed, 11 Nov 2026 08:23:58 +0000
X-Mizu-Trace-ID: 6852131fc591cc1f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 11 Nov 2026 16:23:48 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, baohua@kernel.org,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <avQmFB0IulJ8loYY@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
 <atJwMRHXzXc57qpu@KASONG-MC4>
 <avQW6uvW7iG9Tw_F@fedora>
 <CAMgjq7ANR-ex+qWWjV06b9rE6+0=RP42tzLq5F-M4yw8hb8Qsw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7ANR-ex+qWWjV06b9rE6+0=RP42tzLq5F-M4yw8hb8Qsw@mail.gmail.com>
X-Rspamd-Queue-Id: 8506620002
X-Rspamd-Server: rspam12
X-Stat-Signature: 7st8oot6m69s6rehx1f7imwgfnx5zz3s
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794385439-485653
X-HE-Meta: U2FsdGVkX19rJvaMHhDSPHt3q3oZWlLiGYVxKZ1CRGw8f9uSXlxtyRIHwLmOZ40iqsANZG33xYcgdqmaxzXFJ3OVSEitm9vL6L557r7luXEyWHkIz3gbheEl06zCPYxv8bmOZ/nK8AQhQK4teb7nHp35ZT4Oll1ielKMbdSEqDAy/13ASJcvMMH2CvZSmnAmGQA+HbuAMWo3/Wp9h70ZXnoj7BgpG6xfQHPNctF05TjIUWVUMdfL+ssJ/pSFsBCmTD2RtQpDJ4Q8cAShA5VWVfKkGQjstViMoJdKMlLXep+F/ipumjgnFdDG2+HXsSHA6z9ww6CJu0uW/c5m7Cz1bHiMtdyoh5Zfas5X9Z4zJVVHzZjjUPz4GjQCNxwQe4kF7J1jlxuMSocxf5oiot0NhxNUJ8IHWkuIwSDjCX32CzoCvBSMypzL8ozvv4p3oqAFzCnC8QunEWmyhxUh9bBdEp97APFwYU5KfsRBZeqgWjI+xnD1enkRHikIF8WbGVQdUlexjg5KtmmNP6hOQjIiNWwoMySmvqnrVmlS1Y8TknAKGC1vKnzeoIODrcskIP0IxgVqjYPn1iZFt8p6HN1NJ86GZxb+YN2/hsG16/d+CZGUy/oy9BsRfCyoqp9DzNoTQDe3UEg0DzdbhluwA4beZcf9MrP2KJ/uDaozbe/btM7tAwuOLCcK3qa10IkgaP7KnGYu95HsiIm7sUssaOEuJIiZypaFdl4yBD9JGeuB8BX6i5TgcNZxVN2RKdcmagFYEyyjdEWZurabIj+nAyDwn6FvtIPWHbT1BuHfXPiwuN6rHUZtYTi5rFLM06e5xrrB0izNYibRnolKmuZI9ANirKpykiT2X1tjqrC8vSCoFDAL3CpYWSGXvxeB/wtgt8tvCA4CCEpbS7a5vgsx0cBjb/mnPMnPNMOWsVWEOvMPFVLed1oKh+tvMtK7dtKE+UHalQV/VkTO1mApvPH48Eh
 MxNXDyGQ
 J3f/5OPus5YccqktUbgMhHQU7xNbxzYYYeIW77Cl9fB4xiruGVNqxcL078Zl0eZsl8FUxBktuyMEBL+SETexR+AqAAEDxCXFSqmiOtMlDvvzwuNREvBooHT5nXv4yRvtes88FPnNdiv/IIw/5U1dz2nYG61r53TlRLh/9+2fb6721/nIPidYnrEB6SKqY8qH9lLwZLjRWy3nylVidVUPDqwuHKU60JHISUKhH5+3vxXKtUPXQceWITgZQRySVq6pknkHELCUlwy40hY0wW0Cs9xt5eIyU3aORgzSV/0CPa7Md1CXiY1Xhrw4BD3AVgdxtss5xY1NtTMgb/fZZbEwebE/UdEjmVa11vkGTGX0L8jZVzJzZZeoCbO1QeZ+LoNCgpd+c6EYb22XawmDKCvllZIo7Ix+O+XXSyoJWv+VV64oi4Pvk/XggvL4f9/sJvMJL9QmuE9H8umTgQXSjebADbPuPsMywRq9OJJy/9EbmhjwMKDW+Fb+vjn70ZGiNt9ntBnm2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 at 03:38pm, Kairui Song wrote:
> On Wed, Nov 11, 2026 at 3:19 PM Baoquan He <baoquan.he@linux.dev> wrote:
...snip...
> > > I think we can drop the PUD ptr walk entirely. The filter only
> > > needs a stable identity for the range walk_pud_range() is iterating,
> > > and (mm, PUD-aligned address) gives that on both sides:
> > >
> > >    walk_pud_range(), test and update alike:
> > >       (void *)((unsigned long)args->mm ^ (addr & PUD_MASK))
> > >
> > >    lru_gen_look_around():
> > >       (void *)((unsigned long)vma->vm_mm ^ (pvmw->address & PUD_MASK))
> > >
> > > Will this work? Also I took a look at the hash algorithm of this too:
> >
> > Sorry, missed this mail too, thanks for great suggestion.
> >
> > Yeah, it's a much better way to do pud level filtering. I will
> > switch to it in v3.
> 
> Great, we should have a super fast O(1) key calculation then.
> 
> > And the same idea on PMD has been merged, your suggestion is earlier
> > than it.
> > 65a9bf08a3e4 mm/mglru: don't use stack pointers when walking PUD and PMD tables
> 
> Not sure if I understand this wrongly, but 65a9bf08a3e4 is fixing a
> potential stale stack value, not changing how PMD keys are calculated?

Ah, my bad. It indeed doesn't change how PMD keys are calculated, I
thought about it wrongly on whether pmd key can be calculated the the
similar way as pud. Seems the answer is not worthing.


