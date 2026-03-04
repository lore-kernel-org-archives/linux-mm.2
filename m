Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B1AEB7EAC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 08:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6502E6B008A; Wed,  4 Mar 2026 03:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD9E6B008C; Wed,  4 Mar 2026 03:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A9A6B0092; Wed,  4 Mar 2026 03:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 450DF6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:56:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB2F313B21C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:56:02 +0000 (UTC)
X-FDA: 84507773364.26.83C10C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93F7310000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:56:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mde5z9it;
	spf=pass (imf05.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772614560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+QXxKchr9LYeZChUjeSNxKu29zjd0jIURMpqmqBzLY=;
	b=bzHTyQV/gqWf8m1A2cMxndLPcc4eS43ifhX63OyRCYKOqbA5RnmNUqJUiIvtGWPs2fy4Fv
	it5eYHj/wJT/+Yx9cdywoSzfJcPDso6ex6PzTXuprKCZTkfLiF9tteetdR+PUJSAjibLcw
	ZG7SOpl03N/sqN2VNtg40yYBZmJNi9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mde5z9it;
	spf=pass (imf05.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772614560; a=rsa-sha256;
	cv=none;
	b=nIWOXigyj4T8IHNhM+c9MQUMu5/M9Pg9ok4YNekxbJwtOcvGvqQmI7zfpnFV9qT+3f7Bdl
	s29Yq9pxBWJyjrrQqPxPxGpg2RYhro+zHaoTEVslKJpLMY9iR0NK4N6Xq6I6uoOsdf1MUh
	obPA4iR5QDRmAdDo3f5C2imdEUO+qGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F1C8660097;
	Wed,  4 Mar 2026 08:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB666C19423;
	Wed,  4 Mar 2026 08:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772614559;
	bh=kFiPfWO1NT8w3v/5flLCwXiQ7b1wqjZeClR10RJf5cU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mde5z9ityG6/gNVDbimVo9o99JOfqaDn/OjU7AyTF3GTRDphbmwKslQ+QbBqErz3A
	 KEq5GnxhjhoFCuLf2GTL48uBEsU8MEoq9u23fNeCGXxedsRjrJi7dYj77CHKob4Lo0
	 T8eGRmDI7cfAbJnZTHQf18ETvQuNkX4NYONhMtqHFSh2XhXkXWs0UcPWu7hi8qJRat
	 YZHmJWnbqtoN5CQ43fBwIPQ9auISIlajP+4rzsFiW+6LxGWUmmcwowou7O2wrseSxX
	 6y9IJwnirSwFmERWCwnTJn6D4a1oH6a/VZGkfniCfz26JJupmKaUaBw51V1v1ITbY8
	 CaWMxGDFw7/lw==
Message-ID: <b60846c0-bbeb-409f-ac3b-cac7f61469d5@kernel.org>
Date: Wed, 4 Mar 2026 09:55:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 04/10] powerpc/64s/tlbflush-radix: Remove unused
 radix__flush_tlb_pwc()
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <efb8f299f33659fe07697a038138eb5760c78707.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <efb8f299f33659fe07697a038138eb5760c78707.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 93F7310000D
X-Rspamd-Server: rspam08
X-Stat-Signature: yattwgzo6n9jpkgr6mojo79rdtbytfsk
X-HE-Tag: 1772614560-622474
X-HE-Meta: U2FsdGVkX1+r3mRud5QuJLMDe39Ll0FBjA2phEo1WAvt/0jUni37YBEnCRFHYPZhYj+XwSB/tyrUM5/OEsqMOtsDO58i35jmqo5gBo5xi8n8T96yGFbtykwO6PxQ7D7L4Gx9AZI7XxmVDpz/khlOTxT9d+Xl7vqw0y5REnvPtp8p7GQ84vGJMHW1iSGRl6IQIMSlHYruYP38OFFw0MAUa+HtHM6tn8VsxS2Rp4dfXnlrShMnrBM29U+5B7ey8IblBylnEegb5Uwn15pGX0iYiGjUnnpqO32hTRuR/5XvoEespRSLZJvPyffCIhxP0ZXTNxaQV63PWEwmQDC0DKoLVxaOyA3YFL6vsJlNLhP+7QEV9GYA5chXAz3uNOOc3i2cF1pYb4KqvuXjyT+L55vvkxQGFch+0mtDHNW5QlGPtA+Ba07oLYU4PrkLdGzGJBqw02IdGq6Zr3ODHqoTgcSsdOZJHyqJyHOzxSbS3ePXYDfV1Rqiy2K/Kw6n50lbxz2Rjn6Porbo6/twdVSZz8chFSOq16FskNkynjqwjRyqKo6oGLJOd4XdggoqyHOQbWLi9KAK6ZBlTIEkPxxlpPyGQ9QtFAnI1vsIjnVmoGOLY0HzEUXHc6mXWhJfdwzMGrAOm7YkknZhlmo3IV/qpIRPHkktHqm+qomD7Vi9OQlLlhZYmL2w3GFxPka/QxafDOELFqn9LD4u+XZIGFZkh2OtR/hLfpFuBuJzykjTZobbUp/ssBTkjh3FeJ33fCAhsbnLICBbSXVxCiHw9uoAI+k1cFNZIluGmzPh2g3lGzXtwoc14AWN6/jqu/BzGswwZvvASPyI5CcOcIBQkzYLeV9I06jMoGn5wyw8dDDf4hqovgzFlee3THc4nTDrWS8MAjCh9isG0nJoVpN5cQAtLYH2sM36Unx+wVvtSk8HOexDUcJtl7/mZrIowrkIxu5u0Cm01k0I5NZnf/9QWWSpjQ3
 +ULDdoV2
 6RPSIxoOTv49hyfKxDNZBhS2qAYZcF7qIwEHsEfO44B/dWDM6pzJ8WmuUDu4rRODj4bEKwHwNIGtMI80QkmLEiYhXkSQ+wqMEI4tfWdTCUeFxletJB+8cBYcR7385mrN3QrK/Bwo2R4AJoY+UVvN8oJVQKnpzZ6rPilv9E5J2ZrTK6uCiQafyd9IJBuOcq5E1tzM7QaPWrF8MZoXwg3OzDQgL+wWfi4l+erL4wVVmTQBb2qSyAKIpARz3IRT/+qrlULOhdA/pKCL42vG6PqwwJ4J9V+v88B7Zf9y721fwTl0upV5gc5cTwQ6jR2wf30+339efYyEERWVnfYR1mSRQAI/UiPSPjezKqkaHXuJPn/tdSq+wgDYvyRlV+nwwETLcUog9ltu2KLu732hfrgmLKvSnszcM9fbyGApZYxud0QD2XmNIAWNK9qyhzUdoZb7u4BzPnTb4EThftkTSrd8dJBzX1AzLEybbrHpR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> Commit 52162ec784fa
> ("powerpc/mm/book3s64/radix: Use freed_tables instead of need_flush_all")
> removed radix__flush_tlb_pwc() definition, but missed to remove the extern
> declaration. This patch removes it.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/include/asm/book3s/64/tlbflush-radix.h | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> index a38542259fab..de9b96660582 100644
> --- a/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> +++ b/arch/powerpc/include/asm/book3s/64/tlbflush-radix.h
> @@ -92,7 +92,6 @@ extern void radix__flush_tlb_page_psize(struct mm_struct *mm, unsigned long vmad
>   #define radix__flush_tlb_page(vma,addr)	radix__local_flush_tlb_page(vma,addr)
>   #define radix__flush_tlb_page_psize(mm,addr,p) radix__local_flush_tlb_page_psize(mm,addr,p)
>   #endif
> -extern void radix__flush_tlb_pwc(struct mmu_gather *tlb, unsigned long addr);
>   extern void radix__flush_tlb_collapsed_pmd(struct mm_struct *mm, unsigned long addr);
>   extern void radix__flush_tlb_all(void);
>   


