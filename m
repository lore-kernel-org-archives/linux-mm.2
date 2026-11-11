Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D0260A2613
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Dx43tSGZ
Received: by kanga.kvack.org (Postfix)
	id 38B3E6B05B1; Wed, 11 Nov 2026 00:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315596B05B2; Wed, 11 Nov 2026 00:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDB26B05B3; Wed, 11 Nov 2026 00:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9F36B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:37:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CF57120213
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:37:03 +0000 (UTC)
X-FDA: 85421729526.26.BA34D69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E5861A0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:37:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Dx43tSGZ;
	spf=pass (imf19.hostedemail.com: domain of 3-_7zagkKCCgXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3-_7zagkKCCgXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794375421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLmVTYOfswJ+cGfMoCZUFy1VK5TCu4veYLS+0REM4CM=;
	b=xYNt2ygl8w4KAwEUzfIQ6rAll66pYo/rlcOp1HxueFwYSjyj7Yx9yRgMo9O5HRhD4vnEiO
	9fje+b+CZFt9oSRRzMf0ZBFZAS53ngFNDW0Luvar1eQTxpAfouX9BrZIsDieGmXSvBzx1t
	whopR6erpMrLvo9y+qeZdFpH/7+7MYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794375421;
	b=6u0Fm+x+CQvg/tIIjza/beQZrMDgitTDzT0JWWd8qB2dTg4bTDMnYIMJDBwHECXLcNRueK
	EbwTWYH5OANGdwBr4FCW81dT9gOSVZGiBgB0OZcSL/CFEBUp3AtHyJUZIqAQ3CXhsA9zv4
	DiRVcFUVPOxpTmi79dkQiByqEg4F3+8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Dx43tSGZ;
	spf=pass (imf19.hostedemail.com: domain of 3-_7zagkKCCgXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=3-_7zagkKCCgXEVYRWELYKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a0284121c6so20822365e9.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794375420; x=1794980220; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eLmVTYOfswJ+cGfMoCZUFy1VK5TCu4veYLS+0REM4CM=;
        b=Dx43tSGZl2ltrZqLWq0+nlIpN3FSoXFP3j/0V985blLyYjBCwvkax5EG8W6LLLcrwK
         Fq0CaIMVDQkiMrKtPm/v99tGcMXXSPiTugpWCPLu25wagNbTyYvVTP77KcGpbemm97hv
         EIHgoneu7GOxN38942GESGy5vUmvq3L/NtvPUhnYzcZlh6AmPsi93t/me/vZanPx7THG
         RBtExSfdwgxs1AU34iJ7BhoDN1s4X8G97C2Nk8MGMgUBfdWLW04WC/tCgzQMju+d9+Gh
         iwoGoAwyDJexHr9sFYAHllzG6DVdZBXFG2aN9M2Q6f+ngKWshnnj6c77zZblWJdwhyQp
         AoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794375420; x=1794980220;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eLmVTYOfswJ+cGfMoCZUFy1VK5TCu4veYLS+0REM4CM=;
        b=jAmV3XnthLLq5i9pbb+r/5J4S8p2fxSL/SrRsili07AjImbbbYmq2sfJ7I4Ifauly6
         KjQvgtwOU/idUZ+wnldVVfzRNloeJorQTCxSEtr64WRITcLWXpGVV37ivPB2xCGSucdv
         bsF7q2o8hDB9HrSMaikCYjktzuHUFm7+4x8XkHfO5eSgYm6wdkKPook8KpgFGJZR/LkY
         avHb/fDUH7uqtHU1QGYbzirCavbLNZj7aXZ+oD8l92iD0sHH7oUnr13nawc1mI+KX5J5
         P1OnV93iSro37fB810sXg0oq1k4sJCjAl9nWY9mZWiF8IuOZ4awmHibTQWojQtPy7Htx
         nIjQ==
X-Forwarded-Encrypted: i=1; AL+hErHMepZyQFzpDt9+8wk+HkhKZzvUM2VN+KHgZYGepi0Y3QbKab1/Or//szp3YIc0dIhxW8jrBm/3Yg==@kvack.org
X-Gm-Message-State: APuU4Z8X8FERhiKAOYO2lAVqXQhnYoOabbX3ahVLhGOLpyfZN0NdiBQR
	i2MTxCwuSrIjGfOQ6biR4VWCG/gYMqKV1mNkcJPhonSJhId2YW0WkK4xC0XA4OJhHq6gPN4TMit
	Ak5zErO5g43MUermFeg==
X-Received: from wmsl10.prod.google.com ([2002:a05:600c:1d0a:b0:4a3:5d5b:9ad9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:810c:b0:4a1:fbd2:f689 with SMTP id 5b1f17b1804b1-4ba09379cc1mr15865455e9.7.1794375419814;
 Tue, 10 Nov 2026 21:36:59 -0800 (PST)
Date: Wed, 11 Nov 2026 05:36:58 +0000
In-Reply-To: <DMRJJX2ZSYQT.2U1TTBGE7R4RA@soleen.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com> <DMRJJX2ZSYQT.2U1TTBGE7R4RA@soleen.com>
Message-ID: <9huz5wy4q685.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 00/19] kho, liveupdate: Add feature header for
 fine-grained ABI compatibility
From: tarunsahu@google.com
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: rw6q9mmagsg1mhhpcjnnijpcyzjy6mux
X-Rspamd-Queue-Id: 4E5861A0005
X-Rspam-User: 
X-HE-Tag: 1794375421-511486
X-HE-Meta: U2FsdGVkX1/XJiBnBwUyUIQoWeMifI0QO8p9v5f2UAVExA0//2dtCA1I58MuJmgo8MTFIptGEetotP1b1iGVIIF+TD+w6tkUXjumTj2NxXHuZ+6J5vP8ykkIqfZUyEGufwXZe7rOQHMBN4e5tXl4dnu+1hJCg3gbV0qsd1D9yUKKKsDSTnu1Ep5MLV68sKpH44c0ANUJHRdKFkD4wsYRJycwbjYoBb6AsMIpSpakEnoFOgSC+/y3GEXDTjmQ75qBjWaZ/n9BerYGlQPgd9hqVCHE6JVIBY2AlBlZMuziDucKiTfwo7JeO+T4KNqF2kw+ZRlrMmGjzAIz38Sf75e42wQZrkaRPT+VtdeOE+DlH+W4EJOBcr5mhsx31XU3cvlGypiy9NiZyeW41QwI7vFc994efrLqd2ReFM0zzw3Nr68Qqe6kTAmLf+B+CDtQDlU/22QaQo8hEIYL8vePy+oy1gRECp9FtUHW3G1vv7ibo8IIok+HnAKajCAMjcB+ZXPQNRDJU6vuatvOkM0V9KSFMSYG3pYASsb9LWp15qWXTWXfqf5iOD5its/+YAQXf9iO7GEmqpC28IcLmEo5sp5QEATC67uUXM8BLJefylGTyVK+fyX8kfqY2mbxF5eTuAu3SNxks0CC2x+72yYra1mvsgaasVPs/p/7dFeuSTu85Uwd2xfQB2uStZ5Vlm9hVvkWqo6zAkt6sE+VYT+7il7YGy3AyCp5H6MZ0C86EMN2gNczuMqf6NmFZa6fs29U1hQmuj06hzf7bRUYOfs78NiY2H9OnD5VLWfFKcBIYET+yrzlHXcP08xWCVv0Rakb/NqRzjqmhiM7fPGyLndR5Ejajr1qU6/qNptBc9jrocs0U13KsYgM2UG4cnMjQVp/zKYEd9zO5DrPXelKTbsiFCmFgYersAIrK/GG1jnnTytTghtrEN5z1b9LCixWx65FN/7bwjel0mohgIoYD4NSFIF
 O1vDLrym
 14fJFoOFanm91yB9oU8iZPwtgzwpjKD1zg+iV6XSHgXiQJagKB3w49Zzp/6rQCr8rfdnVKjF370czKKtcyYNkWrsnZLuQsm68kQz9VakQa46ItK3b1F+gYMQrQuXQ/yfGYXdVte5x9xN/qb4qhwFxkfUwb0yUJyHkJlmB8oPHDfXsEmcnnmbg6t+E/QuAkYVnlyAgRsYeX/mBFAtkyeVsXVU8JgkR4G8cTDSZbzV+zovYo0mZy3VvwGdEIz3N0Dix5NqN2ZfMHLly+vntT1LoCbk0nPS6tSuE+x4Q4+kyikhD8jMbqLShH+WrOu6JZgGoiw4KChxxWafoosB1Kn5EgFpNTTzVy1TvXUvPW07wVi7nXdVQqf8i8++71wCAtDE17ndKKpL77+8w27z+YiZROG1PmH58/QD3hK/9+8/0vPUD0ld/IDVTeT/5GfMMFMOL/d3XQcd9txLZoZ4wEbmQmG7avyyYNblx461SqvHcotbOxkiZ2qA3w0lqelQSnc+fh9OI6YtkRkh9JcXFo2CTwVOTuBY5lvIS/xxgw9lRw99+eRUWPjXBUlLlFYA7Ke7RmTQbLurukQDe1G1ffgy05ogoG56TwxN82o7riSur/4KOC7hbp0e+DbOwu0l+ob/MLb2ltWdbpPlgPB83qF6oEjBzcgB2EYJfpjTE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Pasha Tatashin" <pasha.tatashin@soleen.com> writes:

> On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:
>> This v4 of feature flags support for LUO and KHO is no longer an RFC.
...skip
>>
>> Each serialized structure is preceded in memory by struct kho_ser_hdr
>> and registered via DECLARE_KHO_SER(name, payload_size, nr_required,
>> nr_optional). Both struct kho_kexec_metadata and struct pci_dev_ser are
>> explicitly marked with __aligned(8) because their largest member is a
>> 32-bit integer, and 8-byte alignment is required by DECLARE_KHO_SER() so
>
> I do not believe we need __aligned(8), because the struct immediately 
> follows the newly introduced kho_ser_hdr, which is 8-byte aligned. 
> However, we should verify that the combined size (header + payload) 
> is 8-byte aligned.

Yes, we can check total size alignment and remove the __aligned(8). I
will update it.

~Tarun

>
>> trailing feature payloads remain 8-byte aligned across 32-bit and 64-bit
>> kernels.
>>
>> Also, Introduce DECLARE_KHO_SER_HDR(ser_name, fhdr) which is just the
>> wrapper for struct kho_ser_hdr fhdr, This makes it clear
>> To which ser_name, this fhdr belongs to.
>>
>>
>> Series structure:
>>   - Patch 1 removes __packed from KHO, LUO, and memfd ABI structures and
>>     asserts their natural size and 8-byte alignment under CONFIG_64BIT.
>>   - Patch 2 records entry_size in struct kho_block_header_ser so the
>>     incoming kernel derives the entry stride from the block header.
>>   - Patch 3 converts callers that embedded struct kho_vmalloc by value
>>     (memfd_luo and test_kho) to reference it via DECLARE_KHOSER_PTR so
>>     struct kho_vmalloc can grow independently.
>>   - Patch 4 converts struct luo_session_ser to reference
>>     struct luo_file_set_ser via DECLARE_KHOSER_PTR instead of embedding
>>     it by value so both structures can grow independently.
>>   - Patch 5 introduces struct kho_ser_hdr, DECLARE_KHO_SER(),
>>     DECLARE_KHO_SER_HDR(), and the serialization/validation helpers in
>>     include/linux/kho/abi/feature.h.
>>   - Patches 6-18 add the feature header to each of the 13 KHO, LUO, PCI,
>>     and memfd serialized structures in independent patches.
>>   - Patch 19 adds a KUnit test suite (kho_feature) covering the feature
>>     header helpers.
>>
>> [1] https://lore.kernel.org/all/20260903023452.721732-1-loganodell@google.com/
>> [2] https://lore.kernel.org/all/20261021152527.375070-1-tarunsahu@google.com/
>> [3] https://lore.kernel.org/all/20261026174217.603114-1-tarunsahu@google.com/
>>
>> Tarun Sahu (19):
>>   liveupdate, kho: Remove __packed from KHO, LUO and memfd ABI
>>     structures
>>   kho: block: Record the entry size in the block header
>>   kho, memfd_luo: Reference struct kho_vmalloc via serialized pointer
>>   liveupdate: Reference struct luo_file_set_ser via serialized pointer
>>   kho: Add feature header for fine-grained ABI compatibility
>>   kho: kexec_metadata: Add the feature header
>>   kho: vmalloc: Add the feature header
>>   kho: block: Add the feature header to blocks
>>   liveupdate: Add feature header to struct luo_ser
>>   liveupdate: Add feature header to struct luo_session_ser
>>   liveupdate: Add feature header to struct luo_file_set_ser
>>   liveupdate: Add feature header to struct luo_file_ser
>>   liveupdate: Add feature header to struct luo_flb_header_ser
>>   liveupdate: Add feature header to struct luo_flb_ser
>>   PCI: liveupdate: Add feature header to struct pci_ser
>>   PCI: liveupdate: Add feature header to struct pci_dev_ser
>>   mm: memfd_luo: Add feature header to struct memfd_luo_ser
>>   mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser
>>   kho: Add KUnit test for the feature header helpers
>>
>>  MAINTAINERS                            |   1 +
>>  drivers/pci/liveupdate.c               |  99 +++----
>>  include/linux/kexec_handover.h         |  15 +-
>>  include/linux/kho/abi/block.h          |  21 +-
>>  include/linux/kho/abi/feature.h        | 372 +++++++++++++++++++++++++
>>  include/linux/kho/abi/kexec_handover.h |  11 +-
>>  include/linux/kho/abi/kexec_metadata.h |  17 +-
>>  include/linux/kho/abi/luo.h            | 102 ++++---
>>  include/linux/kho/abi/memfd.h          |  27 +-
>>  include/linux/kho/abi/pci.h            |  66 ++---
>>  include/linux/kho_block.h              |   8 +-
>>  kernel/liveupdate/kexec_handover.c     |  98 ++++---
>>  kernel/liveupdate/kho_block.c          | 172 +++++++++---
>>  kernel/liveupdate/luo_core.c           |  43 +--
>>  kernel/liveupdate/luo_file.c           |  58 ++--
>>  kernel/liveupdate/luo_flb.c            |  69 +++--
>>  kernel/liveupdate/luo_internal.h       |   9 +-
>>  kernel/liveupdate/luo_session.c        |  55 +++-
>>  lib/Kconfig.debug                      |  13 +
>>  lib/test_kho.c                         |  38 ++-
>>  lib/tests/Makefile                     |   1 +
>>  lib/tests/kho_feature_kunit.c          | 184 ++++++++++++
>>  mm/memfd_luo.c                         | 183 ++++++++----
>>  23 files changed, 1271 insertions(+), 391 deletions(-)
>>  create mode 100644 include/linux/kho/abi/feature.h
>>  create mode 100644 lib/tests/kho_feature_kunit.c
>
> -- 
> Pasha

