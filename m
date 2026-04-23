Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BD7F589DC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC8B6B0092; Thu, 23 Apr 2026 10:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682CF6B0093; Thu, 23 Apr 2026 10:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598CB6B0095; Thu, 23 Apr 2026 10:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49D926B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:17:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC5EC1A01B0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:17:24 +0000 (UTC)
X-FDA: 84690023208.23.367BA49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EDF5B40017
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:17:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XeKL7y/G";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776953843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2UA4f7wSXZ4/Bo80ObO/SE71m2E320Jl4CNWIv04cU=;
	b=7YyRFjeuv7g6Du9yPikVs6iEceMl4NO2ELwQ2PohpAVBM4+vslmtCv1bxHP8B+8kvxSpQt
	l7Yh/dKVAr7WasMk8oB4mwINQGG8Ds2LW4zmTaHOq/MN7RgpddVfJ6g97b/QrAU7Lk6L2J
	H90nLgrJm8EAqIFAFjR9IOSEqxq3Rr8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XeKL7y/G";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776953843; a=rsa-sha256;
	cv=none;
	b=5pcmkL16lMLRwgXWfUIAo2CC4yyTyR0h6tLpswgmCLcgHx0N/vgbRDHfPoqkdzkB9QhwYQ
	Ohe04MauOswMx14wu+ingCaZTSnRNdSPFIfmXfdb1/XORF1pPTbq7bOMrUR2k6iCKPdd4p
	hA/NUNovbFgRxIBWnI3HKwwxkU1bLaQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD6E442E7;
	Thu, 23 Apr 2026 14:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A80C2BCAF;
	Thu, 23 Apr 2026 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776953841;
	bh=HYlxK/A4zhqyWVJs4vRBWAO2MAfjEq9L8+wa2Bhw8rY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XeKL7y/GC7ftp33dfqEyR3pNNDrerNvqacH7Vee2ePfHEFzvCo9UeD3+oX+yIfPAO
	 ILHF0doDwuqwdFiDcGq5ONDas/j7G5rCNU3mJBh+Wj1Gin+JpNVzp1RiwfTxN8DMHc
	 /HF339qJxVPKpn9oeZzMTax2CpJp/me8QPrN4JRPSEPX10dUyi8NEy/oT0oo3L2Kgj
	 FCoPKkE02uZNnSACiTs7gs6oIeS1wdC+Ta/Atdl9oZFu6XQxUcHuoqYQMhtcvKhZ+i
	 ty92ArzBL6XrjbhEy4axVu7tCV/mDyNNZioj3i8Vy91PP7cxU05xZtV830I7H13FBF
	 QHDKiozo6ZBbA==
Message-ID: <07f546eb-e523-4742-a8b1-ab830ec4d0d0@kernel.org>
Date: Thu, 23 Apr 2026 16:17:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/process_vm_access: pidfd and nowait support for
 process_vm_readv/writev
To: David Laight <david.laight.linux@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>, Alban Crequy <alban.crequy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>,
 Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org
References: <20260409142256.131676-1-usama.arif@linux.dev>
 <62d88cde-efc0-48cb-be8d-813eda810343@kernel.org>
 <20260423150423.1a428820@pumpkin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423150423.1a428820@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDF5B40017
X-Stat-Signature: s3it3bz7r7h8zz9u4szanw4ia9ehm9jd
X-Rspam-User: 
X-HE-Tag: 1776953842-228688
X-HE-Meta: U2FsdGVkX183QGHncoQHdiQmWrCWyf9akl4ub0tCXSO/7c0EA+Tu56GenX1U4REWKL+bkH37E5bUT1YFff/Bsrl8r5uCg4hrbaP025AEEKCS0jri8l8NbdrxbNNtdEUqj4PFGef5NPbe9dAy4KtiqvvhtJGZWFztAU8SCjYzQHk1EOkmLRWH3x8UPS6bIHI8vtcNv67pNFhUAgwTFbsnf1WehwoxQBGeHgO/l0akg5KkQF0x4WI4QNgiKMeVyo1dqXDpFXNgGitjLI02HA0+xZf7V+vTGcYOHglqz6sjAvTJCYDbTHUg6wANrQXCKkFk0CiCNbTnSczA7COuvjBjdZxIyQXTQYWdrZYnP7zYXDEMtkJreHyZttXMzs6NLVoV33VTH+NOSs5bX2CXWFN8wNX8VyRkVnY2+PS0cH+R6ejdLx+TfYc3e7Rub1pn1mnDcRM4HgL7Cp1JUXXaXECs1rmkxeyPtJe8+0zS5CkKWrJ1fzPiZ2hd8E7+vpwhBMXU0RgAOxQCmjd1linit0cfoYdt1FxcMLyYcR21gRAelXzYGiZAtlMZ/73fhoFMMXajJ9wriNiw7NBxtV9fEWPJWb8poWXB53UpLofrHdFbM6s2xZTHicWj8PtjqzYiU3M6JYsbGLVtTO5l2vYub5NJeLXnWkquo2/Pf63TuIbBniJjTW6onQOlf0Jo3jD6A90XXF2BrvbQjYJEfOZvXLeuyXWm4VU16xmlsXqtmnKReg3R3eQgUG+YCC3nM1yh+rEXm+/9jDZzFkiLWxxka+INpQzeHKiisOo6exOsq9uDxtlyGFhlxpxV/RBaqQfMOQoEvMubTY3E5xY8ZS/SjygaKG1/HoBTCbU90Wwu6G/amUHqzT0LdJzoLLWPlkvIPE0iENWfvXIlv9CLZqf2RmxxMYkSSsa0I4ljyk6/zS96YmuNsW9K4LvCVO3dwit4KZluH6a+jJkzS/fVEee+rTO
 wy1j251e
 eF9ZtVnY29K1Q6rlOF/Ossjg8w39pEotyordj85zzE81jf1MNAGTp/F+/7bFYqbvMHnM8jti+fA9iRk/BDayJnAf/yHHATfeYnhvzOv7dQ/7LMYfJrJ3RlPkjnlUzDOf0wmFjl4phAp3ELhDNGZw8gMyvnKB++c6Jlck0m8E6238ktoFp+B/ZJH+DqV8C9WlZyha1maklkF0lM2Hx3yikVmBengLI8fpj5oUm38N0O3K+r0EnJBSz9Cfd4dj9SW256eyozBV2gQljwSquhAjNhctJEzC31YActkPO6rDpSrE2W57MF6QF1dDAs6MEGvvcvohOdVKZVCH4C15CUY9q3ReqiRuWLGY5BgfVdMreY8vuQQkDrwiLomMfKG9/DsLI113tYVv1tfYqRfqZKm++5VwC2eHwts7Y72O8EFdkWKqFWx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 16:04, David Laight wrote:
> On Thu, 23 Apr 2026 14:52:26 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>>>
>>> pidfd_get_task() returns ERR_PTR() on failure (e.g. ERR_PTR(-EBADF)),
>>> but the code checks "if (!task)" which only catches NULL. An invalid
>>> pidfd will cause mm_access() and put_task_struct() to dereference an
>>> error pointer, crashing the kernel.  
>>
>> Yes. Should we add proper selftests that exercise these code paths?
>>

Just to clarify: I meant adding more tests to patch #2 that trigger the issue here.

> 
> Probably worth checking what happens when a 64bit process tries to
> read high addresses of a 32bit process.
> 

I guess these are a bit harder to write, but would certainly be useful.

-- 
Cheers,

David

