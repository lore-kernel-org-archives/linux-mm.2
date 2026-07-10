Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E93C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0EC6B00AD; Fri, 10 Jul 2026 17:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8518A6B00AE; Fri, 10 Jul 2026 17:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741356B00AF; Fri, 10 Jul 2026 17:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2FE6B00AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:21:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE5DC1205AB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:21:05 +0000 (UTC)
X-FDA: 84974137290.18.4FED9F9
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA70A14000F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:21:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="aVdA/zLa";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718464;
	b=au3NnHsDvZft4S5vL35nLJn6linhQRkvhECYrKfYuMaoWGOJyXx4i3H3o0eTrh6VGXi3Zv
	LT6Z5YgCg8ns3GX92ApiouUxM4yZYPIL2aVyPe0YiWqtYKGsYr9cxp5SWRIDe6VD4tP1J7
	t/d5hWJ0cGK4LhNLDBcGdQZQ+oEXb3U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="aVdA/zLa";
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBOMvPUpfjw5N1/s9nVKhxGNiyKZIoN9dPtD8sVM7ho=;
	b=1pCZ0c7M8HxHlNstRyQKWrrogKOxKZeyEhKhHXOq3Jhbfb72qnInePv6FpjrnB/F7fKbK9
	FpF3Raz6dSsQDQukr3qP+gDwAdQHBbqDuht+qNBvwzOlT0zZ//bWTR0rf7bf1n4qCn73yp
	bPEA+i2dX55WhMh+CO+8BLUrMaE1THs=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51bfb91795eso9176281cf.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718463; x=1784323263; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kBOMvPUpfjw5N1/s9nVKhxGNiyKZIoN9dPtD8sVM7ho=;
        b=aVdA/zLae/hJvMnxolc/9FivpLan8lVMC7NBFB6dmV79UMh/NpzgzCn1Z+GGLYRoCC
         +1DvwIn5SlAKyWUrPFlyUlAo3ilV2KLFcMkIZuD6JefsoLnEFylIMxouE7qwZaYesUy6
         KGBVrpVlcwPaRL5tmBerNQomKoyx1kUKk3WjNW5QBasy6VnFCy7I/XchQgKXkOvWFbIr
         J9m+uYUhhUhKXdGEH0mYfBE+5VAKZplQwqjP0vCqqUx6HqeAVnda9Lo5nN3u5SBjexWv
         nVrbr0vDQ+ugJ7DTOs82MGi0AapDmR6eNNrHDu0Nv1xt/w0k3K3gTVJxqUjTgL1ClKpa
         /kFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718463; x=1784323263;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kBOMvPUpfjw5N1/s9nVKhxGNiyKZIoN9dPtD8sVM7ho=;
        b=oKYnfoOu/UTFinZhf1OIpPQJB6rYrxAdTIO0BMypw9xpXiKt3XtppdL8j2pOEhe+kU
         qhCq7tXYoRwoJ5JprLOES4ibovegB3ZtcCXQpVgAQ0xEbL4bqtq6N8JcP/TcJ9aX6rWB
         AzINrfH0OTBxqEfLtkwoED/CxoT4GC/tm5a136OTKdjd4D2o9J6xmo1Lrorrp9bWGpzF
         Sjh6a4W3DcDh4H9Ul3lu3GfPFshhx5UMlWOZcVMwgUqylej43zxZrgYY1DIt1bhs0lDk
         hGq/8AEcozYS5qS3nPd9VhBH9YSFMP2BTxZaV6kBdeEuly8JH5se0NawOtWeNgjy683J
         aPOA==
X-Forwarded-Encrypted: i=1; AHgh+RplPTIYAqOKJ3aVmbh8vEW1To4jwIbMkIKA+GciuomO8fyrP4qwMpy+9JyNnyiwDv/7UNvvjQlhmQ==@kvack.org
X-Gm-Message-State: AOJu0Yzdi0hBUF4lfxbEi4F79NAijt1etSKppOooK9spLZow8EjnP/Xf
	XNDs/f4tfbJAK1ZDzUEM1ZdilK3zFosbc90ZCjABqyewVHnDEL2wrbjkWFea5QZM8bs=
X-Gm-Gg: AfdE7cmg3Cx1VSG4kF5UJQUau7IpkoY3gW50K4Ife01//HMFq8IYmqqjihsZpUw0sCH
	Hw2DBMjY7BieEl2Jr5Qh1G2+tXuPPoIk7iCv/xbTcwvHOZf6yIR+cAsoNyW4z0CewND+vTbBAdi
	rkZk/mcJxeP7Io5PGo+PjjTXJbfBd99kAt1y11ftb7yaF7VWy78/xPQefm8dqqISJhJOLWPooRI
	WW2AHFxgVxiisVoduDv3g5nMUHNKCzvwQxTzD0wBVgG2YjU/eo+M8XyvDMqHcLbBjisPGDehwix
	a8CKWR9IqIl5tu9Rsl2gJantadiK1BtgqpRKE4nitfEOzpyMLc4EMl08NnV3XNpyYprvtyooZjk
	yQW9beA8aczNwl01sj2cDv7PYnup+P7Mnic0hixh470PJjhIipmteAHCB2UKt24NQXnhpLH2I9G
	kwinU9fPinsi0pRg+LwEP02aGs9cm0NQ/j9XOAgY0yv0zNyFAVgXvMrp2OF+2xHiM80ssM
