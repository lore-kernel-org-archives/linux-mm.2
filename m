Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FEE6CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1496B00CE; Thu, 18 Jun 2026 05:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C91B6B00D0; Thu, 18 Jun 2026 05:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFA96B00D1; Thu, 18 Jun 2026 05:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC00D6B00CE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:30:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1741C475C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:25:38 +0000 (UTC)
X-FDA: 84892500756.12.FE052BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 67FA840002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:25:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fg7LIiJR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DgKcClasxSrNEwOyhFc/Pf3yXG2qRJHjcQekLSqD8WI=;
	b=4x/GM+rDQBu+/R0PfwDMKnKdgS8OAU0pi6zzpkpWfmYbzI2GE6FFyZrfU4ojdrAXnhFKrl
	VKvPCnz+jfWWpZiGKXJ7htH6LP7VjLbarMMEzVFXR6d5tkI0liBEV3ngz3QG6ghThWX5Hi
	t88sjmDqbNf9SAPtyKpFKWkMjVAHHJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774736;
	b=V9wDaqiTB5clb0A2TGTD0G/syeJB/SqYYp8HBZnC3gJAaapX+ywbCsK/PNHyl7Cj1+6hlw
	CrkMIf2Ha4FvbDU196v1W6j+zK6o3UFWXt512Hrnqe6XgVw0A/k42NwQWpGAXsWFS8/b7w
	n8yGjlJa5VkNCopTnpJLiycci7ovZlE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fg7LIiJR;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7094543737;
	Thu, 18 Jun 2026 09:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E9A1F000E9;
	Thu, 18 Jun 2026 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781774735;
	bh=DgKcClasxSrNEwOyhFc/Pf3yXG2qRJHjcQekLSqD8WI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fg7LIiJR7AX9Jn66wWOxFwFC1Ilz8tBNN130l9pe8+ski/iiRItU7Grqgq/n1pD3b
	 a794jZ3egI+eNs+hsjI4MdhkR8FGxEytWyl1w7i6X/OCyHUeCqu6fuato879HTU0/g
	 mGLdvtRPpJAoRQtm9YYitdXw8vvnoOA1CWdr3jth5lNTf0j/apFF1zhS0hvHD22QSf
	 fBvryou88infm346UlwypugTjY6FwlgJSkiKVobm+r0QlbgAgMIQ/KduN+w2495mnd
	 W5srq7C+k7qgdA45I30LwtGtgtnK1gcLK6+EPxaAcJIXZU9RycxyrvqEXwy4n0KCIz
	 jaelC2pgNc9/w==
Message-ID: <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
Date: Thu, 18 Jun 2026 11:25:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
 vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260617194059.2529406-1-rppt@kernel.org>
 <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
 <ajOtfdGgFQYL-T6f@kernel.org> <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajO4sLq2UBciSgOn@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67FA840002
X-Stat-Signature: xwyz4ztrzzno7m87n5tbyyo9su73jb63
X-HE-Tag: 1781774736-804345
X-HE-Meta: U2FsdGVkX19wyPU7z/Z0FTYZ7YmuPLj+FMQBo/DGnzfvI3kUCqvwZPqBKl1QBee10Kt0jScQWSkVbLqPNpruQlCgots1nooga3g8xwD983pmdoRRD4Ou14MrCIyzCY2l8cWAuLJV5S3Tw2NjzcJ8js8B1jL2cdVdlMNdFaIt11eXAmQHS93EAL3RzQ3a6uvV1YioOUKtv5hbd+sPlWrpsxDulIGvSa8b7i9VYiyRHXdBCSCM+/o/5Q1sYwBD3A5FvGoRplPzCpNCWcnJ1a6kPq+0c05LZdaEg3Tea7uNQtNv13QRbF4+7GfjWruZHsZsOkRdANzAYFrADbJoULuFCGkjvDU3Dmi4uBklVgGeOMUx9brPuVa1DEgzZ56ut3g/64fKysOijXbMmvaJfr1VINm9WQzh3FkwZBXN5Wn6wFwbVWzeLbJ/t4RMYGN0y4AuWRHgJnAg2vgHNTJ2E+wPYV8/So4eStTcsRcrFJvA45ddHHoA646+ORcZeU43IXZHlxPbptz6n+uy3MnQ6nz8EhNR7eay8oyVHpciKgqluYKzkB9OzmoBNIb6KiV0CRF6JkjnMDcQj4CqPJQy1w22d2JtWHHP++8VScGUMbCu5Vide/eV7RnJN1HT8LUA4/RiUclghnnFot4esez6Wb/dhBBuOoVRTsjCjDnVHrZttJB7g5FmsvOM3RL3EKyghi6KNe5sYg1rt0AkwlT35pIduyqKMb8h9RPy/GjGhhDWJ9yozOG3lu/mecTOoZmbrKOqyW6waTvO1WMZbre2mZXPiBo44sp8d0Az+a0wUcL8BSCRAtO4OkQptU5bb23zc4tPN7A043zLSY95vcq9qMv2lkx16wSGnBpkC7WKhfUwuHFimDi9sELdlucpjwoq5aLBlFUXGh7HVuQ+lMrk8JSXzxtdohlw96QWrAYlh6rTOoQc9zfluWkjCbLMw5sqDHmFG6idkX/gjbD56AiBm1c
 Fxa23JKR
 HpZNrPwkKUNaZu8kThs1+JXEb3CWyyl1XuYvEdMc2sNgLJnMwF0yRYyJkbl2TiVzDE6a/cY50XT92Vrpx8au3DUufMhxvwEfEUWYqeHiye4EbG/I50ZNLHsTA8RDVrV3C4kEIVoPr+svqfXRWhbs+h1LNoz17iKMV8Vc/g7fD6MIBbqw4Mh1vj0EvQ+21oB4CpAIOwt0cufirNW0P2SbcyGMfz+7yxVJO++GMlqCbskPoXBcv7qz646R6ta//ROR+nYao
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 11:21, Mike Rapoport wrote:
> On Thu, Jun 18, 2026 at 10:47:19AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/18/26 10:43, Mike Rapoport wrote:
>>>
>>> Ah, hugetlb sets VM_DONTEXPAND, so it must me excluded to allow uffd with
>>> hugetlb.
>>
>> It would probably be cleaner to just allow hugetlb, and then check for
>> VM_SPECIAL if not hugetlb.
> 
> Cleaner in what sense?
> Will be uglier for sure, just take a look at vma_can_userfault().

I was thinking of this:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..8a6803618a91 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2029,7 +2029,10 @@ bool vma_can_userfault(struct vm_area_struct *vma,
vm_flags_t vm_flags,
 {
        const struct vm_uffd_ops *ops = vma_uffd_ops(vma);

-       if (vma->vm_flags & VM_DROPPABLE)
+       if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+               return false;
+
+       if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
                return false;

        vm_flags &= __VM_UFFD_FLAGS;



-- 
Cheers,

David

