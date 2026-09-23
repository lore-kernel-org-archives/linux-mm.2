Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D56BCC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C1E6B00B9; Wed, 23 Sep 2026 17:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F034C6B00BA; Wed, 23 Sep 2026 17:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E198F6B00BB; Wed, 23 Sep 2026 17:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C565E6B00B9
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:33:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54626120148
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:33:59 +0000 (UTC)
X-FDA: 85246329798.03.8A21F00
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7B30810000D
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:33:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=saubN+Ug;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqsGonkxLuJTixdtNLZefAY+K0pHqSZLan+XJO0/Hac=;
	b=eMhoynP5ROLoXxVdVekyZ8h5i106/7/yESGzt1SMSagpXbUUe3qrtxnxnpTP1A7k9zZniN
	o9fR/kSNCgZKKD6uN3qba2RM+mo2+hDDtc1ExrMCxxOwBCgbFvcysTEkpCi6jzIRseKY/y
	hnFxlqpRtk3pcihJJ4U6YylPx8eOOUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199237;
	b=xztNi6wfDVS/cbEJ57qEwEvISUDocGgymnWq1RCEhE8I+6SPom+Kmxh5xXrmAGur1Knltw
	Y/bNDxOJUMh9JZf14WZnQ7GZYlzC1LyQaAs7as2ezHQ2DUWHg4papICl2mL6AddGT/1hAR
	+z2ODoZq6f0ZWMtvzGd/lk1L8QWheuY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=saubN+Ug;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939922847efso116152785a.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790199236; x=1790804036; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pqsGonkxLuJTixdtNLZefAY+K0pHqSZLan+XJO0/Hac=;
        b=saubN+UgeppT4CR/FGAzPXP2TyBArp8uJeiAKCqOmx9AzW/m6nsTMPpdwPCOm9ammu
         iWbQkCACsuE1avB8ny2cTP2Osb9voIXEp89J5jWf5fyCOofCIC7nYQGndMOtx4VrcUpx
         o37QWJYa7SIsSf7+ZKXLx2ELYIX8YM24DtJ6DrB0ZmUjTuzFDlV8b8zdXVGvSYYM/wEp
         z0dLCL3FYy9BYMfarGrzrMZFkavINTLHqLMNJtc4ZBAM/CVb7+Sk353tptXhNBM7pL7e
         TBM0AOgewM4IwAdAo2xeXzNWa6V0GUdVLFg9cwlSfvGnH/qnDp3yeirPhBqjADx1lPdS
         zoBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790199236; x=1790804036;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pqsGonkxLuJTixdtNLZefAY+K0pHqSZLan+XJO0/Hac=;
        b=OjCfxI5QyqJG49kaySeqfodlkW1LWQzFagZB+kFauo4qLEFttF1SCmwdBrTR5OGzd2
         mAPA5pGsHoCNN4IE9sAC+MTTiiiiuZF4C1+2ESXuk49NH1dbj6KJvo9/nIfWvmld+mvi
         u0o0X7PrjQkwme7jDvp9sc99NDM+XIuuuSwCeEg6XjXfphUspQp1X6wAWL2iACIIXixS
         ubq+ppSuS6431pXJmJ9T3lfKlr3XDonzBMaAce8D57G5kpuHwvvLgdYhNKvPN3MGka/U
         s3+Xec/ZCjqBPnRJmEqm7XEX+s6nAAfVf3MoZCRlaAOOgf33I9tkp6dWlvJDz/VdOK/p
         FFEw==
X-Forwarded-Encrypted: i=1; AKwUvBw/kcPN5/YMnsiG2AHn4aqcmcOwyXV3xUuvBq4NwA+3bsHl7StAC8KkkZw/q+ozaYUbdLgALPgXxg==@kvack.org
X-Gm-Message-State: AFuF++mgboXwZZnTYPZA9N1xD++iUmKXMRyYaSZh5sOL9mv7UYW9d0lG
	EWruavzm+W0shgabVx1p3EEMzKi5ifOeGBwqlfiRl9tEbFfTSW556qgcRnH65iFpfG4=
X-Gm-Gg: AYBFou2ABbhD2rnAD3Xr3g3gtbR/eTrWYT16ko5K8rU/jeBatjybOnBPU+ewhw0SFNe
	pZFZP0bXIZ+lEi/W9buo42BNKNaLbHqwYA5VZZjssPhdL/1KVITmbS6O45s4VhuekNQiebXlpGa
	k5kqdtvl3OfuyrjsAcgeL0+h4rp1JnpLxJh9WGzBVVAZ+peXBgUF+sZis2IkYcToRo+kkooOn9n
	X214yBtSeoJbScLAPWn32zF77Oi635vPCdMRrYsBXxWIFU5yKiz1w7/uX3n+edj9hi1/jVADAC/
	ntO1ctcVoil5vMmkMT+YJdju7ym2ARjQsxI2wGYXgbWicOv1xMgUDqxx9hwkoWYGNkvkVsv2JLb
	7TYKLhZl99brVHecx+b9txspF1B5QtPtiBaYtzIwjdcFsPV4oG0OoW11rN/bNbgq68D5hkt0yBt
	Us9AyRkmiSQEojEOgKsvc7xivLTMxGsm9tWpndVACzJZQ4OZp3TgwQEFK3nDunaNmPmLCFRwhSp
	MCOT/MDxbFAP6MAf+gizVuS7JSOV26/7YmhgXcRRHxzHbWBHOvMFGWTdhunEcSuDw==
