Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7E4606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hw8NINNs
Received: by kanga.kvack.org (Postfix)
	id 9C9B36B05B7; Mon, 16 Nov 2026 13:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A5D6B05B8; Mon, 16 Nov 2026 13:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869486B05CD; Mon, 16 Nov 2026 13:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB696B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:33:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAA87160298
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:33:33 +0000 (UTC)
X-FDA: 85441830306.09.6AED263
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id E989F4000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:33:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hw8NINNs;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794854012;
	b=Zy/LhMFZYv8jyDTojlUw7eYLgtYFiAOjRGiiJHlSUJF7185NWUxTrncIBiex1B01pJvu9N
	ZI+YdW+N8ZVj/329CrgIcRoGuTourZcNDOfCflx8ackwcni1zhRtVlTApJ3Mslb996sOjV
	y3Q6RSow5CceAjHuUsYCxSTAiApi0L4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hw8NINNs;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794854012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zf1hqnxgUUaXyC+52Twk933Fjs/9VQ8uLC08DreXCRw=;
	b=40LdBQdJx/ToRf7W8dpaeYx+jZi1GAGV9sWthtUEL+SbDsuBBsVKR+1eZJZU2LBw8LMX/I
	4rVau21EQIe619KMs/9QxJdJ4tFC6nHZ3NPxT/ckLuLYPVk79j3Nqd6lvwnNy0aixdary3
	dgOvYsdaraxZSz6eG9lXWiKVlBwHu8Q=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-84a248254f4so2765288a34.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794854011; x=1795458811; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zf1hqnxgUUaXyC+52Twk933Fjs/9VQ8uLC08DreXCRw=;
        b=hw8NINNsGAK7RCvPLTRIb9FkGbLGhdsEUfU4MOFV8KuEeqw8uuEUto3v4+OGv8uoKi
         weFpJBiJWuyaTNk24t1BAqPVEHd9toBccnWBOCNwUCTr1qqGBpSouApuK1021yH/nCd1
         A6nngPQ9PIVH0sfaqhcdIT21tYQLj63D2J9FS1LclnI/cTx3Z0E+TskLiPsBrr+m+/KG
         M4U6fu1bfxzfHWb2xgJ51XnuM32jzID9ajTuxBXIr+YRai8Zmm+oL35QV9js7OFDDAWO
         QKQ2gXe3vD4gEG+mN0crfcaq/f762kC5bJj1XD/OGdHeLUnnpzClM4sUZ8WCAPZ3dmvE
         /edg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794854011; x=1795458811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Zf1hqnxgUUaXyC+52Twk933Fjs/9VQ8uLC08DreXCRw=;
        b=zzy38Pd/gRazRi5ZpO7mEJaL6tl7DuCEW9i55itmdjlvWESBOVpOW7e7VCrTa/qcpN
         4UjsEzaoRPN/t8mAmF9ZQLZ3Q6IjDYvHkTJ/LT32QVSyGUKNzGkG3peHtYFpFFmhaofN
         MO/caXuoEgw+Y8MDdARrl2jNaJvZUrBgtXz+4O4sQ+gGppYuEJQAzrCi8nlrHb0vMYb+
         v/Zc7GIGTwTs0XNlN9aWqSsLaoHk4Mi0LobNbDUbkHiFPGakzl9AfzO/y/VMyYWNTOtt
         pW57JDTuwQPh7WCkMhopkJT7wRuKE8Bhd4seE2TDiwFlx3vPKjbAUyGOBPnUkCVY2P54
         4+1w==
X-Forwarded-Encrypted: i=1; AL+hErGow3jqbWlWfquzyGod4OL5PYiKmVu1lJuZjMaDZk1NvWiyxZtpV/aZ0cEdeSR/t/ZLCxqbuQ97dw==@kvack.org
X-Gm-Message-State: APuU4Z+f6cccwqklMZ41nv1HX4wmowTCcXtcoie9SatSfPsTV9DpF5Ir
	yP69WjuM6zVRO2nEoOeu7b3SKt+HCfmVO1cZzU78JY6US+32bZ9RiKJs
X-Gm-Gg: AYBFou1xnGoevwVSLD/NyhTDbjU2aVmGwTvM3FaKbPl37uYb6XNMROKzrrKS/rWbpgi
	CuLd4ZUe9yq8tCJ5N19KsrCLgY0u3o1hdNsK09SDjcXXGnvFotdYzxXzLY5rPcQTcoM4eYDrIxx
	Ji0D1xWPWQdDdJskkmFSwt5DWmGBth7eZ4ol7YaQUW5jzmMi/kNq81hmGV0vuk1vfKwFrgdRyFD
	GLpbRR3KwQMhwYxz1L4G4MfMZdLCLKzL6IND9+PECRHVo51yyAjnsTZCU8rPPPqAT/igcTa/uZG
	k8ewaOg0rV7C1pxosA1p1iTYBxE1Ouj0CWGxag3mrHRKDpvYU1oXYE1IPX22D1KQkqfXjGIe+lP
	rC0TVikOIsxyqv90S4hlnpRlUWbNnnkG6Nh1KhO2rriCV+pZf3i8ObmGAPLhkQ9jp3buK5V/KCJ
	/u1D+XiAhSU3YA+cs5bjfQ3VlOoNlSys32QrZvxcsnpfKk/SVLU61/On/4xiM4ikQIVlNsrKTQw
	+EHF5yaJ0XRGVlbX/FKgRSB1Z6718NO0Fy6qVE4pK8QIhw+hrmESq20eCFc5lavBm1/ZTxrZZ2A
	bvuSE2BUZmDiuWPckVAQfYKZLajnfUCZ+f1SJ3k3CSppHlGnNWz9D3Ns23/x
