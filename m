Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F2E10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263A76B00B2; Fri, 27 Mar 2026 02:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2146A6B00B3; Fri, 27 Mar 2026 02:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A486B00B5; Fri, 27 Mar 2026 02:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 018C76B00B2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:50:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B0AF8CA76
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:50:22 +0000 (UTC)
X-FDA: 84590919084.02.0370ACA
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F3E1140008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:50:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhJ1oZIl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774594220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXjFFBcD3SJF8SimrCdKf4tkm13+ZSGuVlzsZ43PuGk=;
	b=SVjdCIMKgJ9WQAG2DDdJO4Q9Y8MaJz86RCNTjLwXeYrwPWxfFTTx4gAVCPjSCepVnOsKMc
	n6IIwQdLJSJEjtN68MG8MfAeoRkKdddJakNlKmseMfmBG00wESdcgJccIeK+FIZjN3nqXq
	lmS/lo0baX8kK56iNLk2KUj5GDVfvQo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774594220; a=rsa-sha256;
	cv=pass;
	b=IhbJhT6WMdHylQD0ZEtFcdKlqmJE7W5nOMBkhp1y02JEbc2pTT/oI99EeIJFOOId7obNki
	M7smksYnCRCqzX/TMa06XgfM9byoGW+79foXLBQcIpEEVQqdDAbdLsnDbkNc90ye+y1suR
	RUUz5qPlWw0v67WQiVQdr7IkW4qxNgI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RhJ1oZIl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d7e5e8c907so1128193a34.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774594219; cv=none;
        d=google.com; s=arc-20240605;
        b=bmtJlvq96dpM2C6RjKcXARQ78LdFyu7zWa1zjc1o9P6eCTcKhtRJlyya9CqmMHPf9g
         hKsPCyBlL59ucgROvh6QtrzWYZXlWeYjeAtBBEER0K8tiBp84XIoJviiDgU43eZouyl0
         PDAIFVmpz7gSuMITPmJ6TwOO49mt0Z5ib/I/t3rjoEvFgWvHaeWN3Gb8FolbDTLOYsz5
         UkQNt/ROoO5MNsmsOtBGY9R++NnZsCod+BvTeszG7FauS9mrM4fBPL0jdrcJRIEjJDj7
         v5EUkhbbxiJLHrPPid9v/aXi1PtOGe9hqxXucQgvDzjG3IEh374K2oE1NP+y0cyBJNOh
         ANag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iXjFFBcD3SJF8SimrCdKf4tkm13+ZSGuVlzsZ43PuGk=;
        fh=y40tgJppABM9rUFUSDjA8zc9NwmhLzodEUsNqPDV7pI=;
        b=EOFFxSa3k3kr65U84MIAOjJ1IBoBicrDTPnqzre97lYMFUNAtlyA4NmZtJcz6TDAYJ
         pwkDZmy1Wur6VA9elkQblxddaI+O6tp6C6MNQeyc95vftBjcdDP/+V47jobJnYKpIUSd
         KeY6eA54czilNSGTwpe3Hc+h1VeI6IsW2gIDUD6FDKzCPJHeNqVAUy3fQZh8sH+NcvXl
         dWlDh0VBt3E5LVjTT2TTRw39f/Aeng6SohPRTpoA+yhI4knZBkdpVZNVbH7REr31wx3a
         c0817oOXPMRSEVZSI9MW8V9sPJwB7bVWL/zkg9I3iAjv72qusLLjqag+Dss2CxyrSZY7
         aSYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774594219; x=1775199019; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXjFFBcD3SJF8SimrCdKf4tkm13+ZSGuVlzsZ43PuGk=;
        b=RhJ1oZIlOZfpWkYP7DUSPgSH56vngZLXkPSvv0N5hzJpLKa5NQTe1e5Ymj7j8kAEDx
         ixLHmsd9Bp+4tEzPmBES31hwqv5KF/o28c9XD52mSzR6qVSttt5T0zMZFxMpvozV5jOE
         qVIJVOU44uKE1q7ElFYkk+AQfhmb97oxerHs0Rn4bdoR9mHpSikqwBo0PIAudgN4IheP
         0fzRbtM2mssaslT7Axq7/KlG/sRgi9YBTs17bc+5Fh2V23EXEEBLVboJqIYNvVA1e1WM
         FCvrl56b/IKnWGv4+DCZonrYD02dO4QfZIQCfHEUuIyzgnknIRNpfizmnyNXDH78xHeU
         RJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774594219; x=1775199019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iXjFFBcD3SJF8SimrCdKf4tkm13+ZSGuVlzsZ43PuGk=;
        b=ZypGwu164SF9XOuz/1DJlZ+Gu3IIhx5hxHQ/n5NG8HoYuEeUbcvg3D1zDDtuvU7Pcn
         GvaEPXaCZi4ZHX4GoBnhsp3GAnAXxbEWMPhnHzMIMzVAxxKS0l7kFrlV3d4WLIY3ZNr8
         9wZFYPPhHXnXAANmuV22ymm4JExURTeMsQiM+HDXvDUShR+wwFgFPeqtQf1s6bS5pC6r
         VcwSNTC6QQenrh2SjlDjQLtEfNZnbhGVY9puTLmzlVhFt9TtbM0rCs8BHcxpsPB9Sn+9
         00IB5B0KKfwmwlgXlutjsZ5xm4UbT+Rc5dGIsYaOI81TAPDSProPYdZjonbqhmqPfFkg
         NItg==
