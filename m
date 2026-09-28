Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6226CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40266B0095; Mon, 28 Sep 2026 11:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16F96B0096; Mon, 28 Sep 2026 11:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DDC6B0098; Mon, 28 Sep 2026 11:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6A236B0095
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:08:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C92DC024B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:08:36 +0000 (UTC)
X-FDA: 85263502632.23.D539098
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65BBA160010
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:08:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKxoin8P;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6DwsvvgsaDQmnbhantbUxZ9adg5ZslBN1QuZ3zF8q0=;
	b=nm8z8ryu+dHGw/oDu9mkV4QbOwy7nYLS4b7BDZNA5MseiPJzeNLK0RxYBPTtOEGBs3yWXv
	pIaO184ulODPJF3FyjSuyh5SRMUqNYGuGNoAzQbBUv5n8C9wOiWzOVL8l3l0xIK0HXrsqQ
	+ymDq02Q0BXLvX30QKRGaXA1RdGuZWY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKxoin8P;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608114;
	b=jfpcwmtmSWYbPFYCJn/GRSbO22YxX41cCGiNxLzCTDjAwNnxZwkEUJUu9XjgZ4T016XEp3
	Sjh90W48f+RYKxLhkIUq+fUsi0/cdAdI9/mVVj2Lwets1JPFEOxkZ6NKmUJrc+llVkAAKp
	0MILJA83yaALgIeZRm70d0h04PE7zVM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D26D405FA;
	Mon, 28 Sep 2026 15:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C0F1F000FF;
	Mon, 28 Sep 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790608113;
	bh=e6DwsvvgsaDQmnbhantbUxZ9adg5ZslBN1QuZ3zF8q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKxoin8PPODyfh/+t1dEKhIOvPYbQUuxM1+0JjWv2KdshkWycY0WkfIGE20B85m+q
	 m/+RCaPAa7v36i3if+Tky1ISXuAlTL0/iDIhY9dTvF5ZhyUBr0AmenYNYv2J5h2BVJ
	 hp7Rz9HSD87ksYOCrN5t0/a2qxOs+d9d1TAPerSzvQpsK4OEO/Qm1HfObwjIeqQVPp
	 JrVeF/gLebjqaRCqLskIyRNBI/nuZx8dECkpWS5Wuq+uSnWxokDaOMOh+m6OyU75tQ
	 SC3ZU3ZYvNfK7nsE0daX1ha4pxP0QUK8ne6ezf3s/2iDVSktSN8G1nFhkxdMYv3Poj
	 heP+1IyR+gWuA==
Date: Mon, 28 Sep 2026 16:08:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>, syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-ID: <arqC3n_o-Xdu3xYO@gremlin>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
 <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
 <95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org>
 <arYnXJHW-Rh4eNzt@gremlin>
 <f78d2f52-1135-425c-a3e8-460a6e80e19b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f78d2f52-1135-425c-a3e8-460a6e80e19b@kernel.org>
