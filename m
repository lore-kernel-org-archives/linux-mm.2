Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF4FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 00:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641378E0008; Thu, 16 Oct 2025 20:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6196E8E0002; Thu, 16 Oct 2025 20:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F428E0008; Thu, 16 Oct 2025 20:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4A18E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:56:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D23516048C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:56:00 +0000 (UTC)
X-FDA: 84005789280.22.9C75138
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 75FF81A000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:55:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+2EqBvd;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760662558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSGUPMjLY7nQdhJtvbR1IF4u9EYIDkq4l9YDvMHJ4DE=;
	b=FO2Oh9ITXfsoKx63J2/3AD0G4kTW5Z4yD/55YBnsXpfyNiL1eBMc8/OXDDmDgkKVbKpZLM
	FQdMI4XuB+dkkFNRsO/E4DqUTIXypCxeHSjtbN3cWqDWG9UG59ZqYr/zRCA7l1gJzePHlA
	3w5olmLbHKAmlVWggmwl1Qsp6o0cPyU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U+2EqBvd;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760662558; a=rsa-sha256;
	cv=none;
	b=LDgHktspObEu1Oy4aE0WaUXRqGhbxzji2woR2w9NtMJLeaE/tF5jPd52yA4HdC8Rfr1IMx
	GGaccge3mA4MvUbXaSRNUZWFheRGb4V5DHquVWwIWpNgm9X/DzMYcKkk964InIOv77BJi2
	jjOm5VuwvwOOwJCIEzKMrR8mHqNKyYs=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b472842981fso174046966b.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760662557; x=1761267357; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSGUPMjLY7nQdhJtvbR1IF4u9EYIDkq4l9YDvMHJ4DE=;
        b=U+2EqBvdOdXXDFg4o5EY/Cv32Ik8/5B36kwli5jjI5dnz8d+skckXmzMsX2/4xNvQb
         veDtDctaVrjVH2ZNXhtpw6qeeDJVlJvg0H4IV6vqjI3IEIGAuVZPeXYdH3gKWTqLCnbf
         xgSTuBX91QC6AGQ2CtZiYqZ2Bz41/8inthLC5F2Ox78gsnDW2wmlJAH/n5b5ov4CFMiB
         VaHSLJIsYpsCr21DLpGS8tow6jDReX3Lq5Bvs43NWBh6B+h900zsFp9ATFaCtE8YjuXG
         xXLCQHN5IXXxFY4GERp4jDLRfm2DvRXE0pz9PxctM4btYnGOuDShItdXFbAFXrAdNE07
         7xQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760662557; x=1761267357;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hSGUPMjLY7nQdhJtvbR1IF4u9EYIDkq4l9YDvMHJ4DE=;
        b=AyZ0CQScwOl2n7aODDvaaTfq5UHdVc8fvUfcIvDM+lavIzlT4adrVONa1q/w36/xwK
         3jNCtl1857lun/0ZIdC8DuVvW5GW5eTo+Rey1gb5T5KaZoSg2d4ojdqB8lJyGOg8W0WG
         6ClWw+8iGc5iD9bgrkXbgymxuRkrARgE3g1/01Y90rKCO3uhPAb9c454lHigXmPd28Q2
         egjTFY8n/4oPRCp8d3bkGEASSQNzIBiVyiSBlaWOSs4Myra+7eGdKDC1TF+9j42Kbww+
         ucGMpJp1hYYw710/QGxcB2b8oUnWvYFSJ4Tc2ZRhbKAdHfENNeig2SK5AtMu/+mqBNIW
         oevQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYg65rwdg5kxSBdNpBeanEY9nZdMKlIsBZ0X6wORznmaXeUNBreIiv73Y72Q9VtbL+1+ToE+fBkQ==@kvack.org
X-Gm-Message-State: AOJu0YzW+dnKs4k0ePxa88zQ920pC0yXpGRpsoYtktV1TkWdMqTi/kK0
	C6fJdBNsbyBXsuG7QcU9RlBSCSs72DP367wW24DNY7+o7EcCs8cd5Pef
X-Gm-Gg: ASbGncsV0GRBw1zS2jQ5zAlYidRKwqWzEh9Hg7FpldMCNOHfAGDR3NkD/jJd3VqC7LF
	Sj8upBs05DyGtVPhnGdvmWgYb13/noetmnLHYxQLBpaatLqNw41C4FJsD8PF3qIxEqtYuXGhRfL
	06JxcMCpn6eEHkqxleiqDWOpm31nBl3O/1zY6ZiP31TGcn5Mibi9nKfY1xkA3SCQVcbq/YtBzxI
	Mf67nx3ctDTOGxHw38K4Ghkqs0AMORD6MySc6aJ0a94X48XJpoH5tX73ykfx1V4xzgLmxbwz8Q2
	kUW+f1pQbsp6xcVye1qkjAUoOeeyf1J11H65yUxpZq8LRZev+ftJHg1wJYHuGQas1+MdElU4O9z
	FbcTpJUwi134lbMnojZjGPaQq1eqsZz9ccq/BSajvttB5GzUWiL80Q72CaouBNOpvnpNfChh+r2
	fHy9M=
X-Google-Smtp-Source: AGHT+IHbokPv4BOzbT7MynQoqYmSJxwtKkuj87HcvFC6nxwBb/V7gTS9O6jMUOrVmCPMKUmm0wuEmg==
X-Received: by 2002:a17:907:971e:b0:b45:1063:fb62 with SMTP id a640c23a62f3a-b6471f3b921mr212539966b.24.1760662556738;
        Thu, 16 Oct 2025 17:55:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cb965cc69sm659015266b.1.2025.10.16.17.55.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Oct 2025 17:55:56 -0700 (PDT)
