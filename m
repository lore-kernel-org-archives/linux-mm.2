Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C0FD1A639
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178936B0089; Fri,  9 Jan 2026 10:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125C96B008A; Fri,  9 Jan 2026 10:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0287E6B008C; Fri,  9 Jan 2026 10:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EABD86B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:04:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA5F216010F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:04:00 +0000 (UTC)
X-FDA: 84312745440.17.88176BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1061320010
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:03:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uu2xDZmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767971039; a=rsa-sha256;
	cv=none;
	b=bWwP61leGJm9Bnjnjuhxt09AccMnFBGtqtM4FdVWS/OmW/GcxAbXsOoOH0D+fBTADNQEWW
	gYyorlunsDEiRaOeHrIGoSr44U4iT2ydv10vOoGX66jbJVAzspA7UGoeqgO2TO1wP49Mq/
	EnSmh9aRQx6CjTeOz10NOA8K1hDot94=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uu2xDZmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767971039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6ssEdcHkr4lhwyK2u97S+QH0RFj6bQRJ9iwKKkYmk8=;
	b=dUhAtYHZlqFQAywO6dxTM86sIw9sbS2ssV7eRHpm/i28c5OVvoxXWAoOORGP0wJ6ayPXxJ
	A4AQSKFDl6AeupDPlpC/vXW/8k4yAYWSf/Z+RhnY1BALMCbEqEEbz5tuWSQTy3QMCqN8z+
	1TmZvz8n+bcO1VfTjKOjS8pxcqOXbac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F23D41AAF;
	Fri,  9 Jan 2026 15:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B859DC4CEF1;
	Fri,  9 Jan 2026 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971038;
	bh=9LFMVxyFsOw43Q6k6Eff0i7Pwixa+RzRx4DsbI5AqD4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Uu2xDZmK3PKrblsrsZL8LIcmnB0lca1ztGkSrwKnR3k1T+w3GGUw72vEWmRnJLC84
	 04PN8WJ3tZU0qJxzKPXK/jIY9eHM/FkWJFfqFlKmAMwFCu8bAOMnLGGisVhDa+VPC1
	 Hkm58qx6FwRjuIwh2iTdkxqN5OiOQDU6WIuS4LlqAy4eDc3QabNZxuLBa/iS/+tV6V
	 fS5P07RUWs0rl3AKweG2OOOgL7ak053o/aoA2ECEjLInVqvpv88XZvchTU2IlUt4fg
	 Y4VqP9kXVaCjmME3a4NjLke27874qGSfQHgAkzTpVnrAxfNYoR24aDyxZOKRFuYlCS
	 Zo9TfPAXHUzMg==
Message-ID: <0c72913e-9708-4675-a421-06ed82b7802a@kernel.org>
Date: Fri, 9 Jan 2026 16:03:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/14] mm: clarify lazy_mmu sleeping constraints
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-6-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251215150323.2218608-6-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: q6b5mz8tnnyrua48y6nfdyp1c4fsdbnn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1061320010
X-HE-Tag: 1767971038-957570
X-HE-Meta: U2FsdGVkX1/Y5bQkceElWFBGFH60R6SButzqUtagXvMduRYXTxRkeofhEDQCyhz/boK8pGrLEd9TpZZFxVBzYBdUNH6N5uVNLrUo3QMYFJaVvBYaZ4aTMeLGkQ9Yvhi/Q3H2BYQnM5uv+0SlmlU3ijiBeOSTGbWErbwTSJICQy5DaCWW6hzr7MqaHepBipWBkZevvflpCqLcznaS4431AVezkvKWZQ4vXUGzvmit1QHvbshNd84jcojbu0W/SAIwyXDwK+CynLdfhUwH9aeIChyrlD4fFpeuvgmOMBok7Lj+BSFymNuJoh/mxEaB4cWkrsqYxF5kH1IqItGIj016MXjGYfAPfXt39F1wDgz4dBExE7IaDal5OZMJ+/RsnIaC7p6W1WH6Kvd8EQLy41zwR80AI1yt4UNpGZKsbmDt6JSXQpwC8bVPAnhcP5zJNgu70+VCu9Ui5y/ho6JmKpeSKcgK4qL0RNmLBO2YXrbUbGTgUQUA4NysInFHCvGSHcOQmJ3yp5goBrvvg0exuxcW4/ixbn9Ii5VMcdWn465rMPF8MuoqvTvXgleuOejikcKr+gtHE8/6laKffNU991BCRLQTBr680pJ/3EGGMqLf396J62YcdwVUzxgKFZUJsocrXbbpkOZ28j1sZlc39dx6FN2mtLGSUVHrqmRfmXbyCYPOTbP+mj4eYIbGAR7nZSx0jxRpEJjj6DhEKHO2cQF8Om0oqn6grnVlGC7vTVsmMsZ6ll2wQNbVj3Mdc7EE7E2LXz2ggvU9qBKGMRb9eaeZZhRsEZyGYzeQmNaDlazt4lH+12iztYnSRjGjPT7QWgswx3zEla7nMxRMbb/PfTG+jk8NIiIBaTRkawTXf19uLqniMUtQrVGpejPKlMPmSEEwRkG1xnOGEGv76soW6oK2lsP+0VQKnYfnJhqWIVo8S39jDf3YPzrLx8mI3yHNH5ONXCLrrmCUqgtCnEWNaC8
 K3G1H/Vz
 YqI0NHQLnEXHuy1KlZ5SCn5zzWeuorlUQB4PMl6dMUvafWpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 16:03, Kevin Brodsky wrote:
> The lazy MMU mode documentation makes clear that an implementation
> should not assume that preemption is disabled or any lock is held
> upon entry to the mode; however it says nothing about what code
> using the lazy MMU interface should expect.
> 
> In practice sleeping is forbidden (for generic code) while the lazy
> MMU mode is active: say it explicitly.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   include/linux/pgtable.h | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 652f287c1ef6..1abc4a1c3d72 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -225,11 +225,15 @@ static inline int pmd_dirty(pmd_t pmd)
>    * up to date.
>    *
>    * In the general case, no lock is guaranteed to be held between entry and exit
> - * of the lazy mode. So the implementation must assume preemption may be enabled
> - * and cpu migration is possible; it must take steps to be robust against this.
> - * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
> - * and the mode cannot be used in interrupt context.
> + * of the lazy mode. (In practice, for user PTE updates, the appropriate page
> + * table lock(s) are held, but for kernel PTE updates, no lock is held).
> + * The implementation must therefore assume preemption may be enabled upon
> + * entry to the mode and cpu migration is possible; it must take steps to be
> + * robust against this. An implementation may handle this by disabling
> + * preemption, as a consequence generic code may not sleep while the lazy MMU
> + * mode is active.
> + *
> + * Nesting is not permitted and the mode cannot be used in interrupt context.
>    */
>   #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>   static inline void arch_enter_lazy_mmu_mode(void) {}

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

