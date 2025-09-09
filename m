Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C180CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A886A6B0007; Tue,  9 Sep 2025 02:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FE78E0001; Tue,  9 Sep 2025 02:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99CB76B000D; Tue,  9 Sep 2025 02:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 89B7B6B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:28:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 382D7119BCC
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:28:51 +0000 (UTC)
X-FDA: 83868733662.24.A97E59D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72BB11A000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:28:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HEKaAma6;
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757399329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyfaMLhE+eR6r1x04SbjrHAzIJx46jGGeK7FcNu4fRE=;
	b=5J3nH6V1qWWiczP9dXg4gCABJByx1089oN1ekUK65sIbvNINrLHTifh/ykBjw/tKWfQa8w
	bg28J/YtyhdADn95XkEFCLA2v5PIgVvZ6PJEvnhwV11slufWZWhrXOr9RqXx8e5VyJqo9q
	5+SFC2yCNFH31GYARDTuHR4z6CNIvXQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HEKaAma6;
	spf=pass (imf19.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757399329; a=rsa-sha256;
	cv=none;
	b=IefLvlrdBY7MyvOE8yH2wbH9TzkmHXji8xrrmrQflz+EGQQjVGNuk5VcBbUNv16gUwbbEo
	3mJ47ZT+3kP/pxfWOjOBZ6Vuesi7nhvKQZgdfNeqBHZr/1OsEGG0OjvJtN9cUvSuFAuMi+
	QSTniuORlMEnymNjoTEfvVY6W/8V/vA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757399328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GyfaMLhE+eR6r1x04SbjrHAzIJx46jGGeK7FcNu4fRE=;
	b=HEKaAma6o3A8SYT6qaZp+dZs3hxVPOCxejl8nwLQXuxItqqSLwOGgyCLodgLuagjUu+l1B
	Sav40bUz/9iKiXfIQjGMFnqkhqsq8cks6OFlFYl/OIBpdleMcdTc+zC4u9wMjtlZZs6aBs
	awmuWBDXon5CB/vxhiXLCzo1Crw/LGM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-rzDKvLShMXasmEw3AvcgEg-1; Tue,
 09 Sep 2025 02:28:45 -0400
X-MC-Unique: rzDKvLShMXasmEw3AvcgEg-1
X-Mimecast-MFC-AGG-ID: rzDKvLShMXasmEw3AvcgEg_1757399323
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4336119560A7;
	Tue,  9 Sep 2025 06:28:43 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.88])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7A1319560B8;
	Tue,  9 Sep 2025 06:28:36 +0000 (UTC)
Date: Tue, 9 Sep 2025 14:28:31 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 3/3] selftests/mm: fix va_high_addr_switch.sh failure
 on x86_64
Message-ID: <aL_JD_vNvM2kXoRJ@gmail.com>
References: <20250908124740.2946005-1-chuhu@redhat.com>
 <20250908124740.2946005-2-chuhu@redhat.com>
 <20250908124740.2946005-3-chuhu@redhat.com>
 <20250908124740.2946005-4-chuhu@redhat.com>
 <22a9dd3e-0755-4f7f-a59c-a79a52871f56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22a9dd3e-0755-4f7f-a59c-a79a52871f56@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 72BB11A000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: phpnpkebx9xwkh5bgt9kdp9sbsy7qmc6
X-HE-Tag: 1757399329-952302
X-HE-Meta: U2FsdGVkX18JAMLgm0wU9kL+9RiUPHRDaT26zHMNDT8K/2M8m/PS7S/mrTmp/rBYutVpCQ/AVF9Z7/ODn3lJCHFnfOb6DfAv065/iZEPOaSNCRJ/9qfvDp7gCT3lu7+0SFA5HsNlt8hJlizIJnCeN5HIqf0xPkmhVf3IOnfB+2qDk4uf8nKrA2xGcDeB9dWMkc4esPtY6URF4wqa6pWDAXJ0gBYrh36Bfm5VzfpgshibrDzS2+awz1QUHCP23TgYDqlAFU1uJuyEFdHx6NRDJNYYmByR65T+ajELagMh+Sa6r/PqZTjtB+0cXMjiCy+Mz9E/2USTjuBldBUXNcPqgwqhUmDkNR2NWJZWT+UUzbSTnd+O1PmVXpebBo79NkgOxujcYFLpEGbclfxPK9136i/q/iX2sxwT7FL2VgrxfxWTvQF3BCVqLcIPswA2OtWF5nYGu82FSBR5qKa/hJcWBxRw9tmeQhKs6UuR00KgfM3fMt4QzeHIyzwyPb7P55LXTvBL+yAMDh6jrut1hlTPJANpq4RXQTLNQkhVRV7mXIRmXGCHJ1wF4GuMXNwYG92jdPAcH2gq+F+5InGJSBb4QpJ2rJ1IbN+T1v8AHemwAAzogBmEid3GP6tBuW+NSwmS+mqLaJSqS1rrrXURSezs9zF8qRPOYgyQ46kum4v9xUu88unPEx/Ri0hfqqKmnlJoPFS9PBRq6mXoKTPlofNpNvaBZlCrKxdcHG+sy5+GAbuIJ4tkMc/N/Ze/cTn+5Zdt5LgbKMzhM6K9BgK38vUppAyXZrNENhM4DrhKa9otflS31c8UcDJj7025GfTKaODxA8LHIdKREucHwn/Il2D6/a9pB9F+X4tMaz7gYHWDjpKBtzjCkVktZsKUn3SR9q0uCBqv2o8kBOI3STzKHFd7dBMrEPA0FoY90pKYwpACpLNaVXRS0/TAAOWo6hGsNloot/T43z8IdSY4uf4Jay6
 3X8Bueiz
 pToMFDdTDJYn0sWXzgO/3SIndWB6Z0XNyQqz5jc9PJCgRGPiMvdpVBcyLnPsH0McmE/YKLvERisO5qLV1xeCpbHTsGfuQFmksKIC2KLB7oiZlMXnaHIGZTYERW/BscbnxTkC9ntvGRUwSUAv5iFeYvQVPXxKEu2eTs03AbK2vtU4BdRvQ4QF6iaL1fdUy4eam7Vbu8MGqCxttmsq39Tvi6kKm4IwCezZHxJTETBEzRMpxBfdF9g7NyZtO5vkBRh2AtWH+HR/tycyvshTUJll0M1XC8huZKXCQAwRJEkgRHaJ9QnqQa7sNsYv+F7xAvzd3d4VTQX8hRrReujGBNwgojAddWZUIti2NXjmF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 03:09:24PM +0200, David Hildenbrand wrote:
