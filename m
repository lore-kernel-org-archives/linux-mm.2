Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7853CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82226B00C1; Tue, 16 Jun 2026 16:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59AF6B00C2; Tue, 16 Jun 2026 16:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49226B00C3; Tue, 16 Jun 2026 16:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB8656B00C1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:56:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BD4288415
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:50:54 +0000 (UTC)
X-FDA: 84885911628.08.76C1951
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8F2FEA000E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:50:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAaWvAlF;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781617852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+ScgYfxi0F5b6Wvpjx0LZ37xL7ykIrxLDeq6EIQyhg=;
	b=59BYgTlQiwnnfXtXERgA8HHI8jek8m1KSiTjY/Cv3eG0EBGYpacPa5piATc/K8I7J0BjX8
	uBJmCMIgHND9//rhoDIqr8Kk5DvzmfJCYqeog4Er1eXUlJ5ZiPTwq+FMCA9cswgldt2TxF
	lC2fbCjT0uBOqeL/0opkYS6ae5RyB6I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iAaWvAlF;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781617852;
	b=lXUSI4N1t/eRbNKMoaNCLhuqBuxLfPUrgV4c9LL60JHZWyuAuGE4kXe12x1c7kbmrOUNxU
	TY5K20NH4e73rcyYZmmiZPAJWKG64Kwyiwg46fjx0qBLT90IFTA0Dc07xmgTM2LibRnN83
	qTM5qgss0BxOCcPkksLk0FXrEdhhMvY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA11440585;
	Tue, 16 Jun 2026 13:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210251F000E9;
	Tue, 16 Jun 2026 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781617849;
	bh=6+ScgYfxi0F5b6Wvpjx0LZ37xL7ykIrxLDeq6EIQyhg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iAaWvAlFrQXzwN0luqih09KxDpyecFwRNgyEJGZQZvlcqfWBWriNCVs6bNtlxE4ug
	 eOfP8G0iCrDrvAV1SyjxZvt2RpiaErQtQyCxhEuFU/NhalDxogfri5r9OUtoUpIzYW
	 jzO1g4Zqw2tZo77ZH4CC4psd9pMph8BJpkKiY9/hM0TsGpzgJx0eCML83c88vS558m
	 dQe30yILfvPApiTdDVihnLs46ePuDn6KME18EWyt/oKxDVwmhgZ23m7RvUjAmDdRcU
	 gXPANzsTmyEEtNdIRkbjbkzlzG4bJFDaNJB0v81wTQzs9wQvMsa+qBjLtPDm+OcD1Q
	 m9Pq1Ts78YFzg==
Message-ID: <e496b312-2496-4168-ad51-9764e9aad886@kernel.org>
Date: Tue, 16 Jun 2026 15:50:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm/swapfile: Add batched version of
 folio_dup_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-8-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-8-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8F2FEA000E
X-Stat-Signature: bnitmfk6yeiwp13cca45xrbxqh8gabe4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781617852-841969
X-HE-Meta: U2FsdGVkX193CY8OakKsi/J1vURFIf8volQ9iDPQNbWXEu2xX7t+aY9w795InmCwxPzldrr32xD84rlSltG/BdXAnyVcnsHes5bbIrvaMHdEvhS8pgSCPO3hjC4rh0QF601eQcSSycg2ydxUI0ZfxN+HqvwHRVsFf2rtxKTe7Dsm4wVTeenmbFq9gdrA20cC0wWgbv6IjKIuF7LZr0w3u/mdGmrmTAhGqobsG6csWssAoIwkgOLWVLPm+KYKBBzAwn57ea73UqD2hCMJS3ikogUbl84EyUSxgKWkGfBJIDfImeiVL2tlyyM0OmnwV4o4BvRVy00w298/FAFqsvj4eNRn3ggwc9Y5Ylyucm96LFxJUmoe6xDmQJhErH61odGO2rTQiSLMjjjOVQfH56fBnD2aEDt/hE0M1i9UBoTFLV8o+lQ5Z+3FG81eSUrOl+x58EOb8hnQgFAGhYJBQJjCjMN8qsTBQNuGr965KbQvlJ9xwMFtEsDrROohK7WlqMb0i5R8gE023Fwx6+5OUWajqBg1vWbsJQtNAcJFIObisUxuRVOQCoQVsP+DpPBZW9LURFf5VQpUU2KlT0KW2RsY4J/Rzdz/fJE7wM5J2h8rRFHRWabiOddJd8EmwvpjyUZlyQ/1Lx4oWcR7i+/0SCJhOeNMG6jB4p8o8JFvI5HpZ2O9b4Ls59oQDw9aO5BtwOJ5iumBpb3MCbKIw5LWwaMv7nUxz/LgA46rdWzM+HljTAcCAGv33X8GVezTTMejDMxwthHpGBZw8ZMSDJt2DX5jm7vzhjZR6STJBXVIx98oQ7EduDbMbJHRadN+/4y8LFSf1sSF8Pl/DJ6XNv//qDeC/2/UopYm47n+mcrgdtwG160CKju/FpLOVoMihC8rhVL8w1psCZBQ420L5diodafarS7KVotctMP0SgnAC5XBUJWGfqe2H8bEqrhh0Etfqx6GmZPrHSlVR7PehrA0r/h
 ZV4YBtLz
 UvvDh2nKdks212bPzU8pdxKKnjhxk06q1j0Km1MpbXZkz3xaWXf+miryuQr2FKJBeW1noRi+bGZmKtNlwbsrqmulbhBXhidjUTsn3JITGDfMDPmBG8Xfme+YFnVO2ZKdwhIlyHuiYB+u7mEhdVAQ/E1mTU3i9WNcOowKGrPQQlzr6ySB9QcI58/cepbcVztvXZTaeMRUPcWMZZ2NCwX/0Qna7iWBYpsPKgJi6hyTL2uuc0gXAb0CMqzvK/iYYJWAoCJxpm7QYFKSkVbmS8iO1qZ95NXRjWzO5Z14MFvOvUdk6VxAOAqcB2SKj+CZf17xKo1D8S7o0NN19fmOXJ9Bloxt6n7M3sp4fNQNJVEoaBkAP6isTt0GmgXThe4XSW9XJ2UXUbNJhlYNRM1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
> that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_dup_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
> wants to operate on the entire folio.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

I was briefly wondering whether "folio_dup_swap_range()" would be better (a
folio range), but *_pages() works for me as well.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

