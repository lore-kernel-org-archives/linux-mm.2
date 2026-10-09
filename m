Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AF9CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D4E6B0088; Fri,  9 Oct 2026 13:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE4E6B008A; Fri,  9 Oct 2026 13:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8D86B0096; Fri,  9 Oct 2026 13:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD3206B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:02:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D88A1A043C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:02:51 +0000 (UTC)
X-FDA: 85303707342.12.8B6AEDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B4C344000C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:02:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Myx2bn74;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565369;
	b=gw5DaXVkp+l+HJLXUytalRkcxAI78Vw3mQo9USZ6KrhTX6UNWILvCybD6PSulYPKirylGW
	po/orclhSDMHfBvSLya/NGo+76BBUKil2VcJ5CAXYT1aVa5qyicTRlZIFWt0JEcVv0xtqh
	Q7ySBT0jqVzdednhF0OPL49txNOHIjk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Myx2bn74;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iltjMudktSKE0S1aNS7P4FmpXghrJyhu3qRFPuHuB7w=;
	b=xigEGUkbHLuxxe1DaV4bzPIHOJwN2ZjtFJQCmxw+mUeprwFpLahd0pSFb4qLVDntgrtLat
	P/+Zd5Ew/Ss/kv7gh6/Vzimmhgq5PSPdInm2D+D7k/1DPi/Dk4c5iDClgnx21RLzxxHA8B
	OwAyfXoHypfsztsBNxuNaJgkrylXBPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02A4943856;
	Fri,  9 Oct 2026 17:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB371F000FF;
	Fri,  9 Oct 2026 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565368;
	bh=iltjMudktSKE0S1aNS7P4FmpXghrJyhu3qRFPuHuB7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Myx2bn74+CsGe4sqlIoDeAr2FIBxitw6YYY5cf1fOeSsoLVf0DMU868xrHnLdckDk
	 SEwaCRhAhlp91jqlvRxC0o8GY2X6i7SoQ7V2a85+BfDoNSHsiYNFc/mAc8ZkbQ8m0q
	 RcT/VJ85hP450jqxyz8+DJJPbsyilif4e1uIapHpH15EIxIM92Y/clfpnnvBJQe7ZH
	 BkC0Ao7TWzPrXciX/52QH6HsmsKnsaoF3R+sFr4U1R7VxY9A/2JU6Y/P9fOAgQFREL
	 7OSyoMEbjKV+/WC42yi+AT1fv/wXaQePKHtNzOuIvbhpNOFwVtPTfuZXo3hEcqw7H1
	 4WZITcxY8fzkw==
Date: Fri, 9 Oct 2026 19:02:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
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
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 1/3] kselftest: mm: rename read_pmd_pagesize() to
 pmd_psize()