> On 08.09.25 14:47, Chunyu Hu wrote:
> > The test will fail as below on x86_64 with cpu la57 support (will skip if
> > no la57 support). Note, the test requries nr_hugepages to be set first.
> > 
> >    # running bash ./va_high_addr_switch.sh
> >    # -------------------------------------
> >    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
> >    # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
> >    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
> >    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
> >    # mmap(NULL): 0x7f55b60f9000 - OK
> >    # mmap(low_addr): 0x40000000 - OK
> >    # mmap(high_addr): 0x1000000000000 - OK
> >    # mmap(high_addr) again: 0xffff55b6136000 - OK
> >    # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
> >    # mmap(-1): 0xffff55b6134000 - OK
> >    # mmap(-1) again: 0xffff55b6132000 - OK
> >    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
> >    # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
> >    # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
> >    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
> >    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
> >    # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
> >    # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
> >    # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
> >    # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
> >    # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
> >    # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
> >    # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
> >    # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
> >    # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
> >    # [FAIL]
> > 
> > addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
> > x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.
> > 
> > Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> > functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch code
> > arch/x86/mm/hugetlbpage.c and addr is checked with map_address_hint_valid()
> > after align with 'addr &= huge_page_mask(h)' which is a round down way, and
> > it will fail the check because the addr is within the DEFAULT_MAP_WINDOW but
> > (addr + len) is above the DFEFAULT_MAP_WINDOW. So it wil go through the
> > hugetlb_get_unmmaped_area_top_down() to find an area within the
> > DFEFAULT_MAP_WINDOW.
> > 
> > After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> > functions").  The addr hint for hugetlb_get_unmmaped_area() will be rounded
> > up and aligned to hugepage size with ALIGN() for all arches.  And after the
> > align, the addr will be above the default MAP_DEFAULT_WINDOW, and the
> > map_addresshint_valid() check will pass because both aligned addr (addr0)
> > and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned hint
> > address (0x800000000000) is returned as an suitable gap is found there,
> > in arch_get_unmapped_area_topdown().
> > 
> > To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
> > addr + len is above the DFEFAULT_MAP_WINDOW, make the addr hint one
> > hugepage lower, so that after the align it's still within DEFAULT_MAP_WINDOW,
> > and the addr + len (2 hugepages) will be above DEFAULT_MAP_WINDOW.
> > 
> > Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >   tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> > index 896b3f73fc53..bd96dc3b5931 100644
> > --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> > +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> > @@ -230,10 +230,10 @@ void testcases_init(void)
> >   			.msg = "mmap(-1, MAP_HUGETLB) again",
> >   		},
> >   		{
> > -			.addr = (void *)(addr_switch_hint - pagesize),
> > +			.addr = (void *)(addr_switch_hint - pagesize - hugepagesize),
> 
> Wouldn't it be more deterministic to do the alignment/rounding ourselves?
> 
> (void *)(ALIGN_DOWN(addr_switch_hint - pagesize), hugepagesize)
> 
> Unfortunately we don't have an ALIGN_DOWN helper available yet.
> 
> We could just move the one in pkey-helpers.h into vm_util.h

Thanks for the review!

This is good idea and it would be more deterministic if we provide an
aligned address directly, then the kernel change won't affect the test.

> 
> 
> But now I realize that, likely,
> 
> 	.addr = (void *)(addr_switch_hint - hugepagesize),
> 
> would just work and be aligned?

Yes, it's aligned to the hugepagesize, align down and works. I prefer
this way as it's easier and all other tests in the file do like this.
Thanks for the suggestion.

I thought we would lose some test coverage on testing if it will work when
an un-hugepagesize aligned addr is provided. Do you think it's
necessary? If not, I'll change to:

	.addr = (void *)(addr_switch_hint - hugepagesize),

or we can add them both if necesasry.

> 
> -- 
> Cheers
> 
> David / dhildenb
> 


