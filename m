Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51138CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6B86B00A0; Mon, 28 Sep 2026 15:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767946B00A1; Mon, 28 Sep 2026 15:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656A66B00A2; Mon, 28 Sep 2026 15:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EBAE6B00A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:26:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7D4DA02F0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:26:11 +0000 (UTC)
X-FDA: 85264151742.15.ABD1364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E98EBA0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:26:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wcp7cHX6;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Y8OPyB+lH5YUHprZNR3SaW3cfSHre/dvyOuPKtpY6o=;
	b=qdhsMpm0Nbawz308RrlxvQJGXdScjOxr+OBTcTcsG9JZnvJOXewoyb6qkNxda4Tk0VBZll
	o85DJ0LVJ1PRQtnyJLjSsgR0/uPjcyouvUFxRaEIZq3FuhRyR4tSU5pM9nWUNCts8ZeY+Q
	86D+FDmEjtnUVmH95RlOFwljmxG/Y4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623570;
	b=EaKY0e7SZvarONnNM7v1/C5BUSK9FeVEifjQmppSBWmuZWxxPAgjxO2ytCvJqzul3GNG1L
	6ADFohiSppaCFfVJU2c6FtfjJJc9r9+cJuyJXaU9bZcy4qTGzXvL+BE8SH44cB5eB4ENET
	tOHzW5eWIuMPyqPGvH+npJ8L0BRYZCY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wcp7cHX6;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7E1C41831;
	Mon, 28 Sep 2026 19:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613A1F000FF;
	Mon, 28 Sep 2026 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790623568;
	bh=0Y8OPyB+lH5YUHprZNR3SaW3cfSHre/dvyOuPKtpY6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wcp7cHX6LWHGsQaR9T/tCd3pP+3Nwpky2kHzT10MTDkKhmA8MW27LMPfnHJWAK8YC
	 +vXO4EQfwcr3lSIQ1GPZZy2+hy6VH23tqE8KfCjhgZAJ0QKIAdiG5J+t4BFI0+uLg9
	 KO7aGLZ8hdbZ+QSsWx3hYZrL8/r5YM6CN+AB2mwngYdlvTUXfd15BksKOrruq9yvvZ
	 TIefRcYgE8qu3JEYFQgUw57Mn63WPUXYwIrFppx3c6UIyOl7JZWzlGzLWob3PCk/+O
	 EPLWWcNcONNuYqNUSC7tCX5D4iB/ual9oq/UXdC2DfBrj+FyQTBM1hX24JImxBGYY6
	 wVpQ6xWYlCFPA==
