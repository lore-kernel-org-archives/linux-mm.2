Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716C1606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFXT4w+R
Received: by kanga.kvack.org (Postfix)
	id 873B96B00EF; Sat, 14 Nov 2026 13:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824866B05B0; Sat, 14 Nov 2026 13:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D8F6B05B1; Sat, 14 Nov 2026 13:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5596A6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:56:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E6BE1A0458
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:56:22 +0000 (UTC)
X-FDA: 85434630204.20.7E5156A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BCA6A80004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFXT4w+R;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794682580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//GruLIthFISZCy43B0WDxoPfxAVchEQzL1ze90Ia1U=;
	b=jkNaPwhFpPX8xsU1gzUEAISolFkXFo9CNRmUI+XKvlXCdA6X07fn6vrhARxR4uYPlUoEk4
	tUw2/DEuRXZy09oa8zNfYhIPhUePj+//nespUzw3oWi95SfMrJrgWvnmtKp1T5sG5Hiauw
	NXoPLjkG+CgibkMz7Ff6UkLVi6z/TuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794682580;
	b=Aq0MAfj6ItiRBHVTvViKyMQtIMv1PET9fLgyJ6ABQVLaB/OyQUwIT+0oYpkuGNt+XtZsck
	Q0lnyt7FEfdmC5/P6TzknojJe4SNWiPE6KetcVZdKiftyoISxo6xjA7ZCfHehflCZxgAaE
	tict2plqJcyN5Y1cRuEXbJ9BAzlCmTY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFXT4w+R;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E18561265;
	Sat, 14 Nov 2026 18:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC5C1F000C4;
	Sat, 14 Nov 2026 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794682580;
	bh=//GruLIthFISZCy43B0WDxoPfxAVchEQzL1ze90Ia1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hFXT4w+RF00hYPkv+JLeIEZAjbBCTc5CY95xB7nG2ZeZC6xVNc/tyLfLCXLXXfzU/
	 0xwjpH4uqHfJv3b9jTPfEDI05f7epSGY7WNGrFU65nrM599kdWjAEstILA4u/ArbNH
	 FTR5pcJyhgtGykdCgnB9yTDQlTEGPmVB2LhUyMM/DydIocWWISlDCPO5SdDwgRJIHN
	 4wq5xnK84S73I5MUqu84dXHgKrRnMmjnl0JRhFS++dhSPVoIn0UZspmNkPF5QG60KR
	 Pr81J5yjOzly8Xwkbx+5AcxopvUR+FkweegBHOBezVZ17Bld0ubFOCo/dvixMRJFbK
	 Aqop4pp6GTflA==
Date: Sat, 14 Nov 2026 18:56:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Chris Wilson <chris@chris-wilson.co.uk>, Matthew Auld <matthew.auld@intel.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Rik van Riel <riel@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: do not call vm_ops->access with FOLL_ANON
Message-ID: <aviukG1XPZw2Rja9@gremlin>
References: <20261112-access_shite-v1-0-988a5c470db2@kernel.org>
 <20261112-access_shite-v1-1-988a5c470db2@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-access_shite-v1-1-988a5c470db2@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: btusoz77gs61bsdqee97eqzqqc569wam
