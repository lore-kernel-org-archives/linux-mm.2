Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA27C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 02:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91086B0088; Thu, 24 Sep 2026 22:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42006B008A; Thu, 24 Sep 2026 22:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B656B008C; Thu, 24 Sep 2026 22:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9399D6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:58:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22791A0549
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:58:31 +0000 (UTC)
X-FDA: 85250776422.30.72963C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F7FF100003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:58:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f8ENF5YT;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790305108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8Sjam0r3CZIV8ohCOPZ6ijLXYirjUbaTrxgwPo1KBg=;
	b=BcqvSPtYkeHePLjaUDzO4mk0s1hYBEKCWh6xGyN3Q1w3QSsNuge3B2R1N1ymhzaXTP+UNB
	2Cmcx3X1r0uYSWZMOhmDNKzxJbA/GliZuXkrSkV0GJwsUdDYDFB/p4U1xD9J1BAajymhXx
	g9IzvsObuOJX0SMHQfXfkgiED4FHfx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790305108;
	b=DB+lkFIRY8l+PsdSyqMKcTx+AyW5ihGQNxn14t5yGkTvha2GlJlSNFuti3DizNwxMr/TUL
	GY+l6oZU1iaNuFE0mpiOss7FxRWygqVKEKymShGY5Cp/KrK5zTTPb4V7cT9dpxHgiItZMJ
	JPjIw2aSHW6dk0ySu4sLGr+0rFL+qjM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f8ENF5YT;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 896566022E;
	Fri, 25 Sep 2026 02:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13001F000FF;
	Fri, 25 Sep 2026 02:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790305107;
	bh=u8Sjam0r3CZIV8ohCOPZ6ijLXYirjUbaTrxgwPo1KBg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f8ENF5YTgmEl7FFmi6nS9oagjeDtOyokKn9tg+2X5LPvmvlyCXrpxIG80nFA5RkdO
	 oSIIQtK9EyjxAIOtvayKdZMeEpILT/EyGr117J2T+/rtGGk/XKg2sCA5w6PM1zcvGr
	 1ACB4S9Y8ecwk6hLGm+AErEFEl0Fx60up7GZHZGI=
Date: Thu, 24 Sep 2026 19:58:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-Id: <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
In-Reply-To: <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
	<9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F7FF100003
X-Stat-Signature: gbpbya95j5nw35hb3uxkun5ynqtzow1o
X-HE-Tag: 1790305108-915448
X-HE-Meta: U2FsdGVkX1+1IwXY5qGN5tFgdn84YmDHwAxP0StoPpZD2hyjoRQ2rNnYL3OKUclJUXMcGSxrKPoBGX+BTt5UIGnyFn8FCqQbmZce7c9v9is73KHe5tnLepqKE9/kJqU8628Etxr9c1EcMNeGT0abmsw63qG9AHYcnGrfhh/bxRMCZtFuOl//gA3AIf5ssuBYCS9nSj4BPdX9n7XA0SODv2hF+7zPo0/Jquxl4FFLaxmdx2ZYbGaghBi/rSftvNqRQpcbvxjrBoiGrqmi/Y7suDb+P0cMRv1KzggCRczBqlYmFGi34LYsjyBCjv78zm5b4xFi68aKzNctqqe2czNS00PfsuLG2Ly/WFBfwpei5XXbuBNr/QJa2SRABL6hjLBqP+MdsLemlfBj7ZrlyA5CY82nk+nVQ+uIj41kAUgT47pJwLHTCUnzUlb/FrwBLSfgPibWdU9JAR9lKYha0K4n6FQBzHrgQNZbBU4SwF1l4ItIYYiNikoSg4lPd5jFK7hL4aTSNt/47gqwdYdPJbzueiGcW6OXiuS8k2NHiFsBC7Yu3px5nZ24p3IC/X5VlbkzjTGufusEqeYfWPdqteVBSLEOAwt5mjWGlIbbylVXnsJ7qXiq0LOt3o2QCChmtmB8PbtzfUNUK6uAzDDqx5QzbEXerJjKlkgu9+old1WzJ/sVZyH7eipwpgGLjgiC06TRYqZSr4JfWnZmiC8rWYejSi1lOb4MO/NmtOYXUh161vr8H3sxOLoFWly1VJ9nZHqA+wSlg5DOBOcujca9FIru4aESUrdTeBp8Gpm86McY6Lx0hIKm2Q976LnceBbV+17274sg/uLrwb6fu72TapAQW2OH6b2rqFblzdwurGXbkjfNGUH7kApVkkwynnOvOuRzPb/wWo2teqLSh0KoO2SEW4Gw2iqIw/IK9a94skYRCrIlqOJP4D1bAN1K1X7XWvF4TNM4nkk7bsF7CR75lhz
 XcdjP+Bp
 9CDTzNUoYH+hvkCloJh5hgcj8eoly3f//4ckVU0XgdBKxh4Dr79w99btMzv31YPed+WpZPu6mRVzD4TEGDmUJNCDgu2g3G+mJntcmyegKfPb8fCv3UrNNUGpxhHE8Ne6DphL+nvTuRBBaw0LkaLu+nALXePj+yTueJfzVcTKGBbhtkRm6enTrGdvQHFVDMCl2NGtHF/nj67NzK9BQddC1Q5wUN5LWqKnHjjybuyOs9bn46eQmj/aGkSeJgQSKEyjGgQvJx2gtKjF+9wYeUs0I3ae71c5bTGjArOL/5Fwm9Dul/Yh0Xf4t6yZGS+2MpQKWRgGIC4uSUskd72en6j6E+2DDdk5eW2tqtrPa7QI0GoorYhinySX1InIHzAtkPjPFvftQFhonjtV2jd7u8Vm81kw3HKldjpsZhUtc96dcbdf0toHrfeyI9WGvJJDK1ywfORjuMcBsG1oWFks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 17:37:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 9/24/26 16:48, Lorenzo Stoakes (ARM) wrote:
> > Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> > MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> > non-NULL vma->vm_file).
> > 
>
> ...
>
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
> >  #ifndef CONFIG_MMU
> >  	return -ENOSYS;
> >  #endif
> > -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> > +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
> >  		return shmem_zero_setup_desc(desc);
> >  
> 
> So instead of shared zeropages we'd now get zero-filled shmem pages.

"zeropage".  Singular.  Used to be!

The accounting differences, possible changes in reclaim, memcg
charging, maybe swap behavior.  Switching to a different fault handler.
It's hard to foresee all the effects of this.

> The alternative would be to just convert it to a proper read-only COW mapping in
> mmap code:
> * Not clearing VM_MAYWRITE, but keeping VM_WRITE clear
> * Clearing VMA_SHARED and VMA_MAYSHARE
> 
> Sure, someone could then mprotect(PROT_WRITE that thing) or
> FOLL_FORCE|FOLL_WRITE to get anonymous memory. Just raising that as an alternative.

I dunno, the whole thing feels imprudent.  To alter such longstanding
core(ish) behavior.  And why?  Because a shiny new assertion said "hey,
that isn't quite right".  Wouldn't it be better to squish the warning
somehow and to set about this change in a very careful way?