X-Received: by 2002:a05:620a:4150:b0:93a:1048:7d2f with SMTP id af79cd13be357-93c345b615cmr75748385a.41.1790199236442;
        Wed, 23 Sep 2026 14:33:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248e22f7sm310457085a.47.2026.09.23.14.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:33:56 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:33:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 2/2] kselftest: mm: fix intermittent failure
 khugepaged test
Message-ID: <arRFsYK6rzmax-4n@gourry-fedora-PF4VCD3F>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
 <20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com>
X-Rspam-User: 
X-Stat-Signature: 9xnbuu5dtmnqh4yptwuj4cyg3os7qobt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B30810000D
X-HE-Tag: 1790199237-394828
X-HE-Meta: U2FsdGVkX19JXF8uB1o2bMRI0oxzVn+z4481yHd/MAWc7eQ3kv4jza98IFFgB7uADYGQIONBXoj1q6QDkxD1DTbg3XuMEDn6p31ZVF1HxCTagOsDQsI6mHMliOmyplov/w0RhjUDSDbFbVSjoY6XikI0c5+1OY31EGAfFrLdXpjp3Te/m/nM/FMF5Oup7Qmwgqk7C/IjR1jnGCiKiGG+o7Ya8yU8N20Vphllqp5RVcySYKa/G5YGYEI0ywI4fbAvMfwhfA7TAdtX7V22zYImGoq0KyUQUMmLcBycB5Oayeh0FVYkPMXaMJ8+lkAyDII2PRN5KlNVxa66gDbbEaMXJrAGkBuOiQaoWUHFdbhQF4INvSTZslgbXvXcPm25B7HrmgTSLZRNy5F3BRmqOUiLxoWt9D9av6SWBhplZlupIUmEov0l0Sw+BHTyFHD3FQUjhVZ9EMemW3l7/Zzrb0S/IOr1fIq0qCmVhpiA+h3pc0NPaBPQH4qWgLPo9vPFWYxtQuB1ZHLLTt3oiM7JIK+6EWuWJWAAcc0B2DsOe4K1hnrRETS1WnVwB8dIik65Dis7BeDQe+dvRM0qTTdU7m4bqN41TJhBSPMr5sr/L75FlGeSnyWIBEgZWmiicigbVKXx5MEKgDTHyR5CekQ2NsGmOS4ysuXtFJtZ11bTfnNOuoRlgm7uDZHgTaQfJGIOwuVvxTCo7mI7FJAc1tR39LyAre2bicoSWo9bemFgBOcEXECjcFlmiAuJJ9yteRRTytOPVZj9mux3r3PPHVpg2OGyaW9Rhzh36pjytUFiBkZYCzri+Mg/FHRDC5sJ9pFvKgclfjcjpef6Ajj5je4N+nklwDQq6HG2E/dnBjhERxnuFeUv2RD8kOzPB/DD4zVQa4z8wvUWg7NyQz0t/SlrGofc/vmXxfNiI19eb2IUmY+imISh+6BZ7ufkAh5peRSyzVC/LFBwfOVTgGgdYtOcHgd
 pBsd8pDS
 iuF74vQIobRcRQSWnx0mhJ3J+80RzHeCaaYZa0f76IJoRihL5c6iHXuqTlynyzbl+DEg9DIcIX7gIZ5GXFCkqkCWi68T5vN7zkZSrO+HJo1cm0Y7BvF0KS+tW5cqe6OzOU894przMVyMZWoLJklUibzIO6RYehidvU6Cw32GRPfM10j9gdsTJNXmWT1fga6EHGFjqCJtb2rhpK/xARK6OCqE/GcUI02bwdNHXfKzO9GsWKO8tOVj4Wx2hmFsKt8OVQDfngic5a/zsJyu3gOlodG3PnVabZ3x7L3TCNRSPD/mIeFohJdg6syjis1v2Gg0PtQGK78ycRgnVSoXcKjSQpKK9HuwT5zDb6ejpfYQb6OtsEhesXfHWjHi21Ks7BlyV7xTOdlBhf9YcgBAV7Pje8tP09faicO9PK1ZmTCNfHgvKA64O2Tk665Vm8YD7bwELYNHbjlalGl7L1V5ffyQBkJQ3pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 04:29:52PM +0100, Yeoreum Yun wrote:
> There are intermittent failures in collapse_max_ptes_swap() and
> collapse_max_ptes_shared() when using the khugepaged_context:
> 
>   // while running ./khugepaged -s 2
> 
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>   # Run test: collapse_max_ptes_swap (khugepaged:anon)
>   # Swapout 257 of 2048 pages... OK
>   # Maybe collapse with max_ptes_swap exceeded.... OK
>   # Swapout 256 of 2048 pages... OK
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 17)
>   # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> This happens because khugepaged may collapse the pages before wait_for_scan()
> is called, causing a sanity check that expects uncollapsed pages to fail.
> 
> For example, in collapse_max_ptes_swap(), after faulting the pages back in
> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> before c->collapse() is called.
> 
> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
> collapsed by wait_for_scan() for anon. This prevents khugepaged from
> collapsing it again before c->collapse() is called.
> 
> This failure was observed on NVIDIA Spark with 16KB page.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