X-Rspamd-Queue-Id: BCA6A80004
X-Rspam-User: 
X-HE-Tag: 1794682580-293533
X-HE-Meta: U2FsdGVkX19hmOntPtqcW20JIHz6OVDe6J9AeSgDRkdgcakTJbO9Il5Kilk3dOzESQpe6n0xPbQ93oPU42mmtvYQ1U6siiVJzYs+fyA99PMuyp0H8KHwbVRgnhC0nIRh54f/YYUJy+PLAAUvv9leet6Zrp9gTtU/nLEQQ6hHix6WRh1Y0/oIbAxu3rYhtGzWObiXMX1ErBWp19yEMwJJ4CkmhqccAGJUKM24BDn3XOUfhliDEvjhoEuEhaXFUk1cjfi3UKsTEsaOq/0DuOco4gVM3Ouf5/Dxf9ExdbrNhxosah+2o4Jz2bnWuLHdza5d7ldOpDOyQ6+d1ACvoSkADVQRb1G17LrTK/fGLA50Ijf+RpKD6uNLQQ/UEQh9WiJcD8ys774A/yuaxnZMLnyax2egHBoW9ioJQM77fHzI48m1fyEdGHLm8jTF6IcBZyMYOLj08D81f0DwzaAg9t6BtuFJJhrvZc8j98a80LvZZgCcP+vqSdQXlusmt9eHD9mYXdTahW0Xus9Yeq8zFsYmoTJhRxiaiE/hZ4L7/qlJmDSYRc6ToFKgc5At1/HqkKru7yZCRzFb+4yTpG8LeOOmQeiNQczHGBhAVUs73Pg42bPSPfOn8ZE4cm2jLGS77Dm1gJzmSa7RPzM917Nql8jKbmqLqCVPsDjpa+Av+RJeK2ZKqvSZmb+lCRwezfv8+GZfugx+vXRJ2DhbzCVn2AuqWz6nsNYHAZHukmaEC+LEgV8MBWVx05ZHvWIp2voh5T2uBGaP7L2TT1npgkYMOzyxmFysPVI4PQXWnYbojog3r73Bg5A5tyq2YqTEDFZQvvkDJeoxWC+ek8kQeB5BWEeV9cvknbqYEqzzJQK8tRFnIo4pZCXiP0jBNSPpeVt09bRLVafSn4mmQ7nyUoANH8UuNv2vc2o1VU9PDLdYVaqx46OZujz63en14b32MXMJt5qRq1tUMhYypIK509JijKm
 BT/nQUkm
 1IytrzvPQGypF4EsP6sgrrq+VhW5oqzJ4w8pASFK/fe12hT9y0cMJdEfKux4kQELrMWaeRs7f8AewqzGAWwHlgSiFzL+hyrwwz0isrC7cZDKKMsyCfJAHli2oU0iYuzXPkKq+y+0HXKdwoXKDF/fu7TmPY6JAz21mQw5h/pe4UKgT1ygCzGTKE2m25t+0hoFiQnrGCwlgNbdR4tSIoNrCNGeQaRolqRhPWCsP3qjBLuCRMGRUtKlm2BgrEIxzP+YzyDEZuzjWoXKKMzL9BIrVMVioOlIaHUrzOZMH7O2+obpBwXnkqPvNPfbXINzaEX7LENljQcTgzKNq1VKdr+7VBO2Tb1Or3FJq65kjchUnyDEpentITVDisnFkHivQUs3tN7j5YXMhPcWUfyugzyavYKsSBPgE8JD2fdi8gWVIiqOW5fGqBJW1tdaCiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:08:57PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> Reading /proc/<pid>/cmdline or /proc/<pid>/environ can block in a device
> driver, or read device memory, if the virtual addresses point at a device
> mapping.
>
> Ever since commit 7f7ccc2ccc2e ("proc: do not access cmdline nor environ
> from file-backed areas") we use FOLL_ANON to only read from anonymous
> memory. While GUP properly handles FOLL_ANON, __access_remote_vm()
> will fall back on GUP errors to vma->vm_ops->access() without similarly
> considering the flag.
>
> Fix it by not calling vm_ops->access if FOLL_ANON was specified, to
> truly limit it to anonymous memory only.
>
> Fixes: 7f7ccc2ccc2e ("proc: do not access cmdline nor environ from file-backed areas")
> Signed-off-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> [ david: simplify description; slightly rework implementation ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 1a0ec09c56fd7..d4370c1b331c9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7398,6 +7398,9 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  				continue;
>  			}
>
> +			if (gup_flags & FOLL_ANON)
> +				break;
> +
>  			/*
>  			 * Check if this is a VM_IO | VM_PFNMAP VMA, which
>  			 * we can access using slightly different code.
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

