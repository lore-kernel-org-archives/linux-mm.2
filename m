Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558ECC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 12:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD006B0088; Sun, 12 Jul 2026 08:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DD06B008A; Sun, 12 Jul 2026 08:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CFF6B008C; Sun, 12 Jul 2026 08:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 068EA6B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:41:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DF9BA05E4
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:41:04 +0000 (UTC)
X-FDA: 84980084448.06.CD49025
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id B171B140003
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:41:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ilw8+6BV;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783860062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R//0yPDdMSUye02M0KhsD4bBos+saG3+i2478K3plUg=;
	b=Ew6W0oieB3Ya5Jwz5sx36PXTifvoLVuZWMtyIeOhOg87Iti9wHk50aAquclg6S0co1+ZWI
	+GVYTNJ8jmg0K/M/sYx+1QQwwg/U7qzizSypaDqLDKKtsdLqCo6AdRe7/inVJdS9piJRAp
	OsxBQ/L5+0VjslUWm6k4WBIW7AjTlcI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ilw8+6BV;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783860062;
	b=K8AXU+5lVjFtP6ZN26T6dYAqBQ9Kek66R6vpYVnpsiCVIRbIE+74Pz7wtOJecj0vrJw8gB
	Fyp4B6nvBLSN9CtxECFooE20qmyoTZkILwkfSbBi4steLBll19TCxnx/fZFF7EFdT1RUCR
	BatYaPMO0UGyOsFzwbTGyKssdJXvW9A=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e7c6ec9dbso91049285a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783860062; x=1784464862; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R//0yPDdMSUye02M0KhsD4bBos+saG3+i2478K3plUg=;
        b=ilw8+6BV9gXB3tIWKG9SnnZUgJWnJvdnagkloHt++BeWmbknfBF8V0VOxos1a8+4QY
         OQnj/AkDYONO71O1Pv2EcSQrUXPHnkpefFM6yeWauiSuMJCwcWg694j1yLrWbQfa6HGE
         hvmb3syyXGmLWrcvmR2ymzc0BUl5WDFb+V4ewZ/l8ewVxADlOsU6/+Hf7gOfbId7b2Rv
         oPTUegf40kU7402wyKBK30L6ATocTimBWFczO+wHF/ZgPIcEfwzsDOAn4RfRn6c/9oTV
         98kFJ0iyDb++xKrAIogFAYTr5VAb9inqBWqbJgJviPsk7HgqWx+CQLp/CR64ZNn+J85o
         p0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783860062; x=1784464862;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R//0yPDdMSUye02M0KhsD4bBos+saG3+i2478K3plUg=;
        b=FJ2AYCS4mrc5nAqTpMG2+9r0f99EqtB37AKxqoA9xHvchyO+jrfYWTW5L881g/pb+f
         soO9v/kvS+CkYu3lX56wA7BGjvmN84o5lXR8fCQU/xO67lqKJbt+ERNwxqcyWeNxbL6z
         mDfVw6CDbGU8m58zsIp1HLLl2bJzohdiyS2s6nlNJU0daxT5ocXO6ujxb7S9Bi9ctSDs
         xgcOUM82+O8+WgR2l9Haf1sIet4NDSAH255YG3b8Kpix3u/TjZhRw69NIYmFONkXhnxH
         OHf+kegnjxbDKxevhBudkJ7eajnyEq2I9pp5atGABHGc5G27byH57YtkodbCdWIYb9n2
         0LGw==
X-Forwarded-Encrypted: i=1; AHgh+RqaeG8phQbrbvdNCp/eyVdA2RFpjgbB2lY/bKvCkjNw9jlmnabMnSBL8tYtnrikqLoOm8C2l1a18A==@kvack.org
X-Gm-Message-State: AOJu0YwoCJQSdUuth94HjIxTVePym+mJj0lxDtCtriSXgINg82hBTAzw
	FEVWO40ITPHDyQrVsMkmNJfONNDojWxadqJW3O4X7kEjaq38/x9Hm29NG2qrBBzjvDM=
X-Gm-Gg: AfdE7cmPF5co0hSqRFaQwIh4/s4Fo8ux3+qGNacC2Tyk4OY+duOqLcAT+LDBJkF+iT3
	b8YFIm3DvraFd3jm+4ViYUuskJVCYloAGVc7rFpaxec3JnvI3gTZJLo/wB/aLf+vp3mnqXbkJam
	oTnUyTkfaCTFYvXty5FTX9ZobenHddFRMv3UgnLnRctgOOFWmyG5U7Jn7yKen1HTC7Y6rUk7BmE
	WK6WoIjALDVhTO+Mi7nOdwH+zql8LEvRS/Kvz2MzIMy0SEHwHzqYSjccr2Yevty1ZQ9z6hck224
	WHvVCd5DHveaTpunRosT03DSKLWKUqb6BNSh/F+AV6ObfpnS8WWwqOH9GSB8qt6hX0SwrKfFgZq
	dL87pqfYaXPfOIo4DZ/nlgZMFPco6O/HZydqnIlIiK7AeA4ueQCpiHGLqktPi7gARXfNv+bvTXS
	FWJaXWkpj1iyuMvytXhvMImaTnLuatxbkaZ3eCXdQQGftoIj7iHlYim/etBYHjQVg5EEX5DQ/Rq
	ocz5EY=
X-Received: by 2002:a05:620a:45a4:b0:92e:4927:2002 with SMTP id af79cd13be357-92ef2bd531bmr625812485a.39.1783860061909;
        Sun, 12 Jul 2026 05:41:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d375fesm815846285a.37.2026.07.12.05.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 05:41:01 -0700 (PDT)
