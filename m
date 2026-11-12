Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C0E606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lGhbWc9e
Received: by kanga.kvack.org (Postfix)
	id 159156B05BA; Thu, 12 Nov 2026 07:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130236B05C0; Thu, 12 Nov 2026 07:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045C76B05C1; Thu, 12 Nov 2026 07:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CED166B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:16:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 695E68053E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:16:57 +0000 (UTC)
X-FDA: 85426366074.05.4DDBFAA
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C18C10000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:16:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lGhbWc9e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkghkLc+UM+Ih/ovzmI/ipH5f/tVvmlQK1TTNKFCOPA=;
	b=c5NxPRttqnDkaZu2H24vuqdQMABrmCvWpn4aDxwobX/D2/h0FqHxXGoO1S+3iWlkpcwmo0
	Afz39Jf+9+UKW8K7+7CfOcqzLA2gYrxh3nYNiiRLW0iizd0WGtN+OzoiXIMRDirir1ijvE
	5B94Z9S/096VHxyNh47q4Y14pRAzQWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485815;
	b=G7Q95fKczWpVYjzt8NV46jv0w3upHyw+ZF5FjF/2ggAHBAvOaep/+jW7kMAbjQ5ldJueDA
	2nvM/ZQj05X7H/OZA/D0IB89xihtDkLz9L+ty2x1VrWEuM2CNV4KHyTdC2+tf4KI2536im
	neGfKlWGp3jFWDx/7IxuUarzNQkAlYA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lGhbWc9e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c247f6687dcso686220866b.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794485814; x=1795090614; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fkghkLc+UM+Ih/ovzmI/ipH5f/tVvmlQK1TTNKFCOPA=;
        b=lGhbWc9eEyakhSRNFKX11zq0hBWXFd4c0+PQ3kBOMe97b739XJ9BJBN/OWAVo8GQIC
         3JP6j+BltNmoSJN4pIGBuP6Vqud6Lmj6T6RRhVOvSzkj9ZFFj5/Ngsq/HWNuyShKFZur
         epFc5RGMSaMP/3kU/htj4GB+hVLk+gjm1eJ1TVo9fO50+UjRpCKIIER8YxKt63gsuwYI
         AHRNbsEBh1unSUuMCQGBFneI4PGLSulhzTHNfPUZZgXwcJ4nMIWOdIxpbuXki30dvORB
         pAT0ln0yJkR95G20NN+7sBDM/NM0OaeSA0tTqgaCIIU55g/C3+pd4QABIb1TNB9hfZLG
         T1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794485814; x=1795090614;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fkghkLc+UM+Ih/ovzmI/ipH5f/tVvmlQK1TTNKFCOPA=;
        b=oSMNFgkgID+/ipOHvRYIxBnnTeRiGfeS81t36Kx1gdW3tTmbxNPvXSNprHclfEJl7i
         aHA1EbVDbU40p4OBgaJF7v9dqXbsenXE6di86c1oni/HpNocQDEG1yfqW9BxPfovVnTQ
         gD4gQjOsicYmk/TZAgw0RVL7IQ8VitkFS06WdrBOjpSfJtzbAvbq6KfMPl9SC2Sp0SAO
         hs7QuGXdqO0VGf21ILHMJDggkBVA1ZRrYGVj+CHXkFJndP/0jO1vF20kuTli7iH4TtKk
         ECkF5ZdYqC430+oG4B/j541ibOVH6fq5AENyxwpQ1eu1iZcLxM4eCQwc7hckkNqdhc4g
         T8TA==
X-Forwarded-Encrypted: i=1; AL+hErF4PLta25uBLdme8HL/htpaFZ9GPF6v3rDk5ZKnCjqQdZG669HwfxdewsxFsr24UKGVzR/OkUy6rA==@kvack.org
X-Gm-Message-State: APuU4Z+GO7SSmhmlUPTZobVidTN2FkdauHXM+0D/eXSOAFSSoD1Fq16q
	aAI0nN7Wpcnj4a7U/k4I3rFuQkN2kLJnT10kXKLia2yG3i5ogRQZ5VZ6
X-Gm-Gg: AYBFou1mzL0VungKWVD4g0QHq57FMJx0YeHk1eOt89QwV0PEaT8WuFzl4wndO9WlqLO
	3bFtttDBZzxnGLF/WD204hQQuBrFnC/ypnhBrsL2Z288RCzUE3FGpKdPMSGOe4RgZ+Itkj5NMyI
	7jmHuKcXI3Q1uA3q7zavCwcpwUxCkILBXYtBRZXjrirs2fpor90xAq2H2LCKT3mJRg20gBPE/M/
	07y7qYW7LuefEqlJzRqwS6qM9u+Otsrh1gXqrho3XRAk6m0KGEEwSz4MCWdrG2F89vQ5tRFMmD3
	fvXCkHmrhf5sm6UVZEI0Ke3E8EpppaYuAanG9E4AxBuoFAq0xAxqHIJEe0j8hmpCTSQKmQpqIl1
	LFXBPNGZWIyrhWJoeJclsZLKwuGlXRy6eUyjlxty0tTgONcUDSaJaYW++x3cmEoZ8tv1aE/Zqg1
	4ceJ9YLeUMXQbfeFZMfSClBqd/TVvbbv5tN9EgZJYzkUnfRbKlHx0qyXSuA0mfqhZ0L+HQZofc8
	yR3qOPjpbX3ht6vhSTcfxCn5+G1G5CFXqB/Wbo+jyqS+Sh1GZbslNmX0pbsj2JR9MFcXA==
