Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C43CCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978BE8E0007; Tue, 30 Sep 2025 14:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9505E8E0002; Tue, 30 Sep 2025 14:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D308E0007; Tue, 30 Sep 2025 14:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 779FB8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:52:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D385C07E1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:52:52 +0000 (UTC)
X-FDA: 83946813384.03.B21EA37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1D6D14000F
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:52:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkT9dXVz;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759258370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mIFqockUuM1xJzVFN3EXIFLgZfOpoUB5lLQdmavPc6M=;
	b=ub1qPtGC6grsREkKI6bmYKjMNSRuTeimnoZTE6q1Fe6FBpAFdXiCkBmfRoPX8VQ94Wk2+M
	sVW+it927Vc1hWlN66aolm81S4O03EMKcT0vtTEkHz55SmFQuxXfMnkeXAco9BK+stIvbq
	TGYEL7GoWxkwKmI4t3vRVAY8VZ9i4yA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759258370; a=rsa-sha256;
	cv=none;
	b=r//ZU+2ua17hkn00sN8tSip4rdEcL7OSb4sbe9LqOxvx4GyyPpHLt1nl/gOTZDwDOsChWY
	y9tyEvDJcfwJG0HWmWZoNQrqfOhTyD2IOs8Ip+KUCCDxEeFEReSQcQVgrFzcIBCI7TyaQg
	xsYoJzhCtEBqM1AIt19q91s26GMl1Sc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkT9dXVz;
	spf=pass (imf26.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759258368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mIFqockUuM1xJzVFN3EXIFLgZfOpoUB5lLQdmavPc6M=;
	b=ZkT9dXVzJNvdEOxUoWzAI5YAbihzSjjNNtSj8iKOy/hOiO/tlPajb02ZJH8HZxyIifDVSf
	qrqurESpJDIHlF5qwk6FhbiNMKT6wIsCSyMfNP7qgZhs5sy/f+o/qCvMzRO2zXlOMkIBYD
	Q9gCjgLTqWk2Re15XSSOyS7lbPlevhw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-eDLHiPA6MNCPn55EAUiELA-1; Tue, 30 Sep 2025 14:52:46 -0400
X-MC-Unique: eDLHiPA6MNCPn55EAUiELA-1
X-Mimecast-MFC-AGG-ID: eDLHiPA6MNCPn55EAUiELA_1759258365
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-7fa235e330dso3574826d6.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759258365; x=1759863165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIFqockUuM1xJzVFN3EXIFLgZfOpoUB5lLQdmavPc6M=;
        b=izaK24FYFwangJTbH7XBU4LTV5GGQJT6YZBU3z6Jh9y2Gy34eR/OVNvxSiHfrkvAPG
         VYO2uxXaqndHQyzezNVT7UCdy0VmQC+4InTS+g2kQOf9qcOUiRKRz9knWJfTyVkiHFUh
         b2zKS/KH8AGVq//ZmZ9099tnN0m4G8vsclwKhG0sEhJNHWknyoLAVYT8TGmdPXSOmcOj
         GpSUD4OEZ2jxAM0c+yR39cLwpLLSSlW3NhlCp4MzlUjfliQ1NK0UXXJ5HIfaHgqRUfhH
         +f9Cen4H51qzQW6EdU+MLAb5hjEusiDjAbCtI9ERzEJXEz/NRW5RGkG/0bJhE0Ujz0VI
         PnWw==
X-Gm-Message-State: AOJu0YwUXLQnzIDR/xlPly6VPnwLmvVu25eD0lMAptuVvC0H171SAShv
	OzfpaBSjtVgmbymcniDDPSkCbFoGLG1d3o+1tY6b+Be02vg219hIjvg2Hwumn0aWi2Nreh3aJqv
	1rkKxFodWCyPjwYFG5wWYF7+5QZSvxQbUjD6F4wmzW/U71kMpQNPK
X-Gm-Gg: ASbGnctrJcDkkJ1N86zPj3WkHvd2VzZH5VgKAi+jWYwJt5/1AGH12/2inyp8cbJwMi0
	Qe9RTQyxNrXhl32Kzg86wPdUbFjHe7NUl2EdPd+XhFTqviSH86B+v+XnVkWeY60wyAPnM/mngop
	MB6U/jGIwHeKP3s/rmlQGfMe60WTHrecCLecvBW7LeadS//e3LNo01/wKjM7Il+PuG6D8XfwcLp
	qR40UZvpkxNalhPts51ECjbz+50bGhHV3hWmlrIx3TL4qUkwl1QhEIBpyfgQG2NGRNNtJ+s8y1V
	5o/a68fgKvknqs3BVQMbgDzFwe+LRU3BDkLjlw==
X-Received: by 2002:a05:6214:d8d:b0:78e:8752:826e with SMTP id 6a1803df08f44-87372974cffmr13467626d6.7.1759258365449;
        Tue, 30 Sep 2025 11:52:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEgx2UMaIQ4cNuoiBjSCdSRF49bjJYFxrd6Ahvl6VR/9Pmg8B4boKNrNZqb1or1xhMLXMpJWA==
X-Received: by 2002:a05:6214:d8d:b0:78e:8752:826e with SMTP id 6a1803df08f44-87372974cffmr13467316d6.7.1759258364914;
        Tue, 30 Sep 2025 11:52:44 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8745fa88b8fsm1153106d6.19.2025.09.30.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 11:52:44 -0700 (PDT)
Date: Tue, 30 Sep 2025 14:52:42 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 4/4] mm: Apply vm_uffd_ops API to core mm
Message-ID: <aNwm-uAt98KA9Euh@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-5-peterx@redhat.com>
 <0a60d99b-fa3b-482b-8171-ac63dcdf3168@redhat.com>
