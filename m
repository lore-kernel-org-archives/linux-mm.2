Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B79EB1043
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937FA6B0088; Tue, 10 Mar 2026 06:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B74D6B0089; Tue, 10 Mar 2026 06:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E75F6B008A; Tue, 10 Mar 2026 06:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E79F6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:56:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02F4A14059A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:02 +0000 (UTC)
X-FDA: 84529848606.15.761F4C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5517440007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:56:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDK4o+0I;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkI1jqCvvM+9mfVwQrA5buH/RQSHp3pAOSNmb9U4PCg=;
	b=KdDy2BjF/T5HLefNGyUZ1dbOH9wkuv9MmSn/HV8YAQ/Z9eb19XEYdoZ20dihDj+8KbrtXm
	EkhhjhbkLb2Z/6CjgE/Phm/w4rgAWn5yMqJzPIWkgx5Cjhr3ER+LeJ8KaEL+qllaFQrjDO
	xkCht1BVR5Vjak81lzsVAwRTn59WbWU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GDK4o+0I;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140161; a=rsa-sha256;
	cv=none;
	b=4ULag/h1TRxm9mnB10rgH2x7W8my3TD9VGkniBZJd4dzX/SxQkBOMoWDFQIj3jitp0FSXQ
	S+pcXW+M9u7DCtWP4RJ8Whll/wmeNNxnKHvy2VqntDgvoKCA3JRPo5fhqZRxiWOoAOPQJd
	XLeG+54ZaVrs8igMyUgWYQ3Ve1/fGYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AFE62600AE;
	Tue, 10 Mar 2026 10:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3402EC19423;
	Tue, 10 Mar 2026 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140160;
	bh=ArMHh5miEVyIWBjWcVqK6GugbsLlDS/QQm5Aj1WgKEM=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=GDK4o+0Ip/5JV+tHpWOrpKA8LhGlkubU1oH0LvdADoYAmj522ddyfErcLtYdcOyp3
	 a/rlj6m5RDGC1DAm5L0c+kmLipV+wWSsOK29E4YGHxhPfYV6J527GVE6SIiHQxHIOp
	 EKN5poE9LNIVtMZB5y4Jdg+2Nb+R9t4jEr6yJee7iBjHLu1jlF80gJtW8vXAeBvJRd
	 BMgmYkjOCaPtoPHkuA2bkyASKzb/5fDjsfpZ73xpEzWYevp1LHoevAZFr4jxD8XmB4
	 mViEY8j74jENKP9RW4JCVihkPFf7pkruj3sGistboY3DAKdeJEiOVUZooiWtbuW3Ly
	 5cfBJ1A+hPlwA==
Message-ID: <be647d6b-9bcb-41c8-bfcf-7fa03d2b942f@kernel.org>
Date: Tue, 10 Mar 2026 11:55:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Content-Language: en-US
To: Xie Yuanbin <qq570070308@gmail.com>, willy@infradead.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david.laight.linux@gmail.com, david@kernel.org, justinstitt@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 llvm@lists.linux.dev, mhocko@suse.com, morbo@google.com, nathan@kernel.org,
 nick.desaulniers+lkml@gmail.com, rppt@kernel.org, surenb@google.com
References: <aa7p3eQfEuh2wObQ@casper.infradead.org>
 <20260309155933.41179-1-qq570070308@gmail.com>
