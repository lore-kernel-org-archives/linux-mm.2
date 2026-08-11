Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35855C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277F96B0095; Tue, 11 Aug 2026 12:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DEC6B0096; Tue, 11 Aug 2026 12:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0F86B0098; Tue, 11 Aug 2026 12:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAF336B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:11:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56AC8A04FF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:11:14 +0000 (UTC)
X-FDA: 85089478068.01.1B2003B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8137C40008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:11:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMjLXqCO;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786464672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un/OfXb3LOyN540R6UlGcb5CTwWvA8koOuzxF4qHLao=;
	b=I2R1V9+tI8R8/cqFnD1hgUM5FyzoxPtyStK7Hyu1q5vkz6Z4r3FSbLH8339D7lUj7GK+AS
	cplTz1Tv7U7RDY3nOS+/alz5kpk2Bg9cu9yrRU3fSXqNmGCwSw6aa+lCqXXgpe5TBCBTYs
	ToofgQKiFWJcvLBIdDGGWuaKikAocsI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786464672;
	b=zzXRdzYDgSolM3WpwEMpQtnfNrD9meVnyairC8ZKZNq67xin/Y41T+yLgH7SFeGE++h6zF
	gWovsov+olsO+FKJLn1Vdi/mjsX0dALoBiMbHbdCOoH6hqPgZ2cln/600NDq2C6V8nVCBO
	5RJqkWCwbbmppLSfc//7ckUgw+VxeVk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMjLXqCO;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2407418E1;
	Tue, 11 Aug 2026 16:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728441F000E9;
	Tue, 11 Aug 2026 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786464671;
	bh=Un/OfXb3LOyN540R6UlGcb5CTwWvA8koOuzxF4qHLao=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jMjLXqCObthVZJds8KrwkJZ8tG5aCvdK6chypyAltVhQgquuxxqwD8Fzn2Ha2ux+4
	 xd0LOndlPKYnD5c8PUDY/IGJa+cfz9/5Fyq8j9gqBg5m52VYrBlpA6Ki04Xd8Rc2ZB
	 Tkk5S0MIF1BwLc1xP5NMqtv0iEUG3YQEWIgfQr76LuiNTNGNcuJkoQGzNIXfTC7lBT
	 tNbXExTKLQLJ5ITFP54eBbfdkefM32H8BOhQwfUmZKcEQOfCCU+jBU4EZNBWMfaIqi
	 DfWC62ShGtIj2LNVrmfXfJ1Llhym9HpP/BVIPMIBc+Kay1xcjlexlcgvX5SC+xb2eo
	 UaraW2d0LIuDw==
Message-ID: <db04536b-a98f-4025-a095-9ca49de10e12@kernel.org>
Date: Tue, 11 Aug 2026 18:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: Fix soft-dirty kselftest supported
 check
