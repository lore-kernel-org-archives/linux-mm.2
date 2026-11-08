Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67FA6606A33A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I8vJZKHY
Received: by kanga.kvack.org (Postfix)
	id 6850C6B05B0; Sat,  7 Nov 2026 19:43:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6352E6B05B1; Sat,  7 Nov 2026 19:43:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B906B05B2; Sat,  7 Nov 2026 19:43:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 278166B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:43:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8554FC021B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:54 +0000 (UTC)
X-FDA: 85410104388.24.8607B00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3DB9180002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:43:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8vJZKHY;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098633;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99AHfkNsSNOI9AkrucgD2vH4yfnn2CeIWT8FqF772VA=;
	b=1MbUkpZJ88mRnOGKzfGLrxpJ7dfBqo4H7sqxxJuLo6CSGZfN/tG0DeOqRVc4WH6s81dgHo
	jw3tOPCcE8HHoLAgFbqpk0sAY/+9eIXp7k7i6mUnvdd6IRBJHSAZANTPiUdXcfh3on6LFJ
	sTLpG8c+n96wxVDw9xxTwNf71VWTLDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8vJZKHY;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098633;
	b=LKrBXLRQNIVyMz3sRj4aQPf8PknKNIhSf92pmzppcUOdllobpEunLaPZ2XCjRlnTJIPlND
	SIyXBeCKaNUYQnlUfr74dNMbkhEMtBsKgutLj+pSnAa3goFTWlWAB2jIvKQN5KTPKgEtnn
	HvM+WBXrK9Fsww85vYa1DhOic3eie6A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06F2B60EF8;
	Sun,  8 Nov 2026 00:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD43C1F008A2;
	Sun,  8 Nov 2026 00:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098631;
	bh=99AHfkNsSNOI9AkrucgD2vH4yfnn2CeIWT8FqF772VA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I8vJZKHYJakO7f4cLsEgSxilcocWjesZCSYOx7AqR15RmgDcJEPpBb5tTLrkE1HH/
	 iFrXVHRBsM40Ve+TxN7GsHkoG30W3C18E0BkTuR77YzG5EIJENz+/quVzOBsoI9Gxa
	 ydPOKT7b8sNKag6/bRxL168Zo0Pu6H8WEb550DxI9yiYKMnsD97xWwhJc76V2olV1u
	 pZCgnYMSKG6XiWEdBRYhUxmRtFWX+K4OUVciuZxic2yvfpSWW1tUC3Rns83aI1hI9B
	 zIQgMAx5JJjSk/KHO40g5xHsx/f2K8LVi6SBoi/A0wSEER+VLbF7by5Tot2iurH0AW
	 5FZHKVnBQhniA==
Message-ID: <sashiko-outbox-203414@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 03/88] mm: shmem: Implement guest_memfd provider
 operations for tmpfs
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
In-Reply-To: <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-3-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:43:50 +0000
X-Stat-Signature: gdye5eeqzoz68hzdxxa3hewmai54zty3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3DB9180002
X-HE-Tag: 1794098632-665394
X-HE-Meta: U2FsdGVkX18+sneWQuoaOlMSSxg87pVdlpoQVRRDLSm46SVsU89Hwi7Fa4c4rSsll9K18HgU98qDQ/LEWphAZbYnphRqi6Bj/aM3Jonlu0Q9UAyO0fzkd8NV3qIK+7J2BIBk/Ih1+d/huBWYCfmL1oSrVesAE4bO2z3zP+zoC8ibtz0Im7DD1JyBqLaJaj6gmLKY8TQok/+h9i1+qaXhWEgPL7sx03P/tNh3Ki3Nm2JFjaMoYhCABBDrX8zcHjqLm65b9/P6O6PryVMkOVUEMGWmQ8CRPeZ02sB0JyG0TAo2zgtz8otUSpI4knxxPqkuDrGBPldji5A2od/NlQSTDu/FKis37MH36FFvQCeKQh6iHGQbcvQsFkP4KJDejQ82Rvn9Fyw9Hw1b5IBmUbsCEwYIgUq5ZtqDPQo8XqBuJsytCjuhA7oYDR+703ABsKbG7W5xsf5KLpxI+blJgnJLDAXnDjkkGNz8TIAOsC64wLmIqanE7U+UYXRIo5x834jsOebk1dd34Weo2/fotMyx7cBlPOgjCHeDjEK82V6wTJaqwRGXfKaU05294Cgo4yIcp+S7YVV59gMycwUAKWsPlfoZ20g88AVVufPo6UC+5EVUYhZcmxmzbx4W9COKMP7myVdIzOL4ohC8AHoV2GPDyL9hDwlx2M17cxWoylva43RsFU/3Pw0N+xXoIT06tIZHwSn+zWyBAkaATXAvvL7+qVI5cva08hKxJ5CXW7wXnu42ZFUn9gw/q3H9k1jIkoGlUs0NIyGwfgUlfigpM2BJU3IwYwxUusslaoThNLbxRlt3ioAs3rY6w6xq1qLxpDMuLBLbBnWoJ+WYqV4yoS85rRgX9K/E0iePHR8UVXBWNNPIBitsD4iI1dH6BZxark7Vgc3eEi8zcsjN2TtGNzq+LqEuhcumvn9UsUyLW6+ELz0EFMf4jrTCpweBX1KvtlASnugAc/i2AEVyHOSS1eD
 jyiu2zkL
 Uj9SWKzf3ZJXNf8yMYSsKHURwA7m9BxTfGk4xwSViwHICeZwUlwUwqy/IMdZldbwh3p/yqBbNCtBSsBuZvkRvQ6gvwFxQm2/skGw3Ivsly0N0tHwUzIPbzAgP8dTdezDPRzVTbHSjuz4gAFHzGGnJYkk2TFuQfuhN8AXy6vGIrlD5iefQYN5UG4Qv/k6oo9IU9HW51/tXJXoS3aOZt8xPAENmO4m79Y67E7oSDhgk+lA8SguV6k4COV7rPLADpLvztKSXmlFqSWJ80nQLBZcXOj8pz6vUG/OLA+d/h+RWTeDEuvwrY5eKR55rRfURT/cmJdG665e8jfVpy8+xNoYMewmco+GxF/uU/KdlQiWWfG2f06rXW0V0SqEChHOhsCDPHQXPwTh/zi/0+b/rODszg4JdyPhRHfZxSpeEYEuw9uKieVo9Fd15pw4XzOziMROJwa8N2ifwJ7PRBkf6wgZoC1haoB5rg0cy2RAZ4d+rnsP0Ve1fXvi3hZLRPuPAzC6q6KhI4h8wxDglZ2oHLvsqO3kBhfg51hRX5c3AapSrJIFHjtWjmmgKbSt8S8hRdpBz9drnoksm5lUGGLif0o9rzpBHmLaI5RO+9l8n8VBPVOButM61eXgiqqAdODrd1ic6GBBmXBfIh4S1zznbbcTKrFgcH5XsZ9Kvsui33TPKg7oPi8LKQnbFc1Qchty/FcTwPihJ8qarnbH+psUcQIYpA6Ol+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm: shmem: shmem_gmem_alloc_folio() allocates unmovable folios
  as movable
