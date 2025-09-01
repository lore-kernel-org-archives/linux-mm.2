Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D91BCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 04:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868A06B000C; Mon,  1 Sep 2025 00:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8195D6B000D; Mon,  1 Sep 2025 00:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FE86B0010; Mon,  1 Sep 2025 00:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 608346B000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:00:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C645D119EA8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:00:05 +0000 (UTC)
X-FDA: 83839328370.03.F0D37F1
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BC6BC0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:00:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CvPSRBkW;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756699204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=RNN05k0SkEGnYtipDErhvvyExHnexROka07GUDG5ZG8=;
	b=Rn6lGTh82mU2XgqXHLyScbnrjWvsonPqre8XRIlWT004yi1onL2GhVHu6EraZ8S6yTF8I5
	ckeDQRfMmlx7BZe21czhQP9TnovEpgikUzGTY71H46+Y0gQnz8N+uI9Ao5HkgxHbmf1Txr
	7KmTJyxOsebY1WI9nVMcEoB0Vskqejw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756699204; a=rsa-sha256;
	cv=none;
	b=K5vmciExjgFvqdD8qBN3ZFYNtzxYJ59O0VmJij4mORyTY39R9oxr4/7USxmQbvf/XzKfIw
	1z9HkB6fFLzXyXzM2a0d2oCwby114arI5+ps68WUlIlGH8vnKjaisxUWIJw2t3XGjUuF0O
	zEh07ilNx+jK/aSgMnZ/Aju08xVPOkk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CvPSRBkW;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-24457f581aeso35000145ad.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 21:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756699203; x=1757304003; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RNN05k0SkEGnYtipDErhvvyExHnexROka07GUDG5ZG8=;
        b=CvPSRBkWRwqqlJOrgWO9j+NlGeQtgL+JJsGyUCVpacym+zzc1Cj7Kv2uZiXYlhtxeU
         m1gT28pjk471bNNRl3qDaxXtXTB9b/OGwLek8NPEEjR0tG/itac/5EJmfvLtiS39jCiN
         FZskpCgZPrGGpzyzdHISg75bGtiYwuFHKkIyNSAy+lJfI3JJ/Y6vtO/xTcK96SnBU1Ow
         nl5Zzz7I/bIVkDMX6d6X7Z0TwwgAik+s/W4CbT2MEX8NaYpOGiodYxcudyONA0npb+ba
         qQcSO63Tm9D3lxaOz4L8LRonYpm8HHvQ1K7tiZYBLZp57K4c75k883X6+qhToKZysCjj
         r8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756699203; x=1757304003;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNN05k0SkEGnYtipDErhvvyExHnexROka07GUDG5ZG8=;
        b=MIdiu/0TVdzo1pyioxi5nUh2IC+RSlNustRrJyUEFj6S/vQybioCIMuBLuMbaN4+9a
         2jV39zLl6VXM6vhjMhHbTrLxQqqk9xEtZe1Dt48n1JcrJchRLeAkaY+tqVpS65gyxrIj
         CFjezR3DLh6z61rLWYZd0HykckaxITdODnmBXpNtgQSjUH6tXWuS7RtHrXgGRxPwozod
         E9Yssr3RX4+6yq5qfi7cXjPwxS4HQfBUaBVEeR3eK8NGiqBtriB9MSpgany5dDDbX54J
         iB41D7fcCZzRwYCLtg02nSJCvm/OWV1kOZSIQyO0azZ5XBO6vFMDcohqkBeQ6iixDimh
         3P6A==
X-Forwarded-Encrypted: i=1; AJvYcCVgfMMoC6dPcTh1oB9liytfhueEoxc1cvWs+/8VWgk1xpoMbweIoFeoOBAi6PF76L5Qys/+ENuPDQ==@kvack.org
X-Gm-Message-State: AOJu0YyTHvS6w1ThwWHSYMBBzN5droLhgkbfk6UztRjDF/kImqlUG8Hw
	wYI+BPT6bt0LsChnh95CDcw6EdDOAnWJGDrX7MZnrJzgzp2s1U/I6vBq
X-Gm-Gg: ASbGncv4jznMOUGjiYppPl8DqfmsXxtz50/2TGJM5K4eP1Yh8DKsiwQSoJVzp3a6lXW
	H+1lFNRxzxOzkrORF/5Lffd2Ea0atvtVTSAvEkcZPQnYX4HqEs9Hqk+B53H3FwNKx2nRjX/CrUz
	77SxfWMErdxRahqCplWne+RPVj5+GP8tKuWtQxX2svDvRVUQZA0KaCGUghRX/xqjJH7j4b9Spe4
	Qt0rYwpKOfNOTOPtBneQUT6u9KXZFQ6Vmex/E7RRiIQX98rHkFDE+zYActR8Je/S411x614ho5Y
	aeZWdD9yqS3PE8vaEo3yaBcLUJKatt+lquVWyW5ra42HCilyxkCMH5kDZ1VowI74vOxM4TGYAOp
	ronZHAOJ6+tLWMU8ofCCjYV8=
X-Google-Smtp-Source: AGHT+IHrROqEQWLo3tJoOV3keKTK3UQx10WUIKtupLxaoq9MHd/qKW3me+GT+z8VghgqjcA+jQjk9A==
X-Received: by 2002:a17:902:e745:b0:246:e1f3:77b2 with SMTP id d9443c01a7336-24944b65071mr78080455ad.53.1756699202873;
        Sun, 31 Aug 2025 21:00:02 -0700 (PDT)
