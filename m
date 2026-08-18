Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C5BC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774A06B0175; Tue, 18 Aug 2026 06:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BF26B0177; Tue, 18 Aug 2026 06:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68B386B0178; Tue, 18 Aug 2026 06:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 443396B0175
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:13:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD9AFA38BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:03 +0000 (UTC)
X-FDA: 85113977046.07.02D9EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 103BF80004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:13:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFpxpa+V;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0jR2Hu1pPq47r0Pqs+isJEWmPJhfGvuqIKp7EEfJTw=;
	b=B8Z5u2oSFDWkEDtNmNe1dp69A5ndkfXa+ZWQzAaooHkX2SPD9SOBgSOF7OVoEYy3MgiIu4
	OyTi9MUjhkAUBRSJYNZ0yuez0d9dKiB+++C8NRo6c4G2h27SQDoXdde1iICTd2d0vf3e79
	FI6BGrtd8YsTANjrBoiShy9B5c/j8IA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFpxpa+V;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047982;
	b=FXc2bQ4WKGVJUTiMSrlELjFt3hi9zzmBOJlAinncHs7KlERdjNP9bO1SVW8CKfgRw5IE5p
	XRuggUYs9/eyE+CQz4YWa+oJlRwBxGrWDEHyIoKHmUngzBlkBlyrQFxgxY5zX+Wlo0k9EC
	+QzydVGyio6rxhL73C9yAjR2NiDJGGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09C1343608;
	Tue, 18 Aug 2026 10:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF311F000E9;
	Tue, 18 Aug 2026 10:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787047980;
	bh=X0jR2Hu1pPq47r0Pqs+isJEWmPJhfGvuqIKp7EEfJTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DFpxpa+VDyNxFf3wVwCAF/LrGoNlRgRvjCjGTRjTjKfT4b+1fxGv/ERL6jGnk2PQl
	 yraZ0E7SjbWBuA0PnC1IFVFYoD9mmYEnFP2xz+zsYePqKxveL19B0ISHA0XDziIU1S
	 a6SizlDZ+Vfspvye/2EmHO8a10niwF6mpV9TNCaalVchQZLw+HR5hOwfI4Olrom9N+
	 a8LX0Q+qYh0As+JMMfExsdyDHC2JsKT56vTLNXMt8egX5RSXG6zrTH022Z1fv/yNO7
	 4KsDW8Hfjf6KXdmEcOuuqEhUOGlN3W+mLKB1CnAhuwWBY6F4o1J9p16Cij8NTglZ6p
	 lhWMYA4QM9msA==
