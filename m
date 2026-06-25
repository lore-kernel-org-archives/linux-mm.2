Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36645CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1905E6B0005; Thu, 25 Jun 2026 10:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140676B008A; Thu, 25 Jun 2026 10:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057CD6B0092; Thu, 25 Jun 2026 10:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D09FE6B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:30:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34AFA140164
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:30:41 +0000 (UTC)
X-FDA: 84918671082.16.F30DE1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 42A1440014
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:30:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlsK7Ou1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397839;
	b=41W+Wswc9tw8DkWtVzIgLej05oNXLU5H21dWOEftIc1l1JKJUtokiWL6+vQmK/5+sbPPSP
	A5SHKZ6J6rIBzmFBwPPTiZunaH5+KiKDQOQRDaevUURi8Vb4cxcAF5EKaLzNBEa/AXUGGA
	/b/ba9/n9+qttI05NJaxQ4lALowRgxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJTjD5JnnvNb3nU1EXqFs2iHgmAV6xZmN6yWC5ICfM4=;
	b=H7GTWHv9VFJua4Zqh4L0TAw0oVKkCmoxudbntf035DC50FKs4F1VI8r8QWvDP38T4QcAE7
	NgTmjI1pH8yboiRfAzHViSTVYdPLPK5ySzyDBw5vV++KKHWIOd6PBpg+mnUn1QmS9RtDEm
	UeOi2IkVjy6fUORxcO9sSZniDKwVFJY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XlsK7Ou1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BD27441F3;
	Thu, 25 Jun 2026 14:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436311F000E9;
	Thu, 25 Jun 2026 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397838;
	bh=IJTjD5JnnvNb3nU1EXqFs2iHgmAV6xZmN6yWC5ICfM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XlsK7Ou13WOHjZC+4GA700k0nIyJiBpToQLJdjaFrzsznBTBslPsKtyEx7F7omgSU
	 pXPiKTknGAY6CWQTjAsEf4ebie9pTTJq5TuVVkg8gQcOnyoBfP2BAX4IdCB1y2nUjb
	 OU7/LwHWDg4nNF59SL8GC2u3qo7GmnJ05gfDZbozE6jyHvdYNNh7jvRHXIEDX9sMRY
	 wbdFC4qtN3l/a4Cs6cQdyWl048Bd1TU9tkdtiBbzIgRclX1lS3/5Te5c1nixsqeE/H
	 N7It1VibnL3v2PJoX388ynZ1fN+lvXAIOyMFvNNF3lB/pg6jbXhlhp7XtgS5+iS9UD
	 xPzlOPAENy9ZQ==
Message-ID: <dd395d30-acf2-4467-8b30-cdf2532f585e@kernel.org>
Date: Thu, 25 Jun 2026 16:30:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, lance.yang@linux.dev
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <aj0vjdBN-oNMI2yI@lucifer> <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
 <aj0zDKEJV35V4kMD@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aj0zDKEJV35V4kMD@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42A1440014
X-Rspam-User: 
X-Stat-Signature: di1j739yaop1qzr4iboqu6tujrbeumm5
X-HE-Tag: 1782397839-288463
X-HE-Meta: U2FsdGVkX19BdpfWmLQpsDIxOcIPp7Xh8Es2rba9hiFBoiX/3MS97mbzR+HfQTuPbmkN9vzEAM6x+m932AO0Xzwoqn9J1hEaxT3zdFTQxiPfls+jedeS6B2GuJl2ni0pGI2UlfOgEBW+j/Elrpcuj2KvMqaz0dDGO778IrL7zmAsl3oHVH9xrabxsc15uASuT3r1vAwCylJMCg1IH3JgGbKPrgNuCp41dLITciRiq5zi+LXZBlq0asOXni6HTauRoL1E1YaSnz6SxZCGfe6SdYI4UV8ADMEcRvoIH1lYta2nXK5icLQa0oxroxIfOxQUxhrYJovGhed2n/HDTYdUGVXKqAzbP2TbJscnhOKoxJVkTn2PDCyW21QCOjVz+MNcQ92GAbp2twxwpF2s10a70GijQ/1XsuRrghsz517cCqjWRrAzQnHZvuQkgRlqviUKiuX6LDby5epEyekaLYG9OQmqyS8AEaRY821/L7htPB/u/+T1wej0VH0EssSMz2Jm++rGh9+/um1tt0G/sREcyqZ1or/kTjwrHpOXjpvu8SM9AcIHF6V3Lsen1JTdWYrn/s8JTQW7EsBk1knoQMdfcx0OJFA5tkFqGm+E4zVZEDKTCQ2wynxRG4dHxUR5LMm2ZrWtWga3S+I+kgV0Fs8pqURTFxmhl1NUh+SE88IRlgGHFxo8FL+c35g/vrH1ZgO4uEFzPOmLyfIS1o6EbiiG0EG7xWekO4JfqSdSichPZcOxnO7q4d/G9QRtgy3ysEASMjuUqv535r1OU11WeaZeFbpnOGxyKduSCdLFwmh1jPNPxSfDA2QZEsoBpYzj8vAXHLSqF6sIpHMvQ0qfwFucX1fSQ77TAaQF1t7XpWtyphle2uXT1exXsTqDFy/uZ3upU49tQAxNY6VITcbthAvsjfI1m4KtQKTg53xd9xJDFuONGoMWXlx5/ZExH7S3YB1kfMWkz0e4isG0G3GxJlT
 5OvxIlxZ
 h9JFk5AcEyAR71FZVJhAyzmyP/ah1Syw3LFt0117fD78MGcr3qGJhJgbOsluyQzhSOxJXOstOhZdqPkkkvoS0EMlPtVuClIXjTo5SUoAh+j1MgeTD1XSL6+bDASW/fL8QKTLVOKhOpp+3C+ykROXGZzaSlDb1rRXG/yofqlBNUrZAFg5WQk93rlJX/BuYtxOmsila4lcAC9iHbh0w1SpOjxSiII0iW5EmK/07BKRrEn1Yzr5HEfpu/GhbAFxn6xF99XarRKsE2zXekKu5RdnMuyZgf5t+xRwJ5Ajc1xK03hHnmzoW0dCM6qSt49jyqMGOw8uVTKt3h1J5pirlGb26wvgFHFYzcj+nrL9kGaY7GRSYATC0fZ1KwvlgH5762v14oaZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 16:02, Lorenzo Stoakes wrote:
> On Thu, Jun 25, 2026 at 03:49:59PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/25/26 15:45, Lorenzo Stoakes wrote:
>>>
>>> Let me first say that I absolutely hate that we continue to support museum
>>> piece architectures to the point that we have to make changes in core code
>>> to accommodate them.
>>
>> I wonder why we shouldn't be able to trigger that on other archs with
>> !CONFIG_TRANSPARENT_HUGEPAGE ?
> 
> I think this should just use CONFIG_PGTABLE_HAS_HUGE_LEAVES, since that's the
> property that literally defines whether check_pmd() makes any sense.

I stated earlier (when motivating a proper cleanup of this) that I detest
pmd_trans_huge(). And yes, like I did in foliowalk, we should just check for
IS_ENABLED(CONFIG_PGTABLE_HAS_HUGE_LEAVES) instead.

Long story short: Wei's fix needs work, upstream is fine.

-- 
Cheers,

David

