Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E51606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P0ua6IF5
Received: by kanga.kvack.org (Postfix)
	id F3AFA6B05BA; Fri,  6 Nov 2026 05:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11516B05BB; Fri,  6 Nov 2026 05:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF726B05BC; Fri,  6 Nov 2026 05:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8E256B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:45:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51AD340D77
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:45:21 +0000 (UTC)
X-FDA: 85404362442.27.C0F6D57
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 75C3B1C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:45:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P0ua6IF5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ysUKDhkycj13Q2P+bjvds2QR5Xb4PbnZNX+l6BEN+k=;
	b=j4LQWKxmKdkuKo/z0sBC+Vt1oD8d546FnvjqvHdl+zaTTzB8Asb3eWfKhNgAsLUPaYTcFg
	HpQgjK8lT7o9b1GCREC0ymk9f2IhnLrAsk0mCH4vuGgnyNKjTgNjC7i7k39KWdwngvJfsQ
	x58L37GwyEkyN+7KaU8ebyvfHB65Dsk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P0ua6IF5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961919;
	b=JY6N3ATec/Grr8RofZgtqeugKY56E54sB2qV2b/o0CC1MD3Csni5y6ThmJf9XB1dmPR3ip
	7ue7qhiyWC/NMA7Xw7f9BIp4uTrwcVG7NtbT3013e/+00+POm+7RJ4EnBHr1mK0pGKqZVu
	HVQXo8JKggMmlVeA9QrJNKnQ29oF9SU=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a208d93758so4877065e9.3
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 02:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793961918; x=1794566718; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6ysUKDhkycj13Q2P+bjvds2QR5Xb4PbnZNX+l6BEN+k=;
        b=P0ua6IF5RTTrJqVlncxkgWdDIhtEkwPd5P1GhWy8nA1mJSShetdNYBD5Zn+uxtOfNp
         xW8sdFzh5xCQEFBFNtV1VLfHIPIWlkIyU0tXOxJAagL4sTJWMi312NV7OJYi7Tn/FS9X
         T5UhtQ0VuUeXLmROhqefHnwLBnqlQTyrLcS79DzUYrReomqDOrDuCF76aA6OJ/kiW2NF
         dAm/d2S1LcEDK7ZnfkBV5sQ+ehX7k/BX3kDUAbPFbkT6dn0aGy8svfWndqqO8TCmbzlT
         kozBvdAkeX6dnIbZ9k6UfeC+ZkteBrcnyUHmMZKmYWT18aDTnxYoZbQpl/KC3UGmlUJk
         jV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793961918; x=1794566718;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ysUKDhkycj13Q2P+bjvds2QR5Xb4PbnZNX+l6BEN+k=;
        b=VZ+iThxZdVNGnbfFvmmSI4yQvey3r1HMfRZXHcg+RHFvuVRUn8ZV1VKr4SOsn/HTaH
         s+myp+QZMbAu7JMAKlW1h4znxpBFkmHBtVMXa9JtmnFNXHAfZIaD7js8AcfxMgKoSJ6j
         3z5G5zX1UPu/uF5wlUFXCYYRwP8QOl3hWeKrMJ4xaclyHEUyDaxSxYy9I/hfjX94aB77
         b/iRZV3ruo2MugqAytM8qUXdKrVOXTjYVCdiJPyW5x2LK4apjwSXkl0PU8C3hF7B5Mf6
         1fPCTaQjnudgPtY9y/0jNXC7X+QgP8Rof0BGMYt0qlGHSPZTDOwU1Ey9ngsEar+9arAn
         htUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNPFeMAdZvMbbne5fvzBv5ge60IBV7cf2x3ZSN4SEjef/3tTSuNHtgLOLXAyKcTdNNZarkF/esgw==@kvack.org
X-Gm-Message-State: APuU4Z+AVlEidPutqEpu7/gS9I+YDSlgJQmnenSm0fwz6wcPOCrD/TSf
	3y1ztqbIUA7a77o/n20ObQgNPWFg0nbWWxfCv+pDunJzYWT+rwFh0Ebs5sa19nl1YA==
