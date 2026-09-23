Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA36C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6852D6B0093; Wed, 23 Sep 2026 06:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CD56B0095; Wed, 23 Sep 2026 06:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599B06B0096; Wed, 23 Sep 2026 06:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38DDD6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:09:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD54A160774
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:09:51 +0000 (UTC)
X-FDA: 85244605782.24.51F7ED6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1DFB18000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:09:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a8KCWCSv;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D25We26omVRekeKf0g84Xwb1U0TDe+e4ExNK24rf2sk=;
	b=ltDErt+KvDVa0CwZG9ID3oqNL/Gh9Tp1EFahHm1dtNRNqse20TQGb58DjqzTrMrMFQVmUH
	fETlpkdxEA8Srsp743dRDH30RAM0rxyAnD+KOTD3qlU+APzMIWXtBQzVnIytBqsFyPFace
	N3/PB9NVasRXkBrfAFmBz/senjEH7j0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a8KCWCSv;
	spf=pass (imf06.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158190;
	b=vOtSyU570N++QFsx4WNsoPZkFxVWTPG3+jzCNRk/T9JPGBpP8tNe71FpN63v5P+8xZtkyg
	RRyFJUXTn1LW1o/w7Fn6ScYbSHRZov0zfUiEBDSgG/i+J9t5d+fuLYQYx6pX93GGr38WBU
	caPNSWMyUGE9olofqixVeTW7I6q8AUw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23CB7152B;
	Wed, 23 Sep 2026 03:09:45 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7ED8B3F86C;
	Wed, 23 Sep 2026 03:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790158188; bh=6CM5Lf5mkBbcs/MadegsiNfHVbtm2PeDdj51BA4X+Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a8KCWCSvFRJi9TRcshjk3iEeSP2/E0mevQQFIRMfa0W7h1QFka2XcYN07tzzvT8Bn
	 zB5x0O7Nk9iZPCfSNHApC2DfryTywInOFLn9y/cIsNXT4gXoWGlAUGaqPAjAzG9RRu
	 EOzUplyHXbiVa6klhqSEGogS0zS6fXeJjyTay75M=
Date: Wed, 23 Sep 2026 11:09:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v2 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <arOlZs2izchTdMtL@e129823.arm.com>
References: <20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com>
 <20260921-fix_khugepagd_fail-v2-2-3c2877beef61@arm.com>
 <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc12fe6-4f2f-47b6-b821-8a507eb80b46@linux.alibaba.com>
X-Stat-Signature: k4ctpdtx3yaio8h4hkzx9wo1sdm1gx6j
X-Rspamd-Queue-Id: B1DFB18000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790158189-763603
X-HE-Meta: U2FsdGVkX18u2Oz5GMKqPpoXRRjF9KsT6Ao7Jqebyb8c8Pb4sl1G9rXh52PyZMl5fRHxzX79wI268M7qb/TW5awWuXmzlDNApai0en5uRL0D7AidGiS26SgpuW26Wey9WoYFGG0ykVgkj4E0ntYGs+7XyXreCRGJOC3EtbNzA0X7eW2NtfWB3ok7cNAyLqTR4N6jzoVJGqWTEye2NRVt9H5ru5zc74wlbLIV/SlvQG50ijjoAOgR8nSTkUiNuqq3TbFamOM6mSmY21VsYCbaUx2lYKx0KT81nyeK0GTNsGXl0WYbqQu0hK2eK879HLdt94GRwyZCP1VX8p01QW78fgjksJae7TDBA355WwqoVz+zYFBogPFYCAYggtjbFsUM0AaVAYNaOqv1hQpkZdfORsbVhhJeTYKJOwsPUhl0NhT7fDHl13xEESm2uDVUqfPXI2UiC1I+H+F0vHCRhwEXm/mc5hMtWiYlnz+bW+yLvq/hFTuQCvdb8R3mjDqkiBLjwF1XkmCDUBI/Mdz7MerWH2qKntZL3rraZTBPW0zRldGF4kIZrL3qgIHyMrABgySFy8Em5QfmUA0emCMyrCoAzoG/gASAA88fP1pc9PPlXRPeyb1TFI2tCGEuQsV8vw8wp37DwoiGXLrhyHhF/aZ1P8y7onckZWNiYSjXMFlmCwlVevj30Oh8SlQxvaI8RUiftxa8hcbgNpM0QhQPi5CwTTdHRJ9PcpPXpMuVElH8KcX4MS8sq8OuEwiNRNjMiGg5mDnLXnnWRGLUG8ezVY+HIqQDDgFmS9qGd8bU8AOrYv88opHxxYQn21WK496uCFUpiocuNNVS99VurfDbPU9uWbdRbc2Glb2twEy1M51S23OnoqbeXwQk8qr/blzPA++3IVssARo6F2uiJh0MvsXissQOwuuJ98IhrAndydzv3QJPCqaj42b1khEZLxj+QGMIwSCbk4LRXjB2Qw6MEtO
 HdZsrIjH
 Mcs3lAmbrp91N5jH69EPi6VaP0GgtbRnLm8K689ykyyHv8K09oo0hl3TQLgcz1mxqOqhustOqVJjEel1J1yOijI1ivokYQXNaObqCHPvKmIK2mRkfo0To7RryeiD1IlhsN38R2khTlo8ObN4glA88MPOFQlC/kmt4v3NOOrxXB4PDVhOGyXZLh9U+w/KGN+CtyL0RBgfW4thWQ5wlOAH2wO9+wnFgA72UYja6qj9WPlNXWWkCXQaz67BA4hFy989cj+iwjj4sFvjvhA4rDRK+ZnDeqZgLl9GfDx628iI/MVlN3q2BvcgXF6OmB//I314vq0So
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:28:33AM +0800, Baolin Wang wrote:
> 
> 
> On 9/21/26 6:35 PM, Yeoreum Yun wrote:
> > There are intermittent failures in collapse_max_ptes_swap() and
> > collapse_max_ptes_shared() when using the khugepaged_context:
> > 
> >    // while running ./khugepaged -s 2
> > 
> >    # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >    # Allocate huge page... OK
> >    # Share huge page over fork()... OK
> >    # Trigger CoW on page 1023 of 2048... OK
> >    # Maybe collapse with max_ptes_shared exceeded.... OK
> >    # Trigger CoW on page 1024 of 2048... Fail
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 23)
> >    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> >    # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >    # Swapout 257 of 2048 pages... OK
> >    # Maybe collapse with max_ptes_swap exceeded.... OK
> >    # Swapout 256 of 2048 pages... OK
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 17)
> >    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > This happens because khugepaged may collapse the pages before wait_for_scan()
> > is called, causing a sanity check that expects uncollapsed pages to fail.
> > 
> > For example, in collapse_max_ptes_swap(), after faulting the pages back in
> > and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> > before c->collapse() is called.
> > 
> > To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> > collapsed by wait_for_scan() for anon. This prevents khugepaged from
> > collapsing it again before c->collapse() is called.
> > 
> > This failure was observed on NVIDIA Spark with 16KB page.
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   tools/testing/selftests/mm/khugepaged.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index c32244b565658..1aad4bb427ece 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >   		usleep(TICK);
> >   	}
> > +	if (!strncmp(ops->name, "anon", 4))
> 
> We usually use the 'if (ops == &__anon_ops)' check in this file to identify
> anonymous test cases.

Yeap. That would be much clear.

> 
> With that, LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks!

-- 
Sincerely,
Yeoreum Yun

