Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE85CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320EB6B008A; Fri, 19 Jun 2026 08:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6A26B008C; Fri, 19 Jun 2026 08:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2331D6B0092; Fri, 19 Jun 2026 08:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAB3A6B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:32:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54A761403F1
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:32:14 +0000 (UTC)
X-FDA: 84896599788.29.E12F685
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 630E210000D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:32:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NqffVHgo;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781872332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAgRJPG/x/HKYBdMFy6t9gS0SW7lI2ALodBm8Z0F2FM=;
	b=0U10DC25Bvc5dNK8mSs+IJ7FXUUU4ka7nZPR3vAk2Xnm9tMw0uYYVVXBj2+LCNUNunxU8D
	Ttdr6hga/pC1A47zNN/KQEdSode3Qa94x2kYzJ6UeuzPcXbMI28YoqlX1TYqONZZyqFyfg
	mbjk2ZOUWOCVKyCp++yzSabInIpBz1k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NqffVHgo;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781872332;
	b=6BMOYFReHjWHWTM+XjuB7gtOfDImt37CLrDqf7EtvfcPxWvNnklaQfeHTUPq6Lfx/8WS8s
	BIjrxrX1zXv8Dhrsc8eVvLHUW2jUX0yVs9DFU1U661eKIKaohg+DJ9oRmdnrz+yR3OE5Iw
	XlS0L6Zaggq/FzNOrIk3obCTZwhWwFc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c6a4eccab1so37915ad.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781872331; x=1782477131; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zAgRJPG/x/HKYBdMFy6t9gS0SW7lI2ALodBm8Z0F2FM=;
        b=NqffVHgoH3fjk7HXAFiJAnQ5ijFRXlKAtkWxkwyXj7rAEHqdf4VDGxKrXT4JREKvUn
         ZnImzGcwwUe8DQt3chBnz1LDqU6ppHx7QFjHczLFAATKtcgr7Z+JaB33buz/vlurBoeN
         4siZS4x3jEj9xEOz5uin2eGwKjUT++s1++6st6MiG/L4pmLQA4qtZHxEve1KRgYDciuN
         hxuG3G5G3xSvnKE0mrMexnpRhPKAaGAsR/5tJUYWBZtXNC5XKKCCBTxrhkdwGOlrMEs8
         gQYoMAtjcEPfR7SnQ8hJu3TdoVvZSSoLPU+Hu4jb8taRbl/BNS6Ts5ydpn1Spp//u/2q
         id8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781872331; x=1782477131;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zAgRJPG/x/HKYBdMFy6t9gS0SW7lI2ALodBm8Z0F2FM=;
        b=YvhAEdj8tJc0qYfKuxnG93NIY1i4GV5v0OKxjsuA3in+k8rrtU4xa73YQc3AW3yyNK
         XEiNdLR7ZBl8EqkeiM67/XM82HR7M1HA1RWzjamkjIClx5YSIfUUqnv4uuil2hMd01E8
         R3Ft/DY8mvmICS3V3yUW8sPrS/k9SkUmGXLtVM42CSemVDd8QLtAeWevCGVWPQHpqe31
         1rxJddHw2RgMWAatN8bofK1yuY4tAmMdPeHYlrI/a9MpEknClcEZRNfy0/0zBdVoocJU
         FcjUoMEtb9f9q4mf69LdBF6WAPOnHJo7/QO/M4BrKFaJnPDzE3zaZDooIignFFa5Ji5c
         oL9Q==
X-Forwarded-Encrypted: i=1; AFNElJ/K8TWfVxsSyDT8B91ByDJkSjKL9ALKZWKL8mQxa39ty5KaK0QK8jz8vF4hjv6vIox0QO8SQELzpA==@kvack.org
X-Gm-Message-State: AOJu0YwjbeAb7YJWc0AKPrH+61zTG4PkRIgdF3LovYHKErufB6Zh7gHy
	7ImY5c6qtE+uT6V0uTU5fVNzRbzuxG+tHqJBllIWz/6O7wHuutytP2WPxFVUQgUODw==
