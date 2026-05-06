Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B194ECD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A0E6B008C; Wed,  6 May 2026 14:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251706B0092; Wed,  6 May 2026 14:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167496B0093; Wed,  6 May 2026 14:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04FE76B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:28:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A81F11C00A0
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:28:28 +0000 (UTC)
X-FDA: 84737830296.08.92FED58
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7F0810000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:28:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EuJGeb59;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778092106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMhuEXdDHd/TIgzHbgBh4RMCv7Y0FYwyFxMcxUBxaSo=;
	b=pfHxDg9lDnTYkZmJB/eYOGihU4T2U6/7b+l94YZhyH1x/E81Fm28sMBnZEMleq6o1yuuTz
	SnEU8lbhnZ9tLQgecwQ/HSMZQWw1UqzWNrCQqOxkyr21SV+PBZ0W3ZZf01nqwK3e1eX6fp
	PPf1XfdcIztF49sJZzxtmdz3cuxoLcw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EuJGeb59;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778092106; a=rsa-sha256;
	cv=none;
	b=beBVUfyMLTa55DG6glDJxpD3cJMTQJi28lhF7ojTy5YgUE2DU/D3aY8fssZwYRorWwsD+H
	e9Lx6qVIbTFPkme2iHwBG/OXxy0ITrpJpM/Lu5Oxt8ha5NoSBGpdTxae895g4DTz6Gu/pQ
	POOJJJUlMEnt1Fn4N1/UMZfOGjHDHeY=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a748d5ece4so7263936e87.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778092105; x=1778696905; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CMhuEXdDHd/TIgzHbgBh4RMCv7Y0FYwyFxMcxUBxaSo=;
        b=EuJGeb59gh/P+ExbZd9GcAivZOX6aZy97v8XqBOLWaKD9fn+2JQsFZMomJT7tigkcb
         yUFDN+ZyGNT7WBUA/Sb4sNhS3AvDhnVS8XwGRvsoZ+/hz4SId7zHr48QqyRxmlfYFMgk
         LnezqfIbBeH1QZjpCg7VXRemDRpf8vwbt48Gjec4F3QFneawc1AubJ1L02PCaOqFL6iF
         ToGtB+Fu4Fa3yDw022C4A2q1P/+QpFmKhe4NUB+kMeDYvZPJ0mJ4DOJsfQJRi3LtbuUf
         4STowrlt3lhfpDpzNc3YXaPm6XmMc+ye1wqg+ZqUFDU13bPOpWF4UHNNvWBEsqTN5f6S
         /NCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778092105; x=1778696905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CMhuEXdDHd/TIgzHbgBh4RMCv7Y0FYwyFxMcxUBxaSo=;
        b=kG5ebRKE4zyHoKywSKVhqeWbSYABqJLkuXFQMrnhxK0iEKfPSNPzU+xz8lEdLtOg1W
         L54xU4nrHSYot/fdl1SHhQG4qVKMOh2X7XzDuUwbGQUtyOLoU112iie0aOut5M4qA9Ie
         LBXI106Vs/elQPsYGFbUnYo4EHaimwOx5AJoBAA7b2aZakJr5lVKcRyXwIgpXTSnYJEj
         8iGsEv6I8F020re1ZbmBetdESZaVNoAszlB2MUWkCDD7OQP5N68o1D5VLxAKgofISI+S
         +P27V1gUYp2rbYgn4hzE4GIZ5u7tX8q1DVMcBL0+iGsVtOKxym+Rf88tdDqzeeH1a5YF
         ajmg==
X-Forwarded-Encrypted: i=1; AFNElJ9ohCki1U/gNlURgIDBjfPhXIZYySJDQ5KH+k86RTH8LvlEec6uWjppnFopDRzxjuJMI2NsLya4LA==@kvack.org
X-Gm-Message-State: AOJu0Yw7EiplVOLHT6CH4jhRwX5OQsyE8srf/sgKyOxbfGeCxyzpif8p
	12vX1QjkXIvZKzPv+WplWB1Ima0Ws5x3UVPQhiC5RLXWwy5MuBZWG7vP14pCjP5g
X-Gm-Gg: AeBDieuqQRZqvyb9G6dDclAj7LNIi6OMO1G4/G7t7XmGJL3SYnsEQ2fp3wNN+ZXCTRM
	wfIJbN+U+Ra+wj4SPoEtWFhODotrj9y1cQYHNndlN8MzQqt0BMppeL3p65vGmdf7BYJ11fGGunG
	0eBNlRBERlln9B5azwrmdqckhfpE+ld/O8oq/RRBAN8xTUKDW9t+53FhEeTeZVOtQ8PnHCKtfXz
	xqpm33829u1QER7MQuto04PNyyMpcDvxj1/CxlqErLE5Nw0thlIrKMRfGGQ6RfKqyMgsBon32mW
	sZAverWkRDZivU46DTI3LEkLf2VqaStiGYxweTGBQ24LFJNZY6yzbzBNbp9qLcG/hZDQ+UqU3K7
	mSRyz0sOde2b4tTaNv19I31zZXMeI1QqMrlPBBUK6oN4rLiLrD8vwtzx/gG1Zyszs014+DXdBRi
	rcGuZu5vy+b94uhRHBAKU=
X-Received: by 2002:a05:6512:118d:b0:5a8:6df4:6ad7 with SMTP id 2adb3069b0e04-5a887adfcacmr1849877e87.14.1778092104748;
        Wed, 06 May 2026 11:28:24 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500:de96:9acf:5dca:ede4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86f36e3e1sm3312799e87.82.2026.05.06.11.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:28:24 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 6 May 2026 20:28:23 +0200
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v12 3/5] mm/vmalloc: use physical page count in
 vread_iter()