Date: Tue, 18 Aug 2026 11:12:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
Message-ID: <aoQvybFWhSkWe1o_@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-7-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-7-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 103BF80004
X-Stat-Signature: e3wi6nytxa8833sxb4qbi1c1pac7b5a5
X-Rspam-User: 
X-HE-Tag: 1787047981-851337
X-HE-Meta: U2FsdGVkX19uLZ0wyBYvUeBHIz9zcV4oeiXx9FgdbqAtecTWYJA3XtiRjQln+dyyUBKdLRTYZcyY6Yn0ujH+30elZS8vWriKXfldxt46AoGa92MOh6avU9IzclXiX9WyH4lMpBO5I4eRWy8rcF1fZD0/YUYMziWlU1nBZl1t5YovXCNbBElnoVcl0gMQh4EVcpt+WOp3s5FBiejyXTgEu0AWybho1HD0v4jHKWnnWfoGQk3RikUxp1pN02yZwrpl94P91jHxEg8RaaFL0q2CuGebJ2a9ZzUBgDYJ/buxV0gaER2qmn9LQr5zTA9i4XvVFByitRrskh3PRI5TA3yvK8LB/Xe5G/pmyYehdfy/eCqlni7PPV/YF/B8qEPjrJ2A4HsIfkd+y1ftPqy1jDXi4flTpYzuUnZ6C5/C8ytux+Qa95NKzrf9rv+He5c4ovD6bZtuEwV9KfCN6XIfD+wvxygH/uGM7GLQ6YUvjXv4sr0K5lt1IKkLoZxxNXBdALQLw7YnGDkvVUayzsAql4rcmEFG7LEUEGMxp1JZns+YqQJCosBt5znZgIiBphNOsKlrKDadqQYKE4DwPYdbJrBl/5IHRxKAtHfWbiC9R3X5a8bzcc37fnz2+n9b/nspGVi2KcSfRdUbJQKUbi+J3cHXHdQlCd+UGeNiJQSXyZRWF4Z1ZUQs2jDhR7sbxQ7yXTT35LYxJMHdU6okliY1XiH55ClJ5SpQpmHrZNqPxwXCpnF2OxH75eSXtHIt30obK1MlKZUN7gPAq8Vn9Fjlt8CvVYAPjQWEdfOxgUPgF8FQmoSvLPB97fntwbGAEcbPgNGV8ysFA+bT3QXbUutkXOW5UztBIOnsPcDn7yXCHaMamqrj2ljx4afMGXsuekOXC19pyjz2c8a+JENvHLMzhP6Kw7C2Gc8Wu8DVjX3fUi3YcmZy7kPClZZq03UlsMrAnFIdWS0U12r4dx5hvqZ93F/
 QqAKR21j
 9RSYkCwzeOXWG15yJkkTYfGsBAhJW0dF2PTZ5j8Bm5iixDOamBVaRINREOh91gvdvlkmyMfMjuZDUtTP9OdENhpZT7HnOEF2nn2RaPkk7IXKhZpl1oX0kvHZD+Uspjd/vvvhuvQykgNeDKgbLNOWw9x1DOoM0TniFdwWPsCOOlORkNyjG0E7764Sjms1/14/8MTq9WPwtdLlwIMH0bpfjEUMG+CooJZbUjFmk6RNVy/RvQ/etLet+VYMVU0N8MRlNKRf82Jd2EYraf6Obe3dreHh71CmPmn/ARQCkZX2PRTpICPVClOhovpD3qvkTuXLopEBOAASf15tb7Qo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:48AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> It clears the global controls only, which is no longer enough.  A per-order
> control overrides them, and -s leaves the source order at "always", so
> khugepaged collapses the very range the case is working on.  The case then
> fails on a collapse that was interfered with rather than refused.
>
> Clear the per-order controls too.  Set them to "inherit", not "never".
> khugepaged honours the global never and stays out.  A forced shmem collapse
> takes the order it builds from these very controls, and still finds one.
>
> Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 7eb9db0005a0..0008862e7cbc 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -550,8 +550,8 @@ static bool is_anon(struct mem_ops *ops)
>  static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			       struct mem_ops *ops, bool expect)
>  {
> -	int ret;
>  	struct thp_settings settings = *thp_current_settings();
> +	int ret, i;
>
>  	ksft_print_msg("%s...", msg);
>
> @@ -564,9 +564,20 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  	/*
>  	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>  	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> +	 *
> +	 * The per-order controls have to go too, not just the global one: a
> +	 * source order left at "always" -- which -s does -- lets khugepaged
> +	 * collapse the very range the case is working on.  Set them to
> +	 * "inherit", not "never".  khugepaged honours the global never and
> +	 * stays out.  A forced shmem collapse takes the order it builds from
> +	 * these very controls, and still finds one.

Again far too many words, schloppy. Trim it please. This isn't a chat with
claude it's a comment.

>  	 */
>  	settings.thp_enabled = THP_NEVER;
>  	settings.shmem_enabled = SHMEM_NEVER;
> +	for (i = 0; i < NR_ORDERS; i++) {
> +		settings.hugepages[i].enabled = THP_INHERIT;
> +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
> +	}
>  	thp_push_settings(&settings);
>
>  	/* Clear VM_NOHUGEPAGE */
> --
> 2.54.0
>

--
Cheers, Lorenzo

