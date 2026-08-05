Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF5AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D7E6B007B; Wed,  5 Aug 2026 12:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9354E6B0088; Wed,  5 Aug 2026 12:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8235D6B008A; Wed,  5 Aug 2026 12:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3C46B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:21:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1DA840525
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:21:41 +0000 (UTC)
X-FDA: 85067731602.26.46B2A8E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5450C40004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:21:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PApT/Fq4";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785946899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tizkSZxM4VvXKVuN9JfoqQPAahmETDYIePK/2g8gg9U=;
	b=LC1QL4L0J7bNqhoLGyXMzxfwIJcge4R1tMn1027CCnl8HmylkKsZOizBbVk8zEGhu7u+Co
	d6y/A7dvPf7mkgiiGSUuxt9ESRfedwkYFT21PXVwrNqV0kTJ3VVa88ImBnHu6ALatCU9qd
	9n98yakS7Sn7a9oj8nauE6+ozDjwU5s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PApT/Fq4";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785946899;
	b=FWgdPmDzs46QoGLQwpghJP8cVxOStp8phdsu+z7AzoY26UAI8ZWUERm8eKuif6TA4GwfPA
	lr/01f1HAMxBC4XkG6MfyWDxO6w5ScR52o7+jogOLM6TcuRXxVBmdx44PpDQA1SXkJcVT3
	u3hXZzaR0xWGhvtGcHsrlxxOH6rGxpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785946898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tizkSZxM4VvXKVuN9JfoqQPAahmETDYIePK/2g8gg9U=;
	b=PApT/Fq4f8EPv/u2xW1eaWhimeLrdvNO5em6Vw3tlkIGGoSPWaApWtC56Aie4Y2suVN1qE
	AVgqhcKD3iSoLsstduD7+bzvaU5GkgcRTI9jaM+MXWcwz34zo+gLyeX2oSaXMzzvSROM6D
	aE1IAK9PA7Seh7F+czsG7H5ToDRqfek=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-4Z3g9XUUPI-3oiC2AwKhzw-1; Wed, 05 Aug 2026 12:21:34 -0400
X-MC-Unique: 4Z3g9XUUPI-3oiC2AwKhzw-1
X-Mimecast-MFC-AGG-ID: 4Z3g9XUUPI-3oiC2AwKhzw_1785946893
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47fe23b5acdso1062112f8f.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 09:21:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785946893; x=1786551693;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tizkSZxM4VvXKVuN9JfoqQPAahmETDYIePK/2g8gg9U=;
        b=QXK8kDDqUfI0edgKDVPQppawG5PO6zbcfYfTw3dXyaDEFrQXP+K1oI+xN53e1yxGn2
         k9RL4dp6SgoHXpcpaG1YDFJBKih46gsszI9uUqoo42X1QgzSOQDiR31hhJTP7ljNKcot
         tWP6vOYYt/XhLRrvz1M2wSzOnbcQ7Og67l8E0lZYO82vTBgPG+8ktQPAo8CvuXtN78T/
         23+G/Cf5DdgB+iBhND8rTok/1/f6idYAvwAfSSuHwc3m8Kr0qXLJjbbgbbQQdzEyDKi9
         eUdPMT31+QFz57q/MlU6sqNAJgJ2JZ86UBKRy9I8/KpgpBkWlR70Mfjv//GjN5F9bQVv
         9Nyw==
X-Forwarded-Encrypted: i=1; AHgh+Rr86Oj4Z1jpIQ+5B7ZCX6J+kzc6xfcoWZ9Rq/e+t1GXHZKQhJs9W0pxzKZNbtphrFhSFofm3LmgKQ==@kvack.org
X-Gm-Message-State: AOJu0Yzx4wGYcVMFSahhdtIVv+fXLOysrAQ5IyCyrdz8DOEFBQeI77hN
	XGn39/kB87/9mVrsQPPobKrIOFlVGUWS/5od6dVBK9tMbCa7hM+j2TTf1E61muAoA6/agh0ZcVO
	u6DxXeBTiPcJ2LrLgl71V1IhB7oFjbubM+cMPQG11taXFCJqqvlpJ
