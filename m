Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29217CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC00A90010A; Thu, 14 Aug 2025 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9779900088; Thu, 14 Aug 2025 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD49090010A; Thu, 14 Aug 2025 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F798900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:58:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 519F11DD559
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:58:38 +0000 (UTC)
X-FDA: 83774611116.12.51FE27D
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id AD0751C0005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:58:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jkIHCfIX;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755158316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4s2oDqQ9Axxr0LU8mruMwn41CcHNr/5Tx31AQ1BHTKY=;
	b=3zBZfhuTslZN16tJ/Y3zszZls6uKoIz0XYRsR5IfLQuJHQk2jZFr4HnRhMODdBJhFftGVy
	NWnkshw2ITVAwKIARbZj1vgN0hmA9JdbWaZwY0hcPI5R7JLBWVmh0oKYofygE8DgDk04s9
	CxtN2zLCgVC7bP0MvAh9S4j955vFFPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755158316; a=rsa-sha256;
	cv=none;
	b=ZkTE4kZdywU+sKql7HI/2qhNCXhGv2qHUDk+rN3lCnY1USC3Uzih1iYw/TA671enPndK1i
	ZMGnhMt4d9XV95vjuNpCWEECz0ln8CBu0XOr7tq+x+lAy15XyZTrPgcrW0Cs4m6w5qITyO
	oh89M/o1dHhEublMfWlkqiMD83XUqgY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jkIHCfIX;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-76e2e6038cfso1131636b3a.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755158314; x=1755763114; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4s2oDqQ9Axxr0LU8mruMwn41CcHNr/5Tx31AQ1BHTKY=;
        b=jkIHCfIXmadf9xJqmiZnSDtgT/ithORfLVG4jNqMnhXVuV6JIpU4EjlzMRfcrtd6jG
         lRyNjre4A2eyEXJUEkoXEqYrXFYTemOqRaPveTLSTm9ewn8fCHiFO73O9hVA/+ivD0fz
         sqx6xup3Z2jAqQBxe2XMslbbMRWTVJMl6L2oYDFs6CvLEszEGvNf1mdqo0wjcUMff79k
         zRsupDddJxlQp29HkuCrgCBqcEL0QuQrNLBiufBkWoOUiXMH4q7KlBVl9YR1BzOf1X+J
         PnIxYIX+nrbjZU48qvZeZPnDb+Vz3PpzGjULle05GOh9cSzs8NsNe7qHGMMOIXaYYTAf
         kgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755158314; x=1755763114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4s2oDqQ9Axxr0LU8mruMwn41CcHNr/5Tx31AQ1BHTKY=;
        b=iEpS7p284u0L+4mzisHXj/4hyxcH9+D+LH8fJ+Y5cGfVqNGMkd4lHEna3EGmgBkM0l
         jP8S9VNSQjmuYf7R0erDn7Gr32B2GoAHUoQM8P97j2+xWkrkcwpUmg5KCNRUVu0wyAjj
         vYT0lD4ub32bqsppF55YltgZkS1fbYOI4T3A8oUnUbWPi1vPrWwdSqh6Wq7KV/Asm398
         ZBVVeftCdoK/0panrZPi86WgBbA4AqtsGlFzXkNczsYpF/yCFGf2MfF/yJ5r54k6aeLs
         BQ6L4Gm6A0JFsXbYE8XmjdQSKPPsGMI3L/u42aHnzKW4x+iBu9i18beY8kAAKHe0hSVB
         CC2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMIx1iPyrDw2n2etYnFbxDo5WV+mOd+pUnBz766Vb3eJyXmLp3ZalVaJJr0h+VNKAl7wOfRgSQxQ==@kvack.org
X-Gm-Message-State: AOJu0YyqtwgY6ApoNh6ot5sIhcECVnHxIgN+FM1Pd63cdhuJLWJLoARe
	hf2MDUk9hdpf32atAjEZlVuDfOpqkrUEvZiw3ngsQUqEO36DnCLOz13W+lGQdqW2hmg=
