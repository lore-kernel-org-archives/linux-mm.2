Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACCAC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83B16B0088; Fri, 11 Sep 2026 14:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33C06B008C; Fri, 11 Sep 2026 14:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4BD6B0099; Fri, 11 Sep 2026 14:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 841F76B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:00:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4A74402F2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:00:37 +0000 (UTC)
X-FDA: 85202246514.24.A5C0DAD
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id C59DF180010
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:00:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fI8TNhef;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789149635;
	b=N5xvM9k8BBKpojyzeo3vFSgjWobP2UjMul9XTKdJ7y5DDjwrr9J2L+cWLhl+CwqB2tTMM8
	/tQ4gKbL61DljfEupZlQfKPCr9/vtNlZ8I5Z9NZwsFIn1zK3ySE4HYqZU3Fu2WcvGpIOyz
	uuMSJ51ZiXFQw+uMUd4/Lyv7o2/tKR8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fI8TNhef;
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ2KxZSd+Mcocl51gZtVU6R6qPkmJfHm5SmZlXDUPTg=;
	b=HTMu/P3MWHhDNGSCtUIfytHOomphRQL6QFInYCydrZ1qtIBskBMv6Etw3+hHysZHKSbnxJ
	g6hnlMmPYo64XdZLgEYW2avkl/1rNkqBIGJrIZmNjzxcLHauyYBLnCc34zoAaLwZfLxdlU
	+9lfcypA31vHwHpfOFPw49Ybl9hkSSo=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1670dad7a8so227487666b.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:00:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789149634; cv=none;
        d=google.com; s=arc-20260327;
        b=CR2hggffHRho7AXRCghzkmeLj3VkR5htNErNy8r3agfXCmI/rQKjlYAHJmI7w2dgsq
         i7c2JBi2dXVQEjOxzXQvm00czBSr1M0JxjB4vNVHRW0u2xRzWBXHqBPjzeCjVSDIdnkQ
         EBWVkJMMybFYJVvdrDQ529ZVUUKaME1hX7173YmQ7v/gTF9O4JCr8TB8QUimI6uUsi5H
         RwVxVu6cLpW8zU3LbVZTE9+fa09rPZ4f63G8PjQp5jWW5dB+XlfKVwaOcDPivbnUii3K
         92DU7wFCfaKqH6aLjXtu7I4inRhMcaqvaHkyuI0fuVOHl9azwU0qpHqYm5N5+oK99i3z
         kjBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AJ2KxZSd+Mcocl51gZtVU6R6qPkmJfHm5SmZlXDUPTg=;
        fh=7mVU6tJV2hlCWjguxKiGaT6bHiUKaHvwukwdo2sO4EM=;
        b=PIEwqCHZCPSw4RCLQ6O4bVgngv1dEhLcaf28V1F0tsocsa3HaYNYkSK6GYUGBrEr+B
         zETk9kbHgeyRxQ5cGJw/G4HJvpWWu0MVxGrFmRD61UxOQQlypELjOYafO5LTeud1lq3E
         1DyeYMuW+2TXTGxRNKG2Wm621pFVbN/oOLS5nGAhhb9aQP2bdWyB4MePnFCUtL528gOl
         vQ6qzzWjEdyybU34POYwNUeihqGXuAGafP+TbdsbDhb/Y7FR/5ZqKaXTYAiBCm8rjUhT
         zsyqQzxBLuJEuodMyXVWhuqnSh7xZfjU7+vMz2NDeNw5xjluemjhPEmZrdEtnnrb6hMx
         Mt4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789149634; x=1789754434; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AJ2KxZSd+Mcocl51gZtVU6R6qPkmJfHm5SmZlXDUPTg=;
        b=fI8TNhefE+mTBf5i4sdZzEp4KUS3HfGa8C65lmqjrdWAOg1+QF3NVScu3tTxY8MNz2
         Ap+TyPKlOAuwvrigIHA9U4XoQVt0p2P+fsl1guqvAGpN/2lT6PTKEk3kCnDII6ysL8WJ
         owVIIGh1wBgwQX6PHuw/i1tW6HqogFIRPr9Xk2W67ISn6q99AwYBZ/0kzBKKE/8u5OEN
         9XHMekaa2cK03lC9TsXWDJKAE/+Rdappr021bkcYDExy9rC63qj8SJ8IwX2PyDVbX4e0
         HBvEtJQYz6dWdxcuGzGyAmVkjJtDe0l98WVaF2K5QUebiBGeUsMhVMSLelRG8PjpmO+M
         vvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789149634; x=1789754434;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AJ2KxZSd+Mcocl51gZtVU6R6qPkmJfHm5SmZlXDUPTg=;
        b=AbefANwXJKhc3SFlxST42oCo7TnFYlwVJhEiWI5OP8soEmkC3Zkz973geEC2ofKM5B
         Hgh8bjzf0ihZ5nBXfdB8f3SbUo02EKULI8WVf+UJIcQyOhPSqddoGizA02/o1WoJO2Hu
         U/Rp7ucTrHKwnsgtg17AIvp90y+u3+vhT8Hi/naPkSTtsMHwYRpVcQJzLOL7/VdYr0y6
         qCOdESlwIr3s9j6iWBVfNWZXhV/QAX1utXaDunRYHIEmPA8zu6b7tYVJZmWfaGHCpVgs
         oK7pDzUSwNUeJ40y6HPrGR23zNgzOWyDIjgLjnpwK4Bi8lSOSe3bMmLt8xE2nTL/4772
         ax9Q==
