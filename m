Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DCD606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=q2DWio5k
Received: by kanga.kvack.org (Postfix)
	id C03356B05B1; Mon, 16 Nov 2026 18:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAB56B05B2; Mon, 16 Nov 2026 18:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0456B05B3; Mon, 16 Nov 2026 18:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8536B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:57:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12CF11A026D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:57:56 +0000 (UTC)
X-FDA: 85442647752.14.C04C137
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37381180002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:57:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=q2DWio5k;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794873474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNMtaHpahG58C4CDJTpyGiQEPKrM5bilgLdnVmpa1D8=;
	b=gKYbeu4/nsRPM4oZb5q20ExiSMJ/l0UNtimn3qz1u8GJ9KQyVqjOjo2v4YZtUM5fjzvmHX
	uCN9myHI/YtQz1LxZS+pvhQCPrHT8GEMNhHrRktpU2eV6BtumiJJxgSJVZNtQt1Fquj7cM
	5pIHWZ2KkjOPDufwaKahhVeKFQpuQw4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=q2DWio5k;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794873474;
	b=vQ3b/g5KO8i6Sfvx7799s3IxHrDOGVbZh120by3NFDs8fffz7BQLbV76v8SlJW/Ku+zv8n
	78zdkwhmWzNqlerHyjfT9cVStfxk/DTVNXzXtEZbqtjh3NjHEL2RklPMDJerkcdwi4B5W8
	zBMRiKMO1LPHCn34h2l3O2p8OnS2eOE=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91ec396c93dso71729196d6.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794873473; x=1795478273; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kNMtaHpahG58C4CDJTpyGiQEPKrM5bilgLdnVmpa1D8=;
        b=q2DWio5ko7DM0EGP9tRqiYJ8RObRzCMZ+1YDsEdJE1IcmeJgsAozmW/eL0jawMEHpN
         VdGYbq2/Vtno4DrO4bG6JfCmP01cXyIFEZQXGFChqs668LD1kDsBdlGLrtLSswB8oT4N
         3CniYUJW/920MrUPa1AWL/yVP2JSVkM4Adv6hQ5WmtyRmeBDsQ00iXwcPXo1C9LErEYd
         U/9ZIU1FG58RGamKUiFSYSHLGynvO1GQOqJYK7ardHEVpCf1e3pD8YIiAr+1OLuvhzJB
         sI8B1nakDi0n01DDNXYdnPXoGJ6j8NdITvJjbS/9FvKRScVGqDyXpSnJ760u8uTceU09
         9coQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794873473; x=1795478273;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kNMtaHpahG58C4CDJTpyGiQEPKrM5bilgLdnVmpa1D8=;
        b=anIbPKYgyTaRKPlSqayZZTlWHQwVbHhcjdZZJSHr1XVOvKa8wIYYpjVLIL5QJOVqrE
         D6WqdeYztpFGqdn2jXPWhNOUopC5zxqnqr9U82rcn3XDTdALBzaBjCjsGYh9H5Q8BCgs
         kjXQ2+oWxSNhvSYQtL4E0meLpe8OzxY2T2q++uQDyKVFag4OgbCyiAq5TMU23DXYLZPf
         aNGa9MneF0+YutYEprGO3KOLZVCFBas0rhwDqrt/0tf3YKW3W9tFGteTlGnkdyrXh6Kn
         tXzW+1T7TixLcWaukEpFq3B2zr1XlopD54xnV691jwzqtkwlGs1nZhcQa+PltmX8OsHZ
         MjhQ==
X-Forwarded-Encrypted: i=1; AL+hErG+TAVpGiSZ0P6l3Ft0eTuDRZZDmDpnKwZ1MZNPWsG1qLIClqLMplPG1AXubgQdTUN+EpJzVstnbg==@kvack.org
X-Gm-Message-State: APuU4Z/n8t/ELHkf3k8uYr5LW1mWrBm+mkk/fQ6p0hKOTOGd5ouMu3R8
	pEXiR1Gf2Fd/TaR8WEVL1FtX2TNxXASj4qYQczWSXfqWu9jt3OuYiC25Q0hyyfWsF2o=