X-Received: by 2002:ac8:5ace:0:b0:51c:7b11:41ae with SMTP id d75a77b69052e-51cbf2dffb2mr6287721cf.74.1783718463047;
        Fri, 10 Jul 2026 14:21:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caaf621e6sm23894971cf.24.2026.07.10.14.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:21:01 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:20:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 26/33] mm/vma: update vma_shrink() to not pass start,
 pgoff parameters
Message-ID: <alFiODVaGwd_wYl4@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-26-2a5aa403d977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-26-2a5aa403d977@kernel.org>
X-Rspamd-Queue-Id: EA70A14000F
X-Rspam-User: 
X-Stat-Signature: nqqofbni6wokukcbpow7xbfq87omuo6h
X-Rspamd-Server: rspam03
X-HE-Tag: 1783718463-734992
X-HE-Meta: U2FsdGVkX1/rVE4YSRyZfg7zFax1pnjDI/T+CFvdCZku1K1vRvb7lqwiOfxFkW1Vy72h4Jh5bMmBsMK8QB15l1gFqgIFf7AzjE+wJcB/igwc4irnEAUv9QwXIK3YmWvtjDRRPJwivDtA+g904AYaekV0te/BvPJpLZgQp3v227HIvmkZkB+neBiPiT5T0i2N3ubpwiCPilnT6v6vPT4FK4+G8FQVjqaL11V4zLaZfwXFdyZrnhSZ5yLEeueqA6AbS7N5RFtMRd7VJ81JYObZKSTko2ok95Nzg+oO4T053nmoC2ndyyhLqPwRlVOHqUXNdw3Vcy90D20Bxg83TZ2r/bhl5qJvvEL53lLBKc17CQkVjZa9V6Q3McQJvGYDHbv1DG2nC3wLoSV/m7rHO50PTS+1qZq6kee09T8OKdhfsTxd4E68k20Sdx657SifrxXgXOg27ixo6iLMqE2JRolZbnJJo5x5gr8Dz8gD6GmCLdC+y0NSrAvLvK9bHIdtKrtd7anc9Z1yFQs6qSKsd9g+DX8alVy+dOJY9+BsUWPiQ8hjHzSNz0tQQJadUgG74FoBJou0RgqoBizKGozRND1hMOJ0SVVRzpEqWDvPgxdDjGPTl9y6FxsrqHbUtn+d/GVW7IdrPjPS9t/Cdj32I+C9zlKa+QbKOKD7wsm+leKsXsEkQz2/TCiDZB9rltQyPDGO3fCbQRJitER97FNByQF5xPxttHt3UncrfTDP+84hW789p8VrOYMmqKDekulySZmkkpPDfHFXCb7r8eQ+9/P3e38JcyhHKItU0IrIGFZk7Cn4cif5Dy7GrG+2VD4Yf++2SKB7iqq4F0b0N3g6aOh7VdTDOD5QTOVDEsGLbLUYtZR4GlJzt/sO06MerF/CAf3inarDtRj9riCs2V78diCthOL+4PD/evDAIqP+4d88EcEYlcCIGlg1AdIkv8S7X+FVxDqgRYjLqRoRMHHkvs6
 ToTzUP5y
 OCknHZPCy/k61vpFaJ9FTh7+WL5H5fSthE19/GI1MCiAyPYzVN/YIAMaL0kmUkwC0/x8yJomiwfeyh3lzY9zLUrNIApn+tp8aAzIMbYVDEyy+6Xe2ONIqPWPOQFjDOtJWUCuH33TgryZBBzOd37RV4ibUc+aTX52Jo/wbAFXsE9LkhELqVf4nT47/whS2MQVtJYBLSiwxoPwnVvYOHQ7tWeGnWt0jOHrCHwFbQ2TdK2IDVwvb+/DbSxHxyQehdSfOXe8FtaCawOGRdVTZrG/kYArIFvfVH9pN9PSaPlI4UEXxcu0D9NEGHEbqvK3J5sTpd4/WLMYe9qsRsJmVrrzcrikauauDbDWf+FwJH52gVqYJF8eLjNw3bKNMNOBGHbGsIwpIoU+ULwcDAGhcOkfB72I8LcdW67MT1qMpDnojwzuC4NCvWnKsZ4oyJFsfYq20BFYMpVYNxFQ2dsHM2idfKXdpAgMjaNiE81wQ7xwldlPqi38Zpb1rOAerKrJ33IlIMm6KJYAHPeBUgeKfIQ6SlGU0zap+AzxGuw0xa0fr0MotmnV5SDjxQPsxRGE5xC7e5lbi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:17:07PM +0100, Lorenzo Stoakes wrote:
> vma_shrink() is only used by relocate_vma_down() to shrink the tail of a
> VMA. Therefore neither the start nor the pgoff parameters make any sense.
> 
> It seemed we were passing the pgoff parameter solely to satisfy
> vma_set_range()'s requirement for pgoff being specified.
> 
> Since vma_set_range() is now isolated to vma.c, we can simply introduce
> __vma_set_range() which sets only vma->vm_[start, end], and invoke this
> instead, removing start and pgoff from vma_shrink() altogether.
> 
> No functional change intended.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Carry over from v1

Reviewed-by: Gregory Price <gourry@gourry.net>