X-Gm-Message-State: AFuF++mngOxohL0LhUveTyfZdVTMZBBeSAYrv3DpdvagJ3DXOUutEB6s
	rt68tMZUDBdJUrijzThH/e5O+VrJXdZ5rwnZ8xkKNcUlaPlsZSrF9k9yIuEq71woQw8e0Ptz+fj
	6gZexz6plfW0wMBVzS+EXMZ8a3hHt7yg=
X-Gm-Gg: AYBFou2XJQXMFHAP5mAD798ghZaat/pssygp7bZUgRTC2XcieU7kwBzzcLIuwJyj8dQ
	QSky6Z50/N31ehn/7AE27aZTBw0/nFqbtND99g3oaWevnexqVWroJ58wFDAX1vJw2rrF8w2Anh2
	Yhes0g5kR5K4/XLcu4Qq68XVqPB8Buzc/fW46vqzAinTw5uYsitboJjDgSvF74fIWiqHbXg4osf
	FrJPK+NS86hMkQ71HqHJrb3Ecr9QunvMyqTrm/8uY1Ftqw/yt/2ZwT4Df3hR8ujBMvYIJzYNfMV
	i/R1jVjj0f8aj5YAMQdqKnuZ7sE7zzu11K99NRqVf1fZkHs2kWs6HA1QPN8lwyvZ7SwB94kZcjP
	0NkFKwmxadmkq
X-Received: by 2002:a17:907:73cd:b0:c25:5ad1:41e0 with SMTP id
 a640c23a62f3a-c29666bc9b0mr237997666b.23.1789149633705; Fri, 11 Sep 2026
 11:00:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-12-b532a3f20e71@tencent.com> <aqAvPuHUVXvkJmV4@thinkstation>
In-Reply-To: <aqAvPuHUVXvkJmV4@thinkstation>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 01:59:57 +0800
X-Gm-Features: AcwNN1WXk_UL8RTLRmRjyTyr8SKaQwJ5F_yhnwe2m4m_bksXY7rRnUbRO35DoXA
Message-ID: <CAMgjq7BrdipNh9NFRz6Q=a_xidfa2=F013pGU2x9J881k0dm1w@mail.gmail.com>
Subject: Re: [PATCH v4 12/17] mm/huge_memory: move anon_vma handling into the
 anon split helper
