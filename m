Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B94606A88C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBOhDTuU
Received: by kanga.kvack.org (Postfix)
	id 10C9D6B05B1; Fri, 13 Nov 2026 14:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E42D6B05B2; Fri, 13 Nov 2026 14:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C396B05B3; Fri, 13 Nov 2026 14:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1A546B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:58:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E00B1A019D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:06 +0000 (UTC)
X-FDA: 85431156972.11.9A0C9D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C67D9C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBOhDTuU;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599884;
	b=PX+RVgdpAALyP3xrunX7L1Sz4PsiuIFF18AxToDdr8wDTmjk5B3Z6y91ADQjOXjWyt/GxZ
	T4cXYlQ5VqrI/IM6KdoMzEbGp1rXLMdIZ5qIcGxN2V9Xt4OpD7nHY4OPbUzduOEMb/ugZT
	ca5Apv9Dj4V93K+XY4EIGKEoBovYQlY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBOhDTuU;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbLqO6g0MnnThcPzBQZqW0ZRgI8AVvZaYZ5qNuebmZw=;
	b=nqMi1UgPVe4/ChpC1S0nis0hOrFafq/RMaR3gf8mo85RYFEJDhZs4o+pA9bfM2/0ZyW4oN
	YC+dPX0LpqnFceZLBBcCNI1rr3iC+P0znMIbV1xVkRsADe8u+4y0gBT6PB0TfuFpJec5sa
	J0DPdWccQdMb8MwhkGtrbqw5GzqF3/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAC33456CE;
	Fri, 13 Nov 2026 19:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E851F000C4;
	Fri, 13 Nov 2026 19:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794599883;
	bh=IbLqO6g0MnnThcPzBQZqW0ZRgI8AVvZaYZ5qNuebmZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBOhDTuU2n/nCaaU+nqxXKoavYB8xw1K8tCCIvrNVcpBL7ENgr/B27IziPRbNzyyd
	 aNdSayCifYvib6Z5Hr78yad6NBJdmHl7/NVANgM+kdWkUS9lftyZXD4oOZNTHVxeQ4
	 scOicWe7x9RgVoIyjgvWnA0EPnIcqMTYROuTCaycprVbErerCeXdIVR6dapBwhgyuv
	 VZ0rSyXzCEwgrTd020Wqxi+kq8OjsXpiRsuRMUoXY2V9CvT8Bnrsh9Utu5a+PxeubS
	 pUL0Vs1d92xFpQsUqKb2EI4XwMwYAauS1y6+EFU4F7VQgewrgrYfex/qI63EC89uR6
	 R2XsRsE+bGaCg==
Date: Fri, 13 Nov 2026 19:57:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	kas@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
Message-ID: <avdrZ716BHN-JLc6@gremlin>
References: <20261113195536.2660763-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113195536.2660763-1-gourry@gourry.net>
X-Stat-Signature: iq7eci9q3dnphf8yz8pyqkwc8xj5twfw
X-Rspamd-Queue-Id: C67D9C000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794599884-806563
X-HE-Meta: U2FsdGVkX18eL0DKBd6uMJVbkMSB1MwgR0O/9uI0xQ4+/QXbOO9XMQTxooymIUEtFBA4ydU/5o2ELzvC8xz2MFGB2dPULNX2whOXjZR3cxbYNspjNJSrMjBlXvpB3+gY1D1nlmvA2Fq2xG8VXxNGS67tp7IQhCfyhTPWAum7ou8VKBu5ZrQ6Mbb7DxWo+ibx5mfLoN1jMEMpFD9WM0m/ditunWRllkTyTPez0E69vBVUeDsZA7zyENp6k4q2s0i9ueuAi6jKhF9CqGnbM7BlgNxZLCwi1DyKbEWCSyir2axvX9vEILM6amus7VI0cdmyiMp0z2bE0tQ4p9Cp5td8gwKeq53p0wkcOLb2m6bFs8Ve+14oOnJZN0AMMsVjgQNYUN0OudoZRpsL7Dn/wapVrjyLutteutZ/x8FBMipTLq35k+h7B6jGXZWSjxFqSiWlGAzNghhVY+fHU8RMfjKIWfYiF5BB0pQA7Hm9mmUTRj+rIAuEvaiyHhZUihCIqFEHqM31YuJVsXitaV3zT9i783UsAcOXol3XvsZC8/LrMnTTmpnm873PuuC5G2E2NbHKc7CyliITxfMWCGQeUKjrqpS07zbe3Z4dzBGHwLAjqYH1SwHjln2i5ZPiX6OcyJU1EfAx3k8EzlDKlqDbcggXbRFioS3FIIUodQ/kFjBdKSMB24mSqAzTY+17+1DrUFFlkep1j3YiyI45ooe0VfBiKjnnt24+4zqR+osh/kHE7m0Yqx+TsqmW2L3fKQ3YvrtDC26xsjxKJN5iwLCOYU9YLcjEu+2kE3bJPwE/2Sh+CRbjcstL/W/9YyOiYWoJLw5ZK1Y6gScbamOaEk5XdZhzYlKvL6NWf+TQLuNN/PpzPWFU8uJQ6n6t5o1zLIPw+mLK8oBuJhfyipteABE7hq4/5t3tMYbSkt+u7zwZI1KFEEaESmv7Qr6/kpJEYKJbrxPz4FBkWDC84lDYSEBio+6
 FWa6jC/N
 n2LS4+64qyOc6KorYHzDNoPI2KwV+4Rr8b7n0DDqEv37vyylQ7kvT9ZeX371J6KAN2zQJRoBa8JMGMAPwJ0uUYRXER0jzbOLlFX6RrsPW1VDFeRmbC164Cu2KsTDg6bAvMB6T/M2iQ+h4ytMmbwr3/utqn4Rqj4iPAxQ1ElUXQ3o0J+b/AMzinKGFARZH88y2QZ/v0WxUcmIaZn5z2x1DIXEWVxC/idsskgV8RFhGQfl/7WFPBx4esoiOP1DvWMjex3qRTTt+xkghvy+vfp+L8YVqTUZDNgG/HUY9K1QV5+ev1Y+kt9715yf+zlO2AXSeEOewugyuxpgTmb8s7IUixDc7yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> HMM can grant ordinary device write access to a userspace shadow stack.
> On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> can be returned with HMM_PFN_WRITE without taking a CPU write fault.
>
> Nouveau translates that flag into a writable GPU mapping.
>
> Reject shadow-stack VMAs in hmm_vma_walk_test(). Use the existing
> unsupported-range handling: a requested fault returns -EFAULT, while a
> snapshot records HMM_PFN_ERROR.
>
> Link: https://lore.kernel.org/linux-mm/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: stable@vger.kernel.org
> Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks for doing the HMM side of this, LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/hmm.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..fa61ca59d927 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -596,6 +596,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct vm_area_struct *vma = walk->vma;
>
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
> +	    !vma_test_single_mask(vma, VMA_SHADOW_STACK) &&
>  	    vma->vm_flags & VM_READ)
>  		return 0;
>
> @@ -607,6 +608,8 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	 * allow write access either. HMM does not support architectures that
>  	 * allow write without read.
>  	 *
> +	 * Devices must not gain ordinary write access to shadow stacks.
> +	 *
>  	 * If a fault is requested for an unsupported range then it is a hard
>  	 * failure.
>  	 */
> --
> 2.56.0
>

--
Cheers, Lorenzo

