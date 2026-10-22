Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA12E60A3808
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ma+0rves
Received: by kanga.kvack.org (Postfix)
	id 82CA56B0A27; Thu, 22 Oct 2026 19:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3986B0A28; Thu, 22 Oct 2026 19:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5466B0A29; Thu, 22 Oct 2026 19:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 320426B0A27
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80EA24034C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
X-FDA: 85351852026.21.4474B1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55FF9180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ma+0rves;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G43d0vJ9nZFHoOQhQ9teBTHgfgutS1jAuc3xjbwXZIw=;
	b=ynKg6akfVYKuSh3e4oeNUoQGO2uugZsyPssJ3Vz8MzWi92HQkt7whGN/9kEp1S7rbxKkhz
	hXV3Eo9yzNGNClzFGIMSwHczzfKEv+kLyZTw58w4FUxEKG59WSLHuRncEG4CbJeyvxl8pu
	TOqrwbmjkHt7rtlAZfj29FymCtpsGdU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711671;
	b=cBbsTiNpf/F1/t0McA7+CxvG1X/dr997SY067C6D5HzbYkXLpd9SQYOk7/SRpnMQOejAxC
	jsrE4wJ1m2L4UOBQma3QC16CIvQfzqbNFr3j4Z5G8Zw3IWyD6tdtCPn5kDTAdXhONTzB/4
	9wQYv4yj2DvHKz816Q4I8o/JpDGWFj8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ma+0rves;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8B91405E4;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711670;
	b=Do3JJ+25MDCjHvOFa4mRttaUFIkRbZQ8KZJYBMnxZYHVrHxO+SAlT3gipe/3uv7UJJYr
	 6QUaAV4w62zlDv3rUzMu5j/OhzFeHavf1K8Gq0bySAk6y9qLhXGHdimyW1oYRjyg0+t3t
	 o19zMZRapr9qEU1UODjECPRJGPEMajPwSJns9wr3d+pgyn/7YR7IW+5Bic1NwBI2mE172
	 dGYmd7pKjPcfVYd2VWxZjNA8f9PrB+oL7KZsPjS0o8y+jQtjVMxmGndZh9XfUApEXH5ij
	 Sy/5IfctnjeAHrjXViNHJasvmiFp+AS9WT8qP2xZYe5D9w63XqqmhHewOQX5jTmKTnQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711670;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=G43d0vJ9nZFHoOQhQ9teBTHgfgutS1jAuc3xjbwXZIw=;
	b=1ftELfLoHgWdXrnoryPNyJYqY/831vxBbITKxKMCvk+rYZP0wsTY2TBHfz4GAq5XMDFI
	 NEY9K2oCaHUcE3dKex67YexFWUrxXUqzSNNVmDag0OrPz5AJK2vqylkURg1guyWUChopG
	 Nh42WPNobroTcm4DAiILHBpyJzCqXLb5aKIF6zKaJX8U5PQYPMipd+o/TvMbIWbR2cbFk
	 tWZd1nqKDk1Hu2wCMjydeXLLe5mSsQ56mJSJIutNbMW9Bwpo8Wfms2iXvfpARJKYNmJzm
	 tb/Sb8vxy7Ca/lNkSadRBbOanLp885a4shlT0qhyTCK6ZPCAA9I9JetI6RtbCPC6g8w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D75481F01825;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711670;
	bh=G43d0vJ9nZFHoOQhQ9teBTHgfgutS1jAuc3xjbwXZIw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Ma+0rvesnOtFEtmFiA9fUrArpSborgFp1GV0R1fwGJpl4SWuNlTD1xEKQDAbWz+uf
	 r7ttxiVmIzaBl+tkgRiUyHt8Tg2uZskiDawSr86r/diwLyz0z8+oPObWV98Sm7CZEZ
	 mt2mrSbapCwytMvsvesc028OR201rIvg0E++CHH1OsxZ1xLKETPXAP1aa4ND0AaPrz
	 zblpigSAHRxiSU9AEpw2s4PHYRa3v5bpTRG7Y6wXz2TM2FQw1SkiUZPKb9FNOXUQqy
	 +3U1CrPAgbqjQqPq+S8OyPU7FypTbI4EKpHlfGWPXFNRbD8ysvgmwVO13rDtVXmTIL
	 hTa/WMQ5PfiRw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2EA144203F;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH RFC v2 00/50] guest_memfd alternative providers