To: Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C59DF180010
X-Rspam-User: 
X-Stat-Signature: r4epm6tjiz54objth48kssru9zkhcetn
X-HE-Tag: 1789149635-657319
X-HE-Meta: U2FsdGVkX19lHy658CHmOUAYiJDFGsONKhInXOZubx0UjjqSCyZg+P1I4UcSopENKHUDuxzGFwaJrbpTSQtlla4/sksT0cC6zKviujo560s6qCjLTNj4R18xXnXn3InSqR2q4623K+0VlRdKadrIF+jIYQET8LOml+Nks1+pdaF0j/bWcVpYsh2vUJhL7Brki7TzYxKOB84tEn3cWR3iYVz4d5uGHxmWzWb7dRt70XiE6O2FZJ5e9bu7Zq9v6PIziMsZ0Ec6bRotUDzcX3kpymmjNC/gy2rl2t0Ucc4L+8jO0DphN2NBx5jvGchMFzSpMo5n4C7fzwwSCAlFs/ZUza6oIqIzfRQ95VnEVPH6iwrfJNa7ASpsXLHSp4TWLWkgh5CJ8JEe3QwGsCYeITQ63UGoc97FTsgn895IXQO8MKiaoREDl/1H1Mwi/Wp3EHAobiHGqwIBWbxrMCAGz7c5bZQo9VK1h7eTdTjpr6r+GdzvyNW/j9v1LmqRBkyER7g7wWfHyoQG5t0EujxsHDbKW4HghycnIYtbvXBVVlxCQrGUcP8xwUAs23YrIa/4ssBjdykqetANh3wqVbsc/a4K6sYaE+kCh77gjDdzIPahXNCw2vnLPhzDsV0SRwgQuqI83fBFYT3idmfxPi7N14bI0xnFZU21aPczqjWiTOICTkbliJqwlLfOo6vUciAd3nNcfpB20+dPUPyHWAY9NP8If28UTazEgb9oNtDdhLjymXu6bBaFe/fIViAaYV0RKA6R8CBX9EYfzEqhfO0ykQXAsXYulmMjIu329NF0hvhD6YgLBok2bFGU/KhjaryAC3+uAZKizIwBjX83/rohVVgYBDH0ILk9Ud3ey+61mtem23Hqcs6uIlFRLOcuZln+4jc225thOeFPaHQxCb8KazezFeUGZwThq4ohujkKMdYUxoZynNlKn1AiyyVhyaWveKGXyP/c5AaJ3V//3kY6sxR
 dapCOFUk
 aHCI/mdxtTo61iVOL7iYN4lN7d3b0p6MS85hYqio5YJkMFQsDLq/iSYScZS1Mt30jaRNncg9QFMln9u0xBnHn68UpzrXwjvtHY7yBz/+JGVzM1SsDdWH0VU7Q759figlSVUkwVSzf8kr8ra2ifn4hQ5aS+tagIU1cZcWcrka5KZuQql61BxeAZjCByHKcxnlv48/ld9UtXmNtC/BQUTuOpN9i3YnCMBS/4E9uiFvDE7KLVZYt3Owf057JbTn8XPE5QhkQGSOqFLY4yxSYMYCk3VMwHbc+Zv9gxXipjZwTwfX1z8apBV2fwbLeCMPZKdf4aS3kCrO5d5lWhKG97NdIUsvVVdH7DOsVhcQNBosCeDksD4P6QTONyU0LM7DpWSTAfQz/VgjyoN1otJTrW1WZGU7kWYCb0NnHle8osMr83r/s9E5EVrkPhXBciqnJCcDRd1jbKwUWJWs9BH06qOcQAosrKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 11:56=E2=80=AFPM Kiryl Shutsemau <kas@kernel.org> wr=
ote:
>
> On Tue, Sep 08, 2026 at 02:12:16AM +0800, Kairui Song via B4 Relay wrote:
> > +     /*
> > +      * Unmap/remap needs the anon_vma. The caller does not necessaril=
y
> > +      * hold an mmap_lock that would prevent the anon_vma from
> > +      * disappearing, so we first take a reference and lock it.
> > +      *
> > +      * An unmapped folio needs none of this: folio_get_anon_vma() and
> > +      * folio_lock_anon_vma_read() both bail out on !folio_mapped()
> > +      * before taking the lock, and folio_ref_freeze() below still
> > +      * rejects a folio that picked up a reference meanwhile. Note
> > +      * a swapped-out THP counts as unmapped here as swap PTEs do
> > +      * not contribute mapcount, and they are splittable.
> > +      */
> >       if (folio_mapped(folio)) {
> > -             need_remap =3D true;
> > +             anon_vma =3D folio_get_anon_vma(folio);
> > +             if (!anon_vma)
> > +                     return -EBUSY;
> > +             anon_vma_lock_write(anon_vma);
> >               ret =3D unmap_folio(folio);
> >               if (ret)
> > -                     return ret;
> > +                     goto out_unlock;
> >       }
>
> Hm. Nothing serializes folio_mapped() here. I believe it is fine, but the
> reasoning deserves a comment, since it is what the whole change rests on.
> Something along the lines of:
>
>        * folio_mapped() is not stable here, but it can only change in
>        * one direction while the folio is locked. The mapcount can drop
>        * to zero at any time, zap_pte_range() takes no folio lock. It
>        * cannot go up: swapin, migration and uffd move all lock the folio
>        * before mapping it, and fork only copies PTEs that already exist.
>        *
>        * So if we see the folio mapped, the worst case is an empty rmap
>        * walk. If we see it unmapped, it stays unmapped. Anything else
>        * needs a reference first and folio_ref_freeze() below catches it.

Thanks for the review and suggestion!

Sure, let me update the comment, Zi also asked about comment update.

