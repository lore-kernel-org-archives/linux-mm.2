Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38D0DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8106B00D3; Fri,  3 Jul 2026 10:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E689C6B00D7; Fri,  3 Jul 2026 10:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1456B00D9; Fri,  3 Jul 2026 10:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9B96B00D3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:19:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F2C28B4EF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:19:35 +0000 (UTC)
X-FDA: 84947673510.16.C7C1A03
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB228A000E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:19:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d4kdvoOg;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783088373;
	b=u1l9Yayx4eLkc6jyDomTjW4tf4Yetqv2XONMWlQrwWQn5qh2aitkLX6igHLt8QFp4DVHt5
	UoVBi7wcqYJxcB4aeA6+G3lDq07aOh5asvw/PqcGoTaGSgo8/dn3OleVbnG72hO/Y71hIo
	WGUMKhA/YXlxy8aP6LN+/rIA/+KrSDk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783088373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AtJfCkfnFMyzgye8dfK/HYrK6u/oQ9FNgRgisJiufQ=;
	b=juYKcnL82rcscGYvx0wZp71qXVKe+dNJBboanOWFltmJOt+LZXhy3VAPCImjxzT80qlAa5
	QbBMXA0etOIsr7ICoJWWLfB0584d/pSGfoog+gLyGGSBRyvIIcowwOZvruIV1tt4STKR3n
	QjeJ4vC/XO7u6YHBAPYR3QCHrU3c14s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d4kdvoOg;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4629324e267so78248f8f.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783088371; x=1783693171; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7AtJfCkfnFMyzgye8dfK/HYrK6u/oQ9FNgRgisJiufQ=;
        b=d4kdvoOg/X/a5JHlN+YSlckqhjxoSxsQ/91Krdw4GoIWj+ZAhO0SUx5B84VrKX4FMd
         8HV0p6Ei3a4AqpNWPEWZ6uG+xp1d242yLhA7pQTRF8I4XWr1XspX4LXIE4OVP5G4POMj
         lyVZYGlH/Kw2itfQMybKZvl3bpSvs0smbKPr4USfJ3MnhetysndoTUGytjq131q7HxBb
         5Os01Yt0auM7+GEE+VC1Wc9H10FQ+heP/VCaodRtt/Wvsycxng93ixZ1sTg+UE/TqULp
         +3eoMeC6xJU6K2QhfkXhb7boFXWBCqPMElXVlFhkt0Ws6+rockTya854ag1zl3lUG47g
         Qf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783088371; x=1783693171;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7AtJfCkfnFMyzgye8dfK/HYrK6u/oQ9FNgRgisJiufQ=;
        b=Gt6uQvWsRGUVVq9PS9Fk8npnFHn2kuGvePcgAkl5vqHyS6J8cE97yYk9DBVYBkMz2n
         EqxXMMnXmPTvuh2Oy/ObuI0z4FROc8aRICQ9QElzKUaKdYkgtRNUePTl4FQhbFagNE7J
         TsEsDDfHjG7FS79/W2O0faRmV734HWxmAChr5w59lyHQV/UeUxSFY/iYK7TyfJXDFihL
         qRpl8eYvUJQoOeJN2a+XahizUzEYlPlnNcJkfoGIXDvrm2yTTrGRBexnujeiHs1nLLfI
         cEvl6W/ximyJVBDycjSrGIVFVyABfcX23SIrONkfebI+GuykFKvfa843klYwFxqg6i0Q
         9ZYw==
X-Forwarded-Encrypted: i=1; AFNElJ/UlGlPoyrlyOth/LMFevwE7vzwGdkORl+FGIHcTHxs44tCp1NO6qrNhHWYANCkPtpHN4sIOS7oaQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+KsMV1rue9y5sVI+7xnSlJgMP8oil2t6otfYU3GQMSYfLDdKv
	Zo9mfWikQ43Wu3fyIVa6G1udGgtsehZJS0id3eLp/+j9lA4ARWOQMp6lgI0qkIHGqxA=
X-Gm-Gg: AfdE7ckpevPZuqoRfLBxSwXUozW+5IlNsGI4izErZV0Lh9Qbb4OCdVL7RXW7ngw9k5m
	kG6iJqNHK9trbIw0ewFoSkOz6Cj/O51p4Hbuo70iZWHC7QU/LZvislL41pqlhd0oCVehQkaABbv
	vBOdLAJwXy77G8yc00ajJ/Kg6LtdVx+PkXu6uLNQ3wq0QRgnyhT1b4DcouloEFJxk9wd2JDtk23
	zqs/GKV1kEpH1leSIqWhqnEuGzecrgvYOiqOuqgdX61QpWTPWhB9y5KBMZNdUC4NlSct7R8LUrZ
	77YnABvo+2vG8yHKeDtA8A8IVwuUSRrKywxWO4zc7qXoIDzbGLvCwRWW9Wy7yc71U6KmkDEpUSO
	GQthNPdayXzCy++XjmJDBmyXpVUGGFnlm8o0E0t73ElXud9JQoqPv1weDoqSU8KeHmCOqJK1C59
	iZzGZsec8=
