Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4ABC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78C26B00FC; Tue,  4 Aug 2026 12:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FF06B00FF; Tue,  4 Aug 2026 12:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D669F6B0100; Tue,  4 Aug 2026 12:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B16DB6B00FC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:28:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38B65A0241
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:28:11 +0000 (UTC)
X-FDA: 85064119182.27.46E4D11
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5419B1C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:28:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YeyQRzQd;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785860889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROqP8QdlD7ssu2ObwicRyZpkbdMgd9rnKarPu/SKkHc=;
	b=0/uSFOQbBcoohUH5qYfgL5Eghw4o09XoogpoKg+sFNM4U59hzZ4STgbfcKkb1R5twYC87e
	mIS+0C1OxOkc1SeDABIbYMFDStNDbOwmz0HVWtOZAu4BmgT37/PIwSfo5hW/IILHb84Ff5
	tbrzfKIxecCgta3lr9oK+DjjfNrwf1U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YeyQRzQd;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785860889;
	b=keDI7RVsEnOQNMnBrQVDkutiVDMiN7aj8Vla0dJ5ceR5Rlnwux81RxOc71Jukb8LMdrRfd
	O25zwJlH71Su49UOfIWyEKkIIzjfTpsWUO8Jw0vMucP5+WNIedNeKhUFvwnGfeUqtJBBnP
	+3JT7zVlZPhb3nISqyzGZVq52U0msXE=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e67555e24so2046285a.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 09:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785860888; x=1786465688; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ROqP8QdlD7ssu2ObwicRyZpkbdMgd9rnKarPu/SKkHc=;
        b=YeyQRzQdr16HQUHTmtSFZP+SKc2GkYSxvSXAT6KQQk+sBLyPX4PdFwmQR1uMKQgfZk
         1cR2GtODHEhj/NvZyC5U3/CDLpVZF2pOKVB3WfupQGKnr/D1iUIksIubvyyGsmwu1Cb5
         +So8E3poWjj+SJ3PlvWK4/6tASc3ubFZ4fptNEkmShS0zLYnM2boMRE0cklGDLdsTELC
         jfuxHpAkrK32+aB/6O012ZvWBUTWfuBKbp/6Iwak8M7K7O67e/ojusfr7lMwib2mmvUH
         KmmZloc6232Y+aamFA4LP6TXrojFcyBAZ3AvogOKA2bu+pGsKxU+yadDc/AhoEkxRQ6E
         IXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785860888; x=1786465688;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROqP8QdlD7ssu2ObwicRyZpkbdMgd9rnKarPu/SKkHc=;
        b=msbQR35Ln43hlF0wxe0hfB/rPiF3Q/FS/9qgNT0iO9Di2yK0pT0NUP7WoNY9WOUBL9
         VJ2cdz3EVLkIe3O3wvpawMf6QIY7IeE838UnHSp1kLzd07HXmDTYBGTZ8HXrs3of9dZs
         x+jZsPxuQI8l/eC2TPhUL7JK/Koeav6N+lMNZZe6wcbCbpI1HxQ8g10phafoJ6igSnQR
         L81dA+ed+EY7mk4QZ9GMSsZfm+Px8RgVLK8yHMvlKh1GAd5SbSi5X+wRKeC6pOr23Ev4
         CTcpnfYK7ix2E8zM8baivxwmssqbtFltmFmbjxMzg3VLwV4k4gomWFaeviZrpxrkC/zA
         e2Rg==
X-Forwarded-Encrypted: i=1; AHgh+RrTGeNYFtAc6sO7E98hWikb7vvgTn1TOvV0ZJlisubpkOdZclmmOOb+yx3eDCui0TCVBmM5dl+l+Q==@kvack.org
X-Gm-Message-State: AOJu0YyC5IHLVlJ+A6v9I/whjYVnVLNKXOBTcZGIbMnWpcx+oY1ISfzj
	HkkheOsOaOUCIofgCJArj2vA7XjgwkpbKa2w6rFdsei7waLpQ0GExivqdhV3CMbEmAs=
X-Gm-Gg: AR+sD13hfhGMH8K4FfICrC0y4zXfhm06tX5JzBLZLqz8eM02WR0B1If+rDwOIy/ENQF
	lZc95r9vM9lC2EtM6bh2/wauDBtNl6JzhCEbJwMc1fIf3Bg7r0X/UoDW7xKrtDkWYmfwMvnXuh4
	dU2AImTukuxOqFHUTtxnjGpQuwxHD1ohey57Iydoi1VQU8cNauRKmAVX0ERj5PLwM2+L1Rje8WO
	aGM6oaBqsAjESLew5cB5Mu9KrHUG8Skmwm2jqRVeBWkJMYa/MPbi7sM7onQFJ8M5qrji+CuDaA0
	68Tfd1AcEtrmBtmszBFy3BTfFyrIko3caY70UdVrG32LbUKO8H3Bfkvib97JH2dQr99sX4oz58w
	Gim2DvrQWs2R7C88g+qmTTU65k192yd+gFoyyg+sOBocIFNAdFprIRSAEDib+C00X4yrFKSp6Uv
	gc1CQglpUzNvzWshe1q1TRI/P40wJol5xNLfwdSWcRArotSskZ+9nlxiwGXFmd89jwb9AssRjRh
	WOkqna27Z/DUdYI603tThrw7j5YfTW61AyfJSaMeULM
X-Received: by 2002:a05:620a:41d:b0:930:fbdd:c242 with SMTP id af79cd13be357-934a08ff3fbmr1778349085a.29.1785860888300;
        Tue, 04 Aug 2026 09:28:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93641753857sm119739385a.17.2026.08.04.09.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 09:28:07 -0700 (PDT)
