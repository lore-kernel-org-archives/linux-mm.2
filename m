Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38244CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FAA6B0095; Tue, 13 Oct 2026 06:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536FF6B0096; Tue, 13 Oct 2026 06:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427016B0098; Tue, 13 Oct 2026 06:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18BAA6B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:14:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A84C8A86A4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:14:14 +0000 (UTC)
X-FDA: 85317192828.29.33912BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCD3840007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:14:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EwlAFwkD;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791886453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M49H+NAkT6bwxKVcjniJdPthk++HJ26cnK1rcwI5YOE=;
	b=B2OhFkB4LM4m5YOBRFfDEYX0GbZufcFy+q4ohIs5axxnXnk0id3ggRWW18Oef4T0gP2lor
	sPrTxpc4W0IPMxT9M60170ScQmGU34FmEAAlivxtnd8LXCUvhy85STcoQJYGPpjz42lfeS
	02ZNpDduOGXqB5eNzwt08MMMqOALShw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791886453;
	b=WspfxwEMhTi1/C69WTgeT6nEmdmprDdraoWnQOG0ibnJ6PQx1/dD3vXj5UrCQOGnZ197nV
	T6etmhE4TWIT4cgAdUA4Xy+u34FgW5a0Tov40Hwz18EJ/2UIvvEkFFFMy0cmGBRlpP+v7a
	0umpM8+O32RUUHE04ItSQ/b/bXctxI8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EwlAFwkD;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2D21169C;
	Tue, 13 Oct 2026 03:14:08 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75FB13F7B4;
	Tue, 13 Oct 2026 03:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791886452; bh=CwIINxwYMx735E6F8s9ep3Xem7KHZ4ZBlh/HyIgAbgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EwlAFwkDH3DXPIhTH/r3Gq7gzfPEvks0fkmwjKTIIEU8lU7V9m+CEaFGUJ2qIKkcH
	 LBg1oIHubi4Bc3NZ0+tI90c3UVa78sskD/3IZOdXFNrnVPDx4Ice2OAwYQT3Uerlxg
	 RYruN74ALtEB3aq/oz+lABH3jelhu/OBkGnIJslI=
Date: Tue, 13 Oct 2026 11:14:05 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v6 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <as4Ebb8GQmAfRb5r@e129823.arm.com>
References: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
 <20261013-fix_hpage_macro-v6-2-2c52d0484de3@arm.com>
 <40f95078-4d3c-48da-9262-afadf231014f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f95078-4d3c-48da-9262-afadf231014f@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCD3840007
X-Rspam-User: 
X-Stat-Signature: 8owrueas854dkmurxpkyawtb3hyae1mt
X-HE-Tag: 1791886452-274745
X-HE-Meta: U2FsdGVkX18xMQLEqHvhJHc7pKn3FQ3yPu85MwonMvngjNQnsyxabHU9tMuM/cD7TM+TdoRJZbBTQczc+oTMrC/jIjyOR1QAt4G3kn04jlTSzC6wxNG7KxOtSrpbAIR8iWNJp+sgyDlPlUqSGwDqszOA66hV7gmMleU2mtoJjIfWTCklIDM2Z2mQrMTxGmtvoKXyP5i/JXz4yp+m4ItBkOexuhTzoOWslGp1QCSqRwTYw1d5BwpLkQmRh7eQMpTT6g5BP8wEulcKaiDosXF2ZrenEL4lXIUwqFIroGXCjcqrz2KY/UbNK5JXJ6Q4jXvtFNWJqvcHg78sDDQqU/KUao7TutPi044pIRPcDhEH78WRnpdEooS5Q/uzCu449POOUp/WIgXe9UvmOb7W4CmatcG4Y7eFh0FM+RxYNBwmjARNAz3W6Z/w0jI5L2r8iLmOoWVbHY2/dQNZyNXhPKehtrfXhjInYUsj3wwhad5Xt3tcY53uU1iSYvXaISCUu+WZ9WIUp4Klfeh7oIqJIyboknm/MgtBy9B2+PCiCnBOUcqnkmy7hzboTQQ4r8f5bvTjzb0QaBLVp/apP9rfkTJTKaDxgukQqex1Vz5W+IJy535J1dsSTdqD61wg+qiV3yJl9IlsSFQw5PdF9BlxlrLBXunavGfffqXbJ6dL89/lzx4zfNKhojwoAuMV8Aa0ocgKbS9ompR9nn1UhXnKB3l8/q4FDOcmig7szULPea3mhcr2iRMKMy6mz7XL+H94tOGKU+ODg2G6yQn0QRw3Gpon3QVVCD0qtdochC62cJ/nHSKO5rP/2lsEF4rK2AzJXTmsknzLqxwCjGjqCRvufveRAqs8U5kbEX23qJBtb9WclXYPZWWFRMqmsLKe9D3qO/2PjT1MNg+w+AK/kS4929uc2JltyArCSvcw8JNsx92JymnUjWr4MDsrc4KgauRVrIj6Wo8NHIfQqk5pY5mUlxR
 uDg94nxT
 +h41lM04R0Uh7u4Q3gZGSBiC19yLLMX2kKEJmuS3BlR61pWDkkEydpoz3ttZPvyRIx34T0IMBGRwap31V1WF2ECxyi3U/mTM3gXrcJ9HeQXAs2LzW4V/4I2dqvrftqqnlcyZFj8RESETRWFRRoKIfaO3JY/pSEtaeEJHBeA1OytWHKO55c2V3kZSmzXb0cTyUEUiKbCkhv2AXlx6Lnt+iO2QqIbbEs596J6XLGdFFsleI7jXytu6DmcZHzi29oYKr/CuiVaJ/8fEvDHg4KSgIjwYTAIBSmVTRZ6aLCmMwXzfmbbPDkTZACiqREP3gWIRYmHaK27kv/5omZOQMrE1E04iXzBe9Q/N+UXvNkWAo18RE9GSnkH2BigbT5lyyqp6hgO74hpsF6XisLu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 03:26:40PM +0530, Sarthak Sharma wrote:
