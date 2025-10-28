Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B97CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E9C80140; Tue, 28 Oct 2025 09:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F008013F; Tue, 28 Oct 2025 09:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7BC80140; Tue, 28 Oct 2025 09:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 895C68013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:09:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FF11587BC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:09:09 +0000 (UTC)
X-FDA: 84047553618.02.BF18CBD
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71B3320005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:09:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rrbrcqcP;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761656947; a=rsa-sha256;
	cv=none;
	b=7uhDez/jHJ1WnvP26ejIcnjlnwnNJhB/F+JWsYJllatQ2JfwA1CrcVLkFQaRoWscST+fpR
	mo2CEITGNI0QbauVtYrGYUaerZNoE069o+fQvQwSi8sl2PEDpMFD6NTiqTWH8YFzc3VKvx
	slQfwAkOmtgQq/iC+vkV9XA7ANGgJgA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rrbrcqcP;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761656947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCGJuNdSiDHSbgE1dTHIFDy3cujeZVBX/ZxNKRqqViA=;
	b=Pz2AEniTx9qxA/yJpiIN+GZ+fOL+0P9LCqbPLOWxcQeA/eepnasmlE47aS9hgtrpyjZy+L
	c371FXFZTyUlhHkPyZ1A1NC95Z3v+bC1mdFLqlw9Zedt8vyy7ZO9IN+XtFhgKB5JVdKjMP
	BC3cp4ViegEiLaB8kzDz6KXVG/oPTIM=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b109c6b9fcso53734891cf.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761656946; x=1762261746; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YCGJuNdSiDHSbgE1dTHIFDy3cujeZVBX/ZxNKRqqViA=;
        b=rrbrcqcP/2GBG2hmKSjhBQyiGh+eiDonrbuXGbt5lD6672bMVHS548F62c8XT9v8la
         +lOvNYWn138u6MOg0cOvfoN6R4ViXK6GRmavju1YQuuR6dSA3Hej2XGPP8ULPC48qC7t
         YG8IgcWF+ccbhsISrivlecfpOFThtU4mCq6Zhe4ygGpHz4eGyqg/naCGrZiNTB3QaQ9M
         H8pOIXXoNIrjPT5TM3f9G3UD1J1F4XckIawIxKF+H2+a7+Z1XO3xa/6sOea2osiI2dzV
         0raQ2jSMKxXmpeimfeCaWYEQUpeIEaT1F0Kvo7uq13D6/jD96hYXQxdZvAR33B75FdoE
         UOJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761656946; x=1762261746;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCGJuNdSiDHSbgE1dTHIFDy3cujeZVBX/ZxNKRqqViA=;
        b=tp2ONVXltCDl6WExcEoG/gva5KzG/hIrFtCA4Lb8tXogprVMR4c3gHFKOVyiC4cqkh
         xmWdhdN8DAlJiiF2d44+nxNpKCrh6IlSeDycMAgUWin166pUat3appi56v5QdG34Ew0o
         iipi00PDmjhNtGzP/rGmfuWyUabyQySfwiZoXXoIGeGjAup3WwAuluU0xcnsZSqblxLr
         xO9B/q2Xfxr23MOs7Nk/Cmm89kLE8BW/HiscWCQ/jeYOa5FGf416Go90SaztoDq2Rfsd
         K+6vGkQhOrykDWqZ4+qERrvW2IQ2VtLTf7tdd+3Q+1l3KYNaCmKi5twQOZeaxrA/ybr4
         Y9lg==
X-Forwarded-Encrypted: i=1; AJvYcCWvxDZnMaaxfgiENv4nzR3kTcF4ThxLoE4Pw2C9m7Gfk07KmCZlhlhHOroNLogb5Lhlyq2Avm1YNw==@kvack.org
X-Gm-Message-State: AOJu0YwCEzm+Q7WLo6outXke6lKeD6Dxcv/MKRIpj5MhoewWyYpkK8p7
	8DQjG+yR9iyUuz8MhA8uX7e24muP5ZqyFsa+OMfZ2/9TMs7OcX067r8tGq7gf0GkZEQ=
X-Gm-Gg: ASbGncvMuPf9o0nR45yZPZYMKDOkWcUCkuU1KMiG8lYC+YTfx6wMOxYSx2CKVMpmhzm
	qCwZ64+00BqWM9opHSiLSU3c0nmxKU+rkDz0nXgzZX3lzLbmdnKmUhDAIJVRBV+nV063tbb/5k1
	8b6lFA63JboVrprYDCzkua/lEeuCNxp2NiAsiOMsZrB/uwclxTeqfUFnGXqH49kZwWPAZVpragm
	K8DYNurxPXmmtvzKCjKKS3AH+q3/TzqAl0oW0w+ibXF+uIxV1QIA9NQ9KhJ2lHXfhRrzxdHhC6q
	uigf9yTpazTuM3/QrwtIg0HFvl5y2q6XdTIOlhGrrX4V8pqy1lmhUSPHX6kglcR1pSLxfTfc6Cq
	gxvbpLg/+GY4wdlEA+D01h6PpQGD7jpdvrqQysht7kldMInuFD8jcTPJimt2o7aYxVYJTTkDdfc
	gdKd/AbmAoHu7OpYgWsKugJUBg5L7VxKV0aCNBTqN6kohhUFoXQ3KX58NmPIM=