X-Gm-Gg: AfdE7cnhJ32ZTHq5TR5p2t/PrVNUKIF9/SiimTaYp8All75DV6OjpEFl+tiI7Nrf/Nm
	sTRKsBr8Wh7/O3ZND7OTylz8I9a7lIbLiQA1FtjrKqP+nTOczKCHYQ2wRTEW3NK+mkE+Jle2b/L
	du12JWDzeQepyo7V4sAbRh4u8BaZczxrASEmw0C2gW/U7g61QHzrX8HdhQ+G8i50ck0fxHCmlm6
	rFYXJOlcBjnMrIFLMIg81i0z9PDpy8RwS6vJPVaviUQrrTeABCmNymT1giVDz/BwauxgGs1Nzl9
	4+lXQQwHUSN97d+nhm56OmWmFqQk0posD5sbjgk7ACC+Xv006OrWqO755RKYbrQaBfSwMf8x/UM
	3MQc1f1mKN4J904R3zI4UWgIz10jzwUUxKSaL5IqXIJrBpmitViwdOnFqZpswaGOCnProkjuA4R
	/LFDyfM5glT1CCFlPBwsZfO0HDjBGVIisnazKIILcT/xbuG5jqlw==
X-Received: by 2002:a17:903:1a45:b0:2bd:3bfd:74f1 with SMTP id d9443c01a7336-2c718f8d692mr1926525ad.2.1781872330656;
        Fri, 19 Jun 2026 05:32:10 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845534d42b0sm2382315b3a.0.2026.06.19.05.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 05:32:10 -0700 (PDT)
Date: Fri, 19 Jun 2026 12:32:04 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ajU2xJ1BAqqtog8T@google.com>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
 <ajP8ZTTLYkICFTO_@infradead.org>
 <ajQ21kH1ZVajS2Y7@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQ21kH1ZVajS2Y7@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 630E210000D
X-Stat-Signature: x9c5t1iojtycd849focz83cfm9kmpr3k
X-HE-Tag: 1781872332-304453
X-HE-Meta: U2FsdGVkX19U1CFY3Efiwtn7EIDLFx8i/CvXwK9Y6x/MgumufHUuFSEY/euqViM7A8pKX4CNSZwgPjnAO81WiF7sNAFNTetiFD8HrjWT2rFnL5SKbSdVpxlGycMcWNzzGogKa2CFvwD1MnNu63oonD6QWX4jyi3WA3+Ks53fDeXvOOnWaHUhkfS5hEobLq3vTRqWZlquDG2YZ+vBm/yOIqucTE11J1KF4+99wOqNPrJACIYAQcaWrvJlzA/LS4KqLQh1bgjoF0OaZm6YxQaZVchInsnv4ni8rgFH8+mtSdqGPSgQHNoDX0MBebaidBJoU3nWVMQHjOC24I/QXZnTQd0vklWfgzDZ6/f2h/bQzrfxa682Xfu8rsTBWgkGrlNXhSig3zwB6GsTLoJwbfdukFhY7ePIkO5po8HnDKKENxf7lTw6Ar/BM1/KIEsccLRTGKiEy768jzxli5uDu/u7+pNJrdfiQCQk7plFORp+NkJuMoXVbAgH9jhOq4ZOtZoGID9G/v8sWASWH7ybzBZZK+1MvoZyMEFeqBrVKvYJSWUOxvZObCpozZdCJsqi81lzfJGxnAmrgEZrnwT9A8WOOMN8MeamfUvSztyHaBJskCyPozzDq2DBp9pDsBjyM5zAwDKhH/cXnX2bSrv5DBROp4OktDQF+USAwi0Bw6fRw7TtMoz4b6jzCyhPMEHqRb9kRDwCZXt8nbkFQ3PNuHPBnB9GBBBN7UVaSgzJaADOPwJyPgCIsjqOc4iSeGAF61cEN48054XgagHMCyYX9cG7fXc2y0r0GICnBdBsACC8Gxqru8rCCLnKGkPVpnpPoFCzSqp8j3D7my7jyB6U+X9x9SrQlP+G7MYlAfgvBMPFakYAsyAzWlk5XwSj7kmPkId/nHSh/ZD0toNX6x7j9H7fVw0A5wIcPtQqUioMbfkPfkVeUwb6vOOQUjOF8jpBBmvspTiUOcrt2CQ+LLV0CUf
 t+nxvG5J
 Hnv381NmFl39mykXid4s/v0B8gkl79IsNl7dKY6IPcAAy+OBZ8XEwtWuHUyOHdMPI8QoCAwTBpka93wkJTs6AdU4fftTC8WSYmBPhzRCym43w5g29AmzE1a/YuJ4qA9lFQdwpy8ciT9k01CNOE58iuV7/P/BHrl+jESTkLWyTdzYaV504pmMQvNFUBX1PxNTzsHkA2eoJkxSs3QEkS0ADJKYRaXOXt9377+TDaL0+jnSNv2H+seRfOVZNuLcOKPVr+YuPkqoSRyyVbDRbOA0DkDnuyAXaOrg1XkeE2HCVJRpMSzO6AnIxR+wJlmhL+F1P+dNKDYFTsNnUp4X00AzPRADJVVjJ1pGnQ+Qj6lnyFGrdZjTLcAFeRUaj99vb+uoYgFkQD7VTzbEpf5WDj6YkScVNqscZQOMTd7iypq05ysZULL2xL3Vp74z942WkBe67CXLst/+lhAtHd2hTeMiP99A4t5uLLqFsLQr1vXP7eCKCnCVUKD7r0QpiIseKsvrq680r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 07:20:06PM +0100, Matthew Wilcox wrote:

Hi Matthew, Christoph, Trond,

> On Thu, Jun 18, 2026 at 07:10:45AM -0700, Christoph Hellwig wrote:
> > On Tue, Jun 16, 2026 at 05:23:48PM +0000, Pranjal Shrivastava wrote:
> > > AFAIU, the MM subsystem explicitly ensures that every valid struct page
> > > is part of a folio.
> > 
> > It is definitively not what the vision for the folio is, although if
> > I'm not mistaken it actually is still true right now.
> 
> It's not true, eg, for slab.  While there's still a struct page there
> for slab, there's no refcount and flags like PG_locked have different
> meanings.  You'll get into a lot of trouble trying to treat slabs as
> folios (and that will include assertions tripping).
> 
> > This whole
> > area is a minefield unfortunately, and we also ran into it with
> > iov_iter_extract_bvecs and the earlier block code it was extracted
> > from.  Adding the relevant people and lists, but for now your best
> > bet is to stick to what the block code does or even better reuse
> > as much as possible of that code.
> 
> Yes.  Fundamentally, it is no business of the filesystem what the iov_iter
> refers to.  We can do direct io to slab memory, vmalloc memory, memory
> that doesn't have a struct page (eg iomem), or whatever we choose.
> 

Thanks for the clarification. I understand the larger vision of keeping
filesystems agnostic to the underlying memory represented by the iov_iter

The documentation for page_folio() [1] mentions that "Every page is part
of a folio," but it appears there are important nuances regarding slab
and other memory types that I was not aware of.

However, I am a bit confused on one point:
Looking at iov_iter_extract_bvecs() [1] it relies on 
get_contig_folio_len() [2], which calls page_folio() on the pages 
extracted (via iov_iter_extract_pages()) without additional checks for
slab or vmalloc memory. 

I am happy to refactor the NFS Direct I/O path to reuse the same helper
(get_contig_folio_len()) from the bvec extractor, but I'm a little 
confused as the bvec extractor seems to suffer from the same risk?

Is the recommendation to keep these details abstracted by the iov_iter
lib and eventually hide things like iov_iter_extract_pages() and manual
folio conversions from filesystems entirely?

If that's the case, would it help to export get_contig_folio_len() (or 
introduce new helpers) in the iov_iter lib for NFS and other fs to use?

Thanks,
Praan

[1] https://elixir.bootlin.com/linux/v7.1-rc6/source/include/linux/page-flags.h#L291
[2] https://elixir.bootlin.com/linux/v7.1/source/lib/iov_iter.c#L1849