X-Received: by 2002:a17:907:3d0a:b0:c42:4750:8d33 with SMTP id a640c23a62f3a-c5066b46008mr455415066b.28.1794485814178;
        Thu, 12 Nov 2026 04:16:54 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a618abesm330293966b.50.2026.11.12.04.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:16:53 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 12 Nov 2026 13:16:50 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v4 6/9] mm/vmalloc: only flush the cache after the vmap
 succeeded
Message-ID: <avWuMhLKno4LXNe-@milan>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-7-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110112546.261415-7-hao.ge@linux.dev>
X-Stat-Signature: 3orb6qc7fq18es8b3ypc1uw4ury3x4dm
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C18C10000C
X-HE-Tag: 1794485815-910714
X-HE-Meta: U2FsdGVkX1/PUfredcW2zVWLfV5apeOlyg5F/a5Gc0Zc3BZ7TcBzv4+iQWokNKMpq8N/0SY6/7i/mQHlWWitBgQm+jiMUMzHKXCfohbf/cAuI1D0rh9MbQlULKMA/nYuPiRbe+WgtZ/CAno4WZkICi4OibIQuXis2+hN8gYLK6B/iP5rF2tqbxvypAT1o9vkn9j2W0ztCDCtNQVtdHwJZmCKnS6WmUL9rKP86IVxkwe28Q/sTfPQWzhZdvLZkLhMyBfqoJ5yeC04HLa8QszJYFdXcxioOFw6rDL5T5sFvYyibGuX09ZZuU8EaVxdW8Vc79LcIA/yf1BH1wvIks7dMRq1wKoHECDwY44wPYx9Ko69TpfIrFEd+4rK8UKXtsORS091k42kdLL600Rthajr5tNkw0iSft2JJsGbVm6nCeoqggYTQ3+LFhWfrszzQFz5mH/OZCcLs8IdYMlwmBRX654cQRQBk9q3fQY5bspIL9AfOoNBVhXiOOgCGoxlKxD1KU7K7R0DLd9jpKTdvXRdbe3rXauepebwcpgTjtJZhlGcBm0LlVeAyuKXtLz8FDRX60OHfizwYR5h1pmXAcrTOiDYWIfQvtTfc1vZqQGrslFbX53v+s9D+7Cfj55wncT4Vltdy/KJaoU52qQ42RL579KgR59QQrrqRt0r2p5mw8MrUAMl/TgRJZZf37W8Q1XmS+oRTvudt8IWAS3KTVLlEYCsqlL1c47KycLhI4bzC75SgEPsOCV91bukAG2D5e0E1NTJiVk8QDDRWA82T/bCK+ZMaRoMm2U9CNGy/EFsGKYJJCQXipAAzKGLYjcS4MzJfvtl3Np1YUCHzpcLZ8X9ZvCTZD6HYj/Jpb8a2R/KrK5WObv+lM+4N9PanKiVoN80B50u5d3KINioBLAeQ6d/aggAW7BXEcw0JmnaAJBQDDgOBP2+dmPndtVk5kQpYAaInK+W21JKJuwWoOYYmZg
 1aNm1c5d
 QcjMwf0JeNyn4meFXxvlvyykGtnKjEGkcnU3bx7e6ASL/XA7UfRcrqUJe8sKintzpXkZkwH60YbRDM+claw/EEOIU5H9k6tIE0UXG5BNKSWJzgM+Fqg+e5JbXdhwgqyKu9S0kb0UrowvzCC5haC3SPDR/yZXwOzuDgTXjzwBICZWzsiri9jJ76yHdvlm4Ao2Zwxu8OOzJSNOG6sj2GETaP0RINwg8N9+LHz8rZ/xscp8647tiYDAOvhXCSpRtE4/c5NFkcDSp5fsOIKKoAX6HZcda1dzRdyW6dUka98L/WLNyKwrmVckIUxP9PavNcGsKG9cdgqhF2mcy2v/ID+8lLs8VcZDIymoOgOChGPryBy92qYh8IO/1eigDIbQOz13tRdlZ9ybXwmQ/0qrZ4rV5xzLEW2eHLP1HRa6Ig3vf1UKU5Crv2pW3kBPi3sAReaZKer9SI4E/3yeJbEVlZK5onJaMyJG/U0NY9ijwEKi+Pcimmzy/Ucha/X5/6CbXa2yG51UIMoTiUjtlrhZ/rOmMyUrvpDzbkwFgQqLTQXEEcU/ikqm8qZ7ABV00a2MbipoUFGqx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:25:43PM +0800, Hao Ge wrote:
> vmap_page_range() and __vmap_pages_range() call flush_cache_vmap()
> before they even look at the error code. A failed mapping is never
> used, so the flush is pointless at best.
> 
> According to the Sashiko review it is worse than pointless on UML:
> flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
> PTEs into the host OS. Flushing a half-installed mapping therefore
> leaves host mappings behind for a range that was just freed again.
> 
> Only flush when the mapping, and for vmap_page_range() also the KMSAN
> metadata, is fully set up.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0565cbfe325c..3f98056f8c7e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -369,10 +369,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  
>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>  				 ioremap_max_page_shift);
> -	flush_cache_vmap(addr, end);
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (!err)
> +		flush_cache_vmap(addr, end);
> +
>  	return err;
>  }
>  
> @@ -758,7 +760,9 @@ static int __vmap_pages_range(unsigned long addr, unsigned long end,
>  	int err;
>  
>  	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
> -	flush_cache_vmap(addr, end);
> +	if (!err)
> +		flush_cache_vmap(addr, end);
> +
>  	return err;
>  }
>  
> -- 
> 2.25.1
> 
Like Suren noted, vmap_pages_range_batched() should be fixed also.

--
Uladzislau Rezki

