Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9C6FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03DAA6B00F0; Fri, 27 Feb 2026 15:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37516B00F1; Fri, 27 Feb 2026 15:50:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02766B00F4; Fri, 27 Feb 2026 15:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE0B06B00F0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:50:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C24C1A09C8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:56 +0000 (UTC)
X-FDA: 84491430912.14.EF97C4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C4CCC4000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:50:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yp/N+AHA";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772225454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWXlmmXKdelCzCKLDjNkzB9/r0zr/lTQHCtWbhvnuD0=;
	b=HfmaAw+AUmQHrO1SIHiYxEjeG0ol+B1RHgRKbF9WQkDkzDqL2jCZIF1aIra2dhz8GHJSn5
	iCRPMCE81je4XtqFVdOoWZOfN704M4XnDCm9cDzYvTY2yWJOb7jvZ2ulHiZafZM7Atolwz
	cvN+Qp+7Jl0+UkJ2KlR+rQmRh+iCtTs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yp/N+AHA";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772225454; a=rsa-sha256;
	cv=none;
	b=wtwP1P/A7AIuJKgWKNtyj1HyhXhvY1ACyC0ZanhAoOK++IVlGD+77/1JvMtju/L9W6GNQ9
	s+6RNZxxMDGxkk8L1mROsMR7BzJaRHJ+bP/2lHNA2LsHzCz0ejQCGfOneiOGkrgoqWtCaH
	HnBpsDlLaGqOFFbG/ugkNGz53MO2KQE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFD9F406BB;
	Fri, 27 Feb 2026 20:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E355C116C6;
	Fri, 27 Feb 2026 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772225453;
	bh=5PuNZnVNV+EiPA3O4jsUBabWtTF1lM09YKrIK9qPlgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Yp/N+AHAHv1CMk1qBXpZpVH1KLgND3ckyHFUGOaT5Y8KSi41RE5twx/rLgl1lWRJZ
	 jQKCIbUB8AR3Zdi9riA/kGtRBCAIVgHpXCSVPEl7PNhBE571EoL5+tfc7uVDLbDCvB
	 qEtObc4ptSrmviPlkEuJ8JbqeNPbca1p9OBZj3vbErKmgigKyuB+49gZ7FZU0UxnPU
	 KBp/kduAFisTHska70iXJD0wOaN+z7RIerquCDHbzyJbfb1RjHWTcBLrsuF1EXAF75
	 0cNuVVYUo/ZQ2wUyHw0uQxz5lC6CA0NQw+vwk/RLG4mv2Mh/FGRte62WNRchbg0Rn2
	 pfsfNnnwbU5LQ==
Message-ID: <7b4b4543-a614-46a3-87b8-dcb1988f4332@kernel.org>
Date: Fri, 27 Feb 2026 21:50:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Replace READ_ONCE() in pud_trans_unstable()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, linux-kernel@vger.kernel.org
References: <20260227040300.2091901-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260227040300.2091901-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C4CCC4000F
X-Rspamd-Server: rspam08
X-Stat-Signature: pqz6wbh6urx8ct63z879oa4zgbm1xeoq
X-HE-Tag: 1772225454-648443
X-HE-Meta: U2FsdGVkX1+E/boP1KJPIgY8BC194j5jfnmGiP4rnzUt95yxpthCjBtq/V8/Y78e8k0EM71G0G76UdMMqMa6UzJqacHN0w8JMGvHXaAhg9y+4YfPTofedYEFoQmw2zvMVr9yO9OAXNnkGRhHTan6D4purydRegW8MWDuyiHLhGSZ/f+snJwYtffLcr+iLrLkHV4Rg9h3Xmd9c9YHOMn7+YI7LmgD3o33g7TqyTYjmKtP+c0o7v+nGsej9nRj1P7MsVPHEsvFJQXTMZmuuG9rJ5StYKU7o2PiyB27qj6B6Q2k6rVnoeWELtbLhxIXjlAZtlHAaVQig9vBWmEiwFbg6VRv9c1O2gYnM6QqNmezJBYFCA2AHyAOsG1hmAIB8AcOS9MHBMfEobfY+0Fb389m8rfpIxSRhIaaVGtfXaxwdlNtxnu+UEhXljUGP8yytfSJfdLB+2xRToxm5GjjUYWIZQW+2kPf0KPeplAfWLDH/Hvw+0/I2KIz/rvBFRfG1r8S5oTjD98sEGbRdY71ylkaDNJD35n81g28TZC0c5YYDkWUZSNVTftwNoS+pfhDLuOUoiDQ7Ep/PzL9zdmsM8mqqekXuGb02odvbU4EVgweamIEOvwDJB5cpM6YErnz6kqfbRsesPe0l+0GXT/A0QzovIbI9IE1V8OMQAg7w3whZ6VXdKj/iWgBAk8YkXc4zatt8ejGNGmWNmJ8lQuIagCzjxqjz+SD+xtjhtfDi+PtGcnqAw8QbEvAmkdjkxOgIUoDODJwamFr3uqZxrXTwZpmpDN1L1mN65ujh/Wgzdm4j+cbBDQQQumjnpR8N3g0bDVCab5DVgVNVimszLTMinkdXBdhZVEjsrJe/+3K1bvcqYg8Wrh1IiFvm1jKJx602hD9aiHO7Ujsf43GlBb9o+wrsybOvVYliKd8xeirVNxDQRQfIFHi8J8uzypCf4PuA2ONRnjxidJcdg0RgaEixUw
 yKknjrJh
 ouTZnYV+nFfPFYP0MKDjUB6apc6Ep55hxQMTElGyjI7I1Qd0rn/47zY5s63gKvew45II7iUuNIGawKW6w/fp5f4c8kA/V/Gm0yF50JUT085XHh8QQSKgjZnMYN2fmvo7/T1407LgSoSSRW/nAc2vuT8ryF9fBz7VWh8DdDz2KqUn7OusWw4dpRsDSg/msKNhyI7GB+pi5UjiXuVz5nqMwHuQ2MfxOzmdHko+kcw8AmmsQmYty8iI/Ju1CPlWXQdaOisBd2wnJtNETO3km46m1OlFCaAp0AD74glUtSB+5C6FSVOuVI4YshQUtojNCdUsXuXSWdCozhJFEu+dhlQ5PGa7kUFhd5pemqMGQUSbPG1fP1NsjJ6uajTWIiBTfMyrfSHicsrwIRNMQTbDAAnz9FVMWU0EYHjJ+tN/GMqf5pTEtqAMfpdWaK9dRfvFZZH5lLNLLiP0zjbGjhsWsS87sQ+sMfYIu+4mbqv0048AVUe4LKfyu9SLLuigUzACjopPNvybwTEDZbl+nJTInzgW8NeOjsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 05:03, Anshuman Khandual wrote:
> Replace READ_ONCE() with the existing standard page table accessor for PUD
> aka pudp_get() in pud_trans_unstable(). This does not create any functional
> change for platforms that do not override pudp_get(), which still defaults
> to READ_ONCE().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