Date: Thu, 22 Oct 2026 16:27:32 -0700
Message-Id: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOWb2moC/yXMQQ6CMBBG4auQWdsEmiDq1sQDuDUuCvODY6SQa
 W1MCHen6vK9xbdQgAoCnYqFFEmCTD6H3RXUPZwfYIRzky3tviqr2gwjRuNeEepdlAQz65SEocH
 UfDxwY9G7likDs6KXzw+/0fVypvt/hnf7RBe/LK3rBtvYtEmDAAAA
X-Change-ID: 20261015-gmem-alternative-providers-5d98d72efabd
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711664; l=14655;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nFLgyN1Pj6noTRSjY5D6Pyoh6B9lcZYrtGYcU1wlCRQ=;
 b=+ex4O8Hy8Z1rn0M+v1cRMTTz9f9EtA8sIUs0kt9KKi1byJD+eSbNlioRHzexgnlScZYJKO984
 MvY5TLn4Xl+CHbolmC6A96XxDBHtKs23gemms+PMVFHWASLngjnzMfD
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55FF9180003
X-Stat-Signature: 97uqj5zd9ucfs5fcemwisjtrwfaztkto
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711671-65089
X-HE-Meta: U2FsdGVkX197h2dnLGlo7KRPHVyERb8KpEUSwv1zgQUnXBCg7ec0vjckFlZCXzZGc5jhd1Cjs948DlFL7eSbSvuDRnI48IV3UTzy0dgSPS6fOhQzTmtSM1GFd+xe/4+CxucKdAc1iuuiaaTQshg5VqA7crsERCAufS5Eps47q45yfjYTc7a8wX1mfaatfdMfsSl98+KfmYWXn/qNiFPk96VHIZ2mb3THRZPMOu3rfNh7/hN9wItlyBWQEr2JQxvxN7CQqbGLj8llYII7d+Z8SrgMvL5l+h7UaJcQc1GS7NCIcLFaVxeC4+XpxXrj5xm0dCOawaUZ0vjLRP/EWZpzMwVdkuWTevSX3UV8J3zFzQqQBj6RV2MODsOBNPF+Yu9o4BJJHYSzczCXhnP1QOQkvGzMObgWCG3STgLIQgHFkR8EGDfS7Huz63+uL+lKH1EJzw8EGThL+Wt7652SmbCUAQlNRHbm75Eb6mv/FZP8sakpVLb87hRBbRAPzCBD0D/jLDjzIOf2XvBLH6Zh+88Povhls+2XS8QGrKuIQH7++6vH46VMK1aVUjMRcVgsUeFgzzbIUNDoN9w34XaXgRfOGVA3AqkIq1O7dTkazcZ90PxGjTZoK15mcctDuYK8F6sDePBXFKAHy6brt8el6/TkHfZYwOkz7oNMLto44Gvz+/PH0pRm8xmY9e4gE30finmpZ6MmJeBD4yUqyVrOMMB0ou96Nb0+lVVKBUgbO9+bbxLtHmnue8W13YPE6C5Bsz/zVtDAi6OmmQqFi4leTafwwjLWZKOeLp4aD413rWLTOcPJZgT4o2THWHKSMKf86wA9Lc9T0xfFtv/wwkZocQIOqXWxdl9Jbj4IMNq5/KenFzzKpCm0CgfF9MNnwedMl41/n5EUZ43sJJGF2poxT+gbk6Nx9tKH5c47gwMWoENVhp4a9382VEKmdwuQIDBf6toRt0COqBvgKchX8TcCzO1
 wuvCM+gh
 UPAKlEX36aT4QB1NGjmotwvaNrRGzcNzWoHw7jXtMnIcFi9vUKH3OnafSVCz2ehLZeAuP16D5WNArsvsr4ChsPIW7w5vMxgaifQfnZXqNgXpffgo3WIDYBH03RdJxmAwCnqNXwl4lMpDV2rodWVtyvb+1lNxmM3vcS0qWyfbqYm1DXZjUuRXGtPuwe/TOH+azXHmPneXRyLUmSSPVHkJVOTeAa+D77CFBz0V0kWY+wJBD0AS5mb+35eEOONeiMcD/WUCUFW8IcZsw8WvQ0JokK5jHSxRiNrx3WZGP+XeKSwI0cp2PUjzOJrWzIWgLkDBN7AzGY10PNvZcXX9ROHvFTZc3AMIQ6fyHNocBXiDciLsJg8CN1Xerm4LrmnI8wL3NlKKNX7kpsGkxf8bQ9TJHmFNrzfNU6exzCmIv3P4qHxAiy4xxKBS9lnxIarnTRYXXsOSbdRXVfSfCRKvpswjbs36bCdiVh4z+ooKG5riEZj3+V6ygkyF+DYkSovvuHfNPjil0Sr2Lqka6vRlOE5YRU6xdBJQk/G/F+Wq9rSELKaRC+nUv7mkbWC7rhAnxN30MVNImV4vDneknlzwP80x2y+RHXrabk1nKOfX0GJcEWnwuJjx3zV0JipxqBta6GYlX8oh25aV5lYgX5hBdXIJirftZYTa/KMYDw0X+OO/Fwn137LomM0Q96Q4hOP1CZl/cqTdz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Here's RFC v2 of guest_memfd alternative providers, continuing from "Allow
