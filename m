Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D887CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592C86B012F; Fri,  8 May 2026 05:37:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C736B0130; Fri,  8 May 2026 05:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4976B0131; Fri,  8 May 2026 05:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2850C6B012F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:37:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA5F3C27BB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:37:20 +0000 (UTC)
X-FDA: 84743749440.02.576769A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00D0440002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:37:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5IbqFAS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778233039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmNlEK9SNuugXRkliGDgCGDH7J+lb/Kv8oKwSDFfJBM=;
	b=Bg7Lc8tRKDYR26jbC48Pcz7EMEgPNqd4RrsqNxRaY8QINvjF44cgylrq8456l1dUa/+Ed7
	F2ZnqQt6XeOKlbXS9X3GLRgFBeGN1BEEn1z5J5BkvT5X64LO3KEiyr05giMdQTa3YiPvTK
	oRYLoyC5v3R7HmMyVt2qmXHewzHAD30=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5IbqFAS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778233039; a=rsa-sha256;
	cv=none;
	b=wC7kXtopPpakn/snGQVaMIeD5XwQG0J0D2ZHtD1AAeVmB4uJJ/8ozJ+u2mUlm6/bpyeALy
	TlRz9JIIRQW098Ug3/k8Ku/agfYXSdTOaLgtS7SNlS3W1BqRjOYs6Y5txzFfZ1BczU/LwR
	xEKuL15dAxiFa14PoKAmL/4mFjzbmDQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F8AC600AE;
	Fri,  8 May 2026 09:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6816C2BCB0;
	Fri,  8 May 2026 09:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778233038;
	bh=jptUJz4uJUadEduJpm6UzQzWKEFjxaJ6e97Ocqw2jCw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i5IbqFAScfDk9nVfUHsVJC0m0TIHVatFvvJGer1FPzHUEjfK9NXQHEjaiqC+KmEWg
	 2U0Zp6iJH/kqXoxzaF90jmoEepvKDdc1Ghh8NABVVNLdHM0rmgY8+ajaHrEfLZDXON
	 c99tGiJ7eYUz1A96v9zmxCpMLL6zP5Clcb9DVD46VzIEgoQH+h84JYLedN2B+VHomQ
	 h8FAUdo7P+Z3UfubloVyI3bTomUiW0QVTvxJll2a7ktYEdX3jSbE/w7XqJA40L9yde
	 v4+eHd7L9p8cOUGcCvT7R85V8mosgUSFNYrDhP8gZZRWRVbCe4UcxEvPcsER0sCD0A
	 cyc96bTbIDv9g==
Message-ID: <04a4e82a-2479-45e7-92e3-047ac8365ae4@kernel.org>
Date: Fri, 8 May 2026 11:37:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
To: Pratyush Yadav <pratyush@kernel.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jeff Xu <jeffxu@google.com>,
 Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Brendan Jackman <jackmanb@google.com>, Greg Thelen <gthelen@google.com>,
 stable@vger.kernel.org