MIME-Version: 1.0
In-Reply-To: <0a60d99b-fa3b-482b-8171-ac63dcdf3168@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o-EEyW3zVMxpex-bEY_uB3ANNcHWajh8dSE5PVa86dI_1759258365
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: banadtskqak6yi45hq7oy83g37kt6snh
X-Rspamd-Queue-Id: E1D6D14000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759258369-162855
X-HE-Meta: U2FsdGVkX18t0X+kz1IIiNChbsr76srolULqT6aH9sXrT4Wm3IZuXDMv0okezSiSdhzf8J88O3nufRIRYgqhvDr58ZmcbtxR0nsiIqFMSoVE5qavCtW6D5N356mIHJQ1ooALLttgzA/qP+9wVD9G6JroG/6YRUIRA8nxlI3CxJLq4rY35Ld+jrE0RMbV8BZDrhyuXz1U+U7EFvklyuDj/W3CW2/XCvjDYKwzFKJmWCMhEFvPliQIJqGA5I2w358kXCQqWFxs2Q98hwhnTWgK6E8WWbkqFP8GD5DIS1/vAfHidsAuZxs0ajO1VE9R84GjVdVv+x+/f6rG8hQwUPXwNGbOGuGxgG6jRAnpxGYyNlNxAejKkNf4hhE6WK0Pi9UWbGDfP9IzxyfaVJFNU/HcMkGmBPNslMs7qoyDbrswXJ9hKgRpsfKykf6osyM/SuULav46uahRm8G4CTUjfOkgA6mff+TwQKxwffUf83Y3izZIQVS4apAxxA5/oK9PgH60yCTTl9VNNM4O4/3mYgAHO35sdbSk0VFcecXxqjb4zEFdvXo/IrXFwhDKklIARuCLeBuWwvKQopUeuDIxuhFHGwoOb5M8fY0VvqKlQ7+wx3/CKK++6UsCJgs5+z1uFEQyZ0cbLrh1b+XNAQwDa1aw7BygaY5p6x2Fqu/IGaPvn1gbNc2JICllMimVBgeDgXBG4dzciQ6N8suX/AkpBmP7PeRE9exWVsVXiie96dsCIyrcRwFy/9SMgSqZGeDsqlylZNERJj9forckfvqYSkFcLjAWvVb3tcHaGZjfK4RzvpU6W/E1RQGjvEVAWKwhR3njscFQ70iMGc6dtaMJJ68U+KdnLvst7JmZgslEahGUqz1U0mpbh0zCiY17k1cc7pAH7Yy6yNcgyLtXgCZLyJrx8VnlRB1kEHcAIXl7oPec6XnPjLr9nq6ZqJ3QwEBGvMgaJTc3c0Wgg2kM/qynKXV
 lTvEUuj8
 1DPaCg6xjrKWDz9RRhdNExnoGsQAbOIIiF4k6FpcV/jURmZYlR7/SIfO31ttlXIdHv+ABZplvKf28VLJ31NJ/VTjOYayefuuaJAAxqL8PNv9HtSZEFBMBNYL477W3lXqLy6CXMRJUcVcys2Ijgh8ImII3c5L0A+VtAk2VdYHu4qVeAd311TMacDTZ/5Od9Ac4svrNGZ5wQvz4zK2WN7HmcST3KBML+mFBFbT2q4pyUr4m3GXJhB/kPtndlevZE6UvozgLr59MTyqfK9K4g83O4Iod7/B3+8gKKNMmweiXd00aeGZQlBjigxb2Pgd7dwtgBoQISuD83OiATtCvWdmzLiTJEI8oh0yH89e69okhUoJHu0b2GsFqyS5cWMk13nmNcp2r8gWFvOPPn3BNRcVIuOCo+/YBizwMScPxJ6WehbUYZyeCFcL0U/AMmaBrSVe8BIzv/R1smzbf6ABe8WNp+8auLJvVpC4D3frltOu4VNzCafwsB56UhrMhmMhB8qOwMKMEs396G0ZP6UaNIJayyZQ1Zvl6+KJ3oCdDRSKvcRQgDZCEPcYyB8B+r4EabucMuXgUv2cl4rTZZH9kh8xnIifBQRIF0jEQu9sQEAmeoRGGwy/HnrFmU2bXAwszk2cnY9abYfo/LM646x39rtndfLIqmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 11:23:19AM +0200, David Hildenbrand wrote:
