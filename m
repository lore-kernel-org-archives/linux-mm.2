Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4616606A32E
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwnEeaMF
Received: by kanga.kvack.org (Postfix)
	id 720F66B05C1; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC336B05C2; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0926B05C3; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5266B05C1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AFCC1C3AB3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:14 +0000 (UTC)
X-FDA: 85410105228.06.C7ABA50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8D1AA180002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwnEeaMF;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098652;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5Cd/VC6aFMP32fHph0UV0rTVC4GF8CgjbTF6S9e6Lc=;
	b=V/J3blbiRUbG+Kh8dfZH6kSY6cStyp9JbNQ50Pd3aJ8fBSlX31QTE72b2UBhQ0du6m44a3
	sTr3ETI21tverd7t9thePW9O7+s7XhfsjudMcBYqaXBhZCjxvxdcsfMPqcC8RShn1JMZxt
	v+mmfPdEawoQWZtSIHnpEhbAE4udWKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098652;
	b=PMOcS2P5rMx1M6OjTnErrYgOMytFLlxT7wvD3TceX8kfaCA+1DLUi8rWrxagVfTcyMELDk
	1VRlUtgdaNyOogWpUr6Wm3SY6MX8sTHsLlRFTpU8P3L/m1qLwnUVYgb69+tjwNPn+fm7aF
	t1X4mbRjtB5SvC8cKPAeHcodaqPq11E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwnEeaMF;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E53BC409CF;
	Sun,  8 Nov 2026 00:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E244F1F008A2;
	Sun,  8 Nov 2026 00:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098651;
	bh=h5Cd/VC6aFMP32fHph0UV0rTVC4GF8CgjbTF6S9e6Lc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NwnEeaMFpDr4HwL0jycs22k5go6EI2HbNKolbEPMKVV/MBMx1SZSnj3QssWkYGf5R
	 Dap/Ofy6yw7+SYqovorn4ZfK/9TZ8Y/N4QsV2lnKLZCx14vRbF/bnBVDQrnaTRJm4C
	 e3z4NpNHyY3gN669yrw6WTN7YThxXClelkxmre26uazpUXCOf5YXHd8nJV7c+JtVxO
	 SC8QCK9J+b0MRxWztmJJXlEW6m2t2vdHSLd5xDmadP0lVP/p1vNgqGt4BCzTvMjKs4
	 wCEyw6hW2w7OTOGohLpSAvYjrfsx65kxNuJ95NkPpH1kyN5IASsfxJAKHGITkJYlkK
	 vWCtV5OnHCKqg==
Message-ID: <sashiko-outbox-203459@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 48/88] samples/kvm: Support dynamic revocation
 via kvm_gmem_revoke
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-48-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-48-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:10 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D1AA180002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3h6hnckt8bwgn1jfhk1gfimxheeju8a7
X-Rspam-User: 
X-HE-Tag: 1794098652-135482
X-HE-Meta: U2FsdGVkX1/FUA/v08gBgBOhQqIbv9jN5EEnkTUE6623wKi/5UABDb5Wx7ZU3l+3InzIJru2cuWqSw1eI101pykW3HjvHXOU6U9jdsMMkKCRpIgspGQN9jWSYG0MV8wAVUWNbb6cK2K7G6thxYOeTMbhPQC69/YvSl+ArdCFRnf4pilD/2seuJLqkHvuhp7Kfu6oFhsCFmucahAFnoMXuE4kcVt5J/f2CepUrJtwT0PI/XiFYOdXrr+tWeamRpfjEzIT287mQ1tucoVcVEMtnhLMyGvH7EQ7iIJbdzOQZd83fGWdejIuUOCB3BOd3E82BLvQ5B0icL99YrKNYsMi9fISD4doXdEj7n1BI/o8Q4IMALihW8BO3yEfYH+9LJIayOMKiyhBv5/synyl3JF8GpiEOu9Q7+p2fgpS3nJ/nPv3pjPmSsrdDNHM83lK3pA/erJKPWK4Wi23ejiCrLDnwW2Qb2JCvrDgd17AvPJ4SgenbM0UCcaXfewhgJO8mq15th/lBVT9tUnTWBsbbK9rCL+EcJFnOlwbJ9YHXVKmlWRNJOiv2JkL6TcB1M1PN0BoexIp4c8XS1eG9lMzOWe0rI0hdHbn5Ua6ww+dAAu1+9J/4H0HCQeNNO0uaWJBxl8NvbFSJVkHyFckwvM/ht13WMfSmAmqBNaBSHI2hOnt8qF22SJibh+nbmb8xhjyCfFizIUsn717gnFPip8YkhCIu3cjzvhfa7pcvnNLjsPDZqCIHmWLHcgBpCdf634mn0ew4BJ5Om2BXGRE4jyHaUnHA6QRTdXhxWFXu5J9AmxLmDsBmDahjZB38UBmTkrEwUDSa5QkUsKmYKqYawOA5lPLdrtVtQ9c0lyu22cG6Yq1P3NokUE0vx00jGXb/vaBxCsNBAdPkcH2JP/9iSgO4NAtdnW8+wf4nFnZHybNxqZDOdhMjk80R49dVy+paVW/+8FUz4ViD3EAPcZk7EUi0Ce
 PKfq5XRX
 BdDCSHj8y3hLKxuIaPtt6bqWrAensmyDbS0CrpITDT2olU7/BaQPfmSn7ZK9QAEsh8966hAL6dtpjBDDwu0csAZK/7Kv0eU2H5M30r1O4EXC8qBRngIuMXfdWdZTIetPTW4ZIhOQsv16RkRbIQW6GZe6cEmLq9hjH4FX6phuZtLLbg65tB5glcJTxfHZtHQQalq/WJZCYvUlXEBjzzID2qtYiwRD5oJ2vSGY/08Gc7rm29/0XeZLzmsXePXv1zXJPFm+FDeVME9s+fS1D12Rv37jg+bS9yArLvHqzCbDEqQmOB0r9Awe4XMOvk88u3hzC3RWWICkG00a2/Nus4mSdPM/gGQrJJO8BqLH/bm0Nsj1ugPxMOca9iyv3wc1Q4UMoIOndTuvlp9ajI29qgb0DqIH63x7t1Z1IfK2Pxwy/ihBhoC/P+2jAiqlLwIHjjZ64hORQJVx5hf7MR8GGucNrWghfq4xO4IK1YNQADUWpQqCShxo7V2evUL8BBTWFbntos7x/uVrPXLb2lFqDsYB1CB/MCd7yn3frCOI79cAHnh46FcvZ3xwtj/XplFXc0oJwtxbILVSPRadRMHkWncIjQ6uwTUgbgvZ1z5ElETXfoPLuhYVT3Bj/RDGa4QA1RdtGtuk48YycB8RdTP/qvs8o9l5vB3HxL82HWl+BxGGDxsqWXuk4UcY+fQ118xHiMAI2Eia2r8w2lNYGsa0Ed8JDaaM+1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] samples/kvm: stale identifier names and patch references in
  commit message
