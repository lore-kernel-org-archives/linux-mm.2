Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98DFCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 19:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555648E01DD; Thu, 30 Oct 2025 15:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CD88E00CE; Thu, 30 Oct 2025 15:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442888E01DD; Thu, 30 Oct 2025 15:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 291A78E00CE
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:55:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD6D957AC7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:55:52 +0000 (UTC)
X-FDA: 84055836144.02.3F1AFDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7757D4000C
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:55:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlZIPUNx;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761854150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOfjpjtn1M8qsaqsd1nqTT6We9OytpooWr9SyKG7CNE=;
	b=Ja5ZAF5tKL3jGFOEha4hvR9CS5GmtFJjCeT4kisRAbOtA7NsTGJDfCB7JP9ieYmylaEKVF
	X9wyafBdzSBkkA0rYxS/MzCPuNFmYxglNNTd1vWmgWdpcFwMK8skFlI1VUv6UNko/dTt62
	k5L9dHN/FQOriLWp2n2HAJuhv9261oo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761854150; a=rsa-sha256;
	cv=none;
	b=SZ9X0w9HfhAJhDnDvrN/P4OFpmpF53q9c7Rlpm321CXqOByN0U/PBqAHxSQMl6pESVuLns
	lLsJa76jbte6p0uRJ465zvBpXlsWcExqIaquzsZkRGnpmEAxhvNM8IPitBH/pnzuaLg0Pp
	WyaX87arc3bXr8VXHTloA2QZPtMwihk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YlZIPUNx;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761854149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dOfjpjtn1M8qsaqsd1nqTT6We9OytpooWr9SyKG7CNE=;
	b=YlZIPUNxq2ayoGwKZw3ZvDLJuFFUKgFImxcQHdeTDl81q07pZizHR2n9ID9fKUpBUy8tCD
	xDLXfipxytFGx/+S1jLVb7qIZk7qh7zewfbUx6zIVTMhFOO7CvnxQF71/aNyWo2Fj7ceJ6
	Rwyrw32utRFS56LPHrrF0I1k9ukjwR4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-qsUnagcNP4COtHVeK_y1Vw-1; Thu, 30 Oct 2025 15:55:48 -0400
X-MC-Unique: qsUnagcNP4COtHVeK_y1Vw-1
X-Mimecast-MFC-AGG-ID: qsUnagcNP4COtHVeK_y1Vw_1761854148
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ecf72a45f5so47897871cf.2
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:55:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761854148; x=1762458948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOfjpjtn1M8qsaqsd1nqTT6We9OytpooWr9SyKG7CNE=;
        b=kXjho8fb5mNMWKcs5/U0nbI3+FoiZgXeEzEasz6fM/rArHQktVNerw1gls1cMUBM3X
         cY2JjyKh+UcqS9JSS3kqHrt3Me4iEgq+5XO6Zlnezw4vYgr/UGw/4D6eSfZOshy2yfxQ
         WpTdqoI40/V/9d9iBhMQQZQh+Y5sXu2/RTyN6Eo29z6I8ejEzvU/toEUpSTyV1h0uL8g
         V4l5ElNYjKCUvRQf/hIGofDTnQos5GWY8IodKm5Mm3N2KA/agDW/n7m+Cei9Hgeu+hUm
         2i5FMSIT7nRUF6t0Xg077ZjCrQkXygou9dWb8NoH4DmwrQYl1jbO7/Rcs0bpDjJYj+ej
         xGAA==
X-Forwarded-Encrypted: i=1; AJvYcCVhEGL3SqFDffa2oM7RBgR6/QMcPoTskVwxuuhQBYB8fnaIO+pzxAyJaDPjiWf8A/vIT6ZD4sP0dQ==@kvack.org
X-Gm-Message-State: AOJu0YzFZnEZSGdtoZW9dJPvMAeAzoRF2pg0kcllwCdEMLZyn/ZPlJFX
	H2pnZ59Zg14Ie2t36uU5AGaU1vYQS5VYbcMEvZLabyLofBUBDp0V5ROREcCy2zB7S+mubWNamQt
	lcl6PHRZ5YUGzFqXo/mtw/TRSZ3TrRc9ZUKJcSvZKXj4AzITgS2y1
