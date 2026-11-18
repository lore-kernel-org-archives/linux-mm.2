Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210C3606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=crosse.dev header.i=@crosse.dev header.a=rsa-sha256 header.s=google header.b=i6hCBJtr
Received: by kanga.kvack.org (Postfix)
	id 0DD706B05F4; Wed, 18 Nov 2026 18:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E686B065A; Wed, 18 Nov 2026 18:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98E06B065B; Wed, 18 Nov 2026 18:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3B2E6B05F4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:59:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 330ADA86CF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:59:31 +0000 (UTC)
X-FDA: 85449909342.14.0409790
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 375A720008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:59:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=crosse.dev header.s=google header.b=i6hCBJtr;
	dmarc=pass (policy=none) header.from=crosse.dev;
	spf=pass (imf13.hostedemail.com: domain of harrison@crosse.dev designates 209.85.167.53 as permitted sender) smtp.mailfrom=harrison@crosse.dev;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795046369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6R/PYV+nSxp1UtaMco+VKM8S4ufxpCmVV0RFQLraMg=;
	b=A9hx0QEHFMzaklQjONlildF/1aEGOXGOtbMdp8wjZbkkHoRkOqL1a6ZzFbA4/MNTxuuwa8
	Jx7Xa/v2NaME58cleGIfc4kKbvZVTVZD9ROgSmVihSkQyss5yJNgeG1s55MhOGiXOcaN4R
	E9vZkujWPKiBoG7Ild/hvJje4oDhXns=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=crosse.dev header.s=google header.b=i6hCBJtr;
	dmarc=pass (policy=none) header.from=crosse.dev;
	spf=pass (imf13.hostedemail.com: domain of harrison@crosse.dev designates 209.85.167.53 as permitted sender) smtp.mailfrom=harrison@crosse.dev;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795046369;
	b=p6Z5JdZhHQ09CiODKCnCHEudM2akD/i6Gfh3TSZ6fRLZgUZW21EQXj9toyfLSEZYozSsK/
	NjOBsPKorQinhkyV0Y0bNQRRi8K8gl3jVqO2/oXl6Z6/wa38W49FgJBxDSSU7pWyYDan+G
	AFPoDGtD1qNpSpV6f4Ko1SMG5XfmJPo=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be47aa555cso1910939e87.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:59:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795046367; cv=none;
        d=google.com; s=arc-20260327;
        b=KjatFw3uTIkhcfUhaa/FAbBIIxc6hS+T/ttfazdc4VwBMZ9eiKpYwjXHMyyiYOYQ5L
         W7wsJnFcQ3tRXmznptkm2z3hX4haRt2D8O9UzQXQ77LpK6XAz9R6q6K8ftkdvGJWwujS
         WS1zRa6tz1TzEVO0vuFoDpI8rGjVs5yUwDWZNRvWmuRNud9Qspvl519iWKjhAfX4yiX5
         W4/+kiEzGLCLmzpbeHz2V6Rf+e2WYhtAHYqX9OSHZYHWQuVyQg83CQZGWwibSwkVPrPY
         gvhvDCrSbqnTZEaP0VyMMqpz8iP4ckah05SxpFhNZkuYh5Cok9wFXvfNLc6OcfkL584d
         GTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T6R/PYV+nSxp1UtaMco+VKM8S4ufxpCmVV0RFQLraMg=;
        fh=pmXmy2rh2ZXmcByXzJ/4hL0pgDsRxOARZzCBbcH8zoM=;
        b=MU7sIIiNj+7t4BK/SKeX0p08Kzbvc13MVgFD4F1QAz9OAQ5Y8pIU690pNyIQtw6ZaQ
         29wOVGt93eOQIJMvrCL4AtRg9RrJz17F1oJOylNg+W/Eq0dyBYOrUMsW/4XiQiaVUFNi
         w6JOZzAiUTix8/SnMMOJ77y76/JEWwlGo+Tg/ZMNU51njdTG50YDvhqmvvRZdlY1Go/C
         I3ZPdQpFp/VATufGh/rQ9LaZQfgXzy31n8iiHP7Irv6F/A3yRnCqAvezwxFoS4mVhQpH
         moB+ihkwV3D/8nMssRIJDNX5xQP16aAnqPtPBnzGHZFt3jOsTEtjMpJRtmQu69dovZVR
         yxSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crosse.dev; s=google; t=1795046367; x=1795651167; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T6R/PYV+nSxp1UtaMco+VKM8S4ufxpCmVV0RFQLraMg=;
        b=i6hCBJtr5MFWTyVTY0OFJK0lHjfV8ZttKkCAS3UF4TaxajI/78+rQDA5cWRUaWhx8/
         aNHHIfoqoEhqdljhT+cG2sUcB/d9E66KdaghvQn8odNH5WEhUPfL1FD6H8mg8bHka89o
         N6Fg79wvP3trkP4mE/FuSTfjS6hQ5ZYin+p3G3iMPgD5L/dcQ78VL3r/oJhuNjwa04oh
         C4NyrpGPoqQxCepPzhK/ZvdoEZvpNfqMfDvKiDClCMkAa5suyKf1zpQI9ndA2qL/Y3OO
         I38muW88rD+g1bta4pafNbR59bByP4jCGEV7WGdYrcFudK94klQ3EPjkLEvHLIZrxX6B
         Rznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795046367; x=1795651167;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T6R/PYV+nSxp1UtaMco+VKM8S4ufxpCmVV0RFQLraMg=;
        b=Ni3PSKKlx3unVvfABLcqnqicD5UQfj4a4/oOobZ+Zfwf0AOX+4aN9cv/0AwgpDPKnU
         mim5WBK3gmyT24+8DpFu1bCB1UJ3lN4PQM520mtXRkZzTqHVp1evjT32CqvqakPrfB+y
         c0Ok9mCPmuhpb3IXL77erPvMDWCLV8og241sfkXE/Qklal1aJctOHgjzBLM4VpqoCqdd
         JFB8CPMbwEu1ym7DinjP7OQSDvzZ9ZrGsZcQB5N+7BBZfpLWZJ3BAUZE8PKtcnATJgsU
         CGns+FNYkzbetkHSwHkKYD4xRveulb4LdRJNbk77nsPU0TnQ3B3+u3GDx/vbbsI8pX1g
         SWdA==
