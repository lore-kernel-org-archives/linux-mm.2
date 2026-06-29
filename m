Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED39C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F0A6B0088; Mon, 29 Jun 2026 00:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFC06B008A; Mon, 29 Jun 2026 00:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F37576B0092; Mon, 29 Jun 2026 00:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8F686B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:41:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FFD714055C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:41:18 +0000 (UTC)
X-FDA: 84931701036.17.26E3539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CB63180002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:41:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D8rJWCES;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782708076;
	b=rb2+33tfEW8wsL3SLdxNh3Ijm0IEzDneGr5W34nRKD0O3sMmS/nte+8GV/L9S7RdgNJ7Hp
	G/3K2wWakE+u2Cs5Lb9NZ3zKVFhjT78rsrEZnUqChLLZncubyrpVHbCgDOm6wvmXGpsmU9
	Lc32u0CumeGW6msOIUhYIVQhQ0gunMY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782708076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xMHJpueAbVzKNgvxgPJDwFoivtuInCfdlWopSA/I5c=;
	b=nsns/OzvmK+Tw/BPr7pv5jeldHiA+gf1FjIu6TwjBGmgjMNe6+eAuCpjV+lM4rZL8HOa8B
	q2s9REtJ9nJLyo9KysT93cCEIEeOqjQpX5bw3Bt4eFR4fzXWZLB4rBeIJQsO86uCZS5CEM
	S/NntY2eTBgV/3qL6rZ+4C7qSdWNc3g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D8rJWCES;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F48C419FE;
	Mon, 29 Jun 2026 04:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0950C1F000E9;
	Mon, 29 Jun 2026 04:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708075;
	bh=9xMHJpueAbVzKNgvxgPJDwFoivtuInCfdlWopSA/I5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D8rJWCESvqST7sTQ4il+ivHjwS4HUxSOcPMfAE/f0i+1hnkjXGA7x60QziGDqVZv7
	 Gn0ngbRYnInjWhzdvUP6scb0RsQKaj9orbEHviRfJPI4LShTtsxypLQaXEpkMb6i0e
	 KJmbkvU+aY4+ypK2dSFlh9v4xw5GFPLAklaqxvCg=
Date: Sun, 28 Jun 2026 21:41:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: vishal.moola@gmail.com, ye.liu@linux.dev, zhen.ni@easystack.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] tools/mm/page_owner_sort: fix filtering and
 cleanup issues
Message-Id: <20260628214114.2ffe4c4ce7ce1ffa0e3338f2@linux-foundation.org>
In-Reply-To: <20260629014316.130307-1-chenyichong@uniontech.com>
References: <20260629014316.130307-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r975zysmpc9n981q75pgif83f8mx9mzs
X-Rspamd-Queue-Id: 5CB63180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782708076-921484
X-HE-Meta: U2FsdGVkX1/BuRhI1pTaCa2p4AoabjIhZBUwV6e+BgIFdIMpkWvwE2fUkRtn++p7P1wFXo/ueKwk8WocrH+KlHccFJv81MOElsm0ZPRxkO5qPCCXCtbI7OOV1pDXGo4//kvJVX1/b/IxSrvdzZWP/FWELoX85TJEmWwWzOa9BIT+CGsktxd+iNZocYrHvQVjLC9Z/dS2YebAaCWxFxSYuwE497Y6l0QfWwhD/OMAAV318n6PEzgHqwOBP1nmCjLxnIPNTZoUoVxIxKfcbXNWacHe66wrU7QaHSwHC4X8SDh0OltcOhWSFIFwF0goOVJ2oA6La2vIT7TdYZ47GD273mnQlJeDgoJPF4wvAZqqV4bNTTJlX2wmU2+qa5wHAhC93ptQzubRH13pU1vDcQ1S3aY4dzsnFOcOQvgARyM6a/L9ASd7wpLsoEok4XroyBc4FPwQM8I1jgy964w8aAv1kWkKNFbDpwsDkUiATPReFg6emWbjDOFOpwO3k1DLfAcyhoeFjcPzpTWEsGso03A6lYhNhPm23q15DV0EWqyUSF6I/2vQ8xcm5uPWCBYIyCnD6ZO4MEoTn9QN2yhJlVaVmqTfTckL56//AF5haBotqE4Ys9Hi01lxmHVCaN1P/fgIkadAcikF7ETUhnhsJIUG2/tnxHAXwrDs9Fhss9Sv1n9A7BB65vyyd42vr+hOXOdF+VZV2YMzunJZELTdiZGtphiCxQkVLvwiMnIZtZuWnXNPEsTSvSUP6JQpPM2Fp1vTYyvqI0TJWSlGA/+pW2FTYvGGqGN9KU8uNC3yIYCryByj98ZrX8Enl9oB4A/mBAqRj1YMqhEFtOwFz2PrOIbfu8+NmvnniF6H56ubEKPyjCwnOS55JemA+jAWGybnVhNE1crP104hJO6Lsl/r2zrxOVazQzqy+Rr6EngDEpDioubvCi5eSqwHq9wmkpdrwre2HRr0bxHpYBXDs2PYVGy
 /ecLtNgI
 TYKNWdhN+xklQcY/AJc5mRfN8lCJlbh/FqJ+2ObYHpFUmeOtg146ezAZZEsoumVSA7f9n+s3G6nF0vZRYIE+DMm2rjKXJkJJlBf7u1ANrEitsdLhu+ZZ5j6tyJXU52cqXYKXXIu1A0XZ9bJjAxByioj6xfGs+6jZ6vsTG8fUdHdUISVtzgnr01H2+3sW5KNnXLzNiwXwT8cBWOYYxrZcxMb+WJX9ED5ZoLaC8t0eVhf1d4tQWvuMxTfvuM0ujuVgRq6vlFRH3/YT9l5Cku5yrV48mno4lD1qsa+l4CJS7k/l9u+sgc03eBJniFXO1hcNAY0uZRp94OxowrxAuV+6tXogxSGV4ylKCeIhNAJASMcejK0daOyXlDfxb8sugkVboYGx5uw0iVt6lxjE8kYOyboSEzNK2HoILpC2RLP0pw1R0nmPxcOBTt1lFJEiEJDx1HVzLEDmc8aKyKXiHgovM+hZ+niqOeH3G0R/2fmk5oGW9ebs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 09:43:13 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

> Resend the page_owner_sort cleanup series with corrected threading.
> 
> This version replaces the single patch currently queued in mm-new by
> splitting the cleanup into smaller patches and adding the search_pattern()
> bounds fix.
> 
> Patch 1 renames is_need() to filter_record() and makes the filter path
> return explicit results. Patch 2 fixes the per-record allocation leaks.
> Patch 3 bounds search_pattern() output copies, addressing the pre-existing
> issue reported by Sashiko/AI review.

Thanks, I'll add this for testing and further review.

It looks like AI review found a minorish issue:

https://sashiko.dev/#/patchset/20260629014316.130307-1-chenyichong@uniontech.com

