Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0357CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF176B0005; Mon, 18 May 2026 05:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6D36B0088; Mon, 18 May 2026 05:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B2E6B008C; Mon, 18 May 2026 05:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28AC06B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:42:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B56E5A0850
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:42:52 +0000 (UTC)
X-FDA: 84780051384.24.56C5E57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E06A41C0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:42:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0y4XfEs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DM49plLIk1XUyMp4pObD0hsv6PZlJzvWkJKP2E1zklg=;
	b=8B83ioZFs3o4tcXuLAyosDUwqEA6EvstKGGT2V/+6xlvwFF9G7LsTJUvEDzwiCr5QTNOFW
	IFll3Bv/a4gDokONm/1nV3k8/Cpsrr4uNFhQkg56K0QDfxf4y5X5T/wcRB9VBEuLBRBv7Q
	AMiSZFsfJ0XGyzWzCXg8tO1vwYxhApw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097371; a=rsa-sha256;
	cv=none;
	b=Ux7du1YaEKXoHipDxpb+dxxko16MfvWWPTXZPX2tMGahFBLNTz8Kw+wfAm9hM2JJMD/ozT
	eFkXBknUjucvrCPVQCt8OKhvQguyvsbk3dnISjG+FWanY2N0FDJbVqrJ/jZcjSwaxeyX9Q
	PCEBvG0IIuOAFQKQqNuNMOheMM6l/6E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0y4XfEs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBE1843587;
	Mon, 18 May 2026 09:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11E6C2BCB7;
	Mon, 18 May 2026 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779097369;
	bh=EFeO1XoXwO9VBBnNvrbsycDqaLbXNZJqu7j0uNeZ2a4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H0y4XfEsOVNCGqoUDscQt9w/W+I3LSbHnpHe1Q3eP70hx3DeqaSoxp9haRkO53gZG
	 uOrt9UfMoiDrgf4vKFOMF4mHsKfjkKJ3UvprKlt6GGMVDg90xBqkTmyq8yIqaxAUst
	 xEqQA5jNnla1N70yq3pjuYoblpBZiJ++mOvFORPK6FvDw4p0XCycxRAeXIs7dyi3Ig
	 5u713g83UW60jiTZsVNxFhSqA4bDVLADn5SaDjdE8QNdfYQ8iLx6Ky7Tu0eyjkcNWI
	 y9MYoX1aqsiDkCBF0C+eO70343GPc46VtYnBTC85SuJFvJ/+yyuwYmX2QhiiwXWvji
	 IbXw+p4MqfAfg==
Message-ID: <8791028d-00a6-45a4-a46e-681d77d95dcd@kernel.org>
Date: Mon, 18 May 2026 11:42:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
To: Balbir Singh <balbirs@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Mike Rapoport <rppt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, Sourab Gupta <sougupta@nvidia.com>,
 Zi Yan <ziy@nvidia.com>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E06A41C0007
X-Rspam-User: 
X-Stat-Signature: bqofeqqq1w56a5rkai8dskpq775jgud5
X-HE-Tag: 1779097370-278496
X-HE-Meta: U2FsdGVkX19KF1FZEQQLL9HHviSo9yghDbDw5zQghMSKgKpRBXigZzQEcS61RokrbajqC4VmC+REfDeO+w9UndaCB3ROA7F+Pf6IRd/XBim5Ge/ZdfwooPSvclHNtmCyk6cNqZ/38xyjNfUQiKilLlbtufmgz3Xpj0ktQZWW2UFM4xuUiSqQk9xcgevDNUIUpckXnC5+3m/HxENtBfvy8iL8dyLPM4wqgYmnYrEFGwm4b3U/pmBsDZpSSkDAVMUBScdUUlW/5vFHOXUE9fLW0lhJEbX8Lbthvq0HYBC2M4blKww2Y/soV10VGSQv3c39RMIcpkfsrv7KxW4tJ0iSEGD8NteuutpqvfD4Txrz9OJuy0VzHLBGZAajrzZuzEjoHhAjbXcukOgGrxmihMsaCOSYi1Pw4515v5LW9nFFQxK4a1t09HHKau4Dy4H+VqyqJWvgvkvDWedh+L98jSJ54rYmfOtm145lyj1JzmYFySKHZhO1nMiB8gApZed3gb/0F7BPj74uebZcGBwGMEMeclKI9h27N3BqICdoPXn2Rp/eK7JU0hganzj+ne8zHcPQG0SPw9yzbhYGYOS6qyso2YpD2+82TaWhdnqo7Gv4Rx6pF9KhLHpSeX/C5RnYVHk7+clzEDlzCTKPjR0Z2I842g+wkfPFvUpe2wNG5VvJliDo8aifDo6AlorskPmdKyEXVMF/g1vxOoJaQ3Fc3SMK8UD4bMrF4JXyb8PvzOBxY7vaIRMng0k4xGvoXhIvheqNfLCs5NBcgTYbKb3gWOoVIEEhVraNO5FEW5/fvfk6LEZBB1knFqkI8MzUp06VuZ1e98QPiSM6dX4EHAkyy/CvFr2K9zzhTFxHRZmXkhgM9grz6v1GrIKI9XgXkC9QR+Jl4MlkOtkCnwRLwhSX2FiskMzvOSo8MhqvSCIEqufez5hsulAzbQWUrvWpM7RbJdIsM6l4vk/f/GlOpGa4/7H
 kuZXz0UN
 ZkKviHVCeWQnPUyBUexXCrXtFf9pHu2CIwgPBMPMUVgMvszMJDvHsfsdJE10A9Lb1tBpkWNJ/7gA2o51XVjAXUEyR1QCQAkV73R9d2mEAujApGCCQ7DbV35uRi1EDXT/i21Y1n8pV7NAvylfw4Chjf2teItnCoPxDA5Kkn2nxA5+H5vSSdmP0OaA2IyaoM0PsQuNu8vSVR82RePaoGJP/Ll+qR+P1SJ8+IJiOKjrXLIssqT3FfpyOq22lGtaHSeurl7St
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 02:09, Balbir Singh wrote:
> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
>> On 4/9/26 03:46, John Hubbard wrote:
>>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>>> gup_fast_folio_allowed() falls back to the slow path for any order-0
>>> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
>>> performance regression for drivers that allocate pages with alloc_page()
>>> and insert them into VMAs via vm_insert_page(). These pages legitimately
>>> have a NULL folio->mapping, but they cannot be secretmem pages.
>>>
>>> Secretmem pages are always added to the secretmem inode's page cache via
>>> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
>>> A folio with a NULL mapping can never be a secretmem folio. The
>>> NULL-mapping check was intended to handle truncated file-backed pages (a
>>> reject_file_backed concern), not secretmem detection.
>>>
>>> When only check_secretmem is true (and reject_file_backed is false), a
>>> NULL mapping is sufficient to prove the folio is not secretmem, so the
>>> fast path can proceed.
>>
>> Hm, what if secretmem folio just got truncated? I hate to rely on some
>> handling in the caller to detect truncation differently during GUP-fast,
>> but this function returning "true".
>>
> 
> Can secretmem folios be truncated? I assume you are referring to
> ftruncate(), I am looking at the setattr implementation of secretmem
> and it does not seem like it can be truncated.

I thought FALLOC_FL_PUNCH_HOLE would work. But indeed, that does not seem to be
wired up.

-- 
Cheers,

David

