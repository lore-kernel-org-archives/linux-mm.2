Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1417CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 17:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0A26B0096; Thu, 15 Oct 2026 13:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6607B6B0098; Thu, 15 Oct 2026 13:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528EE6B0099; Thu, 15 Oct 2026 13:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5926B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:17:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C5661202D4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:17:52 +0000 (UTC)
X-FDA: 85325517984.13.5E1E0B8
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 746714000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:17:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JZeRl/vN";
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792084670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUb4cagls44kE5et9qrliHAU76p7w/thb7bKXpN7Lxs=;
	b=YVf3RqFqaB1NNa3rx7BvZlJuzlZNYsrPb7wi05YPyhsbO/uGxgznNd1tkbl1iFFbpks9+7
	+i3CoWWEnjRRUVbIZ+UQgpyf2ju0Ka+049RwTnhspBG0XiWvT4T6CJ3FoyOMHIJkNVvhru
	cg4Yo8y3qF8Bs3aFAkhfUOmDiSR0hks=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JZeRl/vN";
	spf=pass (imf04.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792084670;
	b=Ig1qFtiJ3WX3Mq71Znr5oDCSisTNPcPr8K08li9/zsUT86bPEbi8s21qQE7SIBhmrAvbWx
	zBUBFyDqO6N4bX8ffK7b2iZ2cVFP/jI0joxSnlqR6wgoB0tPbdp8MgJ4c9s1ghN4wwzaRl
	nM2L2t5aITKLdtauZYaNLEEqcNdCVpo=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso1130745f8f.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792084669; x=1792689469; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nUb4cagls44kE5et9qrliHAU76p7w/thb7bKXpN7Lxs=;
        b=JZeRl/vN/mRn86rxQh4RvlJkqCUUwBQPqKPNs8A6cpzuHZojy5EjAbXz0EOWanrQrZ
         OIl6DlPrvQiLuIH6p1G5eLXhpPx36toAqu8TtlQj1ce/1f2QcCLiHAAe/4XYYpKaCkPW
         2J4z6GFdK6SqTKsTxp7jMxXfzRU1gU1HgpzxOJ7AcZNJmYo6ooO1TCpkOgZ/10tohH9H
         xsqDQq2/t8tr6tm7qqviZnFjb3e/JLZrIvivxYJ3yL6jTrlQAreJVBu26e7cLYtBz7z7
         Z67TFB0SccRSWabkawJz5HIXXhOuRyTrDovuZezlKqEXQB/gJ2DzpyeK/jhmhWCy0UEH
         AkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792084669; x=1792689469;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nUb4cagls44kE5et9qrliHAU76p7w/thb7bKXpN7Lxs=;
        b=gPOGXSmSf9sHoEhsjAfV2RhtETLJrsglYYopHNK+UAovTMk623UEHFDZ3Im0pGGZlz
         n6yHZuCLUWHyEUu15bng3eK6A1ee5xo0N/jm3rawBxmRDOAExtbShrJhDZzKghVsHqy+
         7+nDyjcPhJDcxdP4dKQErd1SZQ//GEOQVuuRYidxHWW1i2JAkAaEW9FYz5XTTbuz+awZ
         NwCNykc2MJu49FFNx6gEUsnaGRngA0Y4LI2Ipk0kupInB8JKCsXrWydGBBwYrCqLwuvR
         iHWyhiv7bF9Eoglct17+lBGCrgntVo0/lIQUPvvo9BBxz2y1HKJoNDt9SuI2AISrgwc/
         MUrA==
X-Forwarded-Encrypted: i=1; AKwUvBypaFSm4GtWYCbLwB/cprCPtKo1V6uJ0B8dMJXjb7zctjuPG2Rqlfpk2mjkQyGbStM5vGMgtDjl7w==@kvack.org
X-Gm-Message-State: AFq9FYL+V9I5GdhJeH1zItu58D3nfmHaXKfItoabtG1F05S3UUgoGneb
	u4TqKtOmHk+MrkecTQ2XnSNp9qQ7ayV/grc6MQUUTO2TTGxPs8N1NDDs
X-Gm-Gg: AYBFou3wqkAn5hPzMoE5ckCcnrp5w2O06f2csnalOl6QiKx9k7k/tug5POvruErJkZk
	QIldQin4055Uc5lUdm/zqfDtrpG+0FeFFZzqJvdNRyp1YviVADe/GppGOFekMcgtUOwLtY2QT4V
	x1eVC+VVuBXCeKI4g57mmWJ4P7WDEud4AS8EyKU9TkwnaRwqYL5YYYas0G4LBTqu7Fqf10X/f0h
	8YvSckzBR5Fa8+lRmKJRirwezI+UEswhCKRqJzp5F21cIuemZebT04pF7ZZGYQm5HtD7u/Qz9Vs
	5g9WQZkm20UPxhuAMpeizWokvjq2BD5XXrK3KO8hDLtQyH6zukHSmdn7vH6ecY4h/NEkNUNR+KB
	FCAQUmYj+VplJVRBZbKIlWjAAK0RROZ2UIAkStohANYObDY/VDTqchVDaHeDJ2hmegh+OQDqFRa
	3gUV3dUHkqYm6JB4OqS2CAVvcVsCZ69oGr8oUsAOwJnzfKn6aDJU5K60Sq0BXUy8anBFJwpI5GL
	3kbLWKm0NP5siskk1+eHi5IlO865mk8Fp8rXvBBiMC9G5sadZH3ffG400alvz0CrCKpgHoAGt+3
	Rwx8clGA5CoZ0ku7Yls1uQQ1oTjwLrCAErw=
X-Received: by 2002:a5d:44cd:0:b0:488:89e4:c3af with SMTP id ffacd0b85a97d-48dbaae4869mr30499724f8f.45.1792084668569;
        Thu, 15 Oct 2026 10:17:48 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfaf1acd7sm1180327f8f.1.2026.10.15.10.17.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 10:17:48 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ackerley Tng <ackerleytng@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
Date: Thu, 15 Oct 2026 17:17:46 +0000
Message-ID: <20261015171746.51538-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgHtB8j6=9r=txjsKvQM0F85nRN4KW5sdnuv_-Og=cWEfg@mail.gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com> <20261014095702.39676-1-griffoul@gmail.com> <CAEvNRgHtB8j6=9r=txjsKvQM0F85nRN4KW5sdnuv_-Og=cWEfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 746714000B
X-Rspam-User: 
X-Stat-Signature: nxsajazok9gnhzmkyib6fy35zng8jo78
X-HE-Tag: 1792084670-797599
X-HE-Meta: U2FsdGVkX19Zn2hT3alfojQxv1XtnjzaydWtiofpt4hAWjRSwFn1Po7DweCp9lWmCVIHZ9dRoPD/7tSQ7WjK0kXG+s0Ft8Qb/KilNafsvu5m4gEW8npDnsaltMbGvfCg6djjMq7YFX6Gj03Izrm+CxRlbYPWx+PnOuajuRA87pDy0ddyoSSaRQGfLqL8HTvTL2Frqkrq8RDEkbMP9npQZcuQWPHPmHo0OFYFZ4MmOMKpMrN5T/fKHROChB8r3QG0rSLueAif6XPyvjDlSNEQ66wuSgeRS1s7M8Qh956DMFrTw4Q9A6R8L7El2Q7W9cO3sl5sKUoAjpVz4Mzjw3QU7h8fGPbB8ZV1UYPgAuHVajpDLsPyKatsIq4wZB7+q7qNKxq3dvAbAKXj+Fp70/5trqNynKuTovDhSz1qsshTzkXiTX5Trg9QbNPqPtxSZ99Et9giHc8aduBUA+rcI6IzZlqF790m12ERyAichI03KMgHCMbGVomL3serV1Zvp6XzDJXQCbWp7eOSBNA7lIDF+g/aGFL0tyymM6lALbw9umTMmNcuZ3MPudrcIWmEnz1K5Rr4OdP5GftiaDQEmvOR2Yv0vwWWlEeTA3j37xn0fOu9zV6WK4aeDjrLm0ozwMaXM5Q89gH6dqAXQvoOVEYjYoJCuhoGfR82x2fnhG5bBWAzrABdZOCeLQyxw3Hmyr1QY0LgzxFWeQsR/CE5/RCBLOb3gY3k8nKp0et7vwCndO6G5xyhcdRW8m93CX+Nt6gD2nqoDH6fBFuTIOwioDl/yVL18SUSmXCjGN9Pw2MwJq+VTn3VUs2i+KQLcW5zj9B7qkEtIFtwFf9FjG1WBxrIDiHOi/FfzB9CYvAH0j9MF24LJ3+qWLCZx/dAFdjR9+kWi5MGriX7xn8akgI4pXe+PWnWJjdexhcnT+OCD58VXyNPVLoNhiCvLDc3I2RiYSk9gaPFUx4siQM91ZAHdlV
 9TIbZz2Q
 IXQOZ3GD54LQNc6P+ytPxuvtvU6GKHhls3qZ/70Rp0m4YJ1rgKzZ23jXqMwr+5TFue9tA/wq3Nb+z2ZUKwiUo9RUu9CmWvJo95jw8CZ1GOSIvL60XSxD+p+7R/lj82UQ2J8EWv7FIXs0R25l2W/3W/3MJz4Fz7IEiEPMw7DrwHojjmHxH0Fb03GINpn3d40gKSopGxEfXgGRFbfubWtAgLmAOpqWhW0WeOC5OWG4b2UlceER8N04RgI1DYZn0u+N/8Sv7Q/t2DichgwiIdxLNr8XEf9GzziipFxzCCqUGzzab5XMuD7b4choPn/jgPq+rxClahDJZqxfQGPV1KQ1+1v+Jau9tP819MsBo97MlVgv5AFTtpvqleVvvL+J6K8PF4Jtd98V5KqOYhkFx650JaBbp5MrAgikwfVTms8QBvU+VH3faX2jMk9ItlYFyPm3wqrZ5tlQE6qEPblOiQq4nUyqmpCnROX8mJqIMJjmZ5t6FRHzkzshL66C1J843FGnAJ7xckeOSK8Vp5pcLLmObB+mfLrLKUZ3cmi788W89szbYN3y0JmWONWAI/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> To borrow David's words, the part about this that makes me itch is
> conversion. We have to support conversions. Even if it doesn't merge in
> the first patch series, we have to have line of sight to how conversions
> would work.
>
> Conversion requests originate from the guest and then the host handles
> the guest request by making calling an ioctl on guest_memfd. Hopefully
> this part doesn't change with alternative provider support.

Agreed, and it doesn't change. Conversions still go through
guest_memfd. It is the only one that knows which pages are private.

> Suppose guest_memfd still gets the conversion request first, in RFCv2,
> to reach all the mappings in various page tables, it would have to be
>
> + [GUEST_MEMFD] -> [KVM], [USERSPACE]
> + [GUEST_MEMFD] -> [PROVIDER] -> [IOMMU]
>
> since guest_memfd must ensure no IOMMU mappings to guest private pages?
> There's that extra step through the [PROVIDER]...

Right, there is a step through [PROVIDER]. But it can be a step through
the mem_provider code in mm, which every provider shares, rather than
through each provider driver. Then guest_memfd doesn't need to know who
else maps the frames, and providers don't have to get it right one by
one.

Here is the idea, on top of your in-place conversion. The VMM gives the
same provider file to guest_memfd and to iommufd, as in v2. When
guest_memfd converts a range to private, it claims the range:

  int mem_provider_claim(struct mem_provider_attachment *att,
                         loff_t offset, loff_t len);
  void mem_provider_unclaim(struct mem_provider_attachment *att,
                            loff_t offset, loff_t len);

The claim revokes the range for every other consumer of the file. After
that, get_page() returns a hole to them. So iommufd unmaps the pages
and can't map them again, and nothing changes on the iommufd side.
guest_memfd zaps its own mappings, as it does today.

Going back to shared is the reverse. guest_memfd returns the frames to
the host first, then unclaims the range. The other consumers then map
the frames again. So a conversion looks like:

  [GUEST_MEMFD] -> [KVM], [USERSPACE]
  [GUEST_MEMFD] -> [PROVIDER] -> [IOMMU]

That is your second chain, but the [PROVIDER] step is the common code
in mm/mem_provider.c. It does the revokes and hands out the holes. The
provider driver itself only gets one callback, and it can refuse a
claim. For example, it would refuse if it also lends those frames
through another file. Conversions can already fail, so this fits. If a
later step fails, guest_memfd just unclaims the range.

This also answers your earlier question. The provider doesn't need to
know what is shared or private. It only needs to know which ranges are
claimed, so that it doesn't move or share them, and only takes them
back once the guest has given them up.

I haven't implemented this yet. My plan is to rebase on kvm-x86 next,
which has your conversion code. Then I'd demo it with a
KVM_X86_SW_PROTECTED_VM and the sample provider. A device sees a shared
page, loses it when the page becomes private, and sees the same frame
again when it goes back to shared.

Does that match what you have in mind?

> Thanks, I will prototype what I have in mind too to make sure things
> work as I think they will :)

Thanks, that would really help. The sample provider and the KVM
selftest in the series could be a starting point.

Thanks,
Fred