X-Forwarded-Encrypted: i=1; AJvYcCWf4/zcFojBC1IgppP8GRiinaWM31zlk8cJ562CJqt0+RuJYarM2vYxJz707jr08N8o0RZVoBTO/w==@kvack.org
X-Gm-Message-State: AOJu0Yy0AiskKeCLf7yHMywGW/aLyAn6Y3z7dqUKOHKc8x8EzHJ5UpYp
	27fpCIOnuoeXv47zZD8NtCH4tQxJ71pTyE0zZszXe7ta79jJ2jQZJgHcPPHjSOxlWgxPpyNeekx
	RIxIjU1o2sOiAtIoidNq45iiWseLZNbQ=
X-Gm-Gg: ATEYQzyrHope38tMy6RsBhAs7LloorTTFe8BfK0yJKdXWVsmnel2HKn0ImF59vTGXG6
	bT4DwxuG6bfs1rs7faSqcMIBCjKsuS36qC+ojSsozN+ikDuwz7fs23I0CAKsAEkIaUUtQ8uKlXQ
	6ZNzrYCwYHXOy7ZKNBMKxGskQvOSyC6kAjc3W0vly3Jk5tlF2XvbPt+E97FcnuN7eXTs9IlE/ps
	qJLysMux+xIetfnzo+JQyx8IDwr07Pganr63E3nuaidNdPdth7ZdNtQ6BC9/VrBf7NGjnVhyXCE
	E15bCVCI2QwDxHbJHvBj
X-Received: by 2002:a05:6830:82d1:b0:7d7:419a:7ac8 with SMTP id
 46e09a7af769-7d9fae3e615mr593879a34.15.1774594219320; Thu, 26 Mar 2026
 23:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com> <acYlxRBhSMcwBnja@hyeyoo>
In-Reply-To: <acYlxRBhSMcwBnja@hyeyoo>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 27 Mar 2026 11:50:07 +0500
X-Gm-Features: AQROBzCSJ9XrV9me08FJoe9N5FsTCYU6wreGwMbyYjqv4H9TotPPKCpBSj6ZRjM
Message-ID: <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	stern@rowland.harvard.edu, linux@roeck-us.net, andy.shevchenko@gmail.com, 
	hch@lst.de, Jeff.kirsher@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5F3E1140008
