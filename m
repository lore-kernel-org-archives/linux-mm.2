Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F988C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 777986B009F; Mon,  7 Sep 2026 09:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729306B00A1; Mon,  7 Sep 2026 09:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E126B009F; Mon,  7 Sep 2026 09:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41FD96B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:57:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0DAC16017F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:57:58 +0000 (UTC)
X-FDA: 85187119836.03.EC00F17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10FFFC0005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:57:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtRIRZxt;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTX1LYu7X9YZwtw9opoxl4XbB8EDCTT9fYS8a407r3Y=;
	b=r2ewcfP38tL3KwuCk3YjfbuTTIaYmT+bzZOLSXM9IVL9EyUc70DWt0pSk7PeykQBxvsH46
	MAI1MXGzUfbMTkg0BdXx4/wvKeDtRUEgxyHlY612pQxaZnhLNQUuFiPGhR8mlr51mu14e8
	gLFV1R+unU/6UE4qMx6M1fHh0Tgf2u0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtRIRZxt;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789477;
	b=yK9YXvzbEHA5tj9/+GTlGIp7AGlBAkvQl7hathAXuYpGzO70Dkm6YnZXY/yxcmWPbUspgB
	V/z0eiDKDrhMYsHrThtVH6nrQQERnI8IYn6hiuYbwoab1mJ1a2mU4CO1y4tItqo5RHigBs
	aUImIhA69fa8BlJQaJFcjIXm4xpKX14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16B0F40748;
	Mon,  7 Sep 2026 13:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DF21F00A3A;
	Mon,  7 Sep 2026 13:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789476;
	bh=mTX1LYu7X9YZwtw9opoxl4XbB8EDCTT9fYS8a407r3Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QtRIRZxtbrOTV/3mTDMwLSW8y++rxKfFQLzxxIOZ0AWvyeT24botgks8ilBW5Nsou
	 0kMPrRW7qWF/SucxE2a2XHGiTcb/hXfDXMu7pDNpzSlLi+QKEFzcYNLXGsEfqETDNB
	 R/NkOgiK8/VjBRJUiMlGI1dS9EJBapB87ZKh4F34S1lfIG6D1wdkcqOTVX4Nxsc4bs
	 OY7uTGPZiXJLsQ9utfMVsS8y3LoZnpFt8ROcxZ/FM8I42JsDUcbsXynOYQnAEl3vKj
	 JXVKnv0Q7glnbto9vRDVhNADkOKqeVxxHAPB3qcc4uu3CA0KGbOueSrWWeK40vix+h
	 bUC8HW+wM+FkA==
Message-ID: <ee03fd39-389d-44d8-9027-6148b1f4601a@kernel.org>
Date: Mon, 7 Sep 2026 15:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/selftests/mm: add missing .gitignore
 entries
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Pratyush Mallick <pratmal@google.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: md4onw63trnpqcer4tipgt9su5otr1m3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10FFFC0005
X-Rspam-User: 
X-HE-Tag: 1788789476-31238
X-HE-Meta: U2FsdGVkX1/LK1InKp0HBdbGZgMmnoGOjEtVOv+GrcrlpkVq0ZLrvGKD8LK+lXZspemAyLvGkiJ/rVc/dfoeuPFj6jnWy2kOJ6hKEn1/YBW92B3yaTak+6nD+AoU4OfJfZNvfnk3moc10Ov2LzKtoS0G3Pa85uEuVKc0kOF7PPKzqiGLqPRcu3BS3ZtIAkh31VKde6uKZppC1geMDnT4yAC0N/UQCldV/W89/lveYxmQnjmekuOaQNtcG3k8NY3OgnXnC2NWbAUawn3c5IOwr+eUqxjr7yVoghA45M2LUloXF5cFdc8QB/tkYUJ5js/R10dmNq8OY/TKs3cqZPNtW1eHqpjhoeSf5eQAXv4Qrc+YFdCWbr8M/Ur4olZ+72l+7RSVvskO7ZC5oaqUDy0T+ccisg4vcSP0+urAjMzg8kbkhhGgVg4e8GWxMWDNtZKs9LcL7B+RyEzMJEQHDrTdeMaJHxGSYjBI3yyh5fwDHzs9QAbMgZ08g6hxvRux+mrmmDjMbW20bmx9tQvfUFe19KnxRNS2oHwSaRW1AbQU/w/qt6rJ3Ov3PdAgC2R0N5k5lnuHqwqF7TeN5+YZDgrgcoV6OGYmS4TD1PS/k4kKaiQw1sRcqB0v8ATgDwkVEpWYmH8Hyy8Lk//D2hPq3HH1/eWVzGuInlcVXlw4XcyHyU1BcNR0jYE7yJg0lSfLwMEsk3nzVGCwrGQ71No7ByMR4YHR//hoX9WAJDTnVNvQi2J7CuWMZZA8dzvo86bvej+V3j5sf6CpJwgtxEOX8i0UbK+vxnwJ/Uta32srbsJAhSxo58Tmxpwh2n6Wwi3rrsbQPoEmLsRwJOY6f1M212pZKosDugjVafvJh6C+f7eZdyo57sLsUt0tR17/hmrW4Jb1SlG4EOB4sNK8XIJi9qXaO7L/HfzghzODXXdb2kCBm5zZZYmFAbAko29FfKmJLsqrslII1UkvYM6DG8XNWpK
 u/iqaw77
 glIpGPbabO1bX7ZyEtO3Dn9jbuWfjly6JyrjT5b1ZfnNApdedLs3uig1gQ0DFf6GqRVOqUnol0bFIGh2XcVmnphAneXXp1U8IQnUN8g5aHPiJ3DuNnvVVfmae+3iJhhwKIlvkXl4cdeVZ1PZJCPQiDIAmh8NSDE+Jwp8vDGwEVyVZbZiTZNWIjeu/KXQNaODuymJGKz5oTbwy6+Trk4cwNHmq9e9HaXHgoa1zYTpLzRPtvuk22giEKgN0BxoXuUHpXtVhMiI6vtXEStEuhlYeX76S4NVxHo5AVqIG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 16:18, Lorenzo Stoakes (ARM) wrote:
> Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
> switched to a pattern-matching mechanism to reduce churn in .gitignore.
> 
> It however accidentally excluded the page_frag test's-generated module
> intermediate C file with .mod.c extension, and also the local_config.h
> header generated if liburing is available locally.
> 
> Explicitly fix both the issues, fixing the module-generated C file as a
> general pattern as these are always intermediate files that should be
> ignored.
> 
> Since this is a trivial .gitignore change it doesn't seem necessary to
> treat it as a hotfix.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

