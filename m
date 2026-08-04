Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 009B8C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9F26B00E1; Tue,  4 Aug 2026 10:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E820A6B00E7; Tue,  4 Aug 2026 10:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0416B00E8; Tue,  4 Aug 2026 10:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5E276B00E1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:29:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2232A801B7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:29:34 +0000 (UTC)
X-FDA: 85063820268.29.29ED144
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CA094000D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:29:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hwueehHy;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785853772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MatVvvEPd/MRY44EkefG5o7Jg3gYi5AmY+X4QHCk1cY=;
	b=rtPwA4+zncnpfyOIfB1yl2XBbawQjHcQ9FIgPh1jlE6T92QJKeQpMa/ulVuX6u5S1BGegr
	6LjwsmHGOabgRdYfTMOKMdI3IooBsZQhD5WLh447Fp5AqZF/8wyCKaFVJciw4MkNLkp1QO
	lfOOb63CVhPSO7YQHKTHzCfYkwWxhuo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hwueehHy;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785853772;
	b=L46cpZesSCfrIvSNK96Kg+Fm7y64BOl/8JN1jg5j4EdJKGimepXZoL9Nhptxw7f95Nqq+r
	zHlWY4Xbp7jVfx9+mcW+hNiL4HEQJbhuIW7dDX10Ejdi3IeFgD69VvR0qK6AUi6s3u/nuV
	kM5MgibMVt2pNCnwPa0665YgRAGB2bk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785853769;
	bh=CJZscXcd9jlSmZbfO+HKE7sWYPbvfpCJX3EqrHKqS7g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hwueehHyhN6iMjR5EvaXX4oTQgnnhQwVdI60kO5yIcdEyKutsDlq80ySXlHIRwZwp
	 l/+uNBE6mhwajbrNd6gFV2UMt1t151diqYdM3qTs/ag7apb7GsjzUceskdr79iU91o
	 aSiDPnbgy26hGcznS4vc1KSDsomDuUVUHbxyXn0aHXjqfDGpcBgYC1FTZYjffCL9Lb
	 AnL9fTfbdxPL7BMelsT1eCTPAwaJDKTZaqQ5jv8hZLlEPmt/DcG+g4ECTu40VpQbJX
	 0+7dqxGR9WqbSlSslTNPbWK671Zjduz8qi0mkuIOJWTQM9lpSatb6bbE1eEg0AHS97
	 zu2L+pTAUkfHA==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2D0A017E06DB;
	Tue, 04 Aug 2026 16:29:29 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:29:24 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Konstantin Fastov <kfastov@gmail.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org