X-Stat-Signature: azund6c71787uy9y5j7p1sn13s5tcn9x
X-Rspamd-Queue-Id: 65BBA160010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790608114-516233
X-HE-Meta: U2FsdGVkX18PPIsI9pKsiEa7zGESflFYItl4NdhVW2vFdA1DeXHt2GsbDbtPViIbs5fTomIFXFwaspN//yEH7JSs9BX8QADFLnAC8MPXVAUraQuYx78ka+iCp295n7G8i/mDy/of7WP9rZDoi3ELzBlbPvucuPnNps9Tt8LIgWETlKR174lr9dbhznizOxVHuccOYtKwnYgG3pSFoXYfU3jn9o5p7qaunC8aUFEzfANnXKEgbeTWltWEEcbDIlI5JUhRO98c1qAH2QnRAvJYnzxp6jE5Pg3ikpa8IoQgwsVdUFTB0TuuaPn+tFBKKnDGpF6U+T2Sz5WvnQGk18esEC+z/PSXPVUSztM/qzyTC3cN8f8Y+aC//PUkd6x4xiOdgkLpLcXjZBab34Mq4/Lkc/ylYJputjwpwXFpIugnY5feFVGGkJwLyffZ7XiXE0T14+W5B8I4L2Ybjy5ZpIJHd+KIjfnYyzwpZNeMsjnvl6rlONC0EalqHFKSQ0Z+Odqa2DOHC3wRiMF7tNpj6+Q6dND73dbkx3jNWQdWKf6UoUdZ61LwB14GgnFyAVtD5YOP4yFupP5jZpXvNpuIWC4ky8y5HrAEoKKSlIsTjjciDLJFbwe098aKWAH9J9OrDtXpfc3xkamrjA/D+jY6T/VilsnTBAhd3ujkmw8Cg5r1HXSHdc5wOyoAkarSoANL+7ZkNAJDCQUGMUgZ5kjBOChel2cm5lhUirS/ojC0tSAiqjpY4mZmnmAphCJKeoXubQ5eIuFtFhFKXEtt32H4A9L5nqYx4XT/FR0XTwFm3Oib+Y7+A3dznG/MjF0+6PhnejjM3ZXplU+GCy60O/IfRlMxDxz0AjIUABl42L5WcoJwq5qBiWC4VZffy8ExPKcGGQSLt1N+6NvhR7BISg70aCMztzRuTCMD+a7qcRNX4HligniFDWoZspKdTy0wByjnjXxmrkSEv0EcX0UHQYZmUZW
 YI7euopZ
 Ul/FNIOjsR9pzK2r7hY7nfErbXQFEubNK4Y+1y8A7NFLCGWWxMkiEOvkBTPaWmUim6eBp+51sznQ685OytnNmyGiHixQXE+FI+rjMPgD7s4DxZ2ZRWLgTLYbO2/qxhSAkUOFg6AYGWUeYiZjrOwlAT5jCUnvXaDNH1ZgeoL3hgpOxcP5+/fgh6G7xRADnquU89aNcLQxGeskJrDRPrEUkK7SsUXcsgDSLJCyQXR0EkqBbdDBYbYAEZeXFCNGlkPsM+w+tzJTyO3jK0vRY4Gr+Sk8w0Gc98WYHenbAEcDupmycseNo28QPWDG2NO1tXPeh2QWrhGbAgpyVbb1HGBi/AGauhTavPVbVXNKJJH9pc+FsM8fhppknjnVexAqOmT11LH28DW9fCtxTlWxmq8+lEjUNrAwkiwxtw/+nmRhjztfc9PAghH1Hy/QCcl0B8SOH6j/3ZIXUyAIlshQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 01:59:47PM +0200, David Hildenbrand (Arm) wrote:
>
> >
> > It then becomes a question about how to get readonly memory.
> >
> >>
> >> We can
> >>
> >> a) Disallow allocating an anon_vma and fail gracefully. So only a shared
> >>    zeropage could ever get mapped there. Might break the s390x
> >>    mm_forbids_zeropage(). But given that's only used in hypervisors like QEMU,
> >>    unlikely.
> >
> > Something like:
> >
> > 	/* about to maybe prep anon_vma */
> >
> > 	if (!vma_cow_mapping(vma) && vma_test(vma, VMA_MAYSHARE_BIT)) {
> > 		/* don't prep anon give zero page */
> > 	}
> >
> > ?
>
> Something like that, but really just failing directly from anon-vma preparation
> in a !vma_cow_mapping(vma), maybe using a special error code.
>
> But the less we have to hack around this special case, the better.
>
> >
> > I think though it's surely the only case (I hope!) where you can possibly be
> > both anon (as in missing vm_ops) and !CoW? I hope? :)
> >
> > So it feels better to fix it at the source.
> >
> > OTOH maybe it's worth special-casing so we don't allocate on read.
> >
> > But that brings me to c)...
> >
> >
> >>
> >> b) Do what Lorenzo proposes. This will allocate real memory. Someone decided to
> >>    use MAP_SHARED, for unknown reasons, so I'd assume it's unlikely that
> >>    something breaks, but you have a point.
> >
> > I would say this patch is the right fix for the moment to fix the assert, and we
> > can chase up with other approaches afterwards.
>
> It will get backported, so we better be careful.
>
> IIUC, the real change is only for /dev/zero users that
>
> fd = open("/dev/zero", O_RDONLY);
> mmap(fd, MAP_SHARED, PROT_READ);
>
> Which is rather something odd to do indeed.
>
> Letting AI do some digging ... it says there are not known users (I don't trust
> it, but I suspect at least there are no prominent users, which makes sense ...).
>
>
> Getting shared memory when requesting MAP_SHARED does sound like the right thing
> to do ...
>
> So let's try this:
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

Yeah let's revisit this one later more broadly.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