Received: from dw-tp ([129.41.58.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249037022d9sm90560065ad.23.2025.08.31.20.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 21:00:02 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 5/7] powerpc: Stop calling page_address() in free_pages()
In-Reply-To: <20250826205617.1032945-6-vishal.moola@gmail.com>
Date: Mon, 01 Sep 2025 09:17:44 +0530
Message-ID: <87plcakf4v.fsf@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com> <20250826205617.1032945-6-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1BC6BC0006
X-Stat-Signature: g4onmx7714u7t79fk47xo7h81grx7nf9
X-HE-Tag: 1756699203-920991
X-HE-Meta: U2FsdGVkX18Hm2EvCnYtuoF32ry8rvny1D9HsEzW6bWZ/+D3iOnxA5XpOamUv4WlMF5bsuNSGy292HuwXUzMPh8Uj/dxaHpzw0c0CIfSM0iOa95YJLCheLM0xMvP29OQo36JL5L2qtLamnaaHgYcnszESa/sfiPkCz+ZpuQVzJ0D6F4hvdfebXJOnPWJ6EdwegShl0hj07aAvg9gSBVkiTr+Q1tAu9AX29S7gQHi9j5X+oBuKDtuRsrgh4yaSCsRFVnNrmloHi82clHkdLaRma5uZ/vjKiRARoxPnIIqg0jWlQ9W/q14fzqs+B7cwI9s6ygVK9t1KkHC9wScDFzX+/9tLLZIUCOf6HAtqThNJXIBWITorFSzXLYlDhxfzIcGpoodl6Enb4vHaCj6dr+rq2v6c7K2d31fzd9VMcDihC/CqzCfZT/HRBKIT29EnUMDHaqNElmFa4tPyBdqVzSF7LzahH69ZfNfIQzrR4TRPKvMvWBcfJWZTYoO4hU2okDys7nczzd9jBABg9cV2rGokpo/U3m8PN+vjJL++lcWw/nt8PyipUlwsI7Qv0eMF127h6Db0tfzkLkzP7fKsaYJOJyjf7MaA53WfCZcrO25qM9tQagt/tq9sS9pYQ85nybbYUkbYSJeC/VJaRMPukrHQxXCvrx47n+DVXt0wgbrqS3M4Dd4uA+YsyNlgs95HRGBTTF6fI58x8O2lnQa3m8/QP+b2t9UEUZRFSPutRqlp/4KmekyvuEO59Oq6h/KLVSyrTNR8kBvoGTuQAOzNKJTz36GZL23HSn44854zr6y3CLuYLEVTn7K3h04bqv73TWbkyx5vwHgrA0lqU7Wg6DqP4h3jUULtG30NhtyTn4gcZLX3UViXQN2bmhul1WmzP1IaNJjpFtrIcjzrwgYInOU1RAFhGAfmaDUrzs2uFaGP3SiE8R/jXz078jcjhxnxdkbfpzlqnBAgiciGeB/juo
 7BGlGrik
 ONDw0/IKHJqioxNuJpTRCr/iXcOO2b3EIdUwgtKUtPHFxmAMiate/WHzUWhE8hGGao5N2dQxBKS+GvIPsVd8Je4GndiiYHLy6PrPHkj56KOq0MhslSlAysyHoR0fBp72XD9nnbtzTps7D2KfZNVY8nno+/xgki1Kvt/YmhdqusgHm1b8bTYwWqEXoRA21OREBuvonVjLlDuU3wnf69VuGwMozh6mU0k2A1IRjfCoec9/f5zI/qA5wrBEGEpdQMIEGxS+sy1PcW/Fb8lnguXbJBJJkCmXjqOX6kGDG/Ifv/mqzUQS2grBM/uoQTKSMKRPBvdGevafb1fQe9HSYcgslHu7RSHL+4LDR1YWN2GbStX0rTT3lPsiP6as4jSJg+P2URJH5vNxqzUFnQkUsdUlE960EPOpj4i/4qKuX+In0KOEpZ+3LTk2eXZaBgoVS5/9QBH4kaan4MgPVBfisGu1b32BeDuwWXc9lk5SIh3yu40n2+aErTJBT2Jz4+DmFkV0m42pwOkPH8bJAWuoLnVhweAU/VRwHO4wflarLY+hRA7XvY+R4GQhv3uggqcRupksUmfIZOr4UuoCkuk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Vishal,

"Vishal Moola (Oracle)" <vishal.moola@gmail.com> writes:

> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please also cc the respective subsystem mailing list if the changes span
in their area. In this case that would be linuxppc-dev@lists.ozlabs.org
( I did it this time )


Thanks for doing the cleanup. Yes, it makes no sense to do page_address()
here and then free_pages() doing virt_to_page() internally.. 

The change looks good to me. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>
> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
> index be523e5fe9c5..73977dbabcf2 100644
> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
> @@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
>  		while (nr_pages--)
>  			free_reserved_page(page++);
>  	} else
> -		free_pages((unsigned long)page_address(page), order);
> +		__free_pages(page, order);
>  }
>  
>  static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
> -- 
> 2.51.0