> Hi Yeoreum!
> 
> On 10/13/26 3:16 PM, Yeoreum Yun wrote:
> > HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> > When this macro is used in some test, test result would be strange in
> > the system where PAGE_SIZE is more then 4KB.
> > 
> > Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> > 
> >   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
> >     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
> >     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> > helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> > helper, pmd_psize().
> > 
> > Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> > which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> > and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> > PMD-sized units, the test may fail with the previous size of 100 MiB,
> > which is not a multiple of the PMD size when the base page size is
> > 16 KiB or 64 KiB.
> > 
> > After this patch, output of transhuge-stress:
> > 
> >   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
> >     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
> >     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
> >     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
> >     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
> >     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
> >     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
> >     ...
> >   ok 1 Completed
> > 
> > Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> > index 5f2fb5b819c4a..efd99298be135 100644
> > --- a/tools/testing/selftests/mm/vm_util.c
> > +++ b/tools/testing/selftests/mm/vm_util.c
> > @@ -21,6 +21,8 @@
> >  
> >  unsigned int __page_size;
> >  unsigned int __page_shift;
> > +uint64_t __pmd_psize = -1ull;
> > +uint64_t __pmd_pshift = -1ull;
> >  
> >  uint64_t pagemap_get_entry(int fd, char *start)
> >  {
> > @@ -161,19 +163,40 @@ uint64_t pmd_psize(void)
> >  	char buf[20];
> >  	ssize_t num_read;
> >  
> > +	if (__pmd_psize != -1ull)
> > +		return __pmd_psize;
> > +
> >  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> > -	if (fd == -1)
> > +	if (fd == -1) {
> > +		__pmd_psize = 0;
> >  		return 0;
> > +	}
> >  
> >  	num_read = read(fd, buf, 19);
> >  	if (num_read < 1) {
> > +		__pmd_psize = 0;
> >  		close(fd);
> >  		return 0;
> >  	}
> >  	buf[num_read] = '\0';
> >  	close(fd);
> >  
> > -	return strtoul(buf, NULL, 10);
> > +	__pmd_psize = strtoul(buf, NULL, 10);
> > +
> > +	return __pmd_psize;
> > +}
> > +
> > +uint64_t pmd_pshift(void)
> > +{
> > +	if (__pmd_pshift != -1ull)
> > +		return __pmd_pshift;
> > +
> > +	if (__pmd_psize != -1ull)
> > +		__pmd_psize = pmd_psize();
> 
> Kiryl pointed this out in v5 [1], you might have missed it. This check
> seems to be inverted.
> 
> [1] https://lore.kernel.org/all/asj4dT2Q__SlKhgr@thinkstation/

Oh. Thanks. I've missed. 

-- 
Sincerely,
Yeoreum Yun

