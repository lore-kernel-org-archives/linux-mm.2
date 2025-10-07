Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4594CCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 16:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE968E000C; Tue,  7 Oct 2025 12:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6808E0003; Tue,  7 Oct 2025 12:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBF38E000C; Tue,  7 Oct 2025 12:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 287F08E0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:47:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC992B7A0C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:47:19 +0000 (UTC)
X-FDA: 83971898598.14.29F76E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93AB94000F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:47:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VOJu6AZ2;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759855637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTOFzWIRXXry9icZqnPg5XCEpLea61ztG7L2WQgFEsA=;
	b=O5S3VLivYj4lsYfr2k2aAvzHxD3WYAmbFES8MphG6amwnaj4Nc8M9C5NOc/GCrzrGSG41Q
	ujpJL63ECRJKvMxCZAgzQanctxnsdEO39wtFwmXoW/5nncKwVZm1jdyN7D1M0SngS4zv96
	DosQpeTl79Tzbc6dH1I1vBu719SeD/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759855637; a=rsa-sha256;
	cv=none;
	b=vUiSg+VlQhZv7xQOPQkAOvGCHCZykcw3UJXHOdCAYomPBxZn77Zuk97OADTvzSD89pyNQB
	K56/P9jg6MHnEJ8k0lkhIjUSAYQKP7n083uQOjkm0/vjOBJdN6+HxkIvaMtQHF6ijnKrCK
	56DuoiRv3w63QkgXHpOoZHQHeMa1BeY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VOJu6AZ2;
	spf=pass (imf27.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759855637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tTOFzWIRXXry9icZqnPg5XCEpLea61ztG7L2WQgFEsA=;
	b=VOJu6AZ2N7T8S443tKQRXpyipbkUUnqH6HdRKGw49ab9i6t8hyFrPgYPfNgCXPpDfMWrMF
	EUQm19CziuRdTwfCC998lFA7I/IgBl7g7BvQ5XZW5LscElgddjM471w3XJn5Tee4soLqYo
	3QiBafSrnOTCmJMObKCNItTNgc2jl0k=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-rxtE6jM2PACYJAmv62n0kQ-1; Tue, 07 Oct 2025 12:47:15 -0400
X-MC-Unique: rxtE6jM2PACYJAmv62n0kQ-1
X-Mimecast-MFC-AGG-ID: rxtE6jM2PACYJAmv62n0kQ_1759855635
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4df60ea7a1bso136094241cf.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 09:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759855635; x=1760460435;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTOFzWIRXXry9icZqnPg5XCEpLea61ztG7L2WQgFEsA=;
        b=KwIujwQjxqU35E2leAwcKJ40ch6eBjQXafREgGE+j6OTDekdEcU9+ftwJICk/EfoqU
         hha5z57RTwo+vt95K5PqFLWRUDF6U+KuJlcgLTUkn+M6jKmqYPPaBe4WBznir+Fe3mag
         Ri2bSR41qPur3S5i7LO6FjCGAaNgxUEx7MeP1cGd9cmPN/LrittIg9fZPLD3WYOeOI45
         aLkdlT6jbGJGwkbslKR5S+qoTYU6Geuhx5szKxSqW6gmvm3jZyQLgBxd5lqU+beEMK/e
         wwcXrLtJJLkVTasv5a/AbiPmSbhQ2Cm6IhQXIGrBg/u7WUFrTY2jI7w7vZn7z3BSBLxc
         7ypg==
X-Forwarded-Encrypted: i=1; AJvYcCVdesaO1Tc8uXD2O+D3me34DZ+KohZWiEf2o2r6M9rcTL4kxWi9M+Gd/+GzrwT8sUNwvgjnjvQ2Cw==@kvack.org
X-Gm-Message-State: AOJu0YzqbwuIV3tskY5Ef4+lOIaStqhdQawkTBgYRXj+m7M6GmAXjC+s
	x/7dC/AYIdLtpYgOfu+EGpvt4LrYh/cBbEmlFRPYjoIRsyDSuhSiJUEU9fqWjE/1dt/GflKTkUV
	4SKhH5JdWl1Fkr8HtaSyA5VY+QhC+m0AUCP0KKo9tyEAUNqQWRuFG
X-Gm-Gg: ASbGncue5124t8jnlSbwtDVN1Fbn+dU8EqDhYsBmCkglk4nor+qKfgpkXxCwotbv4j6
	qXX9JlpBp4gRt/LK+QhbHMXcXJr/PNlWHQpy++PFdL0HjsdttFY5sJui4OaWTq6vt/m2XFmnyWL
	8wYVkDQO/8WBqGH6BJSGLAQYBCo91gJ5CPF1Ka61tOvG0/KbCgFnE6OZWs2juHqaPZ78e8yMpTr
	Lwj34KJpoaxxFQVVJPD5nt2u/taDTVU/fgNL5psQCYk82bHiwVmt8vxzasTle9tpNX8CHDPpSva
	RBbf4fJ6g5bmQ4TQMJJ0p2/4EEZvaEpgLqC8EQ==
X-Received: by 2002:a05:622a:107:b0:4b7:95da:b3c7 with SMTP id d75a77b69052e-4e6ead4b0eemr3307351cf.48.1759855634989;
        Tue, 07 Oct 2025 09:47:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8RX884Zg/mlMH86KuApH2VeuJdNzehLkNSygcZJ0HaGfZTFTmEttK1Cc2JLQhTCyVQ+bWvw==
X-Received: by 2002:a05:622a:107:b0:4b7:95da:b3c7 with SMTP id d75a77b69052e-4e6ead4b0eemr3306771cf.48.1759855634461;
        Tue, 07 Oct 2025 09:47:14 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55c9e78cfsm160745871cf.27.2025.10.07.09.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 09:47:13 -0700 (PDT)
Date: Tue, 7 Oct 2025 12:47:10 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aOVEDii4HPB6outm@x1.local>
References: <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
 <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
MIME-Version: 1.0
In-Reply-To: <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8VKDl0SCriP4W5CLi_G-HAasYVaqsVYh4eEt5Nup3Gs_1759855635
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Stat-Signature: qj61gakxe7mies1dumiaeo3scpsmfy98
X-Rspam-User: 
X-Rspamd-Queue-Id: 93AB94000F
X-HE-Tag: 1759855637-801658
X-HE-Meta: U2FsdGVkX1+ZUZdOmWPDYbNCMDwd/tEXeR1y+5ScHOojHNw4UuWyiOQO/9Ajt6nXNT+EeFWTgbnNa0PBV/+o4XKPEJsvv2eGtilrksD1ZVnk1uUKKp3QOz3IKawxLsEi/9VHXKNklWtwmKV7zgz+fYH0Z1x18ICiiRePn8JC8a+Htrwij0d/8g1xUl+4nw2uL56YpRRmqwQeYCd5TmY54eqjXTYXLV2bkM0mnMB7NxVfEHIBJKPBIqnlYdm06Wb7QEjZc+mi0gH5y8OnUTSlfkVYtlB4J0G0ZRfEkOe2uT5GidvATnzG/2O8v8WMM2a6hg+55CdQ1eEUis24JdHlv7HAHoEGbRbNz3MnyhKxoHN7Stmc87Vxtnjq5MCKLcfVmFwU4OF46Lnm5yARwUV1qacBWs3hRWx3yJXV6lUIM9u+18Rt9I5Ft/zFmtDy2GvxhI2NOokto5Xr9lrEIizgwXbFkGsE1olXiC7J+C2WZH22ma/0t/ft9KIATYtzxD3WMCdU4Kd9TyVnRWPiKc9diM7dmyid4tZei+CDqXyNHdefJZ8GBKENYlcuBuTegiKQvVwT8M48mzKnrXrapMWywjlKMUKk7Txv4JRy2qKN3qAd2yX26fzxiImRcUstO2sZbUwWwSgt2L2eX8q9CMRppShqlbbZ/ZIx49C5Vgh9qeCINhPNhlHRVmyGm3AuiKjCQooFd2I/h+DJQjyXvMhjm33/C/WsPwjwUH6Bxq2ehXZ5XBPnxh/Jib1RnR/nfIYjyPn0fbSEEBKLZRCOzRY0yc+J/mCPrGL1gFP50dh4Q95FMzEglUQug3qGXjXbD9UdIxZ64xGNgzwGMQBe2TUHxuIOix6VGhSVztWFHnFMok5sl4vMF+SYwJYIj0sk/XYt3UHWq9G8kRXmWbooC165Myv+1MElN2JBbbZDKJMJsFZKDjh0ubHlrD0sDlpI2tCTI5LNjl9mP/ZqSEZFuJl
 2o6YnwO/
 n6vj6ilogOQF9XjBKu34AKO9PTru+MIQdxnejmtW+fXGRwPHp9msDj1qQpxum22nlEZ4HT9559APPZCnrL3yHNvaNOUGr38NhBBT8luudrvw3cX92ceKa2hT7EgPlPjMIsPLIkotZ57i2HpYEA86YmVCZDgVOxw5WpBTKDo6ueCe4pt0h2hxZP0tAu0pWP/aKK2GEx0aiibijEwmVUGmR35xh4F/kfunE79Y+WG0lBpkIOMU2ievfGuz+8hNhiCAm+PZYcJ/B4gYhWVmt5n7kpixCgjTkIG7VcpyrElz3Va5rfZmYaAYtumzcvzS7T2ei2DnP09xmEHYp18pQTG/9x34Ra+U9afu2TjSbcBduuq/NO51K5FT4x1MdciwL47YSNyOsZll2+v5JJZPM/v0NM5cg8RHthbPbn2G1SU6wGz81wEzZDRp+Nzcmkc0g1nARngzqsJS3FgJW6PoPUzdEdA5E2dPy4k4j5FcTAg4SU3rQ/L7/o83z2iLF72ssAHJOMaG38MbOoO2sipl54CaFukG+JUE2MZ5MtXp/Ct+OjCAR/G5YpfFqa8ARJswdD9nXoq1/fmQU7cLZkmEvnP6TK0DaLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 06:14:01PM +0200, David Hildenbrand wrote:
> > > If so, I'd prefer that rather than introducing feature-backend flags,
> > > because I want to avoid introducing another different feature set to uffd.
> > > 
> > 
> > I was talking about uffd_features.  I thought it was being renamed to
> > flags, not modes_supported.  It was pretty late when I responded.
> > 
> > FWIU, David was saying we don't need both of modes and ioctl listed in
> > the uffd_ops?
> 
> Right, I would have abstracted the features to clean it up and avoid using
> VM_ flags in this interface.
> 
> > 
> > I was thinking that we could just put the features directly as function
> > pointers in the uffd_ops and check if they are NULL or not for
> > 'support'.
> > 
> > ie:
> > 
> > struct vm_uffd_ops hugetlb_uffd_ops = {
> >          .missing = hugetlb_handle_userfault,

This is not needed because the logic to handle userfault isn't very type
sensitive. Hugetlb is the only one that differs very lightly, but again I
think we should better take hugetlbfs as special always as of now, per all
the previous discussions on hugetlb unifications.

> >          .write_protect = mwriteprotect_range,

This is not needed.  WP processing is the same.

> >          .minor = hugetlb_handle_userfault_minor,

We can do that, but ultimately we do almost exactly the same for all memory
types except a fetch on the page cache.  IMHO this will make it awkward..
because 99% of the minor hooks will do the same thing..  OTOH, it makes
more sense to me that the hook is defined to cover what is different on the
memory type.

I'll stop commenting on the rest.

> > 
> >          .mfill_atomic = hugetlb_mfill_atomic_pte,
> >          .mfill_atomic_continue = ...
> >          .mfill_zeropage = ...
> >          .mfill_poison = ...
> >          .mfill_copy = NULL, /* For example */
> > };
> > 
> > Then mfill_atomic_copy() becomes:
> > {
> >          /*
> >           * Maybe some setup, used for all mfill operations from
> >           * mfill_atomic()
> >           */
> > 
> >           ...
> > 
> >          dst_vma = uffd_mfill_lock()
> >          uffd_ops = vma_get_uffd_ops(vma);
> >          if (!uffd_ops)
> >                  return false;
> > 
> >          if (!uffd_ops->mfill_copy) /* unlikely? */
> >                  return false;
> > 
> >          return uffd_ops->mfill_copy(dst_vma,..);
> > }
> > 
> > This way is_vm_hugetlb_page() never really needs to be used because the
> > function pointer already makes that distinction.
> > 
> > Right now, we have checks for hugetlb through other functions that "pass
> > off to appropriate routine", and we end up translating the
> > ioctl_supports into the function call eventually, anyways.
> 
> Right, it would be great to get rid of that. I recall I asked for such a
> cleanup in RFC (or was it v1).

I didn't send RFC, likely you meant this reply in v1?

https://lore.kernel.org/all/0126fa5f-b5aa-4a17-80d6-d428105e45c7@redhat.com/

        I agree that another special-purpose file (like implemented by
        guest_memfd) would need that. But if we could get rid of
        "hugetlb"/"shmem" special-casing in userfaultfd, it would be a
        rasonable independent cleanup.

Get rid of hugetlbfs is still not my goal as of in this series.

OTOH, I generalized shmem and removed shmem.h header from userfaultfd, but
that was prior versions when with uffd_copy() and it was rejected.

What should I do now to move this series forward?  Could anyone provide a
solid answer?

Thanks,

-- 
Peter Xu