X-Forwarded-Encrypted: i=1; AL+hErEVQrrygqc58JuKnEf/Dg3Zkk7jsHmDC5XY4jY8ZpLTnMCqAlbBglYwScZXgrgziO/gLE1v+3tUMQ==@kvack.org
X-Gm-Message-State: APuU4Z/xg5VOwtL29/U7bmJpWP8DgUlaAaCMVIisJvd8VWQc0pE++cz+
	V2j9fPABNA5BqeVO9OO/loQ+ZNSr/k+saVx+Kl2IZ9UaizUXNZRWC2toVKstkhPAdZJ3Sagq8fx
	y0U2RsplR4lxKxAyec37M8kjWOeqfaHRuysRRbdfyJg==
X-Gm-Gg: AYBFou1psEojRFunkSidYyuU7G6QQka+ZNui8yza1ZZkbr7/DZDJZVzfAeTQQphTdHr
	FTopACkCdQ3nhLH8/mEZ77ambOLkEnr5uDk532dVnu8RJnsXk4QUYznkOh3QyBhuBxoJEGpfCil
	s9jZ5uSSi/94m6Acu3YBtjGyD9U7/0Pp7InTp86ndh2/01xakmlRCGroKj0YNyEYTq873niJyN4
	aJFabMWchF2joAUn2YpN1EreK0NHEAVS5xRo8hZeCJYpSLz7e6zXQlkmjoOPTpOhM+LkxK5+gWG
	yclF700hvklhFlf2y51lGFvTAZGJg2Y0BNFag6RsSS6zzoFY91MjGSJuyKUQPcHDA7m97qGx4A5
	7ENqVwZ69CtXQ5XSoB7UGaHC+izR22a7HpezE
X-Received: by 2002:a05:6512:10d1:b0:5b8:f81b:dfea with SMTP id
 2adb3069b0e04-5c1aa2ce5d9mr1273317e87.62.1795046367239; Wed, 18 Nov 2026
 15:59:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261118-mmpop-populate-v1-0-9c561d178d11@crosse.dev>
 <20261118-mmpop-populate-v1-1-9c561d178d11@crosse.dev> <e32482de-295a-4e26-b6ae-5b8b58f8b98c@kernel.org>