Subject: Re: [PATCH] drm/gem-shmem: Install writable PTEs for write faults
Message-ID: <20260804162924.0268f80a@fedora-21.home>
In-Reply-To: <20260804140403.16337-1-kfastov@gmail.com>
References: <20260804140403.16337-1-kfastov@gmail.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5r7a54rcj57infmgxn9t86ij7jf4kh43
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CA094000D
X-HE-Tag: 1785853772-667392
X-HE-Meta: U2FsdGVkX19tS+v8ZRluaScGkN+COFAkHXRUqYqdOX4l7oTWJO4IlM5hAfZQySCQ/OdjgZkxu1lAM6l7wwU2ev06BDKnPndViej2SM58UB/MmbqpzjvqTCc20/19V/qGc2IN4LmMMAhonsS94xA7wTtN0yqUJgBHpTX7nxhY/adWRntSzhNBM7UjXZIxPnFFKQ34uPEZQQDUAyOu/6tepX+Mcpc3MzkHNhapnxlxDg6LN2Yx4qnfYY0nsZA5Ez8ycV6GAl5A+P5jJ6aUuiMJ/S/Z+jnrBMIsmWCubB0V/M23zQa7klm+i8xrESxvuEuKpIM1pCl2I4lF3dBJBKFOTNbtrmFBxxiB7BcaOaPSBhSZp9dXr5IP/VcFre1+zvGqamK6ljbnqFZVvKKUTU71+246JYeDM3Vbs/3uJH4XJufi6dDYlRagV0qTugIukmJxobu1XleirjlCBiT52K0lskAjcYwzZ80nhDq3ZtIh/R1jCmC/gVaj8ohbEGt0hw6k/HQPUwsop+3T9LNq6lwRio2eKdkgSv9KR+vmCSIzTavTGxGd//h7FHqUvgIOJctA/JxbOCbKQ4SxvXiwjtDMXeH/jTwEF+Yvn/kax15LouKkz8anJvBfRYH8MWacC57mR0PlFInnp6Qph+MJfYuG2HwQ+8f3YZEq9Mtboo1ZC0MPh1ZHkrX+9j5wssgS5GQDOxjW0gNc0ikorhGycF39Sk+3Dym+nZ49tolB3jnkDbND+pgEx9kTBmBUU08t6KbWS9K2MIVnX6p6faBxdkw7DpvWmZE3Mfr4hEbndqW/ddls6uV23JpMowWyr6sKuUFh2mTOJMuIw26kDdkBjJGrGV56BD0uzuPxutCBAqwo2A1OKnsYBNSzdCQTZAqw9JsmAvN7RfCfjQ8XtDz/ospwM9ZETyWlddZ2nXpBZzlVzVpcae6ExHJN50owAFJHidaI7BWMUvEAx6ZZcMWog+0
 4UCQn9Yj
 LNmI3mkGQrNIDMszJ3dZ112ql893U9UOg355F64EhLm629W3IwCYNKKqDQl7Qds6LBIhh5d2QAtBkvqK9TlYb3ZZ/JQA2Aq1OD511FdN4+63Y/qoinKxYvjhU2BRIKLtok57V/At6F7M/FP6Vp3DCxiIEXC4rKqioNVnwhxZn64RIRXxYFfK1uiEX3680cCHByq1EGORf4uheYSvG5Eyz0yR/1f92RoA0UC/uzm1oLTao5XAK1RreKec+Sg3gSwZCBAayZvDzxXwbFp+V91Wi4DvkUUfc2RqiMAi4Wl0yJIUYeJLG1kQWcJs0K8YaC5zQOSF5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Konstantin,

On Tue,  4 Aug 2026 17:04:03 +0300
Konstantin Fastov <kfastov@gmail.com> wrote:

> Since the introduction of dirty tracking, drm_gem_shmem_vm_ops has a
> .pfn_mkwrite handler.  Its presence makes vma_wants_writenotify() true,
> so vma_set_page_prot() removes the write bit from vm_page_prot of
> shared mappings, and the vmf_insert_pfn() call in the fault handler now
> installs read-only PTEs even when serving a write fault.
> 
> For regular CPU accesses this is transparent: the retried access faults
> again on the present read-only PTE, goes through wp_pfn_shared() into
> .pfn_mkwrite() and the PTE is upgraded to writable.  But consumers that
> resolve faults through fixup_user_fault() + follow_pfnmap_start()
> perform no such retry.  In particular KVM's hva_to_pfn_remapped(),
> after "successfully" handling a write fault, finds a present read-only
> PTE, treats it as KVM_PFN_ERR_RO_FAULT and fails the vcpu run with
> EFAULT.  Observed as AsahiLinux/linux#560: muvm/libkrun microVMs
> mapping virtio-gpu blob resources die with EFAULT on first GPU access.
> The traced failing sequence:
> 
>   follow_pfnmap_start()        -> -EINVAL   (no PTE yet)
>   fixup_user_fault(WRITE)
>     drm_gem_shmem_fault()
>       vmf_insert_pfn()         -> NOPAGE    (read-only PTE installed)
>   fixup_user_fault()           -> 0         (fault "handled")
>   follow_pfnmap_start()        -> 0, !writable
>   hva_to_pfn()                 -> KVM_PFN_ERR_RO_FAULT
> 
> Fix it the same way commit cb2a2a5b37ad ("drm/shmem_helper: Make sure
> PMD entries get the writeable upgrade") did for the PMD path: when the
> fault is a write fault, install a writable entry directly and record
> the write for dirty tracking, instead of relying on a refault that not
> every fault-resolution path performs.
> 
> To do that at PTE level, add vmf_insert_pfn_mkwrite(), the VM_PFNMAP
> counterpart of vmf_insert_mixed_mkwrite(): insert_pfn() already
> implements the mkwrite semantics, there was just no wrapper exposing it
> for pfn inserts with the default pgprot.

The same issue is being discussed here [1].

Regards,

Boris

[1]https://lore.kernel.org/dri-devel/20260804120529.1730187-1-pbonzini@redhat.com/