To: Audra Mitchell <audra@redhat.com>
Cc: jocolema@redhat.com, raquini@redhat.com,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Colin Ian King <colin.i.king@gmail.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Andrei Vagin
 <avagin@google.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
 <20260806181843.1839943-1-audra@redhat.com>
 <20260806181843.1839943-3-audra@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260806181843.1839943-3-audra@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9nxo78kghizggwn7wr6gs5xeokoeew1c
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8137C40008
X-HE-Tag: 1786464672-840500
X-HE-Meta: U2FsdGVkX1+5lEuTh+4+uXJlUwwbSJKpwQ5DBw15oaICmOfarcxfNfcm28ur5yNA/zBxee4s9TzWsso1SBp/PvbAT4SY0s8BeDTx6TUJHysjDV2TrR7/3S5huPaBeWWPvAxLN4llxrrrY+8c1K2JkSdUEi9QWP6s2exF6CtlqLBuTIJz+Q8efC5WtaPdUsGWumMvpYej6r5neSQ3WS4FE/HvUVCtJUnlIJd/0yeRgzj5jLJFz4witkN0Y+lQvq45PM5Kj9iGfQQ1RwVxlb4VrjLO8uQHisxwR8r1inroyCw7BMgWbx2wpSx667scYyNQ1/44Th87cOnAUknVx1pHulO2HmAWEZGvz0On0fW2ecWHWREHg5t4xwH9CEjdzElINDD1yyN+LKSZ2MzOkyrYzM7ZDRegZ4msvbgzLcMO7rwtLDAb7kOlDf7k0X5inKq24TBGpdEcJxw85j18Qoqk1UKi83FCEg5HeIsJM5ns8hqk5vAS1WUmyosQW5TPaVvaOlbysOrFvvpbSlKUBANnbDry552FM6k81OLyt5PVz40y/w2RQ1+av0WlXNWOJ3Lbt0nxbzBfVy8b94Wbp9W3yKZVo/ue1SxrUtYCxtxick2O8uLY4nAVXhjbtpOukQ344kniUTzX3KTaFM92myXBjVs9niROoVookNRIXbtBiGGK84e+t6Ki8MS1RG5W7ktIltsnq96pf+puNs9eNYzSkIyOELbrztCayR4sv37jKDGRuWASrsIhmDdqd0D2gPkkZWTypDoc9N8AR2CyldlgZ3p/e/1ulRFwC8OMVFiAT5T03O9jjiNTj5vyMMylrBXl0ISRY5LuA5vdgZHhQqOdgrAFGTL1rc47OXmI/v1ocJOE0+Y6+1auRYTM2Gw81aFaC0Q8bBTb+MV+esAY9c4bdA07QPtVeBmFCSdkngOEgSbQLZtqQ6ctBmaxE3fvnul6mAAblw7ANj4JBOY6+M1
 EvmibhVE
 /3EVFZlrt3B8/z89QUCoTxvxWxSfJVF9eY41JJWlxAWUd9bBQ5z7rDknd69AyCVUhHHKXRNtRxt6B27Jr8XXrQ17hRN7zUoo1NaJY1hVDuga3IOqL0OzSBfCMlajR6CT/FK4V3Xrdhg8A7VSjRRQymjMJELrq0g22T+G9euEuA+uEr94U0Qng7nsh7OKV6kG+iVX65KlEbyrW3u1kbzQlR+r4L6kYIQN5mAC+Gql1uLCsAK59L+1YiFibcEMmQ8ogUJuSGE4F4B+OHj1WDYEtMW/HL8d7tjO5VuB5Hac0UFDOVEgR/WEePOIqmlWP0jt+4bezI6CgYslFHg0ZoOAxqNgOaIfVIaz4w0YikQjbSIBKh38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 20:17, Audra Mitchell wrote:
> On architectures with separate user address space, such as s390 or
> those without an MMU, the soft-dirty kselftest may fail when checking
> to see if the feature is supported.
> 
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..15
>   # Bail out! PAGEMAP_SCAN succeeded unexpectedly
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 1 soft-dirty # exit=1
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
> 
> The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
> an invalid address for the page_region. This is done intentionally to
> have the ioctl return with an expected EFAULT and with the correct
> categories returned.
> 
> However, on architectures with separate user address space, such as s390 or
> those without an MMU, the call to __access_ok (used to validate the
> variables provided with the ioctl) will always return true and we will not
> fail as expected.
> 
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
> address so that we get a non-errno return if it is supported.
> 
> Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")
> 
> Signed-off-by: Audra Mitchell <audra@redhat.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 6b65bd0a1e0b..4a8e339a7403 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -66,20 +66,25 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
>  }
>  
>  /* `start` is any valid address. */

Acked to dropping that.

> -static bool pagemap_scan_supported(int fd, char *start)
> +static bool pagemap_scan_supported(int fd)
>  {
> +	const size_t pagesize = getpagesize();
>  	static int supported = -1;
> -	int ret;
> +	struct page_region r;
> +	void *test_area;
>  
>  	if (supported != -1)
>  		return supported;
>  
> -	/* Provide an invalid address in order to trigger EFAULT. */
> -	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> -	if (ret == 0)
> -		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
> -
> -	supported = errno == EFAULT;
> +	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (test_area == MAP_FAILED) {
> +		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
> +		supported = 0;

You can really just

ksft_exit_fail_msg("mmap() failed\n");

here, because this is one of the things that really should never fail.
Which leaves us with:


test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
if (test_area == MAP_FAILED)
	ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
munmap(test_area, pagesize);



-- 
Cheers,

David