X-Gm-Gg: AR+sD10vznFdNfqJMcymJ4Gscs33TtH1YLO0UDD4LxWIdzu+368Wtk6USKStoBTflV6
	ANWbPN7cz3VdWzgRiXvebwXIQihNNUM/lazLOtK+3SyXrZ7QUHovjQ/yiXauXxUoot08Iab7VYU
	q6k31nH7BGJwwiGHsXEzDIEW3goMrbeyZ886xsPNE/HlrgwIC3cLRamasthjsWux5TzzLFfvW+X
	UujNTQajo0VgySlobRYTLLnQzJxpRwZDhqAin77CfVnP5XjmerNGxONyzYaeXxr11oBC51ER+13
	nBv9jPhLEHiLqRsM3mDjifYb8hFhClxebghFkTdleunN0Ck4J6uGgO43ItzLsS2/Ny0akcavsBP
	jqNBv6QttQMMA7N7xJ6NwEybxRBSC1QeDFpeYjy4=
X-Received: by 2002:a05:6000:2486:b0:47f:80df:3ba4 with SMTP id ffacd0b85a97d-47fec62aec8mr13193508f8f.28.1785946892824;
        Wed, 05 Aug 2026 09:21:32 -0700 (PDT)
X-Received: by 2002:a05:6000:2486:b0:47f:80df:3ba4 with SMTP id ffacd0b85a97d-47fec62aec8mr13193399f8f.28.1785946892352;
        Wed, 05 Aug 2026 09:21:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec231f5csm10142282f8f.23.2026.08.05.09.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 09:21:31 -0700 (PDT)
Message-ID: <4ddc95f2-8868-4be3-9839-e2d14cf35fef@redhat.com>
Date: Wed, 5 Aug 2026 18:21:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Peter Xu <peterx@redhat.com>, David Hildenbrand <david@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260805055544.1568534-1-clg@redhat.com>
 <anL-NZkNMSSxN0YN@lucifer>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <anL-NZkNMSSxN0YN@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 416ayezfyBmDH59Wq_NQXdZBgptIClWvJhGJ3FXQeX0_1785946893