X-Gm-Gg: ASbGncu/4+x1Hkz4KmVdrtxaKEcHKdSZhMnmVCYp3YGOPGzYeMHXpUxl/tCryIwNeE7
	SWLID2xeBNFAMoelRrTAXk5/DrFw1CV1xxPK3WQsEX3iFoSfIRmJ5TOlen77gRHO/z/wgp1XG65
	G8XjCDeYn7wfQBOgeBaQvbgyAO2TJgXZT7ASJhEy4pKWwgJLj54TLGNYZDXG0xqPYDFj6j7CC0u
	gYzLZnH8PYkz82qe4Fhs0pRNCDdE47qJDMmiTraOaj1RklvLo7BCmqAcUbyCKgHHqA7Ck6XDhxV
	vrP27DA4Yur+Wu8SEIv560bZAf40M7/V/72WR+Zs/X25MMrbGK8dn/CqoKcroMASL8U=
X-Received: by 2002:a05:622a:1b8d:b0:4ec:efdd:938e with SMTP id d75a77b69052e-4ed30e1602dmr11808971cf.11.1761854147755;
        Thu, 30 Oct 2025 12:55:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRKBZnDt6f3bb2SOJLIKbgdsaWvqS0L1Ou0EOOZO2HK+UfbyRXmOhLAztZKbpEZv2OLHJBzA==
X-Received: by 2002:a05:622a:1b8d:b0:4ec:efdd:938e with SMTP id d75a77b69052e-4ed30e1602dmr11808661cf.11.1761854147220;
        Thu, 30 Oct 2025 12:55:47 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f24dd5ad9sm1324998285a.22.2025.10.30.12.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 12:55:46 -0700 (PDT)
Date: Thu, 30 Oct 2025 15:55:44 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQPCwFZqNd_ZlZ0S@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
MIME-Version: 1.0
In-Reply-To: <aQO3Zko6Qrk7O96u@x1.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5fsjNZtLS0qptB33lLydBzSbjkF0abCaKPcSDupLt2E_1761854148
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Stat-Signature: 1cdgeg4co9p7np3bcttbhk8ez17xfask
X-Rspam-User: 
X-Rspamd-Queue-Id: 7757D4000C
X-HE-Tag: 1761854150-230437
X-HE-Meta: U2FsdGVkX190DPySGaU68R8RyOxpbtVYWEdFJbdvOl3mm3sDhHxWWLZ9F1DEdjE5uOZ8H5tU9xhmEc0MIn4Tx3RSfV+EuFJJjslNZ2z9LlYxglsIXoMKM/vejI6tcY6Hqfx9lj+YQ0RP990L6vMftCzt7oRj9wGsOiSFbRV6+yjmvptvlkyJ6/6iQvLrKeU+LEhG2wIO4NIZkpWvr8eBeaIiIi6G7GzoVlRdiTDLFVYWG03UFYgpGOeZMVajXKdY4cRHoWByj4cknM9lX36aOkxoismI8AUU8tXPfOh7FZUOhHZqGrGrCedVmJ0E5hk3aNHCp3j9oqkJF2ncEe6QdYc5Z4kCBUOMh+Zpe38+tbg/OoYm1UFD//bspPh9nodVaucBCN5QTF5WETnQQVarD8J7A0mKdmmJGgi+iB97u20R2gJD/rTKdimPAXiRxI03q3+Uk3Fsy3Rd2TU1kuor8BufXp+onR5WeNeD0orkpLeT8WIoGPvjPbfrGKrsk9gixmo9yhc6JZBqZRQBAYftuFf+PoE11VEYB2UgvVf3DaA/nAtvrihR7rX2/vLtmvK7Bm/3VLYv9+8nQTUtNCe3yfepNRhN+RdBGyo1nsUQZTH0YgerIozNwllivmvt27ZBV0joXKJ1aondUs0ia97DBI/2EsW2d6cmsYiZKAWbwjhSMJ8iRfyyT5GKLyTVY9BcGSQIWNt0cxoLEkVvkb9E6BB+gnHAMxt3fw7fEYgAiPr6AYZXGCZa2ALgB9kLvac07VjLk0FrTJh9JaXyJViaJiHW0LKPJAoxjevOEWL3FqrD8L7z3Naa6DG8WXPl24yNGkRnBhhjoiIa7vmvst4BxRG9VTw8DhPbSsIgLCSGCjuw5Wl8Q+mOP+XRV/2iKfwlb/mzX9eviE8rucst/3lXZiJ3U2y+OnUHfDsD0gsNdl4IYvXRG7z+N9FSrjXaUbBEBW/W5iVwEz3Vpa2bofe
 QfaxJd3G
 Ifqo/xa4lILI+jH0NE5P3jFU/358zREJJTI9hnnyrEj0v47kfYOKddQjViTkOIvpPprmxikaIpBcehlzFCYheET2sdnKdlVnFUnjQ7vMXeqPB8Pi0veS6UB9gBCWRmfRYwzTFrWa5Jbu8GYzNy/ATgBs/FX96NYOJk48YbzR/jGEH8g7SpLsKpcL8Bhyj+QTshr5fGDnsgmz2UFaabmFIZaFMyv1QlpJAZcn9c7VhLnYMmYM2+isqT+vbZVFWqbOOfBD538b9nCCj5YYDW2CMw8xZAX3ZM6ydmO0F9IJYW+Z5R7IrXpipfbEHjT4PZfZRM7Q6EPtGNrnLMRrG2NU95ST09JjfjwKvNvwL+woJyPWK+nM7HToMFYuprulDUtQHch2A9dpRCxW/1QJ/zfV73y5oEz5PD1+mh9v3a9GArwl9ILKWSwuLLZHGrdAhL6eiijRcV4H+aHsF9Pg0HJ97CtHcYpY6nFFivB6TdLzWaJeqqX2w8DbDMU2ko3wcrig24kfImIa1VmgZ2pZ3HnK7/kdhUiXwQDcV0TA+4jRRXk8MyTG149JTbsibag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 03:07:18PM -0400, Peter Xu wrote:
> > Patches are here:
> > 
> > https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> 
> Great!  Finally we have something solid to discuss on top.
> 
> Yes, I'm extremely happy to see whatever code there is, I'm happy to review
> it.  I'm happy to see it rolling.  If it is better, we can adopt it.

So here is a summary of why I think my proposal is better:

- Much less code

  I think this is crystal clear..  I'm pasting once more in this summary
  email on what your proposal touches:

 fs/userfaultfd.c              |  14 +--
 include/linux/hugetlb.h       |  21 ----
 include/linux/mm.h            |  11 ++
 include/linux/shmem_fs.h      |  14 ---
 include/linux/userfaultfd_k.h | 108 ++++++++++------
 mm/hugetlb.c                  | 359 +++++++++++++++++++++++++++++++++++++++++++++--------
 mm/shmem.c                    | 245 ++++++++++++++++++++++++------------
 mm/userfaultfd.c              | 869 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 8 files changed, 962 insertions(+), 679 deletions(-)

- Much less future code

  The new proposal needs at least 6 APIs to implement even minor fault..
  One of the API needs to be implemented with uffd_info* which further
  includes 10+ fields to process.  It means we'll have a bunch of
  duplicated code in the future if new things pop up, so it's not only
  about what we merge.

- Much less exported functions to modules

  My solution, after exposing vm_uffd_ops, doesn't need to export any
  function.

  Your solution needs to export a lot of new functions to modules.  I
  didn't pay a lot of attention but the list should at least include these
  10 functions:
  
        void uffd_complete_register(struct vm_area_struct *vma);
        unsigned int uffd_page_shift(struct vm_area_struct *vma);
        int uffd_writeprotect(struct uffd_info *info);
        ssize_t uffd_failed_do_unlock(struct uffd_info *info);
        int uffd_atomic_pte_copy(struct folio *folio, unsigned long src_addr);
        unsigned long mfill_size(struct vm_area_struct *vma)
        int mfill_atomic_pte_poison(struct uffd_info *info);
        int mfill_atomic_pte_copy(struct uffd_info *info);
        int mfill_atomic_pte_zeropage(struct uffd_info *info);
        ssize_t uffd_get_dst_pmd(struct vm_area_struct *dst_vma, unsigned long dst_addr,pmd_t **dst_pmd);

  It's simply unnecessary.

- Less error prone

  At least to support minor fault, my solution only needs one hook fetching
  page cache, then set the CONTINUE ioctl in the supported_ioctls.

- Safer

  Your code allows to operate on pmd* in a module??? That's too risky and
  mm can explode!  Isn't it?

- Do not build new codes on top of hugetlbfs

  AFAICT, more than half of your solution's API is trying to service
  hugetlbfs.  IMHO that's the wrong way to go.  I explained to you multiple
  times.  We should either keep hugetlbfs alone, or having hugetlbfs adopt
  mm APIs instead.  We shouldn't build any new code only trying to service
  hugetlbfsv1 but nobody else.  We shouldn't introduce new mm API only to
  service hugetlbfs.

- Much less risk of breaking things

  I'm pretty sure my code introduce zero or very little bug, if there's
  one, I'll fix it, but really, likely not, because the changes are
  straightforward.

  Your changes are huge.  I would not be surprised you break things here
  and there.  I hope at least you will be around fixing them when it
  happens, even if we're not sure the benefits of most of the changes.

-- 
Peter Xu