X-Gm-Gg: ASbGnctnLdnSUdBKeI10K7ms/f94ajKaFqYmt5FdT0Fd2K7tSUipNf2X5W8W1vR9tOR
	/Ail/cJice1YBT0xycCp9ej9QoMYzoybiEH8PwnwA8Yf4S9H/gQ7Pc/AxiGSdAOOOmdIaikvfJa
	gQnTCjfxIz+5BaEOPdVdzlFyCwz1dSVBTm31P2Dj/vS4KMV8ZTBipc3StxCK7uRbEyMZ70yNRi6
	s38uF8oj8oPk2WV9XhUsuHW7Y02Wt3A/NvRktUyB/MNIAWhxgvt5dH7cv/NEO9F5DCEuMaCPLz/
	zBiL2L7xRaNRqbGqNNvlXA7KhJMmzssXUMENgh5UdkFakylPaoc/mBPLW34LtshauvWfoyqKK6O
	ja68gp846SiUaLPPpJVuFqrJ+ryksAG+iBbaYnyKbfcPLnG/B
X-Google-Smtp-Source: AGHT+IGQFCOid1xU/kTL2mXM8U4CeNYlG9RrTgm/Ucs/YfzENunJyjCSeSACd8ELwR+xBvztlldT5w==
X-Received: by 2002:a05:6a21:998c:b0:240:211e:8e0 with SMTP id adf61e73a8af0-240bd286e8bmr3253974637.35.1755158314373;
        Thu, 14 Aug 2025 00:58:34 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4263836324sm21721780a12.10.2025.08.14.00.58.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 14 Aug 2025 00:58:34 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	lizhe.67@bytedance.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Thu, 14 Aug 2025 15:58:27 +0800
Message-ID: <20250814075827.62858-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
References: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD0751C0005
X-Stat-Signature: uw855e9xyofy1s6njew86hprpr4gybjn
X-HE-Tag: 1755158315-940851
X-HE-Meta: U2FsdGVkX199VnJrzj56Gck+1GcGWxIC7FG3DfncGJaYl11ME+WV7UBd089GQfpspc+lZZXNWC3zbruyPokBuXHFEpHibwacII+sDoGGL8zfk9PxM/8xUaOWVQt3WwBaEu/ltJjqEUMk4XRkJnbwA1UfbQEy2vNdf0fFCh5YW5Y2AbDX+4uKEEQ2dNISEiWt+Fcp09BAY85tlH51YUPOFwnBkrN72I3LqJ6z7fHjiUtbV6j+hFZb3GGrDUcWpLZlraOH5ffML6SmaXym3ox2z1cDLylzYYg5OlVOff/dl9RaQNV1JlyR0+bAb4v94srNz+XTU+2Yjo4+HTzkLRDb5xOcTsNBVOM5rNa0i/HDgxIXERSl244eCHYoisbYqBi2nmTsaujlKdIXP1EuIlJpL6sDNH9aaVZYxtq3y5dRqslI3XxBWfGfzXo3o32pd7lh5dxIe+wiqXKmk+vNyB9xgSTGrUcxSwjXhPsfl9gA2J+76HcHQLfycboGRqJBld9riH+X4YRWznwFFNFthkPZbLJa7fyuGb9f/Fi1hxQX7BKEt9Ku2G9200lHg1DcK428/aznXOyVIh9nu0ZVYik88VUoD9TxoOMkLCPf7YrRRIEt5/v1usy29JgO5LEPPI7ijWos+fV4BLxJnYYV6ECRkPOdxjHJCC9RDe6N5bB4d5ohSK5wI2un0UIFNmXskVAkPT8dlk5XY2lHb2HECHPBw8YXybDSV/v6JE61jTDp9PE9A4RRSrIS/dtYtmFnEjlTelUOXtv8L8IG+iqkb5SEHwOG8M5axH50z+RZHnUMfdcv4pdnRYSfOgvY3pAfKVFmgl3BPWKqNpf735V7MtD1HeiNq28H/0ZjQ/G5C4HnkYDRcGQ0BasxBLRpFN5O3tDsaGdsg+63BqyyMJsMEfjyvbYQpt8P92M4BC9Hbob2u0Kt39PBXFYtytncp8cIRiTtzA5IUg8nIczTREL1K7M
 YP1ZuFSr
 1JAbpz3dffRXCskPIDGfToe952CL5Bg3/9vx2UJtOf8ZHK4aP1eF6YdSlojEYTw1dDLXNzppecVBU89bAzUmFcmNZzybriB6VBOebgsbFLk5FLWzCRETfpNLblRfkyRCpUK2jgTyGOIjVC/3YwPTtJhrn+jl8Z0OiThyQQDenpQO/8pbxMhXywb8hqg0DnMPN6mycbNfLmFQ8B+aCAaP45tXu4WG6qcwCOWE/9Kj8qvXNUtglnJNEK7PFoupie4Yg7W61LQID7fWAfFOcPRN+qYDtzzxUjB2jyQENMboqpAovED/qVCleNLiuegJGs3L+2Yli41bVaRdh+L66AdzbWM1JZufurwye3X2REPSYYiqUEpBmOJvXg4atktlk06kVZ8BN3tDKAteD6G8rD0ydQfrI4JZHu5pvQ8exk7CwjeAroyU8GYDGJZ3u+Ff8JBDTsCnBFh3VE+qcoyQ8SpFhpyx3L5OyNmNIXogsQL24LBbCvl4pIMOT4IvLOY+uazyJVq7dsN777MlJgsAha1itDmJrQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 08:54:44 +0200, david@redhat.com wrote:

> On 14.08.25 08:47, lizhe.67@bytedance.com wrote:
> > From: Li Zhe <lizhe.67@bytedance.com>
> > 
> > Let's add a simple helper for determining the number of contiguous pages
> > that represent contiguous PFNs.
> > 
> > In an ideal world, this helper would be simpler or not even required.
> > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > without VMEMMAP), the memmap is allocated per memory section, and we might
> > run into weird corner cases of false positives when blindly testing for
> > contiguous pages only.
> > 
> > One example of such false positives would be a memory section-sized hole
> > that does not have a memmap. The surrounding memory sections might get
> > "struct pages" that are contiguous, but the PFNs are actually not.
> > 
> > This helper will, for example, be useful for determining contiguous PFNs
> > in a GUP result, to batch further operations across returned "struct
> > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > process.
> > 
> > Implementation based on Linus' suggestions to avoid new usage of
> > nth_page() where avoidable.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   include/linux/mm.h        |  7 ++++++-
> >   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> >   2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..ead6724972cf 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
> >   {
> >   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> >   }
> > -#endif
> > +#else /* !SECTION_IN_PAGE_FLAGS */
> > +static inline unsigned long page_to_section(const struct page *page)
> > +{
> > +	return 0;
> > +}
> > +#endif /* SECTION_IN_PAGE_FLAGS */
> >   
> >   /**
> >    * folio_pfn - Return the Page Frame Number of a folio.
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 89b518ff097e..5ea23891fe4c 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
> >   	return true;
> >   }
> >   
> > +/**
> > + * num_pages_contiguous() - determine the number of contiguous pages
> > + *			    that represent contiguous PFNs
> > + * @pages: an array of page pointers
> > + * @nr_pages: length of the array, at least 1
> > + *
> > + * Determine the number of contiguous pages that represent contiguous PFNs
> > + * in @pages, starting from the first page.
> > + *
> > + * In kernel configs where contiguous pages might not imply contiguous PFNs
> > + * over memory section boundaries, this function will stop at the memory
>  > + * section boundary.
> 
> Jason suggested here instead:
> 
> "
> In some kernel configs contiguous PFNs will not have contiguous struct
> pages. In these configurations num_pages_contiguous() will return a
> smaller than ideal number. The caller should continue to check for pfn
> contiguity after each call to num_pages_contiguous().
> "

Thank you for the reminder! The comment here should be revised as
follows:

/**
 * num_pages_contiguous() - determine the number of contiguous pages
 *			    that represent contiguous PFNs
 * @pages: an array of page pointers
 * @nr_pages: length of the array, at least 1
 *
 * Determine the number of contiguous pages that represent contiguous PFNs
 * in @pages, starting from the first page.
 *
 * In some kernel configs contiguous PFNs will not have contiguous struct
 * pages. In these configurations num_pages_contiguous() will return a num
 * smaller than ideal number. The caller should continue to check for pfn
 * contiguity after each call to num_pages_contiguous().
 *
 * Returns the number of contiguous pages.
 */

Thanks,
Zhe