--

commit 42b1d24c6caccfeaf35dd92048463c002a041484
Author: Ackerley Tng <ackerleytng@google.com>

> samples/kvm: Support dynamic revocation via kvm_gmem_revoke
>
> Support dynamic revocation in the sample memory provider module by
> calling kvm_gmem_revoke() when pages are marked absent via
> MPS_SET_PRESENT.
>
> Note down the attaching gmem inode during .attach() and disallow double
> attachment to the same provider file.
>
> Clear the revoked pages after kvm_gmem_revoke() using mps_zero_range()
> to ensure that stale data is wiped and cannot be observed when pages are
> later marked present or reused.
>
> Regarding locking and ordering:
> - In mps_set_present(), mark the absent bitmap first before revoking so
>   any concurrent page fault immediately sees the page as absent and
>   rejects the lookup with -EFAULT.
> - kvm_gmem_revoke() is called under info->lock to fully serialize
>   MPS_SET_PRESENT operations against each other and prevent races
>   between marking pages absent and present.
> - The PFN passed to kvm_gmem_revoke() is derived from info->base_pfn +
>   start. The mapping between page index and physical PFN is static and
>   immutable for the lifetime of the provider file, ensuring that the
>   pfn mapping remains completely stable across the revoke call.
> - Passing pfn directly to kvm_gmem_revoke() allows guest_memfd to
>   reclaim the physical range directly without calling back into the
>   provider. This keeps the lock hierarchy strictly top-down (info->lock
>   -> filemap_invalidate_lock -> mmu_lock) with no callbacks or deadlocks.
>
> For now, nothing needs to be done when setting a page present, since users
> should (re-)fault and (re-)obtain the PFN via .get_pfn(), to be added in a
> later patch.
>
> For users that don't support faulting, like the IOMMU, the counterpart to
> kvm_gmem_revoke() will be made available for the first user to indicate
> that the memory is now available. guest_memfd should then do the page tab=
le
> mappings as necessary, based on the shared/private status.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

[Severity: Low]
This isn't a bug, but the commit message has a few stale references from an
earlier version of the series:

- MPS_SET_PRESENT, mps_zero_range(), and mps_set_present() were renamed to
  MP_SET_PRESENT, mp_zero_range(), and mp_set_present().
- Recording info->gmem_inode in .attach() and disallowing double attachment
  was already done in commit "samples/kvm: Implement attach and release
  provider ops in sample provider", not in this patch.
- .get_pfn() was already added earlier in the series in commit "samples/kvm:
  Implement get_pfn provider operation", rather than in a later patch.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D48

