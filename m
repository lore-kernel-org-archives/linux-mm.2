Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E9710AB807
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41866B0005; Thu, 26 Mar 2026 15:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF23F6B0089; Thu, 26 Mar 2026 15:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0E86B008A; Thu, 26 Mar 2026 15:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD6656B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:27:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78F3B160907
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:27:30 +0000 (UTC)
X-FDA: 84589198260.30.0533C26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C8C9180008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:27:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nUU5RxRL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nUU5RxRL;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774553248; a=rsa-sha256;
	cv=none;
	b=v4k7WNAd6Hvs28WNn3I8tO/+tqmGfGHUXV1N2MuhkpMpID+G8PJU78+SJfwEkvYTI52k+q
	il8bBNse2ht++8crEQ7A9kBOa5GLfs4f2Gq/7T9bXLIFu3K8mhj0LQmVOJcgTBsYxqGmgF
	tNFNSvpPfq2r/533uU5+xeMdSyICXUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774553248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hcyFbTCmJIJ1spZUZX4Qii/ME4i5n0MOmjy8r8HuCs=;
	b=4sV+5pC6/JDbTTeaanJSahm6r2U+tHCIGVmog+E4OAeQsIA4Eo0qCzwNujeA5UmVkMwDmk
	F17BkgdIRYfglO1uOP2giy9Kv8uTD/zEzAdU6vgJtoJCmcYgI4+ZiIyOojJuL26S4TGcsw
	FwVEi4aVlMSWc6b3cSkg5O9n7kRozu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A36AE435B7;
	Thu, 26 Mar 2026 19:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B861C116C6;
	Thu, 26 Mar 2026 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774553247;
	bh=bp9BAhAHf8ymXvkEwb3nD7/BwGW/XROA97vHJ/fLsrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nUU5RxRLm/oXP0EkdBjFXv/rEICwTZPKxIiyZsBFgt+lY/gRvZKlnmP9SEGRBmzwg
	 dPyzYfsTpTFgzChSa7U/N6HKl+XfVtw87BCcfaNX5uzwyBhdyvWiiQC8F2EokLedBT
	 kwjA6gSUlrEWd9SXGBCvfupwimwZpO82m/FJ2DqZYDKSx6qHYha8OzKcqOU4ngnThc
	 pmlneHHpRNyCr6cM//4ogtnKkrSF/8wUzkaoNXkC65EYzk1H7de62k3ZFlaXr4QU/5
	 XbVe0sHWNNL+5TqDoRNK1zKd4ffjTxLmZ0W9o6xuZdh0tpZiPTPuz+0W49Hd4avee8
	 7Yhs5aiYTeAkw==
Message-ID: <7c643c7c-a73b-4c24-9845-5d3b55d853c6@kernel.org>
Date: Thu, 26 Mar 2026 20:27:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
References: <20260326185629.355476-1-ljs@kernel.org>
 <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C8C9180008
X-Stat-Signature: taj3umkrww1q5j1jgruwwegfipzdn8c3
X-Rspam-User: 
X-HE-Tag: 1774553248-461039
X-HE-Meta: U2FsdGVkX19+el7W+SF0qVZRn8aJSc5rZ8hnXZnBk/KQEculbVJL8cmPr7xVcs5AuUAarwYuqI1RLTxQ9AOaEKceEo96T/TKB9shLdf2VpFhfaNNTLMxaDdHeGbh0vzX7Z3ZP7CNTJ9KF0QBPB4fSGhjtlnv5vdX6Y0Bu6LMGETa5OV8NKt+Jsuq2FpwPwcUtSjJD6fKJiDgm1nyFDMa/FLqQfrzqgFUlfbJTXCjYuqN+eiPT7SHeZuuE4jnnZpvlSGkNvpRtmgwwuBs5JL2O+z0EEVINQ1SR7NznL1sVVIPndYx7uzszCQAQTTuQPkNSZONaMqctP//fVoGO9N+wIYgEVOOVAv6OhBvvUEwjaWMx6CE+QIfMARDvot05vnb2zrGCARAd+silegnLAYb/DeAtK7EOs7BrDIRjEfFTXxc32o422TZNhPHjz4liyNw96bxj05EsPwhlFeZ7qa9tkKJZtXkmLkk9sfcDtmB7rU7Kx8nCxqZmFfvdp9hp/Ie50L8mdZo+RFYEhU6j0yMSEGquL2HlEKa13Z6lFkHHPdbt6rdGsvqy2uY4oT1lPxIomU2OfblsYRqM5w7bhOhQfvomtNGW4XzWPGzeMnzb6CfJU+YZ3ZLtGQk29jigI0TvqPvZDf5wdccMtK26NTIU5yB7c2rmKqyKQwdlZOPKAffJG4yx3ICD1tJ+FSldOe97mgkozhRqyyD5gPReygXCKPdANTcg66i/7+Dxj27iVxP0KfojUmoxbVE+iqIGK02eVoHv7zmwdIRU0wRkNMRITOyH6pEV5EqH90Y2pe/Q689X/uDAUsrc0R5MlNff3UR3lkWB7Bc9GwVBAG8BLedyVp/uBEdB3SuPzkyJQirCWW5G9t1YkENCd6td3EwuZBXLUBK9umMSU7QnNjFluOsNo87IwSzX839hN1Wk4PeJJcDZchzYlmpx2fMtm65lQ7BcA00NLM/Q1HkUtD/atP
 7gIzLRtV
 6xsvpxGSb2SRWonC8nB9c6T5IpJDhJwDj3gmqu1FqHcwNGr1KQq7h/O5UxRZGWmF3iKCKhetOr4xBeyupGrtwyodEeYriGD38GDJprZhAIVjFHWjg8y7BS3qtdq8/3oQcRdPXiTUZoQKjo9Qw5/6bctK8g+WKc5MD2Sa2Hl7lYp1xnWMBlu5uuecraLGD5LTwbDVU07Or+3ngDiLeBy18K5BqHOrC83xR4B+nsHHWGgNKJSewHzcn/J3sKqVG8O2nCJoe4nal4GQFxOWggQFvTjMDXRGAuIB53mcN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 20:09, Vlastimil Babka (SUSE) wrote:
> +Cc Suren as IIRC he mentioned some intent to look into this as well, in the
> mmap_lock call.
> 
> On 3/26/26 19:56, Lorenzo Stoakes (Oracle) wrote:
>> We are moving to a far more proactive model of maintainership within mm and
>> thus put a great deal of emphasis on sub-maintainers being active within
>> the community both in terms of code contributions and review.
>>
>> The MGLRU has not had much activity since being added to the kernel and the
>> current maintainers who kindly stepped up have unfortunately not been able
>> to contribute a great deal to it for over a year, nor engage all that
>> heavily in review.
>>
>> As a result, and within no negative connotations implied whatsoever, it
>> seems appropriate to downgrade the current maintainers to reviewers.
> 
> Seems fair to me.
> 
>> At this time nobody is quite exercising the maintainer role in this area of
>> the kernel, but there is encouraging activity from a number of people who
>> are trusted elsewhere in the kernel, and who have contributed relevant work
>> or review.
>>
>> Therefore add further reviewers, and at this stage - to reflect the reality
>> on the ground - we will not have any sub-maintainers listed at all.
>>
>> Each of the files listed are shared with other sections in MAINTAINERS, so
>> this doesn't reduce sub-maintainer coverage.
>>
>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 

Let's represent the actual situation indeed. People can always become
submaintainers again when things changes. For now it's effectively a bit
under-maintained.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

> (I assume the newly added people will ack their additions)

Agreed.

-- 
Cheers,

David