In-Reply-To: <e32482de-295a-4e26-b6ae-5b8b58f8b98c@kernel.org>
From: Harrison Crosse <harrison@crosse.dev>
Date: Wed, 18 Nov 2026 18:59:16 -0500
X-Gm-Features: AclHuK_1VAQDAg1dH3obLDVFJKWckiVyn_K5qUH1FINUpBm1FFDjoVLIC7OItpA
Message-ID: <CAAFYBzy=Rf+gtYBkHfR9MpmakDrZBpOEfk-rLxUtRo7RfiFy+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/gup: make mlock() and MAP_POPULATE handle
 VM_FAULT_RETRY properly
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 375A720008
X-Stat-Signature: 5oqfukeoccxwuzen1pw5ang1x4z7s8b4
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795046369-206867
X-HE-Meta: U2FsdGVkX18eYxX/3h94OvHzPDhLAVwoB/8FoOAV9GJiMQDQM5ZNjZE9rb4L9fzEniHeICIxGbM43tuovjFBl9xHBCpdrkjZTuC0C2uVbhQew9YIYGrvjwMsdVvCdR5RLCzR3bfYeRBxFvh2Acvgb/JcdQ0YtzgSV7YcozgBQrps1ECXf0uOkbMn9G9CECATcMkiYl7ubVDBwXWeb5BgBpM2Ss7hz9YZlXSpMktlkUuEf3VyB+9DZ058liaVHFSx5y9XTob0T3yCyhFYzpDDaihzAJoP2HpqzKhBN3H6FmIcMgKAjQ705jnBxFogwcHSrEtjsem+L/xgwnBVUWrolWIXJ+y191gJcjoL2lqdZEIdpOVkDZflLStUDqqGeY9bKBkefXg3S4C4J+HdTgr4aEsbG0vqO1OX6HOl8zb7FNZrZSktHMBn/YiAe24nJR+ah8qsHR39/IAZmpeJhbpBdYn6gJeMFfLNt+ghbkx44B19U9cJbhEQ00x2TeAJ6ILmBJca9kLRyL8uIRn4hxn3Ym9IVDN6+Jv84mejYE1yvocXw0ry+oTDJknqoC/W7WJ0C5jX2v2cCZMVzO8LPQL5Ya+x6roLWXdfTWrWedVSAU5OPWIVi21v5XGmlPN0fMwQpW0UGjM5vAArCAHDjqevyjsHqEFHYVpMNbwjwaVl1M3PUYUSNJZF4iMb4+UpcsAapB9bzWYa3bTpMp/NnDk1dKG24Ow3ofRCsSXc9aHpBIiSKzfjduOKTOwkczHFugILYt30xRcepbxSkKjQ24hlXdrDeA/zQChaVuEigH1ukjcw2HaSkzPOb1ufrEvwV6ZEy3PERQPeve37F8xlzEF31t3A/SS2vvU1OtE01QoyjsJRjZDCPmVs8ykVujpiT/VCsWN6DenbeZr8z2iei2aPpNMx1dQ7oqBn5P8FU8Agl6c2EETYtaOFg43WcIVWvdbchp/Fu6BCQVPlqwFn79/
 y295MIl5
 hAa+RTPTGs4WKdqsXz5hcVz7Gt+ug/hVedhEGulTwu6oSukpeJXZ/pakLbEnUxZShmzzYI1inD84MMRgx/raaZSBuOeVc7RALbAW8N0Y62+zg6+eFRx91bRvKnWWqOfdlfeFYk2IFhPlksBQMKgNs/kqtD/bcTiRw3Nfk/HL2egS3cjh/xKwgZxXxms/nVJt3whqNpEdeTK4YgtdLUHJ70VmweuFVMXN3Je2htFnLiWiDzTwvY0qaiePRXIShzE73r2uQ0CUpy16dyR0BzsgsMFRSqSkLfdQq4rEeNFHn8RjniToORIWb8+axJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Let me take care of this (or find someone more familiar with that code
> that can help).

Thanks for taking this over David!

Harrison

