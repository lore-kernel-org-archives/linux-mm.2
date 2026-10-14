Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AE1CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD276B008C; Wed, 14 Oct 2026 05:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4F26B0099; Wed, 14 Oct 2026 05:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4FA6B009E; Wed, 14 Oct 2026 05:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 982506B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:57:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0B561604C2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:57:07 +0000 (UTC)
X-FDA: 85320778494.11.E69432E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id C4909C0002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:57:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=adaYzdT+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JhQ5yirY83poEzPx8x3H8aN7RnWItIKkuGofgEQwLq8=;
	b=d5LXm7j7JceIodnT8B00DcBCAIaFGMvAIhCv1Hu7M/CTR5XxntZoWlp7+i7OiaPbzyVNTT
	EYfz/3YULEjd0XLKZV54IgeyQYtkb8jigc/xyYXTGHnaV0KDagQw7eeSxFlcfUalpWERQh
	cfIwJ9qUQ5ixuJJBJ0CtAVupQwXWuIk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=adaYzdT+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971825;
	b=qMrNWjFaOX90QLwBrjqoVbyyfa77KOav0fjwlac0bHajsoKSYPUJiEFx4Fck/bMWKhxpGE
	3pQiQ38UWBBGq3ZbpoUcHX3+Q5dY3/QSJaP/nDmUormvT4X16aTY1e6pdQxwxaiTnBzSum
	HXcxcO8vSCJ/RWUAHMg+p+hknuDBYH4=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a171b677d2so23756455e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791971824; x=1792576624; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JhQ5yirY83poEzPx8x3H8aN7RnWItIKkuGofgEQwLq8=;
        b=adaYzdT+z3YNfcKJSYd4uhY/UOn7luV6H3q/0W6+2nCW2iy10JZ9pQ+I0QObfz+KXM
         52PFgh/6DKT6AXdRGByqwq/MBgFoxIMifDOKp/3n8ZBCDspXjBpMm/VqGQY2eNV2apyC
         SJewdWZhPttUFw4B1Go4+XGr/BLV4goedxaeK4JMSZn+eaGJ6URVIooHCPuFNxlv6X31
         CHWcU1PZILToNMRKtvem5r6Kf96TDJYMMp3V2A+U72fPvaMgYok6RbzvTsM230JLDuDM
         THtf9CUM0sRSZYX+cn9n5ms/B+J68hfnCM4b92289lf6LeWPBRG7AuR5HmddQvNFp3Tx
         2JEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791971824; x=1792576624;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JhQ5yirY83poEzPx8x3H8aN7RnWItIKkuGofgEQwLq8=;
        b=y2wlpIJpswVkYbAYQJekkpa/hqsslJzT+RVSB/vf0XKweiD5x2K+lg1QapoSLXEnpl
         X4uj+cZ9wQB72ggpdGSK3zglUTPG3+2z/zqAGFwANG2GObOGJNSi0SSdccktP8x+KHaH
         Y3BltcThtWkL4zIXVEYgXMWJsDo+Zh1FU5RC3s6Thp2jUVzhHt4btLZvOHbrwJSTOEOH
         0GWMx1uvkgA5ZDzrHaPdiyqkObDXgF0WUTayVWqy9I8cBEiu0932yX+7vTI89V5BcWzX
         LWms4nUA9dlK1oZ02Ynr2xWsoAFgbpSYFzdbTwHOZ3SN7V+zjjKyPjtXH6FPhtiVn5it
         4ssQ==
X-Forwarded-Encrypted: i=1; AKwUvBxhU0v6c92r8dUzh+OuyIq8Juk0d1TuhE3og9Z17ovMbj1GMEyhNRX4hpe2E8t8snpU41HWryBEeQ==@kvack.org
X-Gm-Message-State: AFq9FYKVe3TQDjrB2CPMp7Y2354VJndlkDAyP5acMyuQ404B7ngakpZS
	1EeOx1xiP4jgDcZmIoYrLjiGiZMU+EAc6nhwN0y93zejtjlxh2/3jRjk