X-Gm-Gg: AYBFou1EiZCA1PmrDWIM/BnI7/oV23LtPkpr1KP0gZScF9b8QXz2slKZSBtltPbWPoa
	6MH8Ii2YPjPAzGHz/zwDbRfyTR/i+26/OgQIxp+CKdJN7kAa7UIaox+4lOH7oT9zGGMLlFLDuCD
	Z7CsUqsokqgovhBwJy6dRycCoQ0iq7Y113yI9qRFBbDLQ1h0PMlp9/oWsBvy99Wjc6rBnmiW8qT
	WDgeWr0PadDZCgRIqPR0uATpPNLaIdoeEtYbRMaQJmGtsz7/vq3efmy+KZWybYprEV5Dm8B3EX3
	nqLrAINiMYMTEWdw9fpsvJJv9fgiIcS2+Fxx/o07ZdMNXGMwnaLXGrxUNSikR9+8wUyOYm7u3nt
	525jzbdC3ASvA8wfyarvjw5gc5HgHEc1buZfk7FE0IzBpixlI/H9ifZ79dssWDEeIbfkvNiN5zP
	yz2bk5LPe42ASG0DB7eBW7XicUXW28cfzYiS+bDhGHc39amLDYyj8Vwr8wVPohvBsiM+Rk1PZ3Y
	DHYIJFUfsaUu2m+cKkl2EsdIzkkrM/MmSIML1eY3ae0iwFeSuUiZnZOg028lYhhjxypz08l82fW
	sR6A4cUkmSJGdyNY7aBfJiqK3FB/4X28eX9Ugm2ncVnOKr0vdb3/S8LQU3oZp6Vj
X-Received: by 2002:a05:600c:3b02:b0:4a1:fe55:88ef with SMTP id 5b1f17b1804b1-4b6df5eab2emr32006075e9.20.1793961917300;
        Fri, 06 Nov 2026 02:45:17 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b73d28cb10sm16111895e9.0.2026.11.06.02.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 02:45:14 -0800 (PST)
Date: Fri, 6 Nov 2026 10:45:09 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sumit Garg <sumit.garg@kernel.org>
Cc: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <au2vtZFyfUVWeils@google.com>
References: <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
 <aszdnInyJxLhSQRp@sumit-xelite>
 <as3798SFCfKFirag@google.com>
 <as4ATqhp0bPI03PA@sumit-xelite>
 <auILvMVSXk9pZh6M@google.com>
 <auQ5hCdPFz0BmvDG@sumit-xelite>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auQ5hCdPFz0BmvDG@sumit-xelite>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75C3B1C0005
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: uphpbk9xykhhcb9uxb3xmkukhox49rxt
X-HE-Tag: 1793961919-118658
X-HE-Meta: U2FsdGVkX182Rk07bzkS2iOscennkXxgTljGFLmiOSI6mh37mS8IR0lJ0CVFqNhJ0xieZHXXmChb6PDBXTyIK17U6g/WCU0Dh8DSVmNJmBxOywc7qu3YDj8/hSWd7CvBN/1KEf2GOZplO215xolOd4Yh7Oq94AsYB/Lc8InHGEQ6zzOGWonZsTUwwPV1XWQuYZcKvBWky0aL388OFS1taaVkqu+Nhc12FgSvn7hXwfsCv8J7RnCqsMzSXva7TtIGGuaN9vGDzjQ4OMk91txF0qz6/Wm2Jwj654hCQTHT7c1bGSBTH/Xdp/EP+0vc/tuf68bInsnYzABrvFssnpCEuXS1DzsSHuA37NDoKhsjTapKlJ+eHBt7wKDFfVynt22PphjIjdhezgrXPzKFur5UqGhsubLiHP0/pEb+pNUvg0UKYQK8RGV4Z6wewEfMBl7Y5Z5ocwTGdYKruoxnBIrIftusDF+Ovyps54yiUqXCOqUZJNKFFo3skAXt2RfPUleHloqCFsXx+VcXlwbHYxoEJkre477ufYOfePrcQ9ZpSOsS3ZZSqn9UxRvCEnJ79w6Fh6HTC1W+MTgZMKkAIU9eOVfvodyGixLNhT8p7i2lgiIBFMLejUz9XRMX57BVrl0fn0i/W6w113oXdFhEwQzkmEhGwduPqd6jMQH6O3dIM24Mgm01srugJ0pqc0a0KYKka5Y0sT20b7Y+7WOG4rVOUpi7LbFSXIP3VMrssDLaZQ62hlJG+hODlWY9EgPYtbvwqV8Gup8eWnXXMJ4GO4QQcBHuhjAwS1xR7BRUggOijesmzBrUcqJ57pKL+SicK1YsnWxRD17jHRPc2XWRjGgWVa60fNgO8gYSiKDQkmXc6Isj57LAJ5pdYIhEPsnpm2Z3H1q9WCmCu2vMDN5gSFLtbNloVUQ5Wd/Js/WTM3PrbrLXBsU4eNPfJqL8umkb4Rvlw+bt3d9114pRqJb5WPK
 y4pSRphK
 q4pXf0LEyvmFS06b7Mts72LMDDtO9cNpqXBYHOY66Ql4dPj1Fpr5nzyk/lmJEyC1Ln6+vOuL/RDKQzwe1/5uPOJusbM/IPKU1CKge4+fPoaCy3M7KwPjH2dnP7N9oC7+ekjd3bJWikutwWqgO4uHqM9wQeeikEUtmwZtfzjhYdBL5H7i4EzOUVOR/hQlb2+cQ0B/zKxicVLUbVsA4QuqK26hl7R8lM65WZ/SeIqwljCa+1MlD5OiL/3rWO5+j3xmnkTcNO/LBvoW8DfUquT1i6oP38bWEDY+A/Ed8I8UaglMTZCyRkq/VkGi+riLDs6hpax01+IgppjCyFjSZ5FTMqrvgHxcBzqW1T/8xVWLDpyB5oybGMFs41f3E/vSaZ2SxW4Eo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[...]