Message-ID: <askeLm-15RSm6zE2@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-1-54378ae45add@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-fix_hpage_macro-v5-1-54378ae45add@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B4C344000C
X-Stat-Signature: atoir81w7es3ooyoxjp5d4hni8qkskp9
X-HE-Tag: 1791565369-931420
X-HE-Meta: U2FsdGVkX192/0W/wxATElkt0HNg9lPVq5EqKNySd+/vLUjg7R7rcEuu6cdiegAixwOg7cLe7lB0+tzxmE7hocMg18PR4UQ945EH0iglmcbmpBJxlkP0MdUc5A9trB4R7ql2tzJuXX9m3twnqYNqN2/EoIMq7E9OGl/YC3GaEA01EOnlcxtdYhzEx9ObI8ucH8HSJq21JFI3WPwENb0qXv+h/cNccDxG17mHzY3qhBAbW4cXO4ezP8ho5MDLmMw3vxS/0I4zwZCIvF3xau/ZAUIapmK8bpw/qAvYkpAvBqQlLaz/JWLlZIj/CUdfgzlk+L/QzaQtJpgPXxF1WkBzrPF1f4kKDDKaT2OAoIH9ctL5myBgMEj9GOvwVvgwClErHQsa4vv6pUEym6q48IlvSNuo8UI/G+MCcZYYxXBNuw8xnb9tVkOSCgA2ZXv+ONpv1kKgmPSX5cSkVGiKyud58p6dSyWA+0/lkidhqhYQHz2/tg4syQUwsZIZU6umazWQO38lzTA4o92puz4GlXp4L02SWeOXGx6mb25Z9Ik8Uwzid1zCyp1DMD3pH8qeS+qIYrkpyZnKg8MxiCAvjyG1CviXtfyTpcJ2BRxxCX9QmR7n6diObVbM1I2fBy43EAnfzflM+9hiR1K5smqYL+GLF2X49QQ/lVMVB80IglGMxTcnkjOe6HWKy6f6E5FAAh9k1f3bNQS55DxZanUMmi6Q0y2hGHYBkbpFybJIOG6H2q8GY+gRYuUGMs3JyvVPOJV1DtyN+1fvQ3+mMsmgHjc5WQnxBYKrRDr53Nm9zzeCqkJU4z5ftvs/8/JyAx8vHWLfUaPOsSnhVWqWgDUsBwK/i71XVlfcerpNDjkgO1uk8hW9izolvIiilxVL6YzeWpFL/DzTygaf7T7GZ1neaCaDu/UJZFEZwYye6tEaqOvVpBfUDiGnWxJQZYV8LgNuzgErVLAUwu/GhmfVoe+93ya
 txqd8hut
 FJgGeT6cIHb6gDiNxOkI446NaQWNyXb0uAnXpk3zl1nPi7dROef24Lw46CLfJ43OeUUicbhkWp79ikvZ8+0KLcus2Gv4Ldng5M+/MY9BarXasHbMh2njtQRBlg7dl0yN2SM4YgjKgy1vdEs0xXArsnwW86eIF+wm8T9cAI4YSJ8mUvxhrOX9TG42yyRsf9Lnle5lcr10zL+UEI321HPsiGDSPeizAu5FnVcZ4dMGNi136zrRPM0gbujXKNwCsXufAYN5A/zwVBRCSepwkI/zXJxBb/O5tFGAvuWAM5bp5Inrfxfhxzu4lbIB6/5RJXlFWGyOJlmmztSdjeGk1z4f3BanfDhkOqVkSvvoIoXNp+0Hs910lI2ZFTKxWJRazve2llQB1CD6v0lHXmAoCdju+IC6gJk/lmX0dtXXb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 02:27:32AM +0100, Yeoreum Yun wrote:
> For consistency with psize(), rename read_pmd_pagesize() to
> pmd_psize(). There is no functional change.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/cow.c                   |  2 +-
>  tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
>  tools/testing/selftests/mm/hmm-tests.c             | 22 +++++++++++-----------
>  tools/testing/selftests/mm/khugepaged.c            |  2 +-
>  tools/testing/selftests/mm/khugepaged_race.c       |  2 +-
>  tools/testing/selftests/mm/khugepaged_sync_check.c |  2 +-
>  tools/testing/selftests/mm/migration.c             |  4 ++--
>  tools/testing/selftests/mm/mkdirty.c               |  2 +-
>  tools/testing/selftests/mm/pagemap_ioctl.c         |  2 +-
>  tools/testing/selftests/mm/prctl_thp_disable.c     |  4 ++--
>  tools/testing/selftests/mm/process_madv.c          |  2 +-
>  tools/testing/selftests/mm/soft-dirty.c            |  2 +-
>  tools/testing/selftests/mm/split_huge_page_test.c  |  2 +-
>  tools/testing/selftests/mm/uffd-common.c           |  6 +++---
>  tools/testing/selftests/mm/uffd-unit-tests.c       |  8 ++++----
>  tools/testing/selftests/mm/uffd-wp-mremap.c        |  2 +-
>  tools/testing/selftests/mm/vm_util.c               |  4 ++--
>  tools/testing/selftests/mm/vm_util.h               |  2 +-
>  18 files changed, 36 insertions(+), 36 deletions(-)

-- 
Sincerely yours,
Mike.