X-Gm-Gg: AYBFou2G+yA5u1xgoeIZMGr+RVWmvVYDH7pqQLoNHU4t5aRubXTxxNE3ouYO42KBXYX
	obx4UfPeEPpD9PmN3kJzANq9VN3BERM8LEHIsJpzADEzrFLjsD4rGxj1l+ba+1HUS1wmAD2fXOC
	6W+d3jh/I/TvzVeOwkZmzdy33+TTe+K7SckbHDe3RKJd18VNzmaRwqbq/4yGL8oZ24xIVYEfPd1
	byVFdzgKvRLkXWMKdHpjf/DcH1CCrvcrVzMB3/VU6Qt4cJTHZtidyXeacDPFOtAliayoMZib5Es
	EDYhWjOG3sqnre9G0jdvhEk9kJ7p6W+b16yVsdm9PRl/7HsJE5jTsH1k5C1pcnZqZcXCyNoQYeO
	ohpbDvcb4W8QFgzxaqtOra+JVxO+5gBlJwyVTnNGJMDolqksUQnxj+7Qzzq2z/Do+1voeslejJm
	2r+t/kV8LBcmJFjOj+mCqBfs8/D6hlyaWWM0fYyxFVgd4u/8KIXE9LJU7fU2MfBWGbuWWshN7rG
	f3c/ID20YZ0m9xSty8MzcUK8A+eN0af3nc36m6gHjAhx4mbwmS+/R+wuHhzvP3alkMO7EZ8vRQ7
	4z/rdKjYuxelBnnoX5zXhsDUcuot4zIJr13v
X-Received: by 2002:a05:600c:4747:b0:4a1:80d8:aed0 with SMTP id 5b1f17b1804b1-4a18e4a9862mr311763425e9.15.1791971824195;
        Wed, 14 Oct 2026 02:57:04 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ac5257sm11206338f8f.42.2026.10.14.02.57.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:57:03 -0700 (PDT)
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
Date: Wed, 14 Oct 2026 09:57:02 +0000
Message-ID: <20261014095702.39676-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org> <20261006183235.16576-1-griffoul@gmail.com> <CAEvNRgEseLO+LbkwXrEit0H2LH5Wx-srSvHEMpt0=upPL3tF=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qq1cwb35ucyzx8xbhnoreb3ujqxjbj7r
X-Rspam-User: 
X-Rspamd-Queue-Id: C4909C0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791971825-728721
X-HE-Meta: U2FsdGVkX1+Rs1S88SihhIZvH2tM72mUVJBKGycHMnD8Ht+Os7gUwBJXaHYNQzRm2Hjm0SHsPjU/vMReQPdnfDhKvJmchnuRrdy4to2GT0XQISm9x0sD/inOurpVIul9qKDDdNGQuXPdCSfgWLX6QAT/INNMTSx5LGfvai2fjbzLhcnQIHfYvE4c8aFTR7mRGD6HC/pCeuMnvC+gqozrPJW+A/LDuS/E3YKq18ZD2U0lb23F0oJ/EFBSEc2dP6Ebg2SEUpRUjpFlwg6dxnjJPgrdfw+k/KJ+Ufs18NJgvi/Lof9zRnjs/8pt/OICt05gP7aTxoxxtXNhpa4uliORV53RtWmslyIOcVhnfkjv0P3tUej4ZWKYfWSLWot55rkk9oVEGwqei/crneQdKbOPhRgB/P2UGMmAyjs5W4scWt2Se2ApQDK+SLV+epeT+OYzaj4IKFfm/wh+fE5mxFKBMdyKmGI7X4rMgI+21UuzUE1yTiRkfmOoV09Ogov2r1e9ili6wKROSWX/AVRjxaB3F1vIIL3ktqXjhZP02e3G6YJqYzjRQYbYEvT+LXeIDq4wnldJ9R+THjjbrfziirEM/9NHwBiTrIIFNAmppTuAr5Rp4wk3872Ddctq6AUUK5wr0rBz3mfFVaZLW1kJmUZn/Sboeu10ZlFFpRrxPuWa6/VFVybUs/L0f+bjOEZE/Aasjtzdl1ZB03kVbVQfWGG/9xu/xko5bqOyAoIx6z3xl55NJo38Tz+Waio6sOB0LZEDYSSOF8I+hz4kOHk9oMXD8c2vw05nU/i5RnWEJ6O5/fxN3gP4LFQm7RN5EtCMs2TrSjuvxJ/BC32mVbGMGC5hSj5heEXINvficscN8f7EJL1vvrap9G7ceRYplZDDomE1niV7waUJvkMjF3h2tAroa+9gp284QAcu3R5bq0X1osWBoL8b/I1hWpIF0YT2dl3zBhzjrp0/T33Qe+BNQOU
 EGSD0pBo
 t8PPIPwwai1yh/+3YXiJBrWbhPmlcQ2QLvxnhaEe9Y0N6UoT2X/9q1Gs3Bd23LY5MAFwy1DbIt3k3XQLlnb2SeyE8qLIidEP38Mrm2v1WpY2QK5mL7a4W//m5Eoj+WP7kFg507FAEQMSj6zYlZrcFjZzoqu4HUGTZZIK0WtRARDaqke0nstkv/qS5l8wC+eyyMjY9yZhIQcc4CUmTMBZNR9uIh07o5zrTXxbEysZxLE2YzJPp0ab+Rb+P66arQw0FrXunT0Clk6kurbce6IEm8PW9dKYosimCVy1rO1adp1Pao2L+jUrFZ6RvfCd72wpmoO+HlJ9wD3q0Hkl5LWADJSIxUt7WK0+0ULzzgwmd9kXWZyApi6T/LGkbTdHJzLyQ2b6L3Wyj9UZrsE/e9WpuJHR7vhyLHwmRq+fXQ8k5KIe9lGQwgr1qelR9IKL/veh2actR38i0qtDY9N88B+5DU9ndx2oCgI1Xeti3oJYfiM4VyxNFj8qvzz1QLviMTHbGwFGOVP65Yscfn0Mu3jlXdOJ6PGXiZWCVgInPAclRw0k5INssDz7DrAQ2R/KDBe3F2uqrXYwY/qv82V/p9MyoYPjUFFkqI8f5xz3IzxCte7GFt8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> When the provider wants to revoke the page, the notifications/function
