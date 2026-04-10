Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD34F44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E926B00E3; Fri, 10 Apr 2026 08:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFA46B00E4; Fri, 10 Apr 2026 08:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BA36B00E5; Fri, 10 Apr 2026 08:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A268F6B00E3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:24:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 527FB16048F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:24:29 +0000 (UTC)
X-FDA: 84642564258.20.A2C612D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93C5040005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:24:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKHcdKXE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823867; a=rsa-sha256;
	cv=none;
	b=UpciHfOhXc/fFFiC5z8guJrzehF63PaVOZWswqSo3qqi/A/k0lLzbx1pQPUk7cu8CF8n8q
	7zY4xVKH+ws4Zh2YjbTI0aX1TQbWeDSZjZ9eTVW+JmGiP85Cfakk+0e3WZQC/UOA+pE+rW
	5kQ7xeCS3ehzEtUuJLBG63P15Vy4v+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aj5XakvMrHZUrDyYKVsZg4rC5Dtcr4vUwdSNgZSmn+s=;
	b=vzZH9rMDVzQ2Kcx3tsUVAlmFCok+5kdhF3hswxnaSAYj1j4uQ74osMsYZmfn+L18IhBdbr
	oPCiGK8lDajz8FOJ65S5/fSGDgNiO/UtUKY7AtnyeLe0AxP5acR5VIhkA5zp2MfsKB33W1
	MiCGwoC88tmg6yQbAn5SEr1azzaToLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKHcdKXE;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3D916024D;
	Fri, 10 Apr 2026 12:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2810BC19421;
	Fri, 10 Apr 2026 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823866;
	bh=u3shdn/VhTUrysknc+IWeX13Mypw2Gqe8IMtP46BvmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YKHcdKXE2kz4m0NEBd5EKtByrIIew2xRPM9M6TUF00occZ4EyMKOt2YUdYVsHnCo0
	 fNSRX0fb0Hbd2twIm/dyttA2LN+TqLTdZ909pvkhZS8h7pGn7Yhva68ZtJqsZLZ/If
	 tdguzE3v/3GvKP5hHIRnkjjVac850Gdb2uNM2zbSio5tgjmijdEdz+01rtEvdJNKjY
	 QY9VKGe7uu/nk/E51BxqhEmmdYN1W/PvkHS3utdN+SbGU+hY3BJSyQa4VKOyVStKX+
	 7rhSZO2S67XO/uptDkC1XS9crG8eNVR7QT+21pAsNytGil3CdbYboU0ETriEW7gqau
	 PEplVxGXwpW0Q==
Date: Fri, 10 Apr 2026 13:24:16 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, leitao@debian.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Message-ID: <adjrKwgiZwXR9epk@lucifer>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
 <adjkCOiLgZ_-zovg@lucifer>
 <adjllNan2vgBNBHJ@lucifer>
 <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f99b289-629c-47c4-bef0-966d6678a2a8@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 93C5040005