In-Reply-To: <20260309155933.41179-1-qq570070308@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5517440007
X-Rspamd-Server: rspam08
X-Stat-Signature: piq1it13x45bcykz13jy8z88be6hwot3
X-HE-Tag: 1773140161-341463
X-HE-Meta: U2FsdGVkX19U4np+x48c/9OaxRdX8xwpw0QjOR4ZyBaqnbYK7VDfFwm9Qiefl4ag683Rzr+i8bC3RFXukemDx09uQR9LjZ5fRbJPcgJyJvH6lfg6G0OQKXXBgDbPsnstW1tN3DTG9SO11DSuurG0crXdlElFDe0VDfZ0Jo4Sel30jkANW5Yslgq95PGj5hI8qwabYwyhG8sO/B9skNQg9txZ9Y57ACfkkawrwM4r8ngStpa0OzcKAKDtouLL83FSCp37EGV8B0zFT52ie0urcoiJOerQw9wgoif57feexU8aZW+X+J39qZoc0b6N14oVpGFfBe5vku+KGtE0SBUTYamtCDssm8F6iipoOYDm0tFDk/UleIY0dNbnnopbdt6K9GsEJka2aNF3tWbtt7IgUjpQiQJSHANeKVfUlN4CVYSltp6SspP3KhWr1y9P4z4Ryn4TefGaDyytKgsWK2upQ9d4spjMqXLTTr3FJYv+8l75X+gIhYHkUP1shEUmYMl3XoB+7jKl31mKG8hy22tOZX04rWvV4xLkCgMRJBcpmzPIdgORRBERKvmGL4uvOViCHkb29R3Iy72IH4wTnXPoHpqyyAGFpYDifW8Wnq3lnfI9tOvzfQ/uAqBZQSoUTnJ1JvmeIAO9F/ZUeJFGJNx+DEwpHPyqPXruyTEG2Q9e0GLmcleXmUum8+imUUuWSZZKQgx6npmMkLECwecSztAwR1+CYkvh7hnJw4yQh4qyeulmVlhryUc/fKaNzzRc15+cD9sdNkIQpe15TrQJSbuqKpj8Y1pXVyxhEbFwhouzuTOVqNcXDax4AdoF0KVnrXYciU0XDGWtxetGM8QuKTkBopjhaIyj5cCB/WhjXojNmddWEp1DfDWdyhgG1gsEmvNZ7HAnLO/8otPAjTX/XquaLOn62MznXTTPEdQGoh35nnbio+fiteWXVZIdmflXW5B2JT8OXMmODm4XXD5/hFg
 L8EfLfi/
 pfuB9vkU3gpgi895jgqEEo+sbkPht8Lu8nzWr31wtebTpAcm3A0pM72f6qBN8PeneonyiGePJsAxNkx8fyCyzvRLMi8org/qJaXkdMFdzJvKNh5UacpYasRswkp1fb+9AhvxLYjM5sbhXY/0zjlXruZAGeYNcoBgPpHA/u2TBj4YYmDGgbIP9x9u6S/ek5wv4/UBtEsRZJglFvaX4kfZoBd7fMiPOY5xcLOfoxnjYfMGiEfFZA31Tn5JGlhqOGAI6YCEma7y94qOkCsECw2MAQiON4T25TgwG/M4fYis3pJd9v8FHHhf5IjJQmXTQ7aMkhDSzOzHJzDqplj70P6ODg/6gpC2muKX6xRFSqe1WA9odhQgEkUfMIG129vgF2i3QTHnMFQxUWK0a/TywWvEKKg1Ihg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 16:59, Xie Yuanbin wrote:
> On Mon, 9 Mar 2026 15:40:13 +0000, Matthew Wilcox wrote:
>>On Mon, Mar 09, 2026 at 11:38:11PM +0800, Xie Yuanbin wrote:
>>> As shown in the commit message of commit 242b872239f6a7deacbc
>>> ("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
>>> the code "unlikely(a && b)" may generate poor assembly code if it is
>>> actually "unlikely(a) && unlikely(b)" or "unlikely(a) && b".
>>
>> Why fix this in multiple places in the kernel instead of once in clang?
> 
> If a and b is both unlikely, then "unlikely(a) && unlikely(b)" will
> generate better code than "unlikely(a && b)". This is also true for gcc.

What are the details of how it's better for gcc?

> As for the issue of clang judging twice, I have already submitted it to
> clang:
> Link: https://github.com/llvm/llvm-project/issues/167117
> However, even if clang fixes it, this optimization will not be merged
> back to the old version of clang.

That's life and not worth complicating the kernel code for. This is not
about making it functional, only about perf.