X-Stat-Signature: gcyhcx8ogs46yoa466cbrmmx7cx9kr85
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774594220-64340
X-HE-Meta: U2FsdGVkX1/f0LUt83YVjKL0TMUjfEr4SAhlOwBzn8692qagv/ZXIG6gb8jsSjYreTRWVJIuLI4eXIIovAmC6kdJ37efDyvvGVRxsV1ZCqN031BCtyXlbtFSqaeGBd2yYOC5cGVaWs3Nb32HquizbEqzfufmqLi0Z1jfzC2Z2HyWgfFA87CGtPS0He/Z5djDlEa4gHNhWzAyzZPS5jWIwATmB/sldiwHLH37Zp6RtyMc+LbH7CUgqk6VRxurdbXiF3vCG/aRrZTiJglCYQ+gNoawxqXlVvp6FHi88G/vCxdyQcl4NT9DlJ84GyHX+h62zGCYJwlLi0R+DNGxRpoLdSn/LInPy53pdm1HTiLHm+IKzCvH6Fupbxwceq8i/5UENhIYPCBVRRoSa7ZpQBbD0EHTQyRzQX7D6qKJ10BZmqFnIbNS21R3X6ph9hjGaTj8E4A5VnSBbhBLsGH6oCsSh7FiqFU/SOv+qIR5OC0u9uuxPSUOEnYmi5LdevWi3X0ZrESUZyogd2brH4bOv3Op6TU436yWtaV/KqI3VMeXRDkkabR5b36FOUBiCvbb4J40AYNSNdijsy0kSh/6ZiFHJ6u31voc+MyEkVanHxAuwX+SXvWSawHcm9D16y9sHNzdkCrg6wtk7F9WGr2v6LWtEeLhb/rEtORfEvAC5cyabUuGUt7G7jQJ+MCLPaobwk9Bg0Sbd3I+xOPUhyjfNP+ItRgFVe61GqFpEvUR/HeP43SJVkpYU2fozw34Z+5VHoQEC0FRNAl4QftKdVz586I4/6UqZMloQtSiTU6bKdUJLELY/r0RupMPr0w7e+qHcVzATk2wryWbp6VgUOJus5t8uZktgzJbM5fx0p3Ju35V3wREu5WjvCQo11B2i9WEDhZDcoihyJ/mNmbOvJJp7eYr6fUt3wVJSf7/dQN5kKFtol4kCRMr6BPUFcYSxEbgG4wqLq2JHwvtAJPtuRSwBOp
 hgt45GX7
 7CKjUsK/CWMvqupWAjNHs0dPImMoXQmLoMOpDm6csPXjUVWbPbJh6FRxaDdZFoGCGGvtBQTIJ5q+h2NXMitbsZXrbsvtaTlGHbzjq3qENxtJnkNdTQs0HmBG+S86LGRPKBk0atlceSdnaR7PtoiGOlWyAOA4bDaHggOwz071X0Hl3DWlcUZbTtSkZF2nnPEteGhsJay57Nt32kYIPmYYEEJRCkmPi9kzdTV1zdYGT44djJ0QPC+msZt0hlESMusbiUDUaqLZz8vsWkGnYD8PPF9CYA2i+lQG4SY7UJWnHIhzBP5YXxrPuwzwUzTj7rDfz/XoJGBbAu2dCFto2ejnj4Y02shYVQa5KDSgTONLjV1nIEVRKfK9rL8L+e6BHWuJ1UM7zbTV2uj8ptq6JClpji2P9/xwVckjT63MmnaGLf6a92iQfPSLW1BXaif/+IahyHAHETHHyyPPQRbRArB+qkqSR0GQg0a5DRpQW+ezZqlohwH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:38=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.o=
rg> wrote:
>
> On Fri, Mar 27, 2026 at 10:58:46AM +0500, Mikhail Gavrilov wrote:
> > When CONFIG_DMA_API_DEBUG is enabled, the DMA debug infrastructure
> > tracks active mappings per cacheline and warns if two different DMA
> > mappings share the same cacheline ("cacheline tracking EEXIST,
> > overlapping mappings aren't supported").
> >
> > On x86_64, ARCH_KMALLOC_MINALIGN defaults to 8, so small kmalloc
> > allocations (e.g. the 8-byte hub->buffer and hub->status in the USB
> > hub driver) frequently land in the same 64-byte cacheline.  When both
> > are DMA-mapped, this triggers a false positive warning.
>
> Is it feasible to suppress the warning if dma_get_cache_alignment() is
> smaller than L1_CACHE_BYTES?


Hi Harry,

Good question. I considered the dma-debug side, but the issue is
that the cacheline overlap check in add_dma_entry() is intentionally
strict -- it catches real bugs on non-coherent architectures where
two DMA buffers sharing a cacheline can corrupt data.

The check already has suppressions for DMA_ATTR_SKIP_CPU_SYNC,
DMA_ATTR_CPU_CACHE_CLEAN, and CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC +
swiotlb.  Adding another special case (e.g. dev_is_dma_coherent())
would weaken the check for all coherent platforms, potentially
hiding real bugs on devices behind non-coherent IOMMUs.

Alan Stern discussed this in the bugzilla [1] and concluded that
the slab alignment approach "seems reasonable" [2], noting that
"turning on debugging should not affect the way the kernel behaves --
otherwise what you're debugging isn't the same as what normally
happens. But given the way the DMA API debugging is set up, I don't
see any alternative."

The memory overhead is only present when CONFIG_DMA_API_DEBUG is
enabled, which is a debug-only option not used in production.

That said, if you'd prefer a dma-debug side fix, I'm happy to
explore that direction instead.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D215740#c31
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D215740#c44

--=20
Best Regards,
Mike Gavrilov.