X-Stat-Signature: mmqcrqe7kbkud33hcnrkqmt9uc7sx5er
X-HE-Tag: 1775823867-868743
X-HE-Meta: U2FsdGVkX1+agsn2V/J/tsQDedupkUGk0KCBf3ckkARpDbc5KKGPR8oLo0VkkD5G+vpkzkiNR4IAWGwb2ee/LaQRTcGBxGLqHtrmBCaDeT9Ici8uGAQaNEAEEmxN/lINIzEFW6JLa234/l9Dny5ESoI8hLDTvWanZjx2pelqE2nqGHecB1Yf0AzG5wzVMHpxoAUFXIeK6kQV2/+fo9uKRcXTOzmihqjB/5sZOg/11dQ1u6bwGndIPregW8RJPXZxNopJD8DWJctAAomXZp76Q/4K8uY4CUHSD2KGd2xm/4wuAAoPcB9TDwTFRcaOSdTYkZqjD1meYCaACdVYwKjAtX9aF6aLC4omkDBPgrsqJyWfR8xdkZM/n6REinUN3U7zllkQoPqTlefRUk4QbYzjIaTOJPfanA+ag1tBJaDG8GkmgP1MUlEK9qNdho1qyvCKe5XD7rFyjluMggwW1ulqrZueocm/KJ1KEafVBwxEUyyRF3fDZ2Vu3XyUObtFvowRp7YW6CuZNr3KagRdG+Ad6mXO123yrt8HRvNyrxsFzOmQAO5a3UubSmHAMwZ0K1MhFZSginOD771Uh5tsa6ToNNhqHlVhtYaZ1HJyBSkIW5H7OKNnifg58QnLKuJ8cv9c58MObm5gOCoSxQv13OmtJlEgPCoQn9cRFwId3cjnf92ql4vhsL8n2ng6k2FGA6vO01xDrDOkxbcNM/c54apaC6kIoG6GJwLHxi0ld9gGA/PYnqwXrdbWh7ZHgL+1nKX1l3M1VKOvRKAkYfW471NqbbN3oTB3ISSuwEGh/gwPskaLRNrzqSgW1iJBuKKxb5g9BuPyPB/JpLczmiMB7qHGnOfr9Mgr/h9HbfouYcQg6DhoSZi2HyrELkv83MTF4w5Ui+/QzUONGoDucKtpJjklDVzdCm4R6Pyo4JBSzNrUKrTtNd2Car0y89b41miLR/Ea9unhnqfGyjC44GLAnvV
 T68lb501
 w50C060YqV75dlhr4h0cYILmFCKS3SKSMk9pL0vk217AfTHi9znyNxRpnVU8Q5xh/0hS9S8V8/ao8QK56uE+kYA0Y9nd+y1BhLv3Rv1l013Kbiql8O+T/IbOLX0/v5LJfAAQUE6HP7bA8FOUI1nOug4A08rIhNH3w/Lcr596LpymoOhudIYyYuvWzJ5OotcbKRQ11fLTQBlxTvSANpO3mIsWPlMYJ/i3afn04qQT81ozmoxDoQS15Uv4M9Wpp40/lVT1s8XysyYFNbo6yKI0JmnrbLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 01:19:08PM +0100, Usama Arif wrote:
>
>
> On 10/04/2026 12:57, Lorenzo Stoakes wrote:
> > On Fri, Apr 10, 2026 at 12:55:42PM +0100, Lorenzo Stoakes wrote:
> >> On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
> >>>
> >>>
> >>> On 02/04/2026 19:08, Usama Arif wrote:
> >>>> v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
> >>>> - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
> >>>>   to HPAGE_PMD_SIZE limited to 2M (Rui)
> >>>> - Reviewed-by tags for patch 1 from Kiryl and Jan
> >>>> - Remove preferred_exec_order() (Jan)
> >>>> - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
> >>>>   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
> >>>>   do_sync_mmap_readahead().
> >>>> - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
> >>>>   page size for arm64.
> >>>> - remove bprm->file NULL check (Matthew)
> >>>> - Change filp to file (Matthew)
> >>>> - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
> >>>>
> >>>
> >>> Hello!
> >>>
> >>> Just wanted to check if there was any feedback/review on the latest
> >>> revision?
> >>
> >> It's -rc7, this is definitely something for next cycle :)
> >>
> >> On my part, my upstream bandwidth has drastically reduced, and review is
> >> probably going to have to be a hobbyist thing at least for now.
> >>
> >> Also, not to be mean but:
> >>
> >> $ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
> >> 21
> >>
> >> So... :)
> >>
> >> Review in mm is very lop-sided, let's try to balance it out a bit!
> >>
> >>>
> >>> Thanks!
> >>>
> >>
> >> Thanks, Lorenzo
> >
> > (Note that we're in a 'quiet period' from here until -rc1 of next cycle and
> > won't be taking anything new until then. We plan to do this from around rc5 or
> > rc6 of each cycle in future).
>
> Thanks! Just wanted to check, as I am always confused about this. Is it ok
> to send patches for review for next release at this time? So that they
> are in a good state when rc1 comes. I wanted to send PMD swap entries
> for review after I am finished testing, but I want them for review for
> next release.

I think different people have different views on that :)

I mean it's debateable whether having a glut of new material on day one of -rc1
is preferable to having a bunch come in that might or might not get lost along
the way :)

I personally feel it'd be better to send during the cycle window rather than
before but I suspect others disagree with that!

So from your point of view, feel free to do what you like, but maybe David +
others would want to chime in with their opinions?

Thanks, Lorenzo

