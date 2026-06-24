Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569A7CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245CD6B0088; Wed, 24 Jun 2026 09:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DF16B008A; Wed, 24 Jun 2026 09:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8046B008C; Wed, 24 Jun 2026 09:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBACE6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:54:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4430C14039E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:54:44 +0000 (UTC)
X-FDA: 84914951688.30.7FBCCE2
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B14B1A000D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:54:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A3cqOeH+;
	spf=pass (imf19.hostedemail.com: domain of abarnas@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782309282;
	b=Vi6waMtUwx1a43uRE8w7aR9tGQY3tGX8B4LmuBKgrBYCTS1ijYUoGDUglPy/e+l5sa56Ro
	7JadPYyjJBiktm6ISwTHqgeflQAfFExeCBt2QusMOwc8ZstT14qwIzNcc0cJCnvmSf/3UW
	V37XJrm8Sh1BooI/i0fcyCqS7yEzj4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782309282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZV9AIpiCFVK4tdxG3Z8tFEyC+qJoxAahhaSiAUDsyI=;
	b=H/hR8ozph22nZJRJdDcGMWIWz8QpJaFtykdCGTUgeandXWi0dmWhKLcceW8TeZVjFB6cak
	2usYDouCgees5+zvU45hU+V+gt+ViQcMoT7UXZRbT1E1j05yL0veU2bNAdfKn11AcTLp8E
	EWG13f0EuAXEW7Q9BiTEWwbfZ4LrN4Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A3cqOeH+;
	spf=pass (imf19.hostedemail.com: domain of abarnas@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-46cbe01d4b6so368320f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782309280; x=1782914080; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GZV9AIpiCFVK4tdxG3Z8tFEyC+qJoxAahhaSiAUDsyI=;
        b=A3cqOeH+Eqk5g6ITJyowOrRQK0JOQ5R3md37VK12EAwZblgYkfGr2K0zammLbn1G1S
         +zgwp7txyMJLEs0dVRmwt7NsqOJyyGHuQFifATuf2HYf6L45kpaE4KbJViheGcU96PoA
         7TdjBlKPyRwUMLMyIgtrAgMWUSFtbKfC4bb/WzgelMZy6bS893/PdIwO0sgn+upn/k69
         TKu8H7vJ+QZdG2vVi9ajFLmiOz5zmT2sI8j6K07VdDRQN7IdxndMP8tyz2vY6v5NaHvK
         E++66DPGE9+KBarKjo4J60UP2AJq0dQ7h9BbjQujH8XHFQRkgsRJVK5NjcovX+Pt4sl8
         HBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782309280; x=1782914080;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZV9AIpiCFVK4tdxG3Z8tFEyC+qJoxAahhaSiAUDsyI=;
        b=i+0JFrPzmcWkO7UWT8Etrbv45dHiXKlmRrv1QX+9XHrqH9nbgoUhRtj1ELi9042Oeu
         VezQtcMSg5gNMYgPJj/2YzZ2KANPf8l4s8K+2oHusmhhMkzFKwc9O8vaYDiBbSHGNuOF
         JrhJta19FhA8F91p8/k4f04FZzZaU5yElwCoLJdnZ1ooSYHDR4IxfEV0pZLEWCmqOQwt
         t1z9ETxb2w1ZtmsP/1jDOiTeOYyulKivh186skJFVVW9H9ykju1jaSPyB1k/ioIufBLQ
         yN7Nm0cbARxgHLXL+JIsfRc83q/Qw0ZsI9KheT9bJ8735h3/7v60UQ9YsWmlB47yB+9u
         FgVg==
X-Forwarded-Encrypted: i=1; AFNElJ8fynhK3hawaTG/LErYR1A6KDX3K9X4U0/MRgKrAhxqf3NYTYFngj6Zy/6eELzY+uHGLHkRzmHajw==@kvack.org
X-Gm-Message-State: AOJu0YwAJdtHs2H8TtAIsftrKuO2+OvM7n2YYQTKiW6rXeFLvkc8ie/e
	/1o8nL9UYQ0feqRByfXzgFw11dak0IPTjUvUDudIzbR47ACF/ebGBta20mHd/jAxfHS9BdMwhZ0
	LrTGEaA==
X-Gm-Gg: AfdE7cnQ92UK31RQKRxIZyX4WXVuNKMvaugSg32yAKJo58O4L46z5iNrmNc7wY8cmE3
	Wkckb9FHUa1TxQmM+3sXID99UjBaXNiFb7WpVI4+UsIpui30NwgzQN7zSjwUeDDKnGcWxcrCIlp
	3FMPECvoA6nAMYMu5+B6K/d/Syj3t/7oJ93FiGfc2NHxM0uIGe6qTo9jUctO3mSCGEJfT7BasBO
	5jVzygYGrTQSBaBAp61AUd7eo+dweaHFqQd2pMK89VbevkBCOJd06OFXuVtMg3nTwaHanmsR/F/
	7QtpWLg8yADGldW/nmPdP/bwlL+p8uAp+21l1uyG5BYbh3ra2xeB5+/yBfAABHZhWx2+fPLT5al
	tuI16sEfcnq/4cRO+kx/KTm2LfLaNRlMdlCGTIl5X9R7B5UxXU7la2vk0L0Bs4hl7zc2Kms5MlS
	P3k4Y7CsXU3LUb26W1EXAevVNHAzhCMcWwiChj+fAqcMBM1kj5faLv5RjmcQ==
X-Received: by 2002:a05:600c:3b17:b0:492:62d9:4e57 with SMTP id 5b1f17b1804b1-49262d94ef2mr19529165e9.2.1782309279820;
        Wed, 24 Jun 2026 06:54:39 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4926064f0d8sm49968305e9.0.2026.06.24.06.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:54:39 -0700 (PDT)
Date: Wed, 24 Jun 2026 13:54:35 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [RFC PATCH 2/6] arm64: mm: allow huge vmap permission
 adjustments with bbml2_no_abort
Message-ID: <ajvhm2aRQJPhRGW7@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-3-abarnas@google.com>
 <07ab8b6f-cb58-4f8c-af7e-c99c2fb8933a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07ab8b6f-cb58-4f8c-af7e-c99c2fb8933a@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B14B1A000D
X-Stat-Signature: y9yasscgo45qj4b4j6z9qcs6xrcrfq63
X-HE-Tag: 1782309281-643416
X-HE-Meta: U2FsdGVkX1+mXG4WpLw6NEIhI7QvIfd3lLdq8pjnI5NkukXVFEeud0LO/OIK3jdFC3sk2WhbdDUOx0YCocyrHIW/94KLwieOJXEskLnBUwrQ3hrWq0Z63HOKhQzoqdagynOTLag0GAu/FFruAXxeup5rjSFuFzXu/ws8Or3TspwxjyAC+GtrLDIVz90rLeGlKALPZGBMVaMQxbojQDcfiKqC0D57jVgyrMhRvSnhkS77cSWqIEsF4U2DbhWTWLKSBlJ0l3sFMj4TA7RMk91YM/1renYLF7duoI++mlsmsxc25zjSFLrQQ/pKwCv5Ryl+V/HlmZJXILK9gfDZGjKrJwGcrzfhxZrt2sc+NKlkCiPm5JmfByQlmah67+GxXy69fZCXp3UQFLTrcYQc87taPnMxPojuOI9aVu7wg0yUc2ZwLYchlTIIY3PuUsZPsgatpX/KG2VpC9rySxStq5ow6gluGTpxG/HgfRQkYy4bm3YOCduYDTMBxFQAntg14nHl4T4PgUVdznsBplraO7+uog5xrMWHCfwODKG1sLognSkg4kPhJ5zXp7qdco7AD73Jj4fkHagREUHB8Pew9DrIc4fGwY7p7QCFK2byTtCjWc5PwaEDEH+MRZHmnvaIc6dRyH/Up0jNv5/wZfu6lOhh8CHdPXbjeYhv6E97HD0QhdHXpzYPKMRWQ1t3ofq7tXYp4rKiT9MQpLCmqooR+IVA8+4E86vuBgDbQkI/LcWcSt42xUebkrlESpdM3C2355l5RA65DaXMaMZ3+6JfWC4/JuEig8dU9B4B7GuaCNxGrBeCTI/0JBkQr9GGQfWHMSNokuzUt48AaBAQT6jRhbhpKzw13LOtvYoKu7nlm7pmUQ+iEzXrCUrAjQJ0tiDZqn9T5fXPXTOcZQF1q7KlME3j9t5EaD76sOPXe7C1t5ldMhO4540UY6a1Y0SkpAF4XncMm3OaGPXxpd6xiutSqz6
 /U8wknrc
 eV0njj224UwStJ/aSFSnMlz4mVqsTEusGx1nRVz2eqAtQkbewrvgw7wGZeY9aQSb/vt0nYz/Hf23qp+wVxR0l25tHZdzMk5tzh/vDI6ZkkPwHX7pRfbqySCQDovYzEcoU3a4d5e6kiBbiPlnJB7MMOaDBVNPdaRteK6ixT1ztvZ/fT4uIzwuVN1bvGJVSJ3yMdO82cB0QK2LjLNWrnWI5NoXjeCOyuF7+5Q+IsS1YaPaty55m++9yivr+icz6owaFJRl8hkkSW3aTpMwSGCePADc24S8uWU/lZPgzOwWaNPCbTmrrb4uYcS3y+xgMAF5Sunl23fPKok38xRluEaWVOo/J9dQ5UfY1olxvFtSfTi29SOoc33nbfRVOoSifORsjnFA1O3Qz6CRnX8GeFER/FP55sropwRl/wMF54PpHZ2UI6CJgcvVRcIMzud1DvMrNisCSFFGMo7f9choS0mow9dVFNulaOisjB0F74cwa4AyWgVO0mQSweorBfSAFGvFaPUCm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 03:21:24PM +0100, Ryan Roberts wrote:
>On 11/06/2026 14:01, Adrian Barnaś wrote:
>> Remove the protection against huge vmap permission adjustments on
>> systems that support the bbml2_no_abort CPU feature.
>>
>> Splitting live kernel VA section mappings into page mappings was
>> restricted because it could cause TLB Conflict Aborts. This forced
>> permission adjustments on memory allocated with VM_ALLOW_HUGE_VMAP to be
>> rejected, resulting in performance drops (e.g., when enforcing rodata=on
>> disables huge mappings).
>>
>> The bbml2_no_abort feature (which mirrors the architectural guarantees of
>> FEAT_BBML3) ensures that changing between table and block sizes without
>> following a break-before-make sequence will not generate a TLB Conflict
>> Abort. This hardware guarantee makes it safe to allow dynamic permission
>> adjustments on huge vmap regions.
>
>FYI Linu Cherian has a series that renames bbml2_no_abort to bbml3. I think he's
>planning to post at -rc1. Would be good to rebase this on top once merged.
>

I will keep an eye on next releases.

>>
>> Signed-off-by: Adrian Barnaś <abarnas@google.com>
>> ---
>>  arch/arm64/mm/pageattr.c | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index 358d1dc9a576..88720bbba892 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -157,23 +157,29 @@ static int change_memory_common(unsigned long addr, int numpages,
>>  	}
>>
>>  	/*
>> -	 * Kernel VA mappings are always live, and splitting live section
>> -	 * mappings into page mappings may cause TLB conflicts. This means
>> -	 * we have to ensure that changing the permission bits of the range
>> -	 * we are operating on does not result in such splitting.
>> -	 *
>>  	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
>> -	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
>> -	 * mappings are updated and splitting is never needed.
>>  	 *
>>  	 * So check whether the [addr, addr + size) interval is entirely
>>  	 * covered by precisely one VM area that has the VM_ALLOC flag set.
>>  	 */
>>  	area = find_vm_area((void *)addr);
>> +
>>  	if (!area ||
>>  	    ((unsigned long)kasan_reset_tag((void *)end) >
>>  	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
>> -	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
>> +	    !(area->flags & VM_ALLOC))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Kernel VA mappings are always live, and splitting live section
>> +	 * mappings into page mappings may cause TLB conflicts if bbml2_noabort
>> +	 * is not present.
>> +	 *
>> +	 * While bbml2_noabort is not present disallow VM_ALLOW_HUGE_VMAP mappings
>> +	 * to guarantee that only page mappings are updated and splitting is not
>> +	 * needed.
>> +	 */
>> +	if (!system_supports_bbml2_noabort() && (area->flags & (VM_ALLOW_HUGE_VMAP)))
>
>nit: no need for the parentheses around VM_ALLOW_HUGE_VMAP.
>
>With that:
>
>Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>
>>  		return -EINVAL;
>>
>>  	if (!numpages)
>

Thanks,
Adrian