X-Received: by 2002:a05:6830:640e:b0:862:c685:84bf with SMTP id 46e09a7af769-862c685924amr3847900a34.4.1794854010849;
        Mon, 16 Nov 2026 10:33:30 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862ae607cf4sm6939137a34.18.2026.11.16.10.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 10:33:30 -0800 (PST)
Date: Mon, 16 Nov 2026 10:33:29 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	liam@infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, mhocko@suse.com, 
	pfalcato@suse.de, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, kas@kernel.org, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: don't PTE-batch a swap-in of a folio with a
 hardware-poisoned page
Message-ID: <avtMXFH75SJFpQjZ@devbig011.atn3.facebook.com>
Mail-Followup-To: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, byungchul@sk.com, david@kernel.org, 
	gourry@gourry.net, jannh@google.com, liam@infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, 
	surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, 
	kernel-team@meta.com, baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	stable@vger.kernel.org
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116063624.1382944-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: E989F4000F
X-Stat-Signature: fz9r7x8tyiazug1engmmx85wxqds1izg
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794854011-480438
X-HE-Meta: U2FsdGVkX18LFAX8D4oPQBcm5PHd60W0vPKtX+QN+ihbxrnUgfNfdoNrfClbYLKUGwzbvzRGP8j9xPYiM/NlQiGSWMR4oSshXK6q+SmUOru4oCYjlDlTiZ0fWI7YXoNUrNmpKARjeJ5/bFm8mflC9khmhuHWu0AV1n75CNYbPAKFf6/0PzeTzy1du4akER/on0PaGJbEMf3qtYTss52ipo2iBkKhtUAH27ojkM/cun8UgoS+1SlJWFoIqnIGshgdTG2TCXn84q11GnuL8UIxklDKT2BF5Orj2gwtE//imDaKgmf5lrbqBcjIvHX1giA8ls2iMa5Mr5CyQIWdAMX/F4ADJ+Ybbew4vbrgG4stp/lTYdSc9fp3JVfBwxHLI5Ew56WBBzIKBOQUVGHqfQZe9HvnZZnntKItexZX8LfscqrZ9+q30h9gqNWPyt6/Eins7JLs2giIHc0bumE69OZzybsEvkZXwqsU5IiDM9fYqC3L68combjHzrWqg8Kil2CYKhct/SDftaAPV+jBScUyRU9L5T53nLBTMc7eVVGRN+5hos5TnDmu2eGf/jslQPx308Z08W2p1i+DnlTCNSAroTxTqebdgNi35JEoURfI94IVvhGcsF4WBKIGsTPOaTFntXPPJQ+wEYMddISM7oz6Q4jZJC8ELuzo85vyplPgQ16ciImifcJv7GeFPQlqBcoBaqhY86b7I6j07Ku0sJv3TE4abTv9ogjJu9bP4FwE8K89Ycy7OCsX7niEadwku3POhTnbBdcBGKHeUXLNX3Xv0cyQxvZ4mlktNP3xKyKt7dAYh10yBzJiYjUOREho0mA1ZiEXN9/DXskAguv4Wd/5DxiFt1Xg6XMLuXLsU+fN/8e2GNi0hMKyBnIo6l7TWLAUYM1AweqvNvGfwY1ypgZEduprI1KAVND21GzApR81qCmfQ+MWzB0WMtE2KkVFIPHU460vUVvp67UCaxs79AU
 9iEloE4L
 6Oo7g5/DkxP0UjQvV4gxwxVK0f6QlxR0Rsbmqe+LU6SNeGchWyh01K3U7AtvcgfcK+Y3iG3vorKVf0CVB2SFENo3YfGb8ZDvZBgOu4MZM9Uc9S8utFam0SKYgO97gHiv1cwSe2kJff1UE38yXM0QwnVxoQNo4/ML5pV6tuZSexXSwLQx+h8F8PLWKeH6BbMAdgkoLMnC4KH8oIMtp5WrOBVt18iLg3LoGZvuPq44xZObRoKdIhAT8lMd2xES2xvVX2s1nfBK9IsmLFqxFvobbolJhrv3wj6KqE790LUxbSfxfLkKQaPiBDVDNpwUQHWhYvskc9SYxP9yPZ/LpyCS67zJCoVTGgZXjYo6MUhU4d0ea4WEv6FI90k0BIEQBzSYBLZdOJUbgkkMxLE9QyDKtgSCHuncNoi802TMkQsOtKHW67FYQPe71URuTKe78G5Og5AEcgiDdOqrsPU73OvXFbLBYlzOiabTq/mAp6KsVoH6nwi2KYEvvY2VPEk3CAqboa0fBXr2STIsm4eg+Vv6N9vLHPPrWjwMfiwu83MKymgRrbw9UMCVfyU9kXgKjRsmjBP7c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 10:34:56PM -0800, Usama Arif wrote:
> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without
> looking at its other pages. A poisoned page that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
> 
> Skip batching for such an anon folio and let each page take its own
> fault, where the existing check catches it. do_set_pmd() already backs
> off the same way.
> 
> Leave a freshly read folio alone: it is not anon yet and can only be
> mapped as a whole, and falling back would free it with the poisoned
> page still in it, which the retried fault can then get back from the
> page allocator.

LGTM!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index d477a4f986bc8..51e72fb40655f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5158,6 +5158,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
>  			goto check_folio;
>  
> +		/* A poisoned page in the folio must take its own fault. */
> +		if (folio_test_anon(folio) &&
> +		    folio_contain_hwpoisoned_page(folio))
> +			goto check_folio;
> +
>  		page_idx = idx;
>  		address = folio_start;
>  		ptep = folio_ptep;
> -- 
> 2.53.1-Meta
> 