Date: Tue, 4 Aug 2026 12:28:06 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <anISVv340bo1l9as@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-9-willy@infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5419B1C000C
X-Stat-Signature: ap8knd46oxdoakj463poygd88g961er5
X-Rspam-User: 
X-HE-Tag: 1785860889-707734
X-HE-Meta: U2FsdGVkX1/0oJzIkeULYpnYS3uyIbRr4vW5/1yRGiN1Pd+peN/D314VSibDbOM1UyMYtDHUOR54q12gSITwVjSGo9OXy4RrRZsaJkzKMuQwdoI/nmAb/sak9S/0jOq9m2P8Kp2rJ3kHBugRIXVkGrPn4WMpyu/fK71bMQlmPQcieGpAKjqQySQ3tkrmGnFmSjMMImKSBKV9hfcAWnrLNOXqiDWJVsLk+D2KWV9PCHpk2VX7u73Xga0d/+Ej+N7oIIATrcrdSjUBG+hxuI5jfkNs+Qg8aCgpNvfHv3Qna+y30+YYRVyok1FOpDqpjrEMdAeaJPntA3hHQjitU/Fyu4k6wnVUtRrO98+o7U5i3o8z01a5qXUQMJXJTPVgZ8eTioCW+AAFkeYzmhdseqT6cUFDD4YypwHlEzapjIC+vCmIUvuDon3Ru8+pFAX71GRb9nnDV3EIZS2L2J3r3gN97W+5z2kbNookYJartH5kI6V0DEwAeJBhk7OdESBKfidAZDdmxfxU9g7EeZJx7Vwuyuzv4QrINaytZC8nmsWG+6R+e0e6qpEPOmpOBZj4JEyOhzvh0tswh3AQcKNw9XtoD7bwWAwgdpG77uOm9eG0woveF62SBnV24wYAtNgeGHfkMWOtU+iV6jIaxN0SdPnqnKz6EhGvgUT0Z949rb6Pl07UpNiE5D+UTnE9VtA3MhNtyuA8ZPqHLe8xxjVCJ54iCzLlpg4ZBHvWr2Zkqo7vkAyAOmrwxdXreZoG98Sc+zkScB2shqQov3EC4XS7r2oxn00lqmY97h10x+Z9bjQFV7hiR11nvzEKG8KfmnPMuEQSvnzGcXaYBvf4bqVF7/YexJDKnHrwR2O0MHYt4jGjHe0PpAIQ23+iXwZNQTUJDEce05bKQfU+tqYpjbwp5jj8kpwEbJ4lr1mGf7rcXdPyNI6V6sIq+FKlZOjjjbZnn+zvoA5lr2K0XLjxrqBywjO
 oXpVXOuK
 9nnFJLUcem2c0E53Fh+p8Wdplei/C/nYif+BnnhaIk9bnq1lOo4ic76oGSbSxODAUaWcNQeYn1Mf8p9Amb6l5druaKJN+MfO5mRBK2QN93VBPeRrZOfV8EknWsdQvO27oJ/ASaU0PiD1OmAOvtQ6zuTQ/CXxBZDKqGsD13j3zsSQeWCAcyNJZ6kynJm5Gf9qbsKN1405TO70/AAfhF7IFr/9O33/2iPbKfZx/OXkxkOUp6EyLgTMnWrSOSNGFQxbshCVvp4PyD/7qxz3iktNC4MFPiyqonJ1LuuDFeMjCf2YDXhKOTfNKL5BFmDH0NqTgRJ3VRZu9BPGGaUFIEw6+m6ivIb/LTwP7c0kqJIWrYV7tcMASOd+wWr8jZeHVgrT2PzE07oFcmXZuuTAON9JRpGVk/KeF/LNFIDYGjkHoPmXogii0SSrDJmuxH5Jk2bfMARKszqzN595feJPgX5HQPnifyCvpv/VHtuC5SbYWxHBXM9o81SNqB2e9h/CfYLYSv8Fzr0LjKuLHJPJtTD2CcU/Zz79hcxQRwejoeVtfO1JBbU/3Sd+w9DYQLPPIrsvKxz6H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:07:53PM +0100, Matthew Wilcox (Oracle) wrote:
> Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
> This will help us use the per-page hwpoison flag in the future.
> 
> Also introduce a folio_test_huge_poison().  This has exactly the same
> meaning as folio_test_has_hwpoisoned() but can be used when we don't have
> a reference to the folio containing the page.  folio_test_has_hwpoisoned()
> can race with folio splitting / reallocation and trip the assertions
> in const_folio_flags().
> 
> This closes a gap where a page in a previously-poisoned hugetlb folio
> could be observed to not have the hwpoison bit set.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

one question inline, but this seems straightforward.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 4185a03a45cf..4fab3fbfd430 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -893,14 +893,19 @@ static inline int PageTransCompound(const struct page *page)
>  TESTPAGEFLAG_FALSE(TransCompound, transcompound)
>  #endif
>  
> -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> +#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_LARGE_FOLIO)
>  /*
> - * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> - * compound page.
> + * folio_has_hwpoisoned indicates that at least one page is hwpoisoned in the
> + * folio.  That page will usually also have the HWPoison flag set, but this
> + * is not possible for folios which have HVO (see memory-failure for the
> + * scheme used in that case).  You probably don't want to call this directly;
> + * use folio_has_hwpoisoned_page() instead.
>   *
>   * This flag is set by hwpoison handler.  Cleared by THP split or free page.
>   */

Had to google HVO, and didn't see HVO directly mentioned in
memory-failure.  Maybe worth expanding HVO to its actual definition and
a sentence on the quirk.

Does "Hugepage Vmapmem Optimization" just report poison for the head and
we lose the sub-page poison information in general?

~Gregory

