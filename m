Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08EF3C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFD36B0088; Thu,  6 Aug 2026 13:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7F06B008A; Thu,  6 Aug 2026 13:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3F16B0093; Thu,  6 Aug 2026 13:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A937C6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:07:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EC9D80179
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:07:50 +0000 (UTC)
X-FDA: 85071476700.04.311AF54
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D82C10000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:07:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tooaFCxW;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpqTarvM3plb3e18QvLpdCn5d0SiQvgtNYeE1iMGePU=;
	b=P3LQK4t5hHE5gy3Z2aVfc9TOyGWDwPVxCrWBkyt+s4c9F7DouOinQ6/8Uyp3Abp2NXn+ON
	sTs8dnyU2iPCbcZM5NDs8EXI8qiIJt59BYQa8miYRjWTY4hyR+/xG0VbaDQ6WdlyjP47eM
	oRtTqlLa+wA77WToakXUrd1RJeHeYTU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036068;
	b=XWF3AvttiuFh89HPLwUGGUCZF1hersqAaQ5TNJLxb1HFGsq1jqOkjiJ4g33tSAMHScg6HJ
	dyU+QSdI8dWoINB7Dwoz+jJLVvHSJX48p5U+gmJAu4xUZg/Tm5FR97P/qsQtwuN0/Veo9G
	UH92eRmJktL+g2ImXW7iIwr8q5HCsCI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tooaFCxW;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.214.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cca0c5799eso24679945ad.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 10:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786036067; x=1786640867; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CpqTarvM3plb3e18QvLpdCn5d0SiQvgtNYeE1iMGePU=;
        b=tooaFCxWkFzK6bIS8LQvz166Vpua7M0OFBl8C51arx06SXSVC8htJoxX41dOxgi317
         hBHvbgFtzaAMvwhrJHuNYG82MiEMZ8oe4Vci3f6X/9t+WGKhyLa+4UaglKquaTLnp4E6
         zKeHifzxVlr2OUZcQIz2Us0ixUphbSrq+6wKJlekSWE6b7vQ3Ki9eCzYQWOocAzTmvXW
         CX9qFOWP8FlLPyxGBXq+JNje6Elrvy1F0byuy1jYi1nR6IORqnaIVnMLyYube4qwyLvp
         nFZwqnFewd21K5gImflDuQaDFqzecUi/ReFxxfMjSCvJolQktiZnkzWNzYfwcsyjNJ8m
         rDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786036067; x=1786640867;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CpqTarvM3plb3e18QvLpdCn5d0SiQvgtNYeE1iMGePU=;
        b=h5Wz/VMdL6GWT6x6xn3dhxZIE0vWMvnfkU2BvMVeajvTUQJmS2cWUOv+Hff8yfTfqY
         c8WhPV0r9kLkuvYVKyWrc5ozCkmNr1oP+/tjQkmhx61SEOxw4t3iu57GNqRNTq58G8cU
         MQA6dPrfRQVSjb0Iky8D9rfRyJahh7K77cX/BlefD9bDQI7XbNfIe6c7DCA1X+AXGf/t
         UBAHarijHSsMEzR83YI6JJp6/3jxNG5S1LceOney/Rg+sf4XCsnnvdXssNrMgi38iCR4
         ZNakHxA4uXckIFVeuY+h7m3WozU33qHcEgccrCHA9I1RAp3TN/FHB9nZOozqPlDoG75k
         Db1Q==
X-Gm-Message-State: AOJu0YyjYcKrk3VeCev4vb2DNBQ8yOoeRSwVp5e+RFOEMuBd4CEBuE24
	Z2NW6wTJhHMJ2X3qQNWv5CBkl7Yy3kVvoHQ7l0oW77ogDnxC7MYIuZZPbcbS9xAi8cs=
X-Gm-Gg: AR+sD12EcrajZrEq3PG1k4GEGaAeOkIseYu2gsGZMaFrhgKhBW07xTXGPoNKh8ugRtM
	a8c2PdbmjCmjF/qzoSHeRznvTQibaEO/CGsU8rEOoviUPyqfvk4GjfUAX5rvzYPiPd2nNBE+mcq
	uGKGJN4FYxt6W296XixiPdoRHc5Mf6OaRRYkv4Uc6UXzC0UD2Y0etf66jAvyTNUfA9VT19bLHm2
	CWjkq6dwd58NAAM1H84SoRisHX/cYr0v4Uc4FYUV+PbSuVxiH3/uQF8hVP39G1d8QJVQjGf/HBb
	P0MuMYGo37wqzhNIPySpBCUMgvT7V+Mr0BZnt2Okvv9++OrYzalT+f4Uf7+ng9zkwkOSY9/fiI6
	MMOTx6CdPUkds4Mcl4zx+xBxWJk2nBLDo6ZNRAJE6BbrhKVWOVrGMN+gK7EKtllZGbavu+scFl2
	9OSZDYMPOfs655rcMvjeQKvCPWwwRfG1QzKN8Ew1llesXTaVlTWN1H4I5N9UqIVWwa