X-Mimecast-Originator: redhat.com
Content-Language: en-US, fr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 88cmacxqaus4uyyddbu6xi5cnt985zd7
X-Rspamd-Queue-Id: 5450C40004
X-HE-Tag: 1785946899-321304
X-HE-Meta: U2FsdGVkX18tO8N+mXkamkARLooOl/umOnFKbqiNbUZyKwneLqrl5v7VczYBIQAMyqqhDlRWFGh+bM90SpOYTTDQwtOMH/QKKdevbQ80VBk599OgoYvjv9ubV7XjJWTXtz3fSVOIwJAuHDuMS2gR57e+Vo1uEVXJhxrglGNQf55PFTfpgmQ830a4I3mVVBQKkntl1ZyVe5LFjm6km0z8Khld2/qisHG7l8C1vj5w7+m3y6pK3tvoP6MBY6bLi39i7017v3CdiAYShzT7SyQfkC34pZEE2uW1v45mDl+1A81zXq8lbL4iuAS9gyhYP9tLqWEwLJdWlDi2eZQaBHKNIBJ/eRPRQHsNO3x6fxc3JvEokZsqjwo8r/lIIMa5JUFHD1XdulHFLNCcWuhmQLYj5mwuYqu3sc2GNvvPewnCozIcyq7d15KfYUFiiZftbyzgEGHJ2Dap71NrLL8nvsWZAKaU+xATquS1fj5BbXw6YIRQIW3HcZWsqntWrp91CmITpkeuy7d8nlpzj1ZfXafIg27uwAeloPNCxb/D4IOgWwI1pWEomBMjzLSmueoNp8qRzSNI8BObxtITIYUgAHrPj/Eo7egDS3pdbZ6+oxzZhI9fIIkVoXos7qN9PyEgBw0A8ggXns7fTPpKr106l/ihXD8MovY6aJ8D4Ic0IBzKBZ1uiAWNEsGjA8v71Qn28bT96k841rHRUMsrc5easIaRjdQy9vRIxCHXuV3PAa7eGcIwuXJ6dc7h0JWm0+a3+nwsgIq+rJ6MtCWaiqDlwiARCrh5Cbt+Fl/oVLnXR6wl6zSgLr+hIEBReUO+fWvjDzxjZpAMwjpH9J0j89a34TzZf4iwvxjQqYeZd4tCgQWhWACykQJxr25NyD9/BLOvLlrcMaAOfdOrr6aMAebc2BXpLVXbt3my5yatOi7YtPif8glduHeqpRFY/hPuj6ARaka8v3z33ZTUBIMDanhsOfb
 KpeGgIIB
 36/acieWp7bCLDU3+djwoHdzj7fVS4yaxe+knO+Vg3b7L2G9kyHmQq8iLn+FY56L2r5dP0Mqvks7L4Yr10BKkYOOI/tmiJ5ROsavNDt/qE646mD3lDsxs2wiy4TYv6zCKvL1lkP2ZYo51XgUifRfR4HNyfQVtIYauOSpBABV6bLG0DC7GUswJIw7o6o+fRAaSDblm/JPJWXrW7NX0jTgVpS3AprPk9MkRRnnsLXNmz9UJmKQqBSbDmtNbZOqDpAEQRkgVqkbsfTZEFPBdneEUSjITyQbjypOD8cE5a97SwA1u7ush1fJ65qOwrJqlLTzmk0Q86E1nuiXfg9coSHncku4+RBpxEwwnAFgn36QHx3t6GTBUu7r0pFBnl+NmK76PiUJeH+jhb/neIZjUcCSKxVdMxjqTjAv6hZnqz+pn1ILCBEF/84upO3NRnjNuDHU43GGiDdfJcbNxKc2+nh9i2buGHzMWcKhGZwES
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the quick feedback Lorenzo !
> So I think it should be something more like the attached.
> 
> That way all the handling remains the same and the override is applied in
> the right place plus smaps keeps working.

LGTM, do you want me to respin a v2 with what's below ? or you'd rather
send it yourself.

C.



> ----8<----
>  From d6537260722c8741586e6295c8eea68d06087efa Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Wed, 5 Aug 2026 11:35:13 +0100
> Subject: [PATCH] ideas
> 
> ---
>   mm/huge_memory.c | 32 +++++++++++++++++++++++++++++---
>   1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index abc65d608c23..5fa01364f089 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -111,6 +111,34 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
>   	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>   }
> 
> +static bool should_obey_thp_file_tunables(const struct vm_area_struct *vma,
> +					  bool forced_collapse)
> +{
> +	if (forced_collapse)
> +		return false;
> +	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
> +	/* Huge PFN mappings allocate no folios so the policy doesn't apply. */
> +	if (vma_test(vma, VMA_PFNMAP_BIT) && vma->vm_ops->huge_fault)
> +		return false;
> +	return true;
> +}
> +
> +static bool can_thp_collapse_file(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, bool forced_collapse)
> +{
> +	/* Override THP tunables? */
> +	if (!should_obey_thp_file_tunables(vma, forced_collapse))
> +		return true;
> +	/* THP=always? */
> +	if (hugepage_global_always())
> +		return true;
> +	/* THP=madvise? */
> +	if (!hugepage_global_enabled())
> +		return false;
> +	/* Has VMA had madvise(..., MADV_HUGEPAGE) applied to it? */
> +	return vm_flags & VM_HUGEPAGE;
> +}
> +
>   unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   					 vm_flags_t vm_flags,
>   					 enum tva_type type,
> @@ -188,9 +216,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   		 * Enforce THP collapse requirements as necessary. Anonymous vmas
>   		 * were already handled in thp_vma_allowable_orders().
>   		 */
> -		if (!forced_collapse &&
> -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> -						    !hugepage_global_always())))
> +		if (!can_thp_collapse_file(vma, vm_flags, forced_collapse))
>   			return 0;
> 
>   		/*
> --
> 2.55.0
> 


