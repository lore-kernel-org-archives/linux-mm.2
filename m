Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0705860A2605
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=iTuO3NTL
Received: by kanga.kvack.org (Postfix)
	id 1BD116B05B2; Tue, 10 Nov 2026 20:30:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195006B05B4; Tue, 10 Nov 2026 20:30:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1606B05B5; Tue, 10 Nov 2026 20:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC5216B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:30:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BBC140160
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:30:14 +0000 (UTC)
X-FDA: 85421107548.29.CD748F4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 357FF100005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:30:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iTuO3NTL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGlSCsBqT00WxRPhug38CXPcNLm6Ex1XmxYgMp6Ugpg=;
	b=tHqc7VOt/ljL5RDru0IL5IaAaySznnoR55bxrLUdn3Fz95kjYrFRkMQU4rO6lSxGkk3Hx9
	6pVCL2tSvDfJyMmNwcVEdLc7DNm5zq1n/vvJKC5GeyTwwFGxkdB9x14HSFgi/tTxuGx40w
	95YzoKIWgxKUvaxrUD0bnCnZf26PQX0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360613;
	b=UZd1jK52xSL8xi3mUynvl8dZoqBGohSK9EbWoMBo3xoQ1CoPlz0s4BJr//7Ezco84LZQs8
	hho184mBB16ELa8iA9OGu8YtEhCZX0u/6qQuViyhB2c2mTzaYku/pXTNuvK607KHJWgrQX
	SfJjFXa4RDC6d+9vdPRnHH2GnOPIqPE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iTuO3NTL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aGlSCsBqT00WxRPhug38CXPcNLm6Ex1XmxYgMp6Ugpg=; b=iTuO3NTLniEKwOqFogBVymyw+f
	hC9z4aIQYBz+bQuf+3DOUcbj4QN0evwNuaU9REiLhEIGn4zKQ5rIp6UwzKTmMY1aLEvVngKt5IdTU
	ugzeVNBMQFm2DT6O7vMYGWP7AJsb/H1P/i7S69D7dRx96cwzNzAx7BFGawQMdJI2k9670bWUnLDcO
	asJe/8UR0GLO0rXhdzF2UCJ/azd9ubAMB/98EJ3QpZNNn0NKdemL9mHwaDWJ1WhlT0cNfxVteGw/l
	+w1gKd1fkeoCEPISipMQj3vBstrmjj2xp+zR4p81PP9D/fxPawWSxpspe9d9vbUncS+TD7k9+wVBj
	QhLiO6XQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xQxAA-00000005NdW-3Ngd;
	Wed, 11 Nov 2026 01:30:11 +0000
Date: Tue, 10 Nov 2026 20:30:08 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in
 VMA lock code
Message-ID: <isz4p3yfc7dm346qwnjhl6zraspz3jsvwl6bcyn4kddqma27od@33qacw4zdsfq>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
 <20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org>
