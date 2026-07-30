Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7349C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E7A6B008C; Thu, 30 Jul 2026 02:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50316B0092; Thu, 30 Jul 2026 02:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17086B0095; Thu, 30 Jul 2026 02:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8350F6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:39:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14C621208C0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:39:33 +0000 (UTC)
X-FDA: 85044491826.19.D9504E8
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 52417120005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:39:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mNZiJSOy;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785393571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOg1TP69pkfX9jACUFVlU927ii/AFS16vNDFEmK7SsI=;
	b=nmiVyHev82sCUU1bHJOmr38xdkSPEWql9alr5+BnJrROZUj5ku8dnB/0HxTavS1FBHF9+7
	rdxJ+VRc+I0+ocvH4ehPjL7J6ioSwPgk2RjtlB27epoZ2kp/8To6K/r/ARrZn1aWWn23kd
	gpVgxA+g4BUVlXBVXNIORUcw6JppyOw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mNZiJSOy;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785393571;
	b=zp0c6nudbqPz83fXAwwW+f0EqJ6Jz5T4TgJCHZeF2u4nOly6k6oX1Mac9SFS/Zgan6ogGv
	pgHrSYtNbOsj8+Bg8eucQkpjHWt+ErlKTmYIAd5vYfMlA6QaiZsoRjU4J354hLKSSPFvLh
	Vp5n6ZWwN6kOOXV3rMYcmwCFSbzg4To=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e50979c71so174578685a.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785393570; x=1785998370; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kOg1TP69pkfX9jACUFVlU927ii/AFS16vNDFEmK7SsI=;
        b=mNZiJSOy2Xz1XYpWVWn/vMygKsaHWZzNG4xKLuY0g+k1+E9dqPr8/PCJGHLM8ax0Jf
         oiJ1qTSGGOp+eD9r1ThHUquTlqgG6IZrTjEI9dStP5yK8stG+A6iDy2ndzqpbCHOw7j/
         Fl8Iz0VpAePz7kfUoeyd8eEp3KTknAjLp0tA8p4v6m8AJYA0mOZYbT+AKaE/RaQu/NSg
         3cuLW5t82Y80rQvICgjwWl1em6LGMS74kPEhkVcnZ7t5xZ6UmbYISeVudmd469gaIan4
         UTTeLB/NbOuhhrKhu40FwHjK7O8C+9z+UuMJadS0CuGsUowi5ncAcuC27rY2Q4kKZQnh
         0+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393570; x=1785998370;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOg1TP69pkfX9jACUFVlU927ii/AFS16vNDFEmK7SsI=;
        b=P4Xx6Afj6kZ0NrghhqF0bTICNeTHw9Al/p8Fe/dn39nhdBuBH0AP6I542adIbtyJpK
         hIOAO9UeFnMBTuRF3xQlAABSjkCrVHNqNqnnUthnHXxJox/SzscolQBoUdPflr8gaC4L
         eG229TUXRoDFyXvqXr0X/8SKDFWlD4ahVu4mslCk9qQj1/84vjMB9L5NUPKXiC+ULF8e
         9WEySeK6ffNJMojMc0k54qpwoS5L99kDdv3jo8qD2SUbYt6q/H2F0M6z8Mf5itFrigKr
         z/CkqTlRLKd5ByKQd3t766nCo7PIIQJqUgmLTWaQwcDouFOEYYVdsz//Rr3Eh101Ekal
         UUnA==
X-Forwarded-Encrypted: i=1; AHgh+RoP1UCoBL3vMjMgbjJSkavl1ShiSicMZIrBCmjzulA4XlLvYRQn94Q2OJBgQ19sOLcp72Pn42KYcw==@kvack.org
X-Gm-Message-State: AOJu0YwTirI/TD/e4nvLrSjOrdx50uEZiR1aOKH0kxs4FIBzJR98vqFK
	CSOLK4CkAqhlorOX1dmr1/Vi8JlZt5ZWZEUz4fwbJ9OFbivXBUPCIyIyEpp2r8dM1Zo=
X-Gm-Gg: AR+sD12rmUfreL6Y7xoBl3yAQjiI9v7rQCWyTr6UQOt6uY838JGPwLOfRB1cYlXpS25
	dhZWJUkltF2eRTcTxaRRCuA/Whvyo1zwHvwd71ANe4rd9aslE86JMBOMjAyIoMDTx4oyxBOIO1Z
	8zFK4+tLrACv4jjfyTMDaeeYIAMajFdzhrB8bAWOLBSvHO5o9b5QXcKZV/ygHO5jDVqfOXr54g8
	MRVgXzYXRDdrGaJOP0MKVodHDS72WYqzIfj2llPIbhEZTy+A3G6BIqTLCmm/0Y6L/W9gLv0tpPv
	PRQEwBQg7iysR+WU3AMPEF6LXYeAm3jr/scjnE+gFkBwBFTWClMfiFYpzKz4HbCAoXkIlJCGELh
	4v8/9SZiZ+JFZtn9P4K8jlJdBANDUSxskee9BJWLOk/LkUvQOhNf6Qrfm69X0EP+ZIeL0bkeHz7
	OydCyUXzymonQnV2pAYsaJV46jhoEJxIjee3zs+357QDcZ89qZtAQpy1qMPw59s02ncRKewkoVW
	ExyEbMO5iccmZGVJH5Z6fvdxcxOGADr6t1mtiX11Bb3
