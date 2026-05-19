Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FCDCD5BA4
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A5B6B0092; Tue, 19 May 2026 08:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8116F6B0093; Tue, 19 May 2026 08:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F426B0095; Tue, 19 May 2026 08:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 645C66B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:46:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E417F40317
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:45:59 +0000 (UTC)
X-FDA: 84784141638.22.B194237
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AA7C1C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:45:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FfLpklXM;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779194758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tEY/ViETcYWqMbew+LgZ2oRYOW85rqGc3tYxA7i0ak=;
	b=YSnVuL3Gc0Dh3TtUVS6yPWMn/jNFI+1SibK79mNNKtAFgL/wBkgvkiK6In2Y+u5RvtN/xN
	PWqncaSwC8VWGQsFVFALInVI38OrHDR2dLj1HIU0LfE8RaDyp+Q/OaVuxS/rzlpxWLN2xS
	/Gfd7yo5reS6bFV30X6202afBRSUJlo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FfLpklXM;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779194758; a=rsa-sha256;
	cv=none;
	b=Gv12JsBXrcZZuk6NTQ808qXkRnpZr20S1NSbTGPq3jSl4NVLnNVYbHkF71PNVP48LEC3Xe
	aWf9QqnLxP+F6JILVDZXM83BWO3ZdKoET/9i+W+EDvDy9t13QTH899SM1+edaaOrj2LYiU
	RZZPBKj8a//I9UpQhHPhAd6Zlkl1mXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 070F240267;
	Tue, 19 May 2026 12:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B010C2BCB8;
	Tue, 19 May 2026 12:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779194756;
	bh=0tEY/ViETcYWqMbew+LgZ2oRYOW85rqGc3tYxA7i0ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FfLpklXMkKT1W9LjHbc6orFesNSR/WYbThmN3RY3KQ+Sj526oZ9knAqWz1hOSb2V8
	 dNS1B12b6zt9T5UOXQ1nrMbNWtECIR2msv6pUBdn/ZjxEPvXzm8/CRvLKqnqCU51sq
	 haxA77qodnAWypw1XScQZfjJLKwh9FciR3mqwcEzxbVxwnrLWlqLfHqEPk5J3o8Cmy
	 0Wlh1tz1PaNb1cIMkhcRqDoftNLeYh74seeYdw4fbd1+VoscIEyfDFSquLrWTQHUK9
	 L8E52Y782Q8/1j6v9de5qhI08YuU7rlNh8jgJpwnmYyrNumFGmR+cEYpT6UhTkfXca
	 +brOZETnCxkNA==
