Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47822606B849
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqTh/yMX
Received: by kanga.kvack.org (Postfix)
	id 5C2766B05B1; Tue, 17 Nov 2026 09:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5707C6B05B2; Tue, 17 Nov 2026 09:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460B06B05B3; Tue, 17 Nov 2026 09:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26C3E6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E83F12047E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:34:02 +0000 (UTC)
X-FDA: 85444855524.08.7801A71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63BC420006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:34:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VqTh/yMX";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794926040;
	b=lRJGvff0Rz9/xqyn27RCbt3Hz7BQ8yqWPhbG/zDMiIUgrVnSi8I4GdJEUnGyxIbyYMJoLu
	EDMtfMc4fHsiLieSFJCtjiCR9xMvFJ694UOn9PEBNYxeBTT3VFIGnmW69VTlTUmXCTaPpn
	E4XZ094tZoOWctvqh2srSDDsOtLKupI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VqTh/yMX";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794926040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8lJn5i3rB8hKxekAA9fjmUZ4HWkDFl1+fq3jMpfeiZY=;
	b=0kpPZIU3/m3JkHjrw2zU+F1jEDVAhf/PxykCw9STOHDHzBs5SaOAKnJ62yEmn6OXLYmNL+
	uQ7FMR8gS+LxVs7gl0skWlDIXKIdPb8opbMf29rMG88QmmT5XN9RTK55Ze0icY8nkBPQZA
	zDEQfZCas76xoku7KpnWKq1u03bgDx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 858494108B;
	Tue, 17 Nov 2026 14:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8D21F000C4;
	Tue, 17 Nov 2026 14:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794926039;
	bh=8lJn5i3rB8hKxekAA9fjmUZ4HWkDFl1+fq3jMpfeiZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqTh/yMXXl6eU95sOIdz8nSlg3vVLthgUnKTxjjfYVKLjNA8AMU6YVK+xi5lI8yVC
	 os1kppKGNFo89igovqaicw3qmvxvOT5Ar0NKlYin4F8+GZHPgquSRzqzDoq24Iy95l
	 QX22x6FkoYYaEDI8Ki5USCIgZrvGWuISGlaitQyHSj8yXIWSsXODyUq+2Z7QwTnIei
	 M1SOdg8gUsHTanPlFcVuvoEo4JcGv3vSo2e9IO0ThicDU8a5Omf54yz7l65F3FV9fI
	 KwM0gPzHgrNwDUBzkSG0MPvrIbQJASTo0VcmdvuwUeaPZQDI+/IE7+eBwpmdec7fyC
	 UeNTm5MKweqpw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/paddr: skip hugetlb folios as a whole in pageout