Message-ID: <335f5274-7174-4fe7-8d29-37a1ed26147b@kernel.org>
Date: Mon, 28 Sep 2026 21:26:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] mm/collapse: state what a collapse may do in the
 policy
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-6-kirill@shutemov.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260928100630.21870-6-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E98EBA0004
X-Stat-Signature: y5d8pxs6mtfixt7i454rfzea8e68hgy6
X-Rspam-User: 
X-HE-Tag: 1790623569-870604
X-HE-Meta: U2FsdGVkX1+PT+elfjG4IGdQQgtvokdfQEvqvk5SsvD3Q02/7kR5FiJ6tZ+cmaAK+mSiSj/E/lB1lsK1YHtGxlUrPi7fZZd/4I2JnatmqN7GWhDYnbnCWYmmUWqYVgBBrUVj1lj47fFCrySDp05KN0ymfuiGf25MH0j754b6C+Flbmz8FHnJ8E1ZB5h5VeUzRhs7BrxjHLF3XJ7Y9cv4kLxAovkTja52K37HjTyN52NcOpK6smOXAOWUBiewsK1AaBhBqyDINZKdL2a/GG9mk2HZLMHGWgoUiAJzjXHvrHSqpGrruCYL39LsRHCREupYKPTuaoU1NTfIET3ETB9qNH20jlEcVBLfE18iDEEm3g40DhpG7P/zS/cn+qRkOXqFCeu3j4QOLBBsoLDDhvkVl9BlaGHtoQFk7E0vfjRTosvf7N+ApHMY2fD3BgvWQttBSpi2BXRtyA0NIhAHX96MYdSn4Fqbk5ZlxeisvsS15UlxGn/Qyv/BLFE4L55U5lakoyCgvgHYzxlr/HIkIqETqmZbcO9s68j8Muri0+ctF7t1uR3/pyxldcR7pnR1EzR0H6IjuCTMDp4ywueThjFYzWcCrQ7E1p2RofX3yADIuFRI6oR6D84H6yvSTpQzLvAaTg650AamLJU3VLFjFAm/PnyViFMHiqlpENxduoFsc18e+pcK68sFYoJ0rAiM5jcq6sHs3swac1fmdzGIALcq9J3vWzG+AgtEvqJajj+3F/Z2iJJkHZND2FT4ShnHsR348hH2yljRXIrBTq/4OXugYXETcExoFLJIItY1zzBeXSAhQO/+O2xmOVG9yivt9mC8WiiMrt3IkOc9hJVYP5laWzV2nt2Q8rbWtwymOQL8lZanuIOrOgzJi3vevXrwkVvr8p+00c1i8NK5yBp/47Fo1RFMZmibJZ3JWrt8swZsVJ0DVS0/LCWvpj4x6KEy9QftEHJLIDrPFpTzIpQQoI6
 qLMwjSBH
 BCcHgqJQ9MMI7i6E95m8wjNxhrYuIarmsZ+SC0MXLbzcSzfjD5zbPwRUCHuFPcnfwmRbNvDFMolCFdo9EPfHb3GkGxQdeGmHduS8EM8XVhcb05j7eb2hdoceoie2q9S6Sd3vg/ggk/DThGU5f8gKNOQmYkSbrhzezKUWKEU0ckGPYhH1VflzB347TKPy/pxEFAmFfMdnc4WaOodvhR+HkxvXDVVq/bDlAdjwtKZBeng1yvJMx8RIdjY0WDLT3DutlfaOIw4ZZHfdHDZJbzUyUET6cS8vwyMxaoRyB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 12:06, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
> 
>  - which VMAs are eligible, and how hard to try for a folio;
>  - how many empty, swapped-out or shared PTEs a window may contain, and
>    whether a sub-PMD window is held to a stricter rule than a PMD;
>  - whether a range has to look used, and whether a MADV_FREE'd page is
>    left alone;
>  - whether the PMD is mapped as part of the request, and whether dirty
>    pages are worth writing back and retrying.
> 
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
> 
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
> 
> The PTE limits come as two sets, one for a PMD-sized window and one for
> anything smaller, so that the helpers pick a set for the order and read
> it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
> and empty PTEs only when the knob says all or nothing; the warning for a
> knob value in between moves to where khugepaged fills its policy.  The
> fields only one side reads say which: anon_ or file_.  David Hildenbrand
> asked for both.
> 
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and the
> defrag setting behind the allocation mask are sampled once per pass rather
> than on every table.  A table scanned early in a pass and one scanned late
> are then treated alike.
> 
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereferences
> cc unconditionally, so the check was already dead.
> 
> Assisted-by: LLM
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  41 +++++++++++++-
>  mm/khugepaged.c | 147 +++++++++++++++++++++++++-----------------------
>  2 files changed, 118 insertions(+), 70 deletions(-)
> 
> diff --git a/mm/collapse.h b/mm/collapse.h
> index b115034d9018..dcd117071955 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -45,8 +45,47 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
>  
> +/* How many PTEs of a window may be missing, swapped out or shared */
> +struct collapse_limits {
> +	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +};
> +
> +/* What a collapse is allowed to do, decided by the caller that asks for it */
> +struct collapse_policy {
> +	/* Limits for a PMD-sized window */
> +	struct collapse_limits pmd;
> +
> +	/*
> +	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
> +	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
> +	 * window whatever its order; any other value counts as 0.
> +	 */
> +	struct collapse_limits sub_pmd;
> +

Yeah, this is cleaner.

Skimmed over the remaining stuff and nothing jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