Message-ID: <afuIR08cj0e7hpd0@pc636>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
 <20260428-vmalloc-shrink-v12-3-3c18c9172eb1@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-vmalloc-shrink-v12-3-3c18c9172eb1@zohomail.in>
X-Stat-Signature: bqt1ogju8cxhjkn1crqgey3j57hc4ug4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7F0810000A
X-Rspam-User: 
X-HE-Tag: 1778092106-880094
X-HE-Meta: U2FsdGVkX1+/AHaB1KsBP/Jg05kyxXl5og1KQz+8d4vaJQ7f91IEBrZYtXRqxN/YF+lVH32RXmPlTnouLNCjJUHnL/jYtldAyg+dYB1vrX2QXkzemxr8ihRRKgdK/RlOIejQFBcrJ/Ur8oCgUCWOM4sf8AfvIPzF38khFWa6Ium/NuqrMj9T8+MnCPPmYjSRMiDn/UdUHsdgKomyiyvb6UDIGc3zSfOr6iLMEUEG0tNDY7DTg1n4j8TlkYQt4hwA/Br/m4unTLBlktAWmouV7ArLXerccQgAq4ekHNmep6iOiUjx3dW2x7M9g2apLHoObJShnl2td/ynrJKo09/uL9jCFFMK9jrW7DgeC3XDSbilp91PGQC1xMDAExXSwAPerpe3A5sXvhWXdn9qfm/hafRE6PXfx5JTGtduoR1IBSHbq9plLL+2R4VHIn57dEvQVD2d3L0qs3rkELUBwqI2mMyVDfwyoNpzShsH0Ug2HlSxzHgoiWhhoV65YCh7zvkms9hOVNa7PVFVSNJ2EInAbg/GfXQiqy+uPgzNsFdpRsl+X5sBjb8FM+I2VbhJ/gWUCcMZo6KnYnyJGuTRNfRZB+xs4SoNxdw1N+MhXHu62SUBjT5A5N0B67qtwPju8ICpmoT+iZWw2QDD3h9oRJmS1k2FYDoQX3buusM52D03yHy+74/PgFc8cimYGz6jO/P6zOS2jji6wpbolM0XfHvHGE9FpgBul6MpIASC+Sdr392zACyEXOdkyRKsBqYzP+g4e/FgKsz5Md/rlWiBuG9se4joeD+6CfiA9mYVxPdkfAHihJN0t0EEEbs61HRb5/+9h2w11BXIJjPwfvwrUpi1f/Fe+cdE0Yn0MTVGUD1ZT2qiNsFN3vWGOUlVTaaysLFpWYiDUf9+aHEIdtygOa5N/EXljCrTfFdG7pFFKAY1eu4oI7e3+qD/UqkS25FdC9l9k/oLyZqxAthvuQ07BI4
 UqHfvz/+
 vRV1D17DoZatL5Dqd83yoAQG7HnsUoWyF681DQ5UENQMUukv3pJMVffk1oJDlHqSsibzPnSlqTZ9vXeLhPlDbZeXU88Ly3HH8pfV6kk1FN/hsdKcaecJOAw+LDUY/r83/+5GDFoArYMZlLJjJxQQ7FtOvJ/ZKwB3fnEhbiXzyPoVek6LjSaH8I1HQMEV/N1quOQWfqmwNTRtijlyCKKrOExwA6lJkZ7kxozX56A3tywdSblHXfAgTu9tbdQqh47hzHhW8aTwtjjDE1LRAvTCed03QU5sO4uTfMd4lJBtS8MfDFgjKQLT6PHMtKXgVmwVYxsl5iHuQPKbhEZoAUY0l/fDFnI8qQxsTECEtME+9/s2yJth9w1BvjlK/vqoi0PvX/9r5TMSAsnYrMntt9tsa9Mk7LwNiufo8N0U4saezBoMeKZLd+YfTt4ns0n6hZ0NthXQa6DFKuhyyd9PpiWuRvsHdff1i0MhC7z5xds97zL4RD+Bx/1zgnR4Gmqj2FFA/PZlARhySsDHAwwDo8wPTk39CRwPRCa/N2apZTtYWcKpMTftkM0P7PULBzWYxrA+iqx/S2k9TBR8DBJJ0cXL1YuiGfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:54:18AM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Update vread_iter() to derive the vm area size from vm->nr_pages rather
> than get_vm_area_size().
> 
> Currently both values are equivalent, but the upcoming vrealloc() shrink
> functionality will free pages without reducing the virtual reservation
> size. After such a shrink, the old get_vm_area_size() based calculation
> would overestimate the mapped range, causing vread_iter() to attempt
> reading from unmapped addresses. Switch to vm->nr_pages now so the
> reader remains correct once shrink support is added.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 9cb3e287a1e8..65e0a23efb3b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4661,7 +4661,14 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
>  		smp_rmb();
>  
>  		vaddr = (char *) va->va_start;
> -		size = vm ? get_vm_area_size(vm) : va_size(va);
> +		if (vm)
> +			/*
> +			 * Cannot use get_vm_area_size() because realloc()
> +			 * may shrink the mapping and area->size may be outdated.
> +			 */
> +			size = vm->nr_pages << PAGE_SHIFT;
> +		else
> +			size = va_size(va);
>  
>  		if (addr >= vaddr + size)
>  			goto next_va;
> 
> -- 
> 2.43.0
> 
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

