Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E571606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KctJr5aH
Received: by kanga.kvack.org (Postfix)
	id 5889F6B05C1; Sat, 14 Nov 2026 12:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539B56B05C2; Sat, 14 Nov 2026 12:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4507B6B05C3; Sat, 14 Nov 2026 12:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15AA06B05C1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:12:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 822EE160459
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:12:26 +0000 (UTC)
X-FDA: 85434368292.19.7DB2400
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CE19320005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:12:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KctJr5aH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794676345;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuUas9394tXVS2rINaWyftKxBgw1MZ4KrFxs7EBX5no=;
	b=iumLCRcgJ2Hj/dnhcPg4qMvfSupCRBXYhxB8WXFErijPRyIkFRAmt0Pw8LKq7O8dBWWxWr
	FpuuFgGVz2JQU9GGRPiOnhlLdyPkLXKW+WOTABIEA4Go4aeXgEJjmhwjuvX2mbsvA+7rX/
	YHfrQRV5Q8tGrBzEmllCCZeBSDxnEAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794676345;
	b=enxWpQMW6zAO6GVUXsGKNNC9S554ij48e8Ntx2bgrmxqE4QleIBwWaP0kXcagutzSrsPLT
	n29Q3wKCeg/T6/2inZGRiFR/vd8mPuJtzRHJYZKbixZybl+QyNqEpPchEKvpOf9ElnxK4m
	Ri0mrEmCRRXh7SCQx098o6NcUVzJhok=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KctJr5aH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1628141739;
	Sat, 14 Nov 2026 17:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DBC1F000C4;
	Sat, 14 Nov 2026 17:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794676344;
	bh=GuUas9394tXVS2rINaWyftKxBgw1MZ4KrFxs7EBX5no=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KctJr5aHRt1tIu6GHbg3QvOztA2LzkQ2ka5nqUPyAA4IhSDLaxswiaEW9S6eO2rZ1
	 UVjd9uEqfr5ePG591F0gsVAAqbo3oh2uk+eoyhuM4sqEqajYUbUZzbM5unAwlrOogo
	 kWPE0RiA27wIXiPqei47M5ZlXJeUQNbEDodp5bl9wkBIixqi/wZzsyQC9aaCAYKD1P
	 i1HJ4yyiT8CGhGu2Ff90mOw1ZZ4DSqRaikY2XT2H1SHGOsQ9dDMIiYeqLqVLe1d1+Q
	 HY30pcjL5wIBtza2NKwL5g96u5gA2OlnlGZbxV6h1dH8Fd+5NZSapDr5dTnJ/xE+No
	 Jd0kVs5YVvyng==
Message-ID: <sashiko-outbox-214828@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivank Garg" <shivankg@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Borislav Petkov" <bp@alien8.de>, "Ankur Arora" <ankur.a.arora@oracle.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Thomas Gleixner" <tglx@kernel.org>, "Bharata
 B Rao" <bharata@amd.com>, "Hrushikesh Salunke" <hsalunke@amd.com>, "Ingo
 Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "David
 Laight" <david.laight.linux@gmail.com>, "David Rientjes" <rientjes@google.com>, "Linus
 Torvalds" <torvalds@linuxfoundation.org>, "Teja Vojjala" <tejavojjala@google.com>, "Huan
 Nguyen" <nhuhuan@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Peter
 Zijlstra" <peterz@infradead.org>
Cc: linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 17:12:22 +0000
X-Stat-Signature: yeakqnxqd37bt7cgwgrkkuczy3ofg6so
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE19320005
X-HE-Tag: 1794676344-362557
X-HE-Meta: U2FsdGVkX1/xdkv5aQeahWlxJZ1+wrG5LrsIqCwwaJLOpq6fIzl7vPrpDjDlkJ9N4un9UctDODSKul05njpuQTqQGlQMcnxFVEHAYbSofddRftOvPPnC5a7UhubwvHnYlBMTjnAJmvtMWXH4RF0SSLHJpq0W1cda9aN14HRsuswv6LXltBK7nuLNsSl9fzNOViAwxeI74duQOMrPYFQUxtYh7z/U/+2wkqDd24YrzBFHLMQMDdNtG9+ZNTMYtUIk9fUZWzz8vadzOhkb57xQfpLwDsO92veB/PJisqNoMNsqS0F+wp917snT5dSF7FNXVi2j76wNdK1TzXABZa5dbZCpqbTYP2MrlCgHhTahOdxgbzJT5+LqcsYbRLfaUPGEnAijcDjgF0Hc83dnLywFcWZkaJyGwCkiKtC8iV56kT3x45YzY1U2ApTJ3ZZCzJbwLUJyYdqdQIAZELugBZrv0w+5P7TIrPYmtC48SHk3nZAZ53OkjwnJFYDt82w0B1YWfV1nXXchVdNReFgan8WzAxmlmDQo879s7CtJfTPdSTxVw/HdydETPLiqxADOjDN5bV100xCRhrThm8Irckzdfz+3DX/Q5CTs7jNtFbfkHHYJPaDGpLNSdQqiNHNn+oFHTt9ZOjDaqutYREyyr31ex1fzBSyVyUaHyUOVzJatZC1IjDRxjuAedtzSTF0ePWMO1xWey4ZJuqK5EQMTSkP3IHBb3sePCf505nGBTxVlbK0XMylVV17wy+SyQG6BacYunIRwTu1HSG4BIHPDQS7O9GgO77WhMnwgqOYFXZoOA0M+cG4eAEEyNgw9pe3lEeehBzSgKse6Vd7ed5Em+CxlJoiOM/vz+XPrIFS4BeEGcZDH2u0J5dq2/QpK7B7xj4uz+htxFk0iBpE17c8yGYCKjWHnucwe0GUFKnWi9cP2d5+UNzrXMCKsB54uEsptjsatY4YP1Iy/ZL7d6c/9Mjy
 Ezf20DK4
 ATnCBxtKBa+5XaP2Mz6JinMtVcOLDDZMwx2zSpaNS98BdZjCTmxfuOlhM5SPAcSHzuRNjdSFINOdTikoSz1Dvux8CBil9ZBSoXt0v+zU2zWOSAq4X8I6RFIa0FqqnIVUI8U+5tmOkIYRy+/4EIq/qJqWFXxhKEhEp80gkskdoY2mNMfHlY4JkB9YPSytE+vs7Vfe86SKJWKrLtiJdzUDcuZ2EKzvg50TU9jiHChU1Inympdy7khmj3fAFnP6YlRp7aKzOwU7pzc4IYN9D7PzME71dTj98hIizG+I0lmjLY0/4M6qz45Q7Zgn3IPX25PVTWKcc870JG0FgC032KhvtbQ+88wsmwJCBMDURe6OFllcO0IuaijOUDOpaaL7G1mJHRBN/QJmkgGHw9wUKRaIhpBjTnTBi/7qoGXwdyRpGHrXq6VdpJyui4jbgOTNhjAO9M1OS8ptBQdwTLk0p4jeA1op10qONZp4NHkJusXXoLIzEqXyvybAjsh1R69ckr6Z3D4dCrKqrhj4bGaS3eimd0oEkyBqJfpH1ruXNLMhC/oFyzihyf4jvnxmDfzi/Rlqb1O4cXZwndgVpaDz0VKffpSWQZ5G+xUoWuLKUDs+V4FnTaO8j13mruCIh73Z50wmFNRqs5ZnH8JAAycX6PA3Qd/DZb7WZSxuSyUfFE6B7IOPIKFyvz6E0nh0Yyb7biCiYsI36sFZdmJbJeiCZR/GFOskyVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm: missing hwpoison check in copy_mc_user_highpage() and
  copy_mc_highpage() [1]
