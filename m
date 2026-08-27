Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A2FC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276786B0096; Thu, 27 Aug 2026 06:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200766B0098; Thu, 27 Aug 2026 06:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7F96B0099; Thu, 27 Aug 2026 06:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D31256B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:59:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B7C6403A3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:59:47 +0000 (UTC)
X-FDA: 85146754014.08.0D7226A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A01E02000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:59:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvYFBtsL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787828385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTilTslFKE7HZzvpGDxb/7pQm9deCdXcalmACc05fDA=;
	b=nWzfWpC4EvGGSRbb9z6QsGr9w8GQbaFEs/R6IQxFrsMZGaRggpzyAGjzrJlOc3s5Wmmj16
	CK58Qp7hNjpBD4osFT0/ZfXzC0aNORzLmrnLU/IaInimnwil2+Rnhp3RWnLcU/fDshOzk1
	IML5YOgZvb3pXQYPVlKoGmx3krbPdLc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MvYFBtsL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787828385;
	b=vFusycklWZnaYkovQzIHwvO9ELcz4cAnC737cUixoY7Gcu5gijFSwwxGS+99lW/B9RUcg+
	41Xz0XXv5Qnb2xaXwYJKN6XnXvyJnSAWeMZ0d6zgClfuCFIZ/KbiQGhw7mxSX7NYgXBMOS
	17Reng5J3mBFrQnFegbukW8APwYAcKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0024362B;
	Thu, 27 Aug 2026 10:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591E11F000E9;
	Thu, 27 Aug 2026 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787828384;
	bh=bTilTslFKE7HZzvpGDxb/7pQm9deCdXcalmACc05fDA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MvYFBtsLuN12Pv0VYkQqjjOnhY+Trb2wLo+zJ/inbaSWr5pK8xH2Y20XiDGpenOyn
	 +2nNPn8DM8OTv5auP6DUGKTpphrD01FgumMLW4Qno5g7YzDXd1z8jkf3zVpXgUR5Fa
	 fF85EdWRqkmqneUsKEp2tR8HpiCUuw2yxkmRxdnOKx55/Ge84j6+f4ZnbS1FVN1JaK
	 BZheMGfoAZI5HoqHHuKKOAkUz91NFUGmUyZX8g5w2yEhRPzBksfllRnSNRfAo5vSf6
	 iDVKKRN/CrF3ED8Rohmy7F9jAPaDEtdWLoAbo839LWarJNoUOCgeWLnqoiSpqJ2Spl
	 Bt4yCE4M9ePXw==
Message-ID: <36c54170-f7cb-4b1e-a1fd-50544390632b@kernel.org>
Date: Thu, 27 Aug 2026 12:59:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] kselftest: mm: prevent random failure of huge page
 split for khugepaged
To: Yeoreum Yun <yeoreum.yun@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-1-71153c7f579a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260826-fix_split-v2-1-71153c7f579a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A01E02000C
X-Stat-Signature: 5oizxmu4cs949jkzwqmbctefbmeqcsuk
X-Rspam-User: 
X-HE-Tag: 1787828385-686299
X-HE-Meta: U2FsdGVkX1/iMGMQx1f997OvjgPjx++O8zte7av0HW5EX9PbZZLAlyU4Ej/EbywVqWSZRs4pRtjnckt/dZvAIivHDOKJgAq2WCs+3kVfPpyka/irfZgnm7mMb2NPvh17JxhZmkWwo8FisFBtcMyXSRbE8kBFXXDrmU25xQO0Cfqz2uVz6i7HfxM7eCimd+hnUvr/y8e1W575C1gT+o+thGIxBK8xs1aod0sh0BuIEQnADYZagJBnaXTCvtmB9vTcD4vCEmQDIxBgqtpvlpkeuiM1CbgOK2q4RdoKs+yDvq/JMcZFaCCVQlixZhCr6igSm43gusSmta8hdBRfigFvSK2Cxy3ZPh+Um4mYcMMlPJBUGGoZvR77ho8SUyx7QKixcPGUgzaLlfMAnnlkxymjyE6oAHyIrTGR/0qUt99AyY6cY7JivE3tjSS1pC71Juui/+S9ZqN0WqMW03w0WOBoEwpZrPfHGT6GHpoyOPJE+3vwdyj0Xuu5OMBF59bsB5DyWxI4S4FRDuAYyMPg6g1hieFjCQIyuqr0Y+gQKVoMWB3J+9XekKCFGA2IO51VAD1xLBQAPwtjfoD/G62LjFKeFAZayalDiiXx0Bjn74mL6iTMi6rTshWwxUmNBO+PslxHMvD/U0w0AVp87GT3n26FBkt5yvWfh/sL4uYLZZ6CgTjtVCAzpDpqYknGhASUB2aixcGnTpL5M1WVy5gMNoMtFrkXZdqbMdrEV0KUZU5iowpOhZavWv8xVy4RixRgKlingpCTDcmgRlT/dgyfHQzgj8Gje9Koj/gJEA8lln3QMxrLZEQHfy+cTjNb3fxEVI5dqmInTv/l3vNM2wNTGWN7GS/cXofpZ9XNtO+kpTQwULB+OKjwUcfJ8Ecsj7X1yIrWPNEXmLf5Okscnm0wZ784HgqzDbvoC2ddeTcQc9w/pU5iAeyVdd3pge3/vgV50Mh+t9SqjD26mvepmEJaiM+
 K2M+dXXH
 BXQ99nNNIQKayuOUeQNk8AjMMpZ92xqocOpjUNN2DG5HVsgn9g0QX0AxbNM57zggKwzyWjY8NR3IAlqYp9Yr+1u6Kd6esBDmurHHiDjR+gRv54sQxRckHNspTxpMM6Qc0a5sMUqUDDQFa8dLF3AKmRh3My/ybt+PdfDhPbEGTqAkQDYiVuTT4S8GvG17Uhcp/PXzhC5X7lGTkqQZdNoDVQHj/aSfSiTP8n6lwnGN2CSbQFNWG0LdWnYwRoySNFhfMTTniFNkVYzDsiMMK3YaM3Ton56bSI2eghIk+Ao0E1kID44fFAg79M7i2RA4M0bMifoWNLjDKK1MpcWXNOUa/EpEXdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 14:24, Yeoreum Yun wrote:
> There're some random failure for split_huge_page_test when khugepaged
> collapses pages into pmd again which had split by the test.
> 
> Prevent the khugepaged's collapses for split page by setting the
> mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> 
> Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 86a603692826..8f68bc94a5ca 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -180,6 +180,10 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	if (!rss_anon_before)
>  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
>  
> +	/* Prevent khugepaged from collapsing the pages. */
> +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> +		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
> +

Ok, this is really only expected to fail on extremely old kernels or kernels
without CONFIG_TRANSPARENT_HUGEPAGE (where we should never get to that point :) ).

Can we just turn that into a
	ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");

I'm okay with a ksft_print_msg() as well, but would shorten the message quite a
lot ("MADV_NOHUGEPAGE failed" or sth).

-- 
Cheers,

David