X-Gm-Gg: AZFdTZfZH7zGJl/FxgnNE0UoqyZvQcA9cqYhRXJsp1sQpRSTxE3BbL00aXoqk1jsQpi
	x/N13GPSxQO9++zm56Itre9Uj9ltO4OXWTJr0RkJnp0K5LNSo4YPYdiLCJOw/yLb5eyCpuI0DX6
	3cRuJ9myxO6oxf6IkdEz0FiM724nhrpUgZYQdIMsdAGjZR9DfCE4qk014Tz1YzCZBiSFvZZm4gg
	nqm8VA2g0QibDgebaZTuhd9f3c4APCzeohvlVt+PX/fS0RNK+LSvDSfgenLxZp8jDURLG9KGciW
	iwxMagP3dKh7NXbkkX+tfh3Yu4tPcGTO8CyuozcGh+hSkDKDUBjmn+wc9zq7Zs2Jw5ky0F0LrUY
	AcyK1Ghi/zSaxX/yUwnid3Nze5Qzl+l+O8/vOPl686Jm5jkS7V0tj8JrNFN3TbO6Qt4ue6lj0rq
	EYtl6ICOpDiSdPyTdgi7j7fX8ZvgBk/ybgyX+Ve+zayUR9Mo8CAvLdXWQmlt9dVV9Ss0NsZZtQR
	sil8kfLf+QAjSGbYEL7zideFAbx/Ec895YFiDiA1e04P6+e2ysn5YyDKdvdykN3dlcG01nK/1t6
	gPcsteJpUwsmIyZwcT2QV1piHJ0SbYOlgqCFmN3/oQrAihgviQqCSR99Y5x7rpJCnr0cNiY75/i
	+EVAv3ME=
X-Received: by 2002:a05:6214:4019:b0:91e:a219:fed9 with SMTP id 6a1803df08f44-91f2400c99emr200139666d6.1.1794873473078;
        Mon, 16 Nov 2026 15:57:53 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d453casm97144106d6.10.2026.11.16.15.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:57:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <avuN2eIrlqrO0u6O@nvdebian.thelocal>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <179460319801.482102.15329919214055018110.b4-reply@b4>
 <avuN2eIrlqrO0u6O@nvdebian.thelocal>