Date: Fri, 17 Oct 2025 00:55:55 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <20251017005555.snztmz6hawkcwkpk@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016004613.514-3-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 9w4wemusjdo68yswm3hzskrzranoy6bc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75FF81A000A
X-HE-Tag: 1760662558-737525
X-HE-Meta: U2FsdGVkX1/SRkOssUE65c4VYzCl89mA9sfkQrHPNRPAOQLTlt4aH38JA/FsV6eyW2nkSxZLvXtYtTSqNi9KojRzrtasFEEIRUz58woKIcArooSQF9D80q+9NfVAIU/e8KaD/YxcNdBjuSo0U9UcWi4dFSFSuvXkpVaLbCTx+i4Ab1Py5lKxnwNDvpczAlLHSamI13KSNY3V/HvEGLPWginJPnmHM93PA4F3QIZzCkI18UhkTaCvArfPJONWYv2diTIMj/OoP741SfRLEw5hYtQEAQpIX0nzC2LVcGbIjAR3FbPseS3ja40lh8F8K6bdLZZ61B+k6LEth+OVdoI7Eyy5Y2M5IVZeJv35X7oMg7qrvSvyGL7XD3ZMed5+1BtKN0UYBrZ7YHEi1fKAAAUJ8sl3mMI9q2F5BNLdyHyF9Fq41ly5XcNozOFoMMVCKH9FHgaHDnEJhN6rPVZ0k6PkCsmiHjpzUsvE+4WBSKg3OjvCGJ5Nu3/ePGzqe0Rhgya/QESoN0L8eg18qKbs3EnZQQctqglmCUgRwo8ko8sgfvijaiiva1TMmHTT83xavWVZgXkgguzmZTfFv7vFh7E0P42+aE2S9eRnTsm559c9dFPf0yVK4/53NtS9p3ioCan2n1M4BcBxXR4Xa7+6VIBqheznhqozmqTgK9CgUC7JJ37o8LN+b4xX/oDjzsINVEeXnKK21VVpa0+ATH/F8itABacAiZexN7O7YKsFu4trXJ9GV87Vyi6abbASVbNf+s9TWx5d4kan+3lSPljCVJK/Kf3c63EoFzUWaC5s4zaEgzfM+F5xNFeTIsUtKOgygekv1xsZ8Zw8n+96CMthFJ0mxTD/Ue/MZ6MqXwO/D60G8C+Js/IUtVLQ7xFb3vlafvdCDyRn8JKL8U6hV6ReRslbYzQEqH1X/cu7I0ZcVIuIqEVSJ/BpXytQ+j2k6rKBq1ggJ1s9DYznk14OssG/tIa
 V2PoxqWi
 o2qKw9ClAB71n0XntMyzRNEs2jkWBB6Yn1QVRd3zz3+Or04jefolzB4RY0SiFbgC1ePi+Sd4D2HfYrD6XF845fd5BV07TeE/KriniddOEwjNrjmpVyvw3lWpVDQu5lhvIIrzbW52zV7SN7rL1npWivRtHQqRaFCXu/z2d/5wOTT2VWPQu/SZY8r0iCB9OkEVOPUlpHePsa7M0OeNwC9/2y5GmXK+UnviXAbxpwW3EpIux4q7ZTYWY0HwiQisoK4wGRTfQlgs2ra/OV6thL2Q9dkJ1lrtgkpXsT2A5FG4Ehf4drHjLYZb3ndxK/u4TefK7vxr0ntMMs/y+Yo3zVnlTM7nAoT8zaxEjnp5E5TPUBwVasPo9UeLb9CrlOn+PmtdeWJkMGTWOU90GtLSFL3sL9xJVutCJf4p0XXjbIxGcircV3HeDVPwerN+whU/Assvr8/Q00JmHXdNVOYx88x5aOyvpR08tC4KAueOMoA9reSCtqVIvPOdBB7J0Po/SfjDaoGTOlGP/lB0FFgQ+dX8aWEbz/qC7pnKwSFoenWCcbkb05c5/sbHL/+1maSZIDD4gsoDtVjBLsKovTeAXXe23Cb1gKNzUBK7EHSwTMIeoiSFrkAWzRNbLW9zT7WrPmqsoH0awPMUjmElFag+FvCtW5preNOi3dnw27gSuhnGEeImh2b4hXb71UCS0l99ai1jGYNjdkLVSNfXhq4vUnp2JWBA19hysoAOrWnJi07rMuhIuGaWHdGwCz/cWd7F4q7iAL28b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>Existing __split_unmapped_folio() code splits the given folio and update
>stats, but it is complicated to understand.
>
>After simplification, __split_unmapped_folio() directly calculate and
>update the folio statistics upon a successful split:
>
>* All resulting folios are @split_order.
>
>* The number of new folios are calculated directly from @old_order
>  and @split_order.
>
>* The folio for the next split is identified as the one containing
>  @split_at.
>
>* An xas_try_split() error is returned directly without worrying
>  about stats updates.

@Andrew

From David and Zi comment, there is little change in change log.

Would you mind helping update it? Below is the updated version.

---

    Existing __split_unmapped_folio() code splits the given folio and
    updates stats, but it is complicated to understand.
    
    After simplification, __split_unmapped_folio() directly calculates and
    updates the folio statistics upon a successful split:
    
    * All resulting folios are @split_order.
    
    * The number of new folios are calculated directly from @old_order and
      @split_order.
    
    * The folio for the next split is identified as the one containing
      @split_at.
    
    * Stats fixup is no longer needed for an xas_try_split() error,
      since since we now update the stats only after a successful split.

-- 
Wei Yang
Help you, Help me