Date: Sun, 12 Jul 2026 08:40:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
	balbirs@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@kernel.org,
	dev.jain@arm.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
	ryan.roberts@arm.com, vbabka@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com,
	shakeel.butt@linux.dev, hannes@cmpxchg.org,
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm/madvise: skip device-private PMDs in cold and
 pageout walks
Message-ID: <alOLWNIs4jA0NmAo@gourry-fedora-PF4VCD3F>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
 <20260710105557.1987433-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710105557.1987433-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B171B140003
X-Stat-Signature: wktbn8e9z6cymj33k9pqcmd9z5o99uug
X-HE-Tag: 1783860062-952259
X-HE-Meta: U2FsdGVkX1+VijDDb1/6WFeoZY9tbcongntJzrz+lLdZyzDojqEgsvmJ/dQTsxVrgVzGNM9pk8dUGP4QK3ONl5RbgbHol1pmA3yqTrhMjtjKVyR+CBns9KtMGlYNPcjSyqyLfkwDrXJVLwBGI05E//nZVyGcg2nzQEeXzuyw2I5Uq5hxRS1wiI4OdDAyVd6CZJUMox9NX92KmSFYA1JXanFaifyQmQbDlPcWGb2viX65QNzisk63Xn7IG15lpxU/cv2zCYQw+Vafoo3+lmtAtpYrgDSbYdfBc07IzLYGX4bLP1rWite739Hc4AF/zBnOz24yxTaiaDjtGQ0BdgzCdQLOIeE5fO+LN9ioaC2IgJluF+NnAmgGcpzdvL7By6BzTNXJi24jA8Z12wYFPhm+rje2EiLT2Tdp97QvURsN8B4OpUaT8IlPY1UoIqsIcCdCe1eQWnwZ9ZwXETYUWeIOApqU4dWrzmHjUkQkrwwubTEuxbFFFfkG/L4r0FEh4BR5rvueJE39eGgOE9wL8QAaQVOJfeQZq0HxR9ROhX8z72krszQL70IOB4dkEsJ5vPDwVEb7kqjEcOOn3x3rQUKvJpXclPN4NxKfE4bGdFdeo+TxQrPq093v7vNvyYXRO0dLucBFkTg8wVgdZAj1HTNmKRl2R9CATZAwAOPBdF/xIVX/DcKPYDu6It3SNXFyt7ZMFcUFBhcsaaU4Ugf7DLOgmACmN8eODelQTwpO39IojchyG6O0YFa61rgDD6Uq15YKlBQqZufDHq7ouqEW87pDtKFNMwxEo4PuWYsQhdea/ThmE1rcLAEpC4CdbtAoC4sGep6qUAeU+cUCuxrtNFYintw4nOx+nn1wlJOmGzrCxFOT9gVbahZP/lfJP5vPIwH6/AFKRyo4S4hRGtMW16LCruPKJzQSxAsOn9UNx6+CoQ/LVVUO32+/gPQ2UuXikAhHHR+Mo376loJbqda4/t2
 JA/u2BGO
 t1FkgVOLIQVc9F8+hPxcuBXnJ8VGAU4T1Dmo8R3Q93SY8cT5W3Z2ihLEtaTHe/JTwJhWg3kFqFv2ZDuu1h/b0xdNOjf3KJX6c3ef3hVk9Fm87G4oesemxU0gkjuLrFTxM383hWft1VCk7DEkwkJ7VeTykLLHrOD9nOvqW4lI1iSUWttIfUFp4QdKhdL7qGuc2Dv3Qr2srcEish3NCLvkq5P2KE3lmxfhNvqe4DoZQrTQY8ioeqiqiTnkaZz3+l/XL9CCywrSTDJK/WDCGpm1vszOltPDruWynyzabr+ZcI/YFyepMfhAOomvhUf3IUkRO7eKlDQ8f5338UwJmjB4wHHQl4O5bXnyB8bZS6VkRza1Mfus3RZ+kp9OT5dnLOSpMTN8ZTxe+fH5q26w0BA0oIzl6OKN2GA96xvm05RYsrTLJHQxtsU8Ux+120XiwReSZnZfdl1H9pFZ4JTlbTZbqpQnjT39w/awBXt4ZS1FkVi55xMiT8/i4deid/9iN5wQ+Kvp4dLbrTLN9lI07B2ZNKCHlyGRpc5meC23kvVK58rkQe8ys2lXNblJhwmOgHJGOSlh0v/GFP1jExV5mAv58p0A6wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:55:22AM -0700, Usama Arif wrote:
> madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for a device-private PMD. The subsequent
> !pmd_present() branch has a VM_BUG_ON() asserting migration is the only
> allowed non-present case; a device-private PMD trips it.
> 
> Skip device-private PMDs in that non-present branch and continue to
> huge_unlock before calling pmd_folio(). Downgrade the check to
> VM_WARN_ON_ONCE() so an unexpected PMD softleaf logs a warning rather
> than panicking. Drop the thp_migration_supported() guard: it expands to
> IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
> pmd_is_migration_entry() and pmd_is_device_private_entry() already
> return false when that config is not selected, so the guard suppresses
> only the case where the warning would already be silent.
> 
> Potential trigger: an HMM-based GPU driver races with
> madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
> migrate_vma_pages() flips the PMD to a device-private entry before the
> PMD lock is acquired.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Gregory Price <gourry@gourry.net>