Date: Mon, 16 Nov 2026 18:57:52 -0500
Message-Id: <179487347201.482102.6428415219993123805.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 37381180002
X-Stat-Signature: hcrf4tnw9hrnisxnapogcbmjuow5qfa6
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794873474-488512
X-HE-Meta: U2FsdGVkX1+9gADz5i5/oqqvzWyDj9uNPDg9tuScg7eYKuFUCgmC/X4zEaT8Q/7EUUJhpv4PAlEsPablh2+jjzVJyr71nNATibi9lJFx8mrNBPkfS4MiO9RPeuNE2Z29ODCG+IDSNYdOCeW6yt1ujRWETKkBSWUal5Ca+1To98huW2UPudTmh/sKFwYt2j9HOc7jo/TRB2sgWHp6IYG3D6Gagl69Bpmp+bhBy/KtPBa52aryE+cbgnDPkQPH7paxXt1vCRdNtdRMthDSQCEdc7E38S+Z5LmgGEbcjE08ImVkXsrA4yeCWKamt0bYPCEIx/G6/jJj6zPyeRfvXQvgCIQQupnvQ1ubLLQz3518qIq6wUfEoIWGVKkPcV+2NuGB2vPDGTeI75PB7OfqTiynG2a9xbQ6BveXOBn7TCxl9F7tOOUHZeM5fC8Al3T3B6m1L8+H6w35HrDyMU1gCMW9YmwJ1ijaQMoPBprUGi5QG8dcYL0TVeYC+Tgmb0UuFAXflI2MVQlflQtHJclZ9dYFS+Uq1FmjaHPIJF5Y3xTt6nJ4azpKKia5t54/MPkqP6gpUyQV/hu2q/rZLqXa3CozqMBYrbqDyH3WoJCmG/tyVzEhrGudJDq0vAiG8ik2gMDJPK8qKhzi9K+i0esm87r8HLH8h9M8uMO1uDmbgqENaDFp/gRqOW4a2krQhAGFw2VotuByFdX1ViZ9b0Un0DwRQpvb8AT3O5+kzDiZlibLrxvCAkHepja2lTXzp6WcKGAsRRcK7lCOIHhAsV1dt5LgSaJKhtuR+xR9WFeH4k0BKDVPs7Vm6J45aQyUhDC+U7osyE5yOjQ0ELVqrS1C7RtPG1hwan1lX55/RHGup3dKG9jzlc7eavI/AE0vzbhDBFMSdTytrEkFQXYVtnFTjm82XJFKOobzswd2m18F2rx+6pBsyRtMdZcaA+FsizL1l2W/wm8OSsvUxw7zwV8cb/C
 W5eYLvjl
 Ngntg1Ef6Tx25s6Jl/t+HNBzq+F9JUHfUSvPRxL6sKZWv3xnQocyQSy7tlLDZmP4Q9CTUaCo0o7kYlHFfOFjtrLDkUS2XvD7GbWa96SMa1/Gu3fyUjyJzdf8QlhJQfw5ryyOlY3aE0CUUf8/OiDgLLTIOItZ0x+Ij/JxVsufyKPtUQHdV9ZeWoUmq44ndnYcZWYmAfNQua8LtpPyGmnIutIxMg2UPvagxML8MVg+ukz62IJuHs7xvJrunYwd90mkTsUp6YAjn/h3BuuxsZ7OuSFNuOb6qpVBJkp2OqNjwGs2Qvg1C99CMhtiYZUmarx3lofdcEeCJ1WayKyGNuFqnt/F3Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-17 10:24 +1100, Alistair Popple wrote:
> On 2026-11-14 at 07:53 +1100, "Gregory Price (Meta)" <gourry@gourry.net> wrote...
> > On 2026-11-13 21:43 +0100, David Hildenbrand (Arm) wrote:
> > > On 11/13/26 21:34, Thomas Hellström wrote:
> > 
> > > I recall that John (cc) kept saying "GPUs and NUMA balancing is inherently
> > > incompatible, you have to disable NUMA balancing".
> > > 
> > 
> > If this is a NUMA-hotplugged GPU, then this is resolved by a private
> > node, because this:
> > 
> > @@ -6404,6 +6404,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
> >         if (!folio || folio_is_zone_device(folio))
> > 
> > 
> > changes to
> > 
> >         if (!folio || folio_is_common_memory(folio))
> > 
> > And all folios on the GPU node are never subject to NUMA Balancing
> > 
> > so balancing can stay enabled while the GPU memory is not subject to
> > PROT_NONE spew.
> 
> Hi Gregory, just to hopefully help clarify understanding a bit here this isn't
> related to folio location and therefore private node won't help much.
> 
> This about a driver getting a snapshot of current PTE state to program a
> secondary MMU (in this case on a GPU, but can equally be a NIC or other device).
> 
> Even CPU memory being subject to NUMA balancing can have quite an adverse impact
> on GPU performance due to increased incidence of GPU faults, hence why John says
> GPUs (using SVM) are inherently incompatible with NUMA balancing.
> 

Ah, I follow.  I'm still working through the performance implications of
mmu_notifiers in the presence of PROT_NONE faults, but if i'm
understanding correctly it tracks that you'd say it's incompatible.

I presume here the driver needs a global view of memory (or at least all
memory it can potentially DMA), rather than simply just a subset
(some set of VMAs)?

~Gregory

-- 
~Gregory