> calls flow this way, the last [ENTITY] in the chain actually does the
> zapping.
>
> + [PROVIDER] -> [KVM]
> + [PROVIDER] -> [DMABUF] -> [IOMMU]
> + [PROVIDER] -> [GUEST_MEMFD] -> [USERSPACE] (AFAICT this was not
>   implemented in the RFC.)

Thanks for going through it. I have just posted v2:

  https://lore.kernel.org/all/20261014093733.90312-1-griffoul@gmail.com/

It changes two of these chains. dma-buf is gone: iommufd attaches to
the provider file itself, through a small interface in mm. And
guest_memfd now maps the file into userspace from the provider's
frames, so a revoke also zaps the VMM's mapping:

  [PROVIDER] -> [GUEST_MEMFD] -> [KVM], [USERSPACE]
  [PROVIDER] -> [IOMMU]

> IIUC guest_memfd conversions was not illustrated in the RFC: what
> happens on a shared -> private conversion?

There are none yet. Only VMs of type KVM_X86_DEFAULT_VM can use a
provider, so all their memory is shared.

> Does your provider need to know if some memory was transitioned between
> shared/private states? The provider can be notified too, if
> necessary. If not, then isn't guest_memfd doing all the coordination
> better than going via the provider?

Our provider does not need to know, and I agree: once there is private
memory, guest_memfd converts the pages, so it should tell the others
what to zap.

I think the two models meet there, and the v2 cover letter now says so.
The iommufd side of v2 does not pin and keeps no references: it asks for
the frame behind each page, treats a page with no frame as a hole, and
maps again on a revoke. guest_memfd can offer that for its own file:
shared pages return their frames, private pages are holes, and
guest_memfd revokes a range whenever it converts it, in either
direction. That is your [GUEST_MEMFD] -> [IOMMU], and it should work for
folio-backed guest_memfd without memfd_pin_folios() or refcounts, as
long as guest_memfd also revokes a range before it frees its folios.

The one difference is that v2 also lets iommufd map a provider file
directly. Going through guest_memfd would add nothing without private
memory: it would only pass each revoke on. And memory that only devices
use, such as MMIO, does not go through guest_memfd at all. Both paths
would use the same iommufd code.

> Does the revocation model work for you? If it helps, I can rebuild the
> sample provider to illustrate how the revocation can be done.

Yes, the revocation model works for us. v2 replaces David's sample
with one that moves, donates and makes pages read-only, and a selftest
that checks the guest, the device and the VMM's mapping after each
change. It may be a good base if you want to try guest_memfd as the
provider for iommufd on top of it.

> 4. [DIRECTMAP] Kernel direct map.

Agreed, that is separate. The memory we have in mind is a range hidden
from the host with memmap=, so it is not in the direct map.

Thanks,
Fred