> > > Yeah I saw that constraint too, let's leave it for future extension
> > > then although having this reordering dependency fixed will be ideal.
> > > 
> > > >
> > > > So the only case it would work would be when a reserved memory has set
> > > > "linux,cma-default".
> > > >
> > > 
> > > Let's rather just turn DT based default CMA pool to support PTE-level
> > > mapping and keep it configurable via Kconfig or cmdline or DT.
> > 
> > If we need a DT declaration anyway, a Kconfig and a cmdline option aren't really
> > necessary.
> 
> Agree, it rather makes sense for DT independent generic CMA pool.
> 
> > 
> > Also, Rob wasn't very keen on having a DT option for the reserved memory and
> > suggested to have a compatible string instead [1]. So perhaps we could have a
> > a separate driver that handles the unmapping.
> > 
> > 	linux,cma {
> > 		compatible = "shared-dma-pool", "unmap-on-alloc";
> > 		reusable;
> > 		linux,cma-default;
> > 		...
> > 	}
> > 
> > That "unmap-on-alloc" driver sets the memblock flags and register some cma hooks
> > (to be defined) for cma_alloc/cma_free where it unmaps/re-maps into the linear
> > map.
> > 
> > The nice property is optee won't need to be modified anymore. The downside is
> > the entire pool is now mapped at PTE-level.
> 
> Sounds reasonable to me. If folks are really worried about performance
> with generic CMA PTE-level map then OP-TEE already supports no-map based
> reserved carveouts for protected DMABufs too.
> 
> -Sumit
> 
> > 
> > [1] http://lore.kernel.org/all/20260902172436.GB1440252-robh@kernel.org/
> > 
> > -- 
> > Vincent

I have just looked deeper into and cma_alloc can't unmap automatically the
default pool. Callers expect a valid linear mapping right after the alocation.
dma_direct_alloc() and dma_direct_alloc_pages() zero the allocated page,
dma_direct_alloc_no_mapping() runs cache maintenance on it, and the userspace
available heap /dev/dma_heap/linux,cma zeroes it.

Also, it isn't possible to use two compatible strings for the reserved memory.
The registration stops at the first matching compatible string. Layering drivers
won't work either.

So while the pool can still be generic and serve as linux,cma-default:

  linux,cma {
      compatible = "unmappable-dma-pool";
      reusable;
      linux,cma-default;
  }

We can't escape providing an additional API to unmap/remap in the linear map. 

-- 
Vincent