X-Received: by 2002:a05:6a20:258e:b0:3c3:875d:c531 with SMTP id adf61e73a8af0-3cb85dee582mr17248845637.6.1786036067249;
        Thu, 06 Aug 2026 10:07:47 -0700 (PDT)
Received: from fedora ([2607:fb91:201f:cebc:3a68:390a:144e:1b87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158678ec37sm29709378eec.23.2026.08.06.10.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 10:07:46 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:07:43 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 3/4] mm/madvise: skip zone device folios in cold/pageout
 PMD range
Message-ID: <anS_X0uQ5GHXsdwf@fedora>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-4-gourry@gourry.net>
 <0b22acb2-5684-4ed7-a916-d531bd5dc410@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b22acb2-5684-4ed7-a916-d531bd5dc410@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cp1zxnna6p3mp88ysnsx5wt6frfz9go4
X-Rspamd-Queue-Id: 4D82C10000E
X-HE-Tag: 1786036068-362992
X-HE-Meta: U2FsdGVkX192AgQ4COdaYMnprut1FBJF2ZQ4IefIraTFOvTDkXCdKzlsfHZ7h52X362fBPHWBXAZV+XOviyt2F39eVG1FKKFgaey8ucpwh3JLBPpETbzVWiJ9ULCk3INQCwIRkuADTs4EoaM1Mj2DsVxegZg/ff5WHwl8FxDgaoI76mIXTTogGaxV/r0sMP6dnOy/1iHcjD80sC346XeN+5Aex4iNPNda4bmGwenVG8wG4ZkITIoyKVt+/WilzsW46Cs0rmswhnclBc+vzWCTjI8kcUE3vAeKdSPw9Yl/YLOsYnTKqRbrazOzrBjiiVwivldfRBMFip6G9j3hoe7Hl1nO+ga3FBofrb+Q+xw5pALGeqvEV6uN9JPdvV47eZujU7ZBkRy5USWcV365l3mF5xpJVffH2NF+13ikn0MagdlUi+BEcxiQiFiVym3amVbAe6l9xrMDWMpewv8afdvl222bPq5WlbaQa+eEz8erUThcUOjT4MhcaZCUGvZyMs3SEwLQuKMiJm7b2CzDWSyarHYB/pT830YeFGixyYpRIhi168SV08cOUpB2cTYLI2oUXXSv8c8vx6zbDSpTjntNHBxQ4Oq9QT+M31wn7IkDpK1Gj7z2xpgnDdJ0VlxuFMspSzdEoR4Xqrpp/jMzlAlL4amWfJP1mYo4Qb537EQyye3ZJM3EfWsRYs8RPyzVoJjhhpovW+K0nsw1NoxxBbRmMthHj88vwTImkW85cw2/TG+hy3iqC2D2AIhTROe8e5BdB6+44JRbioNCWZB06CFeFCN2sGeC7C86emidU5P6zOcR7jselcO8fJ470HkOu7bgrWwO28qFc7JSVqPtSaR0sdFXoLLrjPu5dob9u+1er/oEFyt3JZSKnB6GoqLsyQTm6ikHWiTKeVIoXw/biAUKdYmZ9e44QOAqnWFAhBzVASGUFqz4tRgYujK8BQbsl775As4+lsOv9bmQB1FDB2
 0C0C2YWu
 i2V0HbdJe9v5OEirFFEb87KaTPFWva4kgdeqb5cDbZUNa6pUuihQ/+ZL2A4D5vlx3fZrRY/O7RDin9Mk4VwDJ4KQd0RqGTL6/nhm/7a1tpn+RFsbj9q8XL4/NXLZ2fJJAguei9iGmAZ2Q8lxCy/YnDoxLyAw7wgXgLh0W35NqlvYAHw4hukCzRytOde+Xt+MGi5d6oyKa5CLCtc3Sv1WyJkRwESCMJidueG7I9BjIFSaRGvytkbnTfQT2aQ/EeJ6SvUyBrKKYgV+zjEnAF6/V/xG13tJ9j1D+3X97FHShgqDFZh37eV6Qa+NMP8UBmTjRnC6vx/Z0kLGjpFMJbKavUsogK1J8n0obWZcNxcY3UW60M8SEgcpllsCEK5eCpwa5cLNcSrI25Fucgmxiwi4nCexbt2adTCKeKQFdHK0VyDD6vmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 03:23:25PM +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 21:47, Gregory Price wrote:
> > madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD
> > via pmd_folio() and ages or reclaims it without checking for zone
> > device memory.
> > 
> > The surrounding guards do not cover every zone device case:
> > 
> >   - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
> >     (so device DAX is filtered)
> > 
> >   - !pmd_present() branch above rejects device-private and
> >     migration entries, which are non-present.
> > 
> >   - A present zone device PMD - e.g. a device-coherent THP - is
> >     not filtered by any of these, nor by pmd_folio() (unlike
> >     vm_normal_page_pmd(), it performs no special/pfnmap check),
> >     and would be aged or paged out here.
> > 
> > Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.
> > 
> 
> No fixes tag for this one required?
> 

I think I convinced myself it was unreachable (PMD+Zone Device),
but I will double check Fixes and send a v2 with 1/4 dropped.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

Thanks!