X-Stat-Signature: 9hduuinzn4yu6a4g5wdxw91mp3cfufq7
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 357FF100005
X-HE-Tag: 1794360612-668899
X-HE-Meta: U2FsdGVkX189pjEOaUh1uW1v3tlo8t2jLtrUdUHJwV7DIsl6JkiMrAH1lfbJ8lvpnhcqULZnICxvubMiYZJ1zsy0SG85Q+HBC/5d0NbKcqWWRD4+5FwQEmYNAsO6eD6RxHsL29TlT/7Dyj7yOCzS6QfOhCS86JOtGNqYw/X0x/0K7fgi6DX5+Z+IDAjB/ihgbGO412lIDLCE7eAB+PJ+27JkaFeGHVC0hxXMzjjZxbMNoVBDSfxC9FR391e04JiFcxw7zKH7wUifJMl6KPGqlDR5Al41IabqVOcgrXtO0w5lSbJPNecjxeoEM2XDusq+83rerHXwa6NUG7O4Jfnc68ux1oFRXzrCfjoHV/MtH5Gg20T4mYu+paKGZsNubXXYD6tzsb16PLjacPlvgCoTGpQqLuxOTCjNCPFn1RPN0sZiUEqA+DLAbdKlaY+iKc+Sp5Zi75QexVrXXEJ9Vnljh97PZayZ2MnaTnE+HaHCEu1mFKkLfCnhZWPP9PTyafQghRCJgbiw2zsxgP//7Ia6foVKtf65jyN4q1fIl1/2KRgxmMIWc1/J8GsDcWbYhi594i5JaMG3Xc7YtRYmR7vfiHhZ0l73voMRkxtuHClNX8e+lkm2SUZiHUFXNJnikq+Vfli4IuggYcjOTlAK1b0UenadEpSCoI0EgHgrX6nEl1TAvLJ6maT+IwdTBrLEr5DhwPXwSz0RMjMbliTem61EKsvi00x37qOv1vYsu0QpuqxKvkEZhj+RpfqFEf0DXWx1E0Q+G9Tj1Qv+AJwmrZIuWupiWIPmFpY6eA1eRJJnasya8gbTPOEnCbSwFlquM42DDzEMslEPliItM3Tw6c2DAiktvx7EeRBjiLvsVm4061Rux34NeCDe6rNjmsMm/46RA06gIld+lWWhb84vxiEzRlFSg6os07uxerz73zW5Lkh1f0idXikzjVvswrEadO+63ybIDTvWbnB0jCcl161
 /Mgmj5si
 WYxUvf4uyaN/58eP4+KeHkhqpwTci1XvM6mpT7L611+YlM6luzVb3CwWJI0bbDdMU8XlvCKBjFG/XNcPMfIWfDiGZYvSBO3rtTOHzD9zkmdUlgMEF2ng35w2Vukeo7DWmOTthRhW/HyW7uiIVWtmtUjB5TS4IkqxyyWrgWcEimL/yg+YqNE9yFsku8Mhb73ZWe+aIScpQd+jWIyz9FKyX42FwUTMCsJQS9xqdXJvMz24fdO/xg4Ho9euAQ7SP4Ck8JSdmOmb6bZskIsykjKCtqZXj9uE80AriOTMVUoj7oJDNXUKAKeJRVQFKlWdVgAzGkEyxhNzhXxeyMMvjU7GVmdl57IZPRMR0dQIxLnwVw0rfx94Ld4nU26CJ0LcT/4OBWB905sZA3GfbcCmej3XXCG/8/kKepwPCjoyA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/10 04:57PM, Lorenzo Stoakes (ARM) wrote:
> Now that VMA assertions are predicated on CONFIG_DEBUG_VM, it makes sense
> to convert existing unconditional WARN_ON_ONCE()'s in VMA lock code to
> VM_WARN_ON_ONCE()'s.
> 
> These are asserting programmatic invariants which are in most other cases
> asserted using VM_WARN_ON_ONCE(), and there is simply no need for these to
> be unconditionally checked, so no longer do so.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

I assert that I have read the entire series at this point.

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
>  mm/mmap_lock.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 834bbf86e004..073c5125b424 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -146,7 +146,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
>  
>  	err = __vma_start_exclude_readers(&ves);
>  	if (err) {
> -		WARN_ON_ONCE(ves.detached);
> +		VM_WARN_ON_ONCE(ves.detached);
>  		return err;
>  	}
>  
> @@ -161,7 +161,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
>  	if (ves.exclusive) {
>  		__vma_end_exclude_readers(&ves);
>  		/* VMA should remain attached. */
> -		WARN_ON_ONCE(ves.detached);
> +		VM_WARN_ON_ONCE(ves.detached);
>  	}
>  
>  	return 0;
> @@ -193,7 +193,7 @@ void __vma_exclude_readers_for_detach(struct vm_area_struct *vma)
>  		__vma_end_exclude_readers(&ves);
>  	}
>  	/* If an error arose but we were detached anyway, we don't care. */
> -	WARN_ON_ONCE(!ves.detached);
> +	VM_WARN_ON_ONCE(!ves.detached);
>  }
>  
>  /* Do the VMA, mm seqcounts indicate the VMA is write locked? */
> 
> -- 
> 2.56.0
> 