X-Received: by 2002:a05:620a:72c5:10b0:930:ea99:8097 with SMTP id af79cd13be357-93486cf8599mr88361385a.61.1785393570464;
        Wed, 29 Jul 2026 23:39:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221c71sm356647085a.2.2026.07.29.23.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:39:29 -0700 (PDT)
Date: Thu, 30 Jul 2026 02:39:27 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 03/15] mm: abstract vma_address() and introduce
 vma_anon_address()
Message-ID: <amrw2v7TVl_AG5_3@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-3-e8ecfefea812@kernel.org>
 <amrV0Y7ZUtihiB2B@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amrV0Y7ZUtihiB2B@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52417120005
X-Stat-Signature: qds3qiun7c3b31eyff3s4fguqf8odn9k
X-HE-Tag: 1785393571-374408
X-HE-Meta: U2FsdGVkX1+I690oopL/+M4JH1EgMeA00XKrLeSwLx9t8zICyzeEx4cHzVpz2lk+cv8F8iU0fDeBe/Bokkgeu1fKrm2VxEPwjmSwn6IU5tzAXZFMPzPNY2mUfoNZ9A3pzu/+TAXKqdyq+VnLsV95//CLHRiVvGjHwA1SMxtmaJ3A3NYrgVZ9mDFAUXC9PmxeuPuJ2Y5886tIS7YKwgI8l4HnROTDpZmFBnitqCIj8/BAy9jBvuaZpsIL9dXiKrXNE1nizXZQLyg1ppCXIFGXyra7wWTSG8GtX/5BaRXznR0T/s3P4XDLc13prWzHCGrbp6iu/qQe7DT1iJMGMs/40z5Lx+OyUEWhHsNDP8AaQQiPfRDBDyIgVB4JjUW6oCuGlBGCWlh70m3khQZpkM72cjSjaIwdf1a7SNKG4vB6nVhxQ2flXnIQdIrIO15VQpFRB4pEtiywQSmRBHR587zko7K6KFlOmO8HJsqweGR961fd5lKBLWFWTJmevSADNF7s7i7iEoriCCWEYUoLVKQQ0lw/TPDLhOgJ70YtJJ8M9QtnE+fYTK2tPfq+SKkKUTYWFhfkY9K87sMhqHdUyWDMRKul/UdFWzF5Hu7qM2GnQPXXVuMUAHvgp2HFeKVDeKNkz273Ub8dl5DqXSScWLPvVQq/j37CJj1sUcwtyqmFiaf0g4p/WlD+TbO70aPB98kJvOkCoNlY1iAtl5g4y0cWW98XHL67oMvYNn+YIBdfeGq1AMXZEmbTKzhq40KTTYnzg+cAxmCZntDzfe6c5Ca/KVL96gMgoCQYTvVk51sNRNk/UpmdBqFLGdtWJxZwnk04pwUZmOcaPu5aEo9REVxLKvEQmGcMqHR1TdNzmFq3vKZFiUlEzbltQfWKufLywbiqxKl9ESA+ruPDECA4ekCbA+HHAoyID+o0SJasXLyzq/UO+/zvWw6ZY4FwyZSziFR5w80lZRUl6yxUQ/0yPos
 Lj0XTLF2
 FSr2YOVTJMZ/+KL4pq5FOA22TCurOPe0PRaePpBGdnbx8KKsaCyySovxHCrz3IvQ+MYwy/KmqIGIPIq4KKo2yNSCz2YWKqzwMhV9zMkDmKDSWFLQPfokP9xYXp8qheN4OdmaDp3O2yJlmhmvTpsSOaU9tO7HBtcV8UZmwQ2gEWI6n0sqIdYpzqz1OFcpUyBtHc+kIhUzXPfur3HQ3mo/0cr0WP3MqzUG9NmapK1jGhujtd7HWrjJ8Km7qYl/7ktoX0iKv9VXFiM3noPAracGzUdPN2Mt8IgLkhNMmrQftGc6q/vwySBtop2OG/o6tR0odarMr3eEulEYMq/ksF9BtskMYCDRn37gsIcC+4SGEpt+k4lpKIFujcEz/VhXr4cDpivf0of0uMQzBeEtXpYietP3XRXrO/UNUXykpCiogtlWyELALieFVCbtruLAkUQicF0AnFKG8YOTn5Hs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 12:58:22AM -0400, Gregory Price wrote:
> On Wed, Jul 29, 2026 at 05:48:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> > 
> > This will be necessary for determining the address of a folio's index
> > within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
> > has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
> > field is used for the reverse mapping.
> > 
> 
> This is a doozy of a sentence... 
> 
> ... determines the address of a folio's index within a VMA when
>   - the folio belongs to a MAP_PRIVATE file-backed VMA, but
>   - <The VMA> has been cow'd
>   - thus <The CoW'd VMA> is anonymous (as well)
>   - The original VMA may or may not also be marked anonymous?
>     (just clarifying, could be original mapper or a COW that COWs)
> 
> Ow, my brain.  One question below
> 

After re-reading the cover-letter again - my note here is wrong and
my brain hurts more.

... determines the address of a folio's index within a VMA when
  - the folio belongs to a MAP_PRIVATE file-backed VMA, but
  - <The Folio> has been CoW'd
  - thus <The CoW'd Folio> is <now marked> anonymous
  - The original folio may or may not have been anonymous
    (depending on whether it, itself, was a CoW copy)

Lorenzo you are truly doing Darwin's work untangling all of this.

~Gregory