> On 26.09.25 23:16, Peter Xu wrote:
> > Move userfaultfd core to use new vm_uffd_ops API. After this change file
> > systems that implement vm_operations_struct can start using new API for
> > userfaultfd operations.
> > 
> > When at it, moving vma_can_userfault() into mm/userfaultfd.c instead,
> > because it's getting too big.  It's only used in slow paths so it shouldn't
> > be an issue.  Move the pte marker check before wp_async, which might be
> > more intuitive because wp_async depends on pte markers.  That shouldn't
> > cause any functional change though because only one check would take effect
> > depending on whether pte marker was selected in config.
> > 
> > This will also remove quite some hard-coded checks for either shmem or
> > hugetlbfs.  Now all the old checks should still work but with vm_uffd_ops.
> > 
> > Note that anonymous memory will still need to be processed separately
> > because it doesn't have vm_ops at all.
> > 
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Acked-by: Mike Rapoport <rppt@kernel.org>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> 
> [...]
> 
> > +++ b/mm/userfaultfd.c
> > @@ -20,6 +20,43 @@
> >   #include "internal.h"
> >   #include "swap.h"
> > +bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> > +		       bool wp_async)
> > +{
> > +	unsigned long supported;
> > +
> > +	if (vma->vm_flags & VM_DROPPABLE)
> > +		return false;
> > +
> > +	vm_flags &= __VM_UFFD_FLAGS;
> > +
> > +#ifndef CONFIG_PTE_MARKER_UFFD_WP
> 
> While at it, you can turn that into an
> !IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) to avoid the ifdef.
> 
> > +	/*
> > +	 * If user requested uffd-wp but not enabled pte markers for
> > +	 * uffd-wp, then any file system (like shmem or hugetlbfs) are not
> > +	 * supported but only anonymous.
> > +	 */
> > +	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
> > +		return false;
> > +#endif
> > +	/*
> > +	 * If wp async enabled, and WP is the only mode enabled, allow any
> > +	 * memory type.
> > +	 */
> > +	if (wp_async && (vm_flags == VM_UFFD_WP))
> > +		return true;
> 
> 
> > +
> > +	if (vma_is_anonymous(vma))
> > +		/* Anonymous has no page cache, MINOR not supported */
> > +		supported = VM_UFFD_MISSING | VM_UFFD_WP;
> > +	else if (vma_get_uffd_ops(vma))
> > +		supported = vma_get_uffd_ops(vma)->uffd_features;
> > +	else
> > +		return false;
> 
> To avoid the hidde return here, I think you can just do
> 
> 	supported = 0;
> 
> 
> Or even cleaner, just do
> 
> unsigned long supported = 0
> ...
> if (vma_is_anonymous(vma))
> 	supported = ...
> else if (vma_get_uffd_ops(vma))
> 	supported = ...
> return ...
> 
> > +
> > +	return !(vm_flags & (~supported));
> 
> I think this can just be:
> 
> 	return !(vm_flags & ~supported);

Sure thing, I'll apply everything you mentioned above.

Thanks,

-- 
Peter Xu