--

commit fae95970ccf2607d670f06862e40d3ba9313200a
Author: Shivank Garg <shivankg@amd.com>

mm: introduce copy_mc_highpages() and batch copy in folio_mc_copy()

This commit introduces copy_mc_highpages() to copy page ranges with a
single copy_mc_to_kernel() call when possible and updates folio_mc_copy()
to use it.

> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a4..a79e9d68359c8 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -484,6 +484,57 @@ static inline int copy_mc_highpage(struct page *to, =
struct page *from)
>  }
>  #endif
> =20
> +/**
> + * copy_mc_highpages() - copy a page range with machine check handling
> + * @to: first destination page
> + * @from: first source page
> + * @nr_pages: number of pages
> + *
> + * Range variant of copy_mc_highpage(). On a machine check, the poisoned
> + * source page is queued for memory_failure().
> + *
> + * Context: Process context. May sleep.
> + * Return: 0 on success, -EHWPOISON if a machine check was handled.
> + */
> +static inline int copy_mc_highpages(struct page *to, struct page *from,
> +		unsigned long nr_pages)
> +{
> +	unsigned long len =3D nr_pages << PAGE_SHIFT;
> +	unsigned long i, ret;
> +
> +	might_sleep();
> +
> +	/*
> +	 * When copying we want to operate on the largest extent possible to
> +	 * allow for architecture specific extent based optimizations.
> +	 *
> +	 * copy_mc_to_kernel() does not call cond_resched(). That is fine on
> +	 * preemptible kernels, where the scheduler can preempt the copy at
> +	 * any point, so copy the whole range at once if copy_mc_to_kernel() is
> +	 * available and the pages are in the linear map. Otherwise, copy one
> +	 * page at a time and reschedule in between.
> +	 */
> +	if (IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && IS_ENABLED(CONFIG_PREEMPTION=
) &&
> +	    !IS_ENABLED(CONFIG_HIGHMEM)) {
> +		ret =3D copy_mc_to_kernel(page_address(to), page_address(from), len);
> +		if (ret) {
> +			memory_failure_queue(page_to_pfn(from) +
> +					     ((len - ret) >> PAGE_SHIFT), 0);
> +			return -EHWPOISON;
> +		}
> +		for (i =3D 0; i < nr_pages; i++)
> +			kmsan_copy_page_meta(to + i, from + i);
> +		return 0;
> +	}
> +
> +	for (i =3D 0; i < nr_pages; i++) {
> +		cond_resched();
> +		if (copy_mc_highpage(to + i, from + i))
> +			return -EHWPOISON;
> +	}

[Severity: Critical]
This problem wasn't introduced by this patch, but can copy_mc_highpage()
and copy_mc_user_highpage() (as well as the new copy_mc_highpages() fast
path) return 0 when the source page or its containing folio is already
marked PG_hwpoison [1]?

Neither helper checks PageHWPoison() or folio_contain_hwpoisoned_page()
before copying.  copy_mc_to_kernel() only catches synchronous #MC
exceptions raised during the copy itself (and falls back to plain memcpy()
when unavailable or on x86 without X86_FEATURE_ERMS or
copy_mc_fragile_enabled).

If a source folio was poisoned via software injection (such as
MADV_HWPOISON) or a prior memory_failure() where reading does not trigger
a synchronous #MC, callers such as folio_mc_copy() or wp_page_copy() treat
the copy as successful and copy corrupted data into a fresh destination
folio without PG_hwpoison set, or trigger an unrecoverable kernel #MC when
copy_mc_to_kernel() is not active.

[1] https://sashiko.dev/#/bug/linux-3af4aa7d-d182-430b-b982-583f6aea4594

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-batpagecop=
y-v3-1-297f5b2fd28e@amd.com?part=3D1

