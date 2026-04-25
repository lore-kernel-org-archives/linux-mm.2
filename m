Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCABFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFC56B0005; Sat, 25 Apr 2026 05:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86D06B008A; Sat, 25 Apr 2026 05:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC54B6B008C; Sat, 25 Apr 2026 05:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD60C6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:29:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A417A0300
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:29:19 +0000 (UTC)
X-FDA: 84696554838.01.863ED47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE799C0003
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:29:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y34dj+a9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777109357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0nQD1O5RFKrT1/4S3gthXyjFiuZ98+4eZlOSbGEk/s=;
	b=AnbzMQAeTVU4G7uQ4ceAXKCaIN31XzSdrdyRQAaL5qXpb1oK9hZnnlNEBOZvTBjMkAlbxc
	YPVXgtiG0TGTd24252DPWcmcuzNR2IR0qsePj9zXFAvL5Nb36oa9/X5RtCcEvaAoAzw/s7
	AP1gQhUYkNiH3prX/HgQleFeln6sYkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777109357; a=rsa-sha256;
	cv=none;
	b=Y9sSOrCGQ64aBQEXDxxzze587L9jnYF9SzPq9yDzM1+x7Tl4ETqsqsyMVpL2FYoW+szvSZ
	uf7q/Uaij+HGSFdX6dlEtac5I8rAa3lpy6chf90wZXpEkg24P9guq7++cpc+qgwJEOx5Aw
	Jq88aHi+i7Het5b8jd2iAxLG+79q6Yw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y34dj+a9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD6FE442AF;
	Sat, 25 Apr 2026 09:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DB6C2BCB0;
	Sat, 25 Apr 2026 09:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777109356;
	bh=OdxPm+0am8+CCpi6pZkzPwdx+wjcZGCDVFDlykgKLEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y34dj+a9++HQ4jif+i2oSLTZAg5SCVwF5le+Q6ofsUuv3MXkVU4/SOYjFj3gNQ8TR
	 LziSQKp93gPErh8DkXuEByAWWuXCo3Ltcbvz6gdcCKOP0rBGBkJK3I0QI8DUH7u44B
	 DbKJ9FmJOXYR37ZYagnIMuehwjL04Wz33YmsKS1vtahCXOjP+CJ944QudGFlFleMYK
	 PbJpwY/VipTrJkd3mXjZ4EmODueW6ZM6C41U7G8vWxB08Pu6iTpnYVq6lQkjfDy057
	 UUB67fdD/qLuP0NsXolYGFEXbtW+NjUjYAmp3KuUWvSb6/fcc1QjwlJ+d2vjlWbPXb
	 h48Qc63mXWBkw==
Date: Sat, 25 Apr 2026 11:29:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 05/53] selftests/mm: merge map_hugetlb into
 hugepage-mmap
Message-ID: <aeyJYXYJ5pAy7gmB@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-6-rppt@kernel.org>
 <5cf27d20-83b9-4690-b14c-b08d34d357eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cf27d20-83b9-4690-b14c-b08d34d357eb@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BE799C0003