- [High] mm: shmem: sbinfo->mpol refcount leak in
  shmem_gmem_alloc_folio()
- [Medium] mm: shmem: uncontextualized sb_mpol and ref leak in
  shmem_gmem_alloc_folio()
--

commit bbcb85338583bc4b9f5ee5e619a3f55d643e1098
Author: Ackerley Tng <ackerleytng@google.com>

mm: shmem: Implement guest_memfd provider operations for tmpfs

This commit adds a guest_memfd_provider_operations pointer to struct
file_operations and implements the callbacks in shmem so directory file
descriptors on a tmpfs mount can provide memory to guest_memfd.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 848316eaa7f4f..2a9faf8be7382 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

[ ... ]

> @@ -5237,6 +5245,124 @@ static const struct inode_operations shmem_specia=
l_inode_operations =3D {
>  #endif
>  };
> =20
> +#ifdef CONFIG_KVM_GUEST_MEMFD

[ ... ]

> +static struct folio *shmem_gmem_alloc_folio(void *provider, pgoff_t inde=
x,
> +					    struct mempolicy *mpol)
> +{
> +	struct mempolicy *sb_mpol =3D NULL;
> +	struct vfsmount *mnt =3D provider;
> +	struct shmem_sb_info *sbinfo;
> +	struct folio *folio;
> +
> +	sbinfo =3D SHMEM_SB(mnt->mnt_sb);
> +	if (sbinfo->max_blocks &&
> +	    !percpu_counter_limited_add(&sbinfo->used_blocks,
> +					sbinfo->max_blocks, 1))
> +		return ERR_PTR(-ENOSPC);
> +
> +	if (!mpol) {
> +		sb_mpol =3D shmem_get_sbmpol(sbinfo);
> +		mpol =3D sb_mpol;
> +	}

[Severity: Medium]
Can passing sb_mpol directly to folio_alloc_mpol() use an
uncontextualized nodemask?

mpol_parse_str() stores the parsed mount option nodemask in
new->w.user_nodemask without calling mpol_set_nodemask(), expecting it to
be cloned and contextualized later (as mpol_shared_policy_init() does for
regular tmpfs files).  Using sb_mpol directly bypasses
MPOL_F_RELATIVE_NODES translation and cpuset mems_allowed
contextualization during NUMA node selection.

> +	if (mpol)
> +		folio =3D folio_alloc_mpol(GFP_HIGHUSER_MOVABLE, 0, mpol, index,
> +					 numa_node_id());
> +	else
> +		folio =3D folio_alloc(GFP_HIGHUSER_MOVABLE, 0);

[Severity: High]
Should shmem_gmem_alloc_folio() use GFP_HIGHUSER instead of
GFP_HIGHUSER_MOVABLE?

Folios returned here are inserted into the guest_memfd mapping, which
kvm_gmem_init_inode() marks with mapping_set_inaccessible() (setting
AS_INACCESSIBLE and AS_UNEVICTABLE) and GFP_HIGHUSER because guest_memfd
memory is neither migratable nor swappable.  Allocating with
__GFP_MOVABLE allows the page allocator to place these unmovable folios
into ZONE_MOVABLE and MIGRATE_CMA pageblocks, causing CMA allocations to
fail with -EBUSY and memory hot-unplug to loop indefinitely trying to
migrate them.

> +
> +	mpol_cond_put(sb_mpol);

[Severity: High]
Does mpol_cond_put(sb_mpol) leak a reference on sbinfo->mpol on every
allocation when mpol is NULL?

shmem_get_sbmpol() unconditionally increments sbinfo->mpol->refcnt via
mpol_get(), whereas mpol_cond_put() only decrements refcnt when
MPOL_F_SHARED is set in pol->flags.  Because sbinfo->mpol is allocated by
mpol_parse_str() -> mpol_new() without MPOL_F_SHARED, mpol_cond_put() is
a no-op here, preventing sbinfo->mpol from being freed on remount or
unmount and eventually wrapping its atomic_t refcnt.  Should this call
mpol_put(sb_mpol) instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D3