Date: Tue, 19 May 2026 13:45:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxbJHfa6J2UAtSf@lucifer>
References: <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0AA7C1C0007
X-Rspam-User: 
X-Stat-Signature: gqwphqfkd7n7wd5f7x5nruixoyojqmwf
X-HE-Tag: 1779194757-415434
X-HE-Meta: U2FsdGVkX19mwxRWPKC1G6BAWeq3nmtxySLAhBsggM91LjNYA3+NDtNCkiClZ2/tYeqXo6m8M/zKigg59vJxC3D22p/dkV9xduwMO/3I7Wp1Rs0sUHKb8snhUxvFCv5IWrr7Vs+XPOir3ioRFzNbxE2RKcxFuVM94c2ymJcP8PwYJUqZ7xFIt7aGIOnxhTz0U68lFIE0eTmYkhMRAVYGLZlS49BnKDe2Oz6fDQlN12d6o7pS4cWrZjeFyasIvxTv8VeTv55cYgbPzoy2oCILBsHO3aNHFZnt133ECMlG/OfK7U95NbfIw9EN9m8+U6FuE6/A6kgMpn+1m6ERNN+4ZW5kaJN+om3Uaxe3fBStJTrIIlPPVO7a++m52lg/jO+bQOE3UoCJyD3DWDgh73rnkxK462aYop+LnbFZcx+lT72VtQCOEt9zk5aBgjWc7KHwl2Tt+7dZRIj66oDNNtwDo3SF43NHMY4X83hvMgDMEZnDxePZRIrwxK1iQG1CvOp9GQ6wXTLvQj0LmoQx7TqH+pgUXCWPabs8zhXvUKEiBJ2W3FYHE3W7MKqOnGuLxxfbvGhIIpxor1JhtwHyNvPMc7203ue7Aq0qMBj4jSTDvottG2mRHXHv9AO3Pmkh0rM9tsVqupRqpIZ1KqlbZq8GKre4/xZY8hmJMDckintfQR1sBxBmTkkKYwKUsZhqeIW4I7bdvuYSg9u2h9B3VKS052th0RrBGiIBNW+yy6CyvKwNlS3v5qFSPvjgvmoQrOGw4joUh8RLu/N/TuFEm/6r6xV3dCXDa+JgP4rp79ELv8rSmNClj+CwBJh5Lb+SMZVQqHFDX1DbsCCzZDr3O+zcxn4N/4nZY78SPC/bSFUOB5kw8zb8KU2u7IZi0MYFH9i6m1I7pfSm3fu/1NHrsT3bai6gMXq6ItIlsrbIU9Zf4iCXwgRXWdMlOwzQrWF8FS1EiCy1Bsmp9BG5iJRtO9g
 dbSlPk4w
 pp53Nj2use4rSjWs7Qa3uxs8H/cglYHygw9UYVc4vkNPea6XSC85rKsM/vbb+toshZ3HrStjMRduIihN/CGrGIXqvFIoYt1SdA7bbhnW43O3ake4GlZTvANthKmEQnWpf7ZVColIdvVNGjGEjBw2PlO6h5zkW8Uitt3uJYuNQIxNsu1q1y/dddOBtsjYH5HuGFbwGrtlMy19fGJLgo46N2CqHCRVDlCHxk70dqyVkt7HDrY3/9itwLqH7EAcvE2U/VabrUwI2UF7FiM+42xL9sIuMOCI12JjI78wBkdEqpfAxEFftxVkDtYoGnk0ry1R5EfAoXQ9iYYNSgZqt/yFn+xSU4ovlAGUto/W8f3uLQHmuxmCgNwrJi70owAkRiOW/jUWMEpF0clJbkDUaTh7LVU4vdAsyRhwrpAfpSoVZACq4rzzwvUdfsltW0qC+PBsmczeo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 05:14:45AM +0800, Barry Song wrote:
> On Tue, May 19, 2026 at 3:57 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Mon, May 18, 2026 at 4:26 AM Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Mon, May 18, 2026 at 5:47 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > >
> > > > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
> [...]
> > >
> > > I think we either need to fix `fork()`, or keep the current
> > > behavior of dropping the VMA lock before performing I/O.
> >
> > I see. So, this problem arises from the fact that we are changing the
> > pagefaults requiring I/O operation to hold VMA lock...
> > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > any VMA modification. On the surface, that looks ok to me but I might
> > be missing some corner cases. If nobody sees any obvious issues, I
> > think it's worth a try.
> >
>
> Thanks. Besides the creation of processes via fork(), I
> am also beginning to worry about the death of processes.
>
> One thing that came to my mind this morning
> is that when lowmemorykiller decides to kill an app, we

What's the lowmemorykiller? :P you mean the OOM killer?

> want the memory to be released as quickly as possible so
> the new app or user scenario can get memory sooner.
>
> In that case, if the app being killed is performing I/O
> while holding the VMA lock, the unmapping procedure
> could end up being blocked as well.
>
> If we release the VMA lock as we currently do, we allow
> process exit to proceed.
>
> I haven't thought it through very clearly yet, and I
> may be wrong. I'd like to do more investigation. I hope
> the apps being killed stay very still, but who knows—we
> have so many applications in the market.

Yeah let's tread very carefully please, you're picking two of the most fraught
areas of mm, I'm not going to want to see changes there unless they're
substantially more convincingly argued.

>
> Meanwhile, if you have any comments regarding the death
> of processes, they would be very welcome.

As above, leave it alone please :)

>
> Best Regards
> Barry

Thanks, Lorenzo