X-Received: by 2002:a05:600c:3596:b0:493:bda2:8d92 with SMTP id 5b1f17b1804b1-493d0f3dfa7mr471185e9.5.1783088371071;
        Fri, 03 Jul 2026 07:19:31 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef23feasm171149305e9.2.2026.07.03.07.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 07:19:30 -0700 (PDT)
Message-ID: <458898c9-cfe6-4be5-ba83-f7961ed84329@suse.com>
Date: Fri, 3 Jul 2026 16:19:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>,
 Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d7aj8n6jcnkbie7wsbkez9ubko9jit83
X-Rspam-User: 
X-Rspamd-Queue-Id: DB228A000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1783088372-834926
X-HE-Meta: U2FsdGVkX1/LnQY/q+J4bG0SCmWRnBKEkaAh9n8fbah8pIhvWRCmCLW+n9b+S/ayGBifz5NuN/Dj8OUeFrobwz3XzFU6a8UtlacOgsuC56i0hpWZ+Orbg6ohI8IEli78N/f2aNZAGn+ERzr52FGTARrTeMehDP06lpgq+3Qr2M1wvBvz9b/7QG4MGWMYAf72LsUx8D1k00yEOftkcGZNW8125j01Dm806lKr20YoyS4eUUCDYTwsF7il1s16vq8JLbeo2GxfnQhuRqanLNonSdlBFms6ViFz1RTw84a6XTquYzL2w/vF0xDnlkGk1YB8Zu5OL2VPeT8b9YkIOWdkOqu6eDLU64tjQniHXmEUWmLlgYkxGvTMIhWIuQE6fGXZhHVNXWSx5VeR+OSWGwxmYNhBU0FV9iLosHMwxL33MH2Iwiw5g5VnDv67Zc7JTP9/Y7fI2PLkJor2Qf7VtNzHxT4vjXRFj6p7caz9KLgIu63GV0WbbEiNhaR2aj0SpsmEq9Ymcja/P2qx/YfmAoRTxhPg/tevRiB3i+O6pVe8yS6y3PX9s+Yu5XROleeCpLbKeVwZLbFwKtC5u4ibJ7SalC9Ul70s32wOaYKhhc5Szjrjo60nJXfzyBVJIco37nZ/PJgpxOyK4AoZkFC3N8zacs29fJZk5OKmOT/Uaj9q9PM9JIcgCGMxEPq7Z5z+YvJFjN6SNgR9KGtcnG0m4M4KDl+OGOGD/YZdObUCh3mD0bUQZpXhIbR2oxKohc1SEjTed9xV9KIi8f72vKjleVpYlTTBUmTsvg2Bd8+NGgCSbNEB8+M/FM6qxhI0WgZjohAcpqW9HeQAAfRVbMl6R5bTcb2nSXSvQ8O1IXO0T0l1Jo17IagEDy49ccbF7tV4Bh5tKv+wtzE+ZbelRaBy+wL49GvlULK/MB5ZiUepC6vqc2mM5hmYjk7YxLLM1lFP16m9bm/xFPlu8oYMNXbBh2G
 /o8GKqvx
 /uEijuvkyZmskqyBxL4a3SGPLLTf3cheepfgQeSJwnqy/L6pdYEN1MKE6gntEFaCASJUmJw4E5Pu9SfRGZS+4p9wvqdQ944UaW4uo7N5/DvSwWPczKS6k9CZmuTUJMVP1hMOLHv1GFOaEaOJxodsKJBphjFkyDzAsEq9yh/4kEVeZEMIVPPWJ85NeKrNlM3mbJXpcHlGS0dQlXnoEz8LqnSQr+ngn4wOEJ94QjCdbyu+yurn5igPe2aygy9lJOgAr9rc5upvifnGZuoav+Cpg9PSx00Hq+xb8fGspRrr8RUjsEC8gF7zwojBaPzngXuscQajOtYT21j+WXb6m5g2xdi5AEDZ4Qdoofo77LyWZMyWd9QGLGlT0AlPb3ri9EHZInmdR2h7duZrCi+RdXnV8mqXA3n6/dhy5Gg98ibjKAEyWn4GCWWnlqHFJmEWrH0IT7x/XoIRKnUG5a129kW+QGpELCqI2KPLeIZfbyw8mu5CWWxpvBfHBQoWb0YrK9lfl7V3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mm.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 059144435729..2f00c75e66bd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/**
> + * vma_start_pgoff() - Get the page offset of the start of @vma
> + * @vma: The VMA whose page offset is required.
> + *
> + * If the VMA is file-backed, this is the page offset into the file.
> + *
> + * If the VMA is anonymous, this is the virtual page offset of the start of the
> + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> + * file offset.
> + *
> + * Returns: The page offset of the start of @vma.
> + */
>  static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_pgoff;
>  }
>  
> +/**
> + * vma_last_pgoff() - Get the page offset of the last page in @vma
> + * @vma: The VMA whose last page offset is required.
> + *
> + * This returns the last page offset contained within @vma.
> + *
> + * See the description of vma_start_pgoff() for a description of VMA page
> + * offsets.
> + *
> + * Returns: The last page offset of @vma.
> + */
>  static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma_start_pgoff(vma) + vma_pages(vma) - 1;