X-Google-Smtp-Source: AGHT+IH98kqIm4OLBZ9BxTzNh4SoN+f3UCMEHEUjHueEIBmZ3ZFACR4imRWFssU1iLJ7HaKse0MxjQ==
X-Received: by 2002:a05:622a:261b:b0:4db:db96:15d3 with SMTP id d75a77b69052e-4ed074df11dmr43296561cf.31.1761656944848;
        Tue, 28 Oct 2025 06:09:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba386b6b9sm71298341cf.33.2025.10.28.06.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:09:04 -0700 (PDT)
Date: Tue, 28 Oct 2025 09:09:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aQDAbcpO8_SeDh_c@gourry-fedora-PF4VCD3F>
References: <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
 <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
 <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
 <20251028125244.GI760669@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028125244.GI760669@ziepe.ca>
X-Stat-Signature: uqt9mtq6muunnyt61kkb7z1uh6mzkwco
X-Rspamd-Queue-Id: 71B3320005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761656947-573694
X-HE-Meta: U2FsdGVkX1/2jkpJmMJQRh0MrictjAfWXHoaKgwGYsSBm1q6kzCa98ut1ZZ1lXGKY2umHwlOI1oskplU/mBGBlqC0pDmr9mIXvtxN9YCPxyHgd49glFcvtNPViAKzYNF5ecfeVaUq9SfDEOQ3DyhPkIT/d3pF+C/rBMsXa00C79oxuS0tcEgKRX1+aIDvjXu6SLUljF+2FJ7WQmila2JBCUIbii/8GAEOcOAS7RT257iRrPm2SfIASziBqt5vFVRbpopff0moZ01UaKyu58GH5hiYVGrd9FXO2jCuP0QPbssnK/+KJhqxUHHE3qK2U0cXHXlt49kvtF9CLxHuluQjq0iR5LCypWC6QDKry2N7A+euXAUnvwghAAfJEn4OU1LADfAXQc1shgg11iW4UqblaRYh7UkJbyaTPGfIoTxF1f9n66MDrZZ/X/Adno5WGmx4sajPFM0B4D2xcsyz9eyichG5keL8T0P9lClwfbZ8bf3Yc2fadHTAQDQE8ZXsnmDg93NX3CjDWrqkTe3bmHQYpgd4x78v0jt0NO9s/Sw9Z0LtDTIeNynNc1uLkOXoniwxqeIJ0R1LB2uKAQ9ljxflRAP7mI8UaVErp25sYmmTn985BhWVj92bv8Zxcr+hUl+erP9tEewMfa90V4KBIP3m95vqr8qKx7KqdKTbmH3S92vVD0tK/qBVpyn6cjaZCX0uAGi/atPC2sNmM8rmrqzyitN/2dUFJvsEXMvg/+OGezf1U2npKBk2fEcVpqbRz0hEZq4euq4iyvZXwFJNUYvA+9w8vu9pRR6PxiNQLvEew/rfTiAz2QlKBhnfe5VDgdJSPp9BBybr43y5s0ek3bimV0GLg1p+iv9MwXeHXpbp30xaiCf21M70WYSRv6f6I/kzfl6JVhUFat9QoRNn6vgvtbcmeZ+925sIuZs7xaurFsevUSiDfCwopOj+akkHFlVuGMc4UUWk4daLHJw7kD
 EI9pA863
 DnZflXu5gqY2uo24eKHbtV5OV2VOjsuQcV4PeRGZ4g1YxyCpnkgs0Jqk7LLiNXSk+4lP6JAF4lEkGG6BSdoh9Z4+x/jsfG4+WeiZcU66kKBJPAEzQAqTnas3AAhqFmgy+kJkjrlMj6beKbLWqSISYYl4lnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:52:44AM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 27, 2025 at 04:38:05PM +0000, Lorenzo Stoakes wrote:
> 
> The union helps encode in the type system what code is operating on
> what type of the leaf entry.
> 
> It seems pretty simple.
>

My recommendation of a union was a joke and is anything but simple.

Switching to a union now means every current toucher of a swp_entry_t
needs functions to do conversions to/from that thing as it gets passed
around to various subsystems. It increases overall complexity for no
value, i.e. "for negative value".

Please do not do this, I regret making the joke.

Regards,
Gregory