Date: Tue, 17 Nov 2026 06:33:51 -0800
Message-ID: <20261117143352.121497-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-fix-damon-hugetlb-pageout-20261117-v1-1-054ef8760a92@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 63BC420006
X-Stat-Signature: s7fex7pc8xx9a8nu7kjoq8h69p1totim
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794926040-167846
X-HE-Meta: U2FsdGVkX18WcwbwlnvYaDwFRJ2PqtcqIol8k7cMB+EdlaynIz/KPasx2zxOTvY/6JzSy51NYkUzqcgBfMjaaYjWxqGjfHUpgE8ny4m+KSfQiUd+BpbzVerj8dC3EQkfcDXPB12xEYZS92KTxDsSQzWk7ywsUWLALH3CUKh5KNBu1FTQh6DP6yb5XhjapxnumBDULbAFASRW6u8pWhAr+lF7PB8kDugO24Y54dI9y1dngMicOlFeHa4PZ2JR8uUPEd7vuOG2JZ1JfU+InrmePuyyPpOexjqN2qUrk93CBmlupgZBCdqGSLpSXZM/I3Zd0yYkOXMPgUQJp0F7GkI0D5Z9iJ8iN6aMOSc2yiOZ6kUPyABUXiwWX5B2sVbeyEzzRuDTkWJQsz8t73TVjs5FIwkT1T38k2BwytWk5pcr0jg6cvfiqCpAH5E+f63NTImMo+IKGSTSys2jQ26olUOn+/sEQeZ6OEW3JAsSbQHj9soMeH7aZuT/pbXylL6J2lIezwOC3UNVfV7kr3aQ//UxE7dpVnXg8D64Oyh/+aE7I34Rp1rwQkXEOiVegbbUYmWOvP0TdzBqrG/asuMOgugvCuUG9n4NkaoV3QHd3kIlv0e1270vm8izOzTaNVnC0JYxSuFH8J5W0KMWlsuP7jC6Dc4jEa0RAd7wJKbToa69dNHHTpC5h8FnE6c5Z5v2uni8XAiOQUrSkLsm+rcZuRPcfGVwJGe1DxTO2C6icEQ9KXamkoBN0sAmcVTQkGOrG9q8Iqbb7JjQDni6jJwnHoP3Du9Z9m15ZHfaYJDqDQjmeh3FcDPsOnrPTfhqzDRHyuEffwGMZ+CoRSbnusHHQLY790i27fvZJII4NVum1XqE0SNNw6UbJQ4uQeaVFiVG72L/nrY4GdWJIjLXXXGyspHHl0FFzUlsHLH0r0cRxU3iKtaz/Ev7zT0k7VBmbCcaGRCdHH10bt0kciPjDTVKC8b
 Tecy42ib
 egSkp/A6i3PhopTJLrOLFi1Apz8jneVsh82xfOIxQj6ShoOI3xKkvls2ITsAQapku97bOtnLGxkw2Mwl2B1ouFoAeyvdWPA+mXutYphbkAtFzI06BmgglAHVnmKltgxxGUSxLVMxR5Ov/L5Pcq8TO5BHAI8lJ7Kq1py8kepxnBye4DVU42s/tKEGiVhvh1ED8b9SbM/O2tsB6I7hJ7TlaX1Y/FIIZ3Sf/R/a+cgtC54RjaPrGGX1Aa9E2mJNYObQeNryEEJw+aW+TCm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Aveline,

On Tue, 17 Nov 2026 17:06:54 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> damon_pa_pageout() uses damon_get_folio(), which rejects hugetlb folios
> because they are not on the LRU.  The loop then advances by PAGE_SIZE and
> looks up every base page of a hugetlb folio that cannot be reclaimed.
> 
> Use damon_get_monitor_folio() and skip a hugetlb folio as a whole by
> advancing to its end.  Do this before the filters, the accounting and the
> last_applied check, so that adjacent regions within the same hugetlb
> folio are not walked by base page either.  Test the LRU flag first to keep
> the hugetlb check off the path of ordinary LRU folios.
> 
> In a pageout microbenchmark in an x86-64 KVM guest, traversal time
> dropped by about 99.7% for regions covering whole 2 MiB hugetlb folios.
> As a side note, there is a small overhead of about 1 ns per region when
> each region is a single 4 KiB page.

Thank you for this patch.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> Tested in x86-64 KVM guests.  KUnit passes.  The damos_quota.py selftest
> can also fail without this patch; I will send a separate fix for it.
> ---
>  mm/damon/paddr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 5b773012a876..aca48bf752c8 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  
>  	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
>  	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
> -		folio = damon_get_folio(PHYS_PFN(addr));
> +		folio = damon_get_monitor_folio(PHYS_PFN(addr));
> +		if (folio && !folio_test_lru(folio) && folio_test_hugetlb(folio))

Why do we need both !folio_test_lru() and folio_test_hugetlb() here?  Could
hugetlb folio in lru list exist?  Could folios not in lru list be reclaimed?

Would only !folio_test_lru() suffice?  If so, the patch subject and description
may also better to be updated.

> +			goto put_folio;
>  		if (damon_pa_invalid_damos_folio(folio, s)) {
>  			addr += PAGE_SIZE;
>  			continue;
> 
> ---
> base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
> change-id: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b
> 
> Best regards,
> --  
> Aveline Noir <jm5905938@gmail.com>
> 
> 


Thanks,
SJ