guest_memfd to be created using a resource (pool) fd", which I'm considering
RFC v1.

This RFC v2 is actually at least 2 series, so please don't be thrown off by the
number of patches. It's a lot of number of patches, but I've also taken a lot of
effort to make each patch understandable (hopefully not just to me) :).

The first 18 patches are largely the same as RFC v1 (only 5 patches, 13 selftest
patches!). Here are the main changes:

1. .attach() actually needs two params, both the gmem inode and the file being
   attached. This is needed for the "native" provider as (suggested in
   Fred/David Woodhouse's pair of series [1][2]). and for revocation from the
   provider (See patch "samples/kvm: Support dynamic revocation via
   kvm_gmem_revoke").
2. The guest_memfd_provider_operations are now attached to struct
   file_operations instead of struct super_operations. Using file_operations
   will allow guest_memfd to use resources that don't have a meaningful
   superblock (like Fred's memory provider sample).

Then we have a bunch of 10 patches beginning with a direct am of Fred's memory
provider sample (MPS), followed by a bunch of patches _removing_ features from
MPS to get a more focused subset of features. This bunch of patches ends with a
basic test for MPS to convince myself that it works.

I recommend jumping to the MPS selftest, which illustrates the trimmed feature set:

1. No need for memory to be set aside at boot time now. Instead, MPS_NEW_FILE
   allocates the requested size from CMA. For small file sizes for testing, this
   should be fine?
2. The CMA memory allocated at MPS file creation time stays for the entire
   lifetime of the MPS file.
3. MPS_SET_PRESENT remains so userspace can emulate the provider revoking
   memory. I removed all the donate/reclaim/move operations and child ownership
   tracking. IIUC from David's comments that the "move" (and other) operations
   are basically revoke then give.
4. MPS_GET_STATS remains as a testing tool, to check that MPS_SET_PRESENT
   worked, at least in terms of page counts.
5. No more MMAP_CAPABLE or not, I'm proposing that the provider should not
   provide any backdoor for userspace to access memory contents. All memory
   accesses should go via guest_memfd so guest_memfd can manage page tables
   based on shared/private state.

And then I added 13 patches adding PFN mode support for other providers.

PFN mode allows providers (like MPS) to provide PFNs via guest_memfd to all the
users/page tables (userspace, stage 2, and, in some later patch series,
IOMMUFD).

I'm thinking of PFN mode as a requirement for non-resource-pool-fds. The
distinction I came to realize is that if the resource fd represents a resource
_pool_, like tmpfs (or HugeTLBfs), the resource can be allocated from the pool
and can be fully owned by guest_memfd.

For something like MPS, the resource is not specially allocated for
guest_memfd. I wouldn't say the provider owns the resource, but I do I think
this is closer to David/Fred's model where the provider still tracks the memory,
especially wrt whether the provider owns a page vs when it is in use by
guest_memfd.

In this RFC, I made MPS track the offset to PFN mapping, and various operations
in guest_memfd rely on the provider's offset <-> PFN mapping.

In the 13 patches, I gradually update the various operations in guest_memfd to
work with PFNs:

1. kvm_gmem_get_pfn calls .get_pfn() on the provider.
2. kvm_gmem_fault_user_mapping calls .get_pfn() on the provider.
3. Converting to private stops checking refcounts (N/A for PFN providers)
4. Converting to shared calls into provider to look up PFN, and then calls CoCo
   reclaim on those PFNs.
5. fallocate on guest_memfd passes on the allocation request to the provider.
6. Hole punch on guest_memfd requires CoCo reclaim too.
7. Inode release/destruction requires CoCo reclaim too.
8. Truncation (hole punch or inode destruction) requires notifying the provider
   that guest_memfd is no longer using the memory (.put_pfn_range), so that now
   the provider knows it fully owns the memory.

And then I also added a kvm_gmem_revoke(), which is close but not the same as
punch_hole.

The provider and guest_memfd really need to coordinate. The provider can't zero
memory while guest_memfd is still using the memory, .put_pfn_range informs the
provider that guest_memfd is done using the memory. The provider can still
revoke memory anytime from guest_memfd.

Then I have 5 patches to implement PFN mode provider support for MPS, and
finally a selftest.

It was zeroing that pulled things together for me. At first, I wanted MPS to
manage all the zeroing. Pre-zeroing before any use, triggered from userspace, or
zeroing after use, where the VM can go ahead and shutdown first. I wanted to
have MPS support the write() syscall so userspace can directly zero the memory.

CoCo is a core part of guest_memfd. The write() syscall shouldn't be usable on
CoCo private memory, so I would need some kind of shared/private check from
MPS. KVM already has a shared/private check, but that check is not meant to be
stable, because the KVM MMU is so integrated with guest_memfd that before
committing the results of the shared/private check, KVM would check for KVM MMU
invalidations, and not commit the result if the result is stale.

Imo we cannot expect providers to respect the same invalidation protocol. The
alternative is to take the filemap_invalidate_lock, which guest_memfd uses to
protect the shared/private state. My take on this is that having any memory
access going to the provider call into guest_memfd is going to either result in
races or ABBA locking issues. Hence, imo the solution is to have a top-down flow
of all accesses through guest_memfd, and have guest_memfd orchestrate the
conversions and mappings in all the page tables (userspace or stage 2).

There was another thing about userspace faults. This RFC performs
vmf_insert_pfn() under filemap_invalidate_lock(), and this serializes things
with revocation requests coming from the provider. I'm relying on guest_memfd
coordinating both revocation and userspace accesses together with shared/private
conversions, and I think having every provider do that coordination would be a
lot to ask.

For this RFC, I didn't explicitly add any tracking in MPS for whether memory is
owned by MPS or currently in use by guest_memfd. I took a shortcut where
MPS_NEW_FILE would allocate fresh folios (zeroed) and .put_pfn_range()
notifications from guest_memfd would zero the memory. To allow MPS to be zeroed
from userspace, imo we would track owned by MPS/in-use in guest_memfd, and
direct accesses would only be permitted if owned by MPS. Owned/in-use is
distinct from absent/present, since an in-use range can still be marked absent
(forcing a revoke from guest_memfd). With the tracking, direct zeroing from
userspace (not through guest_memfd) would only be allowed if owned by MPS. For
this RFC, I zeroed in MPS after .put_pfn_range(), so that's also when the memory
is owned by MPS.

I previously proposed taking the PFN and storing it in the guest_memfd inode's
xarray, but I think that isn't useful. Storing the PFN in guest_memfd can't
indicate to MPS that the PFN is in-use, since a PFN is just some number, unlike
for pages where there's a refcount and metadata in struct page.

The remaining request from David/Fred that I haven't prototyped is the IOMMUFD
interaction. I briefly described how I think it would work in "samples/kvm:
Support dynamic revocation via kvm_gmem_revoke". Sami also pointed out to me
offline, and kind of mentioned in [3], that the IOMMU doesn't support faulting.
When guest_memfd does conversions to private, we'd have to zap from IOMMU (or
remap as private, for Confidential IO). This is the same as for stage 2, but
unlike stage 2, we can't rely on CPU faults to bring in shared pages. On a
conversion to shared, we'd have to map into IOMMU page tables.

Aneesh, thanks for your series [4], I haven't got a chance to look at it yet. I
will before I continue this prototype for IOMMU. I want to get feedback on this
part first.

If we agree the trimmed MPS implementation covers all the required MPS features,
I can squash the MPS changes so the next RFC won't have this many patches. :)

This was built on kvm/next, and the series is also available here for your
convenience:

https://github.com/googleprodkernel/linux-cc/tree/gmem-alternative-providers-rfc-v2

Testing: these pass:

+ ./tools/testing/selftests/kvm/mem_provider_sample_test
+ ./tools/testing/selftests/kvm/guest_memfd_test
+ ./tools/testing/selftests/kvm/x86/guest_memfd_conversions_test

RFC v1: https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/

[1] David Woodhouse's RFC v2 https://lore.kernel.org/all/20260720111259.122911-1-dwmw2@infradead.org/
[2] Fred's RFC v2: https://lore.kernel.org/all/20261006183235.16576-1-griffoul@gmail.com/
[3] Sami on IOMMUFD https://lore.kernel.org/all/atkO08eCJzLX6R58@google.com/
[4] Aneesh: guest_memfd + VFIO: https://lore.kernel.org/all/20261017073149.1303738-1-aneesh.kumar@kernel.org/

---
Ackerley Tng (49):
      KVM: guest_memfd: Split folio allocation and insertion in kvm_gmem_get_folio
      KVM: guest_memfd: Route folio allocation through native provider operations
      mm: shmem: Implement guest_memfd provider operations for tmpfs
      KVM: guest_memfd: Support provider folio invalidation
      KVM: guest_memfd: Support using resource provider
      KVM: selftests: Add helper to create guest_memfd with a resource file
      KVM: selftests: Test negative validation of resource_fd argument
      KVM: selftests: Test rejection of unsupported filesystem for resource_fd
      KVM: selftests: Test rejection of memfd for resource_fd
      KVM: selftests: Test rejection of swap tmpfs mounts
      KVM: selftests: Test rejection of hugepage tmpfs mounts
      KVM: selftests: Test rejection of regular file in tmpfs mount
      KVM: selftests: Test guest_memfd with tmpfs resource pool
      KVM: selftests: Test guest_memfd resource pool sharing across instances
      KVM: selftests: Test memory allocation against shared tmpfs resource pool
      KVM: selftests: Test that shared tmpfs resource pool size limit is respected
      KVM: selftests: Test guest execution with tmpfs-backed guest_memfd
      KVM: selftests: Document testing TODOs
      KVM: selftests: Test guest_memfd conversions with tmpfs backing
      samples/kvm: Remove donate, reclaim, and move operations from sample provider
      samples/kvm: Remove readonly support from sample provider
      samples/kvm: Remove child ownership tracking from sample provider
      samples/kvm: Remove MPS_SETUP support from sample provider
      samples/kvm: Remove MMAP_CAPABLE flag from sample provider
      samples/kvm: Remove fixed address and length module parameters
      samples/kvm: Remove mem_provider_ops from sample provider
      samples/kvm: Make provider files independent of a root pool
      samples/kvm: Move set_present ioctl from device to provider file
      KVM: selftests: Add basic test for sample memory provider
      KVM: guest_memfd: Support getting PFNs for stage 2 from providers
      KVM: guest_memfd: Refactor error handling in kvm_gmem_fault_user_mapping
      KVM: guest_memfd: Support mmap and user fault handling in PFN mode
      KVM: guest_memfd: Skip checking outstanding references in PFN mode
      KVM: guest_memfd: Support converting to shared in PFN mode
      KVM: guest_memfd: Support preallocating memory via fallocate in PFN mode
      KVM: guest_memfd: Clamp hole punch range to inode size
      KVM: guest_memfd: Support reclaim during hole punch in PFN mode
      KVM: guest_memfd: Support arch reclaim on inode destruction in PFN mode
      KVM: guest_memfd: Support put_pfn_range provider op in PFN mode
      KVM: guest_memfd: Add TODO for memory failure handling in PFN mode
      KVM: guest_memfd: Allow attaching PFN-backed providers
      KVM: guest_memfd: Export kvm_gmem_revoke for provider-driven revocation
      KVM: selftests: Test flag dependency of PFN_MODE on USE_RESOURCE
      samples/kvm: Implement attach and release provider ops in sample provider
      samples/kvm: Implement get_pfn provider operation
      samples/kvm: Implement put_pfn_range provider operation
      samples/kvm: Support dynamic revocation via kvm_gmem_revoke
      samples/kvm: Implement lookup_pfn_range provider operation
      KVM: selftests: Test guest_memfd conversions with sample memory provider backing

Fred Griffoul (1):
      samples/kvm: Add a memory provider sample

 Documentation/virt/kvm/api.rst                     |  34 +-
 arch/x86/kvm/Makefile                              |   3 +-
 fs/libfs.c                                         |   4 +-
 include/linux/fs.h                                 |   6 +
 include/linux/guest_memfd.h                        |  68 ++++
 include/linux/kvm_host.h                           |   3 +-
 include/uapi/linux/kvm.h                           |   6 +-
 mm/shmem.c                                         | 126 ++++++
 samples/Kconfig                                    |  11 +
 samples/Makefile                                   |   1 +
 samples/kvm/Makefile                               |   2 +
 samples/kvm/mem_provider_sample.c                  | 339 ++++++++++++++++
 samples/kvm/mem_provider_sample.h                  |  54 +++
 tools/include/uapi/linux/kvm.h                     |   6 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 tools/testing/selftests/kvm/guest_memfd_test.c     | 277 +++++++++++++-
 tools/testing/selftests/kvm/include/kvm_util.h     |  24 +-
 tools/testing/selftests/kvm/include/test_util.h    |   2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |   9 +-
 tools/testing/selftests/kvm/lib/test_util.c        |  56 +++
 .../selftests/kvm/mem_provider_sample_test.c       | 147 +++++++
 .../kvm/x86/guest_memfd_conversions_test.c         |  91 ++++-
 virt/kvm/guest_memfd.c                             | 424 +++++++++++++++++++--
 23 files changed, 1635 insertions(+), 59 deletions(-)
---
base-commit: 7e60162b16f9da0d2fa83da5c1723b6853a0ac1d
change-id: 20261015-gmem-alternative-providers-5d98d72efabd

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>