X-Stat-Signature: tugx5zsy7q4yeg7zds1o5ooc563p35kx
X-Rspam-User: 
X-HE-Tag: 1777109357-14251
X-HE-Meta: U2FsdGVkX1/+nojn7SZ65KjBBDCkIT34RbxGkfEYMxv8aoeTPydlNd4cvvulqrDN4NbH2J7gExzppPBhg/2FLcv3RdaTIrqopS764t2+zDELyKGzyKqaTMNBCygzEvPyWKJ8seHjWgfRP8bwe+jpJYitCSC6bEDHzIIsoQjn08o47vGd0XaSWxesmYBD2Iyb5hxsCnv52bV++85I8P2HgeppfkZIqa9hFPQgBr1lkiM+BbtYMxsCuEJGxnmdpcE6AaXOC+K6ogTeX+qYm66yxdQ8lPiO9u7K2LmQAcBYztVeijJNN57+qlP3R5ujLX3V+QGeyoDF5Pdjj0o74G1TFntyjsu5gh8m4T0N2trJEa3ufzbEvMyKQZCFXT5UgahsBtlalRvJneIp03Jz7kR36Aa8c8oMP08HKpU1pcj9wN6PPOn23xFCTL4Nzs3ctXXYANNXx1I+/s/VuV/nQEiaIlHD/ILvIh0uxkwiqKvsGhHVK+KxOSepMX3cHDe9QfjilwX4snUebOFiaNpI/nXg5/avJGq+wqEkCUs5qbkv7uIAj7Jiu584TlPxwhhF9YIPBeDSreIJqK9H3RJ1U/hEjr0AhZBG2XO26aRLKXMcS2I4ckHqq/AFgtfg00AopPnE/QNftcC2i0lZUOGCmdHVu03T8XS+/98FATD/NYd2Tf56GUecxvUSd1DWDlsPjNGGDlp7QXd9MPjwPAz9rMmoN71DYy53FWq7cvsKXSVG3Lot65604soZVNAjvougqs/bhrj0OxnWIJZ98g499DK5lZ+5/8Zb9L2v9++lA5yivsXO5AZyay+ClNigQZeRqcuwVNkGTqyO+YR5DSPVkdviOmukv3F5Oma9KDcAXwzGiGhr9RquIFS5zAIgOjMAdOCOPzPEdk61gytervYtBM14ytQTcVySb9j5bbYuReFq+L4kloFWuf8X6qFW1be3J6OHGBZIWI5gxiyVKntgM2B
 +MbzS4Gx
 4SU+ExLSUbCqRsBTcrauI7sy2xbGL95rcyKJe40YF7v4B96WDdtx1w1IbGFLHvSraNhWKvKe9SX+OICSLgg4tveCuGB0Ke/zJ4aoOjvoWpGXHzEdIBZ3qUFV1FdUj7adFOImoSwVxiepAoa3RAS735jAP0heHhm170K3anyeAU+PZeVIQUzQLX+aXpICcnWIwW4SF+29B5GdUD5S7XdTseYZwmpWj3q816vo/TyAkxQTxuSs55atffzgeFRtZlec0G8OMv7mUtMl8bf53NdP81kl3RX+6a5kQpmYsFzCQgXCB+O0XmPMYae5hAKJ/cZEkj5zgYhIUIm7M8kzWE2IhKtcEXd1BUZLBm62Ka8+Fw4j60KE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 01:16:46PM -0400, Luiz Capitulino wrote:
> On 2026-04-18 06:54, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Both tests create a hugettlb mapping, fill it with data and verify the
> > data, the only difference is that one uses file-backed memory and another
> > one uses anonymous memory.
> > 
> > Merge both tests into a single file.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   tools/testing/selftests/mm/Makefile        |   1 -
> >   tools/testing/selftests/mm/hugepage-mmap.c | 112 ++++++++++++++++-----
> >   tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
> >   tools/testing/selftests/mm/run_vmtests.sh  |   1 -
> >   4 files changed, 85 insertions(+), 117 deletions(-)
> >   delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
> > 
> > diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> > index cd24596cdd27..cbda989f6b6a 100644
> > --- a/tools/testing/selftests/mm/Makefile
> > +++ b/tools/testing/selftests/mm/Makefile
> > @@ -70,7 +70,6 @@ TEST_GEN_FILES += hugepage-vmemmap
> >   TEST_GEN_FILES += khugepaged
> >   TEST_GEN_FILES += madv_populate
> >   TEST_GEN_FILES += map_fixed_noreplace
> > -TEST_GEN_FILES += map_hugetlb
> >   TEST_GEN_FILES += map_populate
> >   ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
> >   TEST_GEN_FILES += memfd_secret
> > diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
> > index d543419de040..f4fcc7c45875 100644
> > --- a/tools/testing/selftests/mm/hugepage-mmap.c
> > +++ b/tools/testing/selftests/mm/hugepage-mmap.c
> > @@ -15,6 +15,7 @@
> >   #include <unistd.h>
> >   #include <sys/mman.h>
> >   #include <fcntl.h>
> > +#include "vm_util.h"
> >   #include "kselftest.h"
> >   #define LENGTH (256UL*1024*1024)
> > @@ -25,54 +26,111 @@ static void check_bytes(char *addr)
> >   	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
> >   }
> > -static void write_bytes(char *addr)
> > +static void write_bytes(char *addr, size_t length)
> >   {
> >   	unsigned long i;
> > -	for (i = 0; i < LENGTH; i++)
> > +	for (i = 0; i < length; i++)
> >   		*(addr + i) = (char)i;
> >   }
> > -static int read_bytes(char *addr)
> > +static bool verify_bytes(char *addr, size_t length)
> >   {
> >   	unsigned long i;
> >   	check_bytes(addr);
> > -	for (i = 0; i < LENGTH; i++)
> > -		if (*(addr + i) != (char)i) {
> > -			ksft_print_msg("Error: Mismatch at %lu\n", i);
> > -			return 1;
> > -		}
> > -	return 0;
> > +	for (i = 0; i < length; i++)
> > +		if (*(addr + i) != (char)i)
> > +			return false;
> 
> Is there a good reason to drop the ksft_print_msg() call?

Probably not :)

> It looks like a good debugging information. I'd also add the address to
> it.

Sure.

-- 
Sincerely yours,
Mike.