References: <20260505133922.797635-1-pratyush@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260505133922.797635-1-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00D0440002
X-Rspam-User: 
X-Stat-Signature: kmep5ie58ackegbfepkc57mwpct9d98x
X-HE-Tag: 1778233038-404745
X-HE-Meta: U2FsdGVkX187cGBXGt7D1TzyTUpjsotO/bLXrblf4cuEV/+3MILpvtVYG0UkyC+nmeuUta/MUnlhn3ydO1QSGrWrrUkbeaImK5j/q7J2hOzrnDKyYgXSNIdyF7zob8Jc8SJNZUl/yMqBJiJqIQP1AbnD9eRiKuX5JxFvCqeeRYQec4c22FpDouOsIMOEzYEMZqqwi8Pxv525JSMmLMgjn3uimtH//MRqi1QduX9ihCig+frDuRXYtaE5jnep/BxjzRRuX9vVNi1yM9u0r9kJap4Apc1OuvBKImBQaBW7FbbbW1vMEWyZzDeO/F8FGAuYi+0AXZRVugxl5FP1DK5Mlxc5fmeN6SuQKZje1QvDdTtjXU2/u3wNjZC6CKZtcSZLIlJbv7ue3ezdnJP9CF7E3Iw1nkxuliTRWu+FK7ZK/V7Q2tBEqEx4fpcArUrBiohaL+PoMforsxcwD9PcCmhRYy7zOTj/M8ZcpnBKYOYKBLTeyKRCp8sfiVdc1bWtLN+kQo13P/9mKnaKVrNetlK2E1i0Qme32yPFLwIu7ktj8yUnKuYOV3xYd1QZUoQeHQwM5Y2mtu5GODA3Ek68ufiqZalvehd2EPAaySgUESpU2BWClPz7XZXJ6DNO0pqzPVqT2J170KNlw0Cx/EKeG/DvFiG03lCq69ZOgkVdvBZf4m5W9OfrhBl18QP1FOcJE2cIlVj0HTdz43U/1igIBAJC6IAi4V/PXeomWk72A5SUAIePU0S3uB+oEnUnI0LhGuHns7oE0Km73YSaJBGJa4Wk92Qcr1p8NDRZ/u3dRCk1sWLMAYNuI+XiIB8B8+wCvHbZJcLGmqiCWZ0vzVE6krERBZEO1TPZEpk8cTT5FFW4uVEzOMAvxBSOVY83ohBNkcesSner/F8qL5TaSO7VIl/d9rpzYqdWyVjG0XdrtkjDpNPKCpZqaS2Y9olwXeEmm1Q8XZQDUAL1GguByLufKBh
 awuTJoOb
 OjIizXP46CbwfLB8AIL3GhPi7rKbQqI2/ajkuJu8cOyQFk0nEE/+35wmu9QqHPoNpeqSpbOuV6Gyp9WNwwDTs88LkODGmnmeQb0Ksjg4RGCKID9euqlfwaBarUS/K9j8OP5t/c+PLfkjQWIOYluwzLlzv2YgYv2o2EZQEyqeivVj2EzG1lBXxkSNcDciDbRZKQQfRRKvE64YXHXfFYLmfGetkkMA5hiRZKSLq0J1KtKGgPwhvWNdJb9/O7KnRqewM76CY9JkXcOaF14psNoyHrZLWq2Msa2/6V6LUFXFbcUixZg4EQuk0t4TEWD1a1qSCDbBsJL3yPCJhxSDRjn/X9cEICN7IovaQbHWLdcFkMR+iqEu7s/E7BKbnLvkKe849fEsi7opbhoiKPuMq0+ZWQ+FAgS/NAiv9RVMw1rTpFNJQGmidGFBMrF7XMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/5/26 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. 

I don't quite understand that.

I guess what you mean is "SEAL_EXEC implies SEAL_WRITE if the file is
executable, to prevent W^X after sealing".

Because if the file is not executable, there is no sealing of writes happening?

It's rather odd to combine both things, though. Likely the callers should just
have requested SEAL_WRITE.

But I guess we are stuck with this mess.


> But the
> implied seal is set after the check that makes sure the memfd can not
> have any writable mappings. This means one can use SEAL_EXEC to apply
> SEAL_WRITE while having writeable mappings.
> 
> This breaks the contract that SEAL_WRITE provides and can be used by an
> attacker to pass a memfd that appears to be write sealed but can still
> be modified arbitrarily.
> 
> Fix this by adding the implied seals before the call for
> mapping_deny_writable() is done.
> 
> Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  mm/memfd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index fb425f4e315f..abe13b291ddc 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>  		goto unlock;
>  	}
>  
> +	/*
> +	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> +	 */
> +	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> +		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
> +
>  	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
>  		error = mapping_deny_writable(file->f_mapping);
>  		if (error)
> @@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>  		}
>  	}
>  
> -	/*
> -	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> -	 */
> -	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> -		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
> -
>  	*file_seals |= seals;
>  	error = 0;
>  

Given the weird semantics, this makes sense to me.

Do we have to update documentation to reflect this? But staring at the man page
[1] we don't even seem to document F_SEAL_EXEC?


[1] https://www.man7.org/linux/man-pages/man2/F_ADD_SEALS.2const.html

-- 
Cheers,

David

