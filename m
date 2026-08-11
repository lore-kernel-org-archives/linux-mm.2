Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED291C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025B46B007B; Tue, 11 Aug 2026 13:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EBA6B0095; Tue, 11 Aug 2026 13:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E589B6B00A0; Tue, 11 Aug 2026 13:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2A6D6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:10:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E6B014014C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:10:35 +0000 (UTC)
X-FDA: 85089627630.13.A63F6A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 77FD940004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:10:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7X2++rf;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCBNxDcN3O2GpPTZ53sd40013NC+rNNPo2MxMRjb1tM=;
	b=2/dL3sffctLKY+JIF0RTZpaNu4b1V+p998dtiDgs/hu8yd+n7JnybN5nDCxBRvY1s+jjfO
	vJEYACpBRQ7WrHObtk0LJGQxHgP1632SVNnVqM3yJURg+tag3Qg1ewJ13xNNbUtpszp2sL
	Y3hJOg+5wZOsOFg6M80Xqdl5EUvds+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468233;
	b=kfK9D1UQUuKvz05qM5SPku9YpsxfxV2XtGYMr8SnSA6hoAGLuKmIbcgU4YXH1HBUF7JeoN
	dwlmCAnHZROSCR94EtuJtz2Sdjopz9yFH+5MJDvWshzQ2Sb3bUR+B4matnocOb3m0LvOyW
	1kmJVE+XwZqJYLVfBJvOmzyUuv00mnA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7X2++rf;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C7884179C;
	Tue, 11 Aug 2026 17:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F401F000E9;
	Tue, 11 Aug 2026 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468232;
	bh=MCBNxDcN3O2GpPTZ53sd40013NC+rNNPo2MxMRjb1tM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I7X2++rfnldfSGFK+xk3u9oWU2zI6ibiB9i1kKaeSqwd52oaecMd1kwAbXY5ClATB
	 zsgKLAKZbdRi2FdBGdkUkT5Q7bPpdvLJGBI6m0v60qeglppT8ylvq34hxD4Kh+QC8p
	 87X6jBXozMN+0rikYQHRm2O69QcbDA5hZmSP/8ZW2yxo136a6K0GjihIcqoWTGjm/n
	 ndEZ2Ak2332uGblLtgv4TQjTDlMntknShroH+5t5JD2Jj29EWHH1vKOsTzO7qJwKMr
	 pFsX3EOuy6r3UEjYexlgJPClsObzPAx7lZxY4Kr6UArsDn5s3yySzIp+VrDda2RW+r
	 ouUysHo7dNA2w==
Message-ID: <26ca1c70-8526-42e4-82f3-0de90ba773ce@kernel.org>
Date: Tue, 11 Aug 2026 19:10:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping
 walk_pmd_range()
To: Hyunwoo Kim <imv4bel@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-2-imv4bel@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811161949.3879321-2-imv4bel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3rktm48fyubxqw53onbu7x6g7aq98r5h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 77FD940004
X-HE-Tag: 1786468233-46778
X-HE-Meta: U2FsdGVkX18x5GrQlRXrESJ1G9nQyG9f+57DFbNaifmrzBlGo7c/0VzWeE9yBB/TU25ggifPepbGoInx55QjoW/cLXYXOiTYMLLmUtLUiThwYbtHhMVnplJ7pQ9Wv+gcjek40n44ZE9IaxfnhNjC6TB5VT86s09VTIM5L9q6dYkT+v8Ts9UbRXbGux79y9nO1KNByUvg3dZttGG5zl9529EQOg7aKNGVfhLoZa8ULrqXY9+9qcQBv1yKuI08yc6fdb7IL+j9J7wMdjB2FAM8MWabj4J3EqzkVzze+7JpZ+3ua8RQKpYo71ep6mz4pBOTM2BRBSMBiB7uyB40odGeOcTC6OtW7JN9OF5xiDPDY2i4HWyrz8nBrb7iSZVEDoLM/pg/Tq4FHVuskOOdYB/LLnD8gYmz/1RMb0qclmzC6pjIZilIFfX90wlhs13ENc3LIZP3m90aQUSgidohZOwyp7uVBOZrsscdLXWHzbOWya8Wzt7tsSIDcfmUJojttus4NNHvnrFR/V0E1G9L1antGU8ALJSRQC7SM5fsasYAJd+9Hnc1RrUE/L3/npI4JB306mH/k4pGfeaE4rMwNMQTuRrkzH5OtB5BwuFwFzCnJLhe1uAytmZQ0rWyvehp5nO9MAmeDt42ETf0L1vYcVNRg0oqFce94VAgOi/tkQxm+WfSJzM+inRW6IEMpCcmURr1A4w7oxBdsbMwZe6J5KXMH8KfkwLDpigrYGeIVAVfJ1MuWoerPyZTRnC0HbUJhTjiXiJ3ifrmImMyB5HahuzVnEJ/5q4TCetoHXzn8kBhMEikZsPHytIHp7pM5e8jgd9tgT1Wx460wh781EPl27/vbuu6XdK2XsQ/EhUiamThmqNeFwfdajhdYX+TpfUlnivFjyMo4MacocWGApY2mTdCVqv+YQdsoWYMtQIL1NIukOmniyuyzdmMAGp6k0iNtvqU2Gh/068DXS8Cc3s9wo0
 y6PDV3HA
 uQrpQeBc9jXSHm7egDUUXj25n9wsBOAl/2+Way0p2B/zyBVLvYAo/+OI/ZIGhP9xWQ1VcFqrpXqDFq17+2Px5tBxYlvZGwT4sRWe/3bcy+O5txaz2v52ybePtFi7kzme5jrxJJBABFP/Ywicv9fLBj5ih+6Wby9soHb6JuJNAYBA3C5jM4aZlyVKrNL5Xyy+g1flY3Hy2nXEfbC/vjb+J8Zsqw1Jpz713iAPYBePFkIrngGIcvQn2XLXc1hEdRv34mH6n0918QZVxxirV54qKVEHfIC8SN59oWi/CZsd43tozMnmiL/gMdJaHvAM9Kx59oGoB4Ue8GPW8I6gTRhTj6Sys9Cimfn+4MzzY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 18:18, Hyunwoo Kim wrote:
> If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
> check is retried. The PMD entry may be cleared at the point of retry.
> 
> In this case, if walk->ops->install_pte is not specified, the code
> continues to the next PMD entry in the range without resetting
> walk->action to ACTION_SUBTREE.
> 
> This leaves walk->action erroneously set to ACTION_AGAIN, which is
> incorrect.
> 
> This was incorrect but not problematic up until commit 3b89863c3fa4
> ("mm/pagewalk: fix race between concurrent split and refault")
> which updated walk_pud_range() to check for walk->action ==
> ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
> to be retried.
> 
> In this case this results in duplicate walk callbacks being
> invoked, which is erroneous and will break any caller that is not
> idempotent with respect to this (and waste time for those which
> are).
> 
> A specific example of this breaking things is mincore which walks
> an internal cursor data structure a byte at a time on assumption
> that page table entry callbacks are called only once for each
> entry.
> 
> Fix the problem by resetting walk->action to ACTION_SUBTREE prior
> to the none check.
> 
> The pattern also exists in walk_pud_range() so fix it there too.
> 
> This issue was found through AI-based fuzzing.
> 
> Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