On Wed, Nov 18, 2026 at 6:25=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/18/26 22:56, Harrison Crosse via B4 Relay wrote:
> > From: Harrison Crosse <harrison@crosse.dev>
> >
> > If every read of a page of a file mapping fails, mmap(MAP_POPULATE)
> > and mlock() of that mapping do not return: the task spins in
> > __mm_populate(), submitting a new read of the page on each iteration,
> > until it gets a fatal signal. Touching the same page gets SIGBUS, and
> > madvise(MADV_POPULATE_READ) fails with -EFAULT.
> >
> > The first fault on the page reaches filemap_fault() with
> > FAULT_FLAG_ALLOW_RETRY and without FAULT_FLAG_TRIED. filemap_fault()
> > releases the mmap_lock to read the page and, because it released the
> > lock, returns VM_FAULT_RETRY before it looks at the result of the read.
> > It cannot report the error then: a fault that has released the lock
> > returns VM_FAULT_RETRY or VM_FAULT_COMPLETED, and neither carries an
> > error. faultin_page() turns VM_FAULT_RETRY into -EBUSY, so
> > __get_user_pages() stops at that page without an error, and
> > __mm_populate() calls populate_vma_page_range() again at that address,
> > again without FOLL_TRIED. The page fault handlers and
> > __get_user_pages_locked() retry with FAULT_FLAG_TRIED instead, and on
> > that attempt filemap_fault() reads the page with the lock held and
> > returns VM_FAULT_SIGBUS if the read fails.
> >
> > Commit 631426ba1d45 ("mm/madvise: make MADV_POPULATE_(READ|WRITE) handl=
e
> > VM_FAULT_RETRY properly") fixed the same loop for MADV_POPULATE_* by
> > calling __get_user_pages_locked(). That does not fit here:
> > __get_user_pages_locked() retakes the mmap_lock itself and carries on
> > with the GUP flags it was given, while populate_vma_page_range()
> > derives those flags from the VMA that __mm_populate() looks up again,
> > and may skip, after each unlock. Retrying with a NULL locked instead
> > would drop FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_KILLABLE, so a
> > userfaultfd range would fail rather than wait, and folio lock waits
> > would not be killable.
> >
> > Instead, have __mm_populate() remember the address of the page whose
> > fault released the mmap_lock. When the next iteration starts at that
> > address, fault in that page alone with FOLL_TRIED, as
> > __get_user_pages_locked() does, then continue with the rest of the
> > range as before. The retry reads the page with the mmap_lock held, as
> > filemap_fault() did for a page that was not uptodate before v5.1, and
> > as the other GUP retries do. With a persistent read error the retry
> > fails with -EFAULT: mlock() returns -ENOMEM
> > (__mlock_posix_error_return() maps -EFAULT to it), and MAP_POPULATE,
> > which ignores populate errors, returns the mapping. A fatal signal
> > still ends the loop, with -EINTR from __get_user_pages() or, if it
> > interrupts the FOLL_TRIED read, with -EFAULT. The other callers of
> > populate_vma_page_range() pass a NULL locked, so they cannot get
> > VM_FAULT_RETRY and are unchanged.
> >
> > Reproduced with ext4 on dm-linear over a loop device, with the eight
> > sectors of one page of a file mapped to the dm "error" target, on arm64
> > (Debian's 6.12.116 and v7.4-rc3) and x86_64 (v7.4-rc3): mmap(MAP_POPULA=
TE)
> > and mlock() of the file were still running in the kernel after 5 second=
s
> > and ended when sent SIGKILL. On 6.12.116, the block layer tracepoints
> > showed about 280,000 bios a second being submitted and failed.
> >
> > The analysis, the patch and this changelog were prepared with the help
> > of an AI coding assistant (Claude).
>
> Yes, that's rather obvious from looking at it, thanks for documenting tha=
t :)
>
> Thanks for the report!
>
> [...]
>
> > +              *
> > +              * filemap_fault() reports a read error only when
> > +              * FAULT_FLAG_TRIED is set: on a first attempt it release=
s the
> > +              * mmap_lock for the read and returns VM_FAULT_RETRY what=
ever
> > +              * the result. So when the last call released the lock at
> > +              * nstart, retry that page with FOLL_TRIED, and only that=
 page,
> > +              * so that later pages still get a first attempt that rel=
eases
> > +              * the lock for the read. Compare the address because nst=
art
> > +              * moves past that page if it is no longer mapped, or its=
 VMA
> > +              * is skipped, when the lock is retaken.
> >                */
> > -             ret =3D populate_vma_page_range(vma, nstart, nend, &locke=
d);
> > +             tried =3D retry && nstart =3D=3D retry_addr;
> > +             ret =3D __populate_vma_page_range(vma, nstart,
> > +                                             tried ? nstart + PAGE_SIZ=
E : nend,
> > +                                             &locked, tried);
>
> Yeah, that's quite the ugly code. Let me take care of this (or find someo=
ne more
> familiar with that code that can help).
>
> @Yeoreum, do you have some spare cycles?
>
>
> --
> Cheers,
>
> David

