Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1996083604
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DzOVRtbz
Received: by kanga.kvack.org (Postfix)
	id 6073C6B05B7; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD6A6B05BA; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476A46B05B9; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1413F6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1FB516020E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
X-FDA: 85406458200.17.85148D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84FA51C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DzOVRtbz;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011818;
	b=EzYhFk+sbeGijUq2eg1+xGGp0Jt0adSo/dqPwqpm8GPovfD6lWGGdpg1qmMdK8wsELa2Y8
	+HRe0/86+9vuI89XfUXwDm2OXI/7TXfagjWi9OJbp2gDWTIJ4nwnSxWj9W2UiFBXSNRNaE
	IpP1JyxbUr78yfIY5ZMuOc/TJ0FvuyU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DzOVRtbz;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011818;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bSP0Q8LW8rkNnI4q6jUwUxmI5gx54PlOVRGPJENZuG0=;
	b=xJ4im5XZVMCsMAE6uHTCNhhjkJBazDPtbpd8a2x9JmZaCn5ff6IZVe1q5+zcBeZq1BD1d2
	w4V7FBk7FBq4htFD/rlZyt+QKOZ0GuuJa/BZVEwkSPxg0t8cmotJ4kN51OpVOhhO8RQ7AU
	aVHV6PrGl9cUO+UxONkSUX/VYS/+M0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1B2443FD7;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011817;
	b=YYHff6rUfiPRp7BMPHD5RxyuJHzfy6DeWqOvl4c+yIdI1qP6nNPJvQIqre2PNj5m5OJO
	 L4BlwrbrV8FDwEuko9vOKFZ74JF5ZG+J3KFsE/PSRgZCaRsah+jUFkDfyHehfo7WRbyYF
	 q04IX8RUb6e5AEEBkJJXTD7TTsOXWAp+SB5F2qhMnSpayUASI27m5IcLKOCl4t37b3w/G
	 P5tjhKks5Qsj+oYGzCf+qjbD7DDh5Z+tkNN4W/fPY8ZHHBAO/Inn3zlxGR8egSBHtwPGP
	 3jviRE/s6QD0Ynb7EbPCMwpvp/raQ3Q135g46dKEZtEl36tb8bgAviXPxqyCzVVYTwA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011817;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=bSP0Q8LW8rkNnI4q6jUwUxmI5gx54PlOVRGPJENZuG0=;
	b=kELdCDjCNPYjV8n41IxeETCWytZn88dp48WKgBuOagoRnni5dAWR+ORqPQqFrfX7eFMQ
	 P0hkZkY2C2uVGrRjGUE7FuFgixPP7S6IAtNKEnPU1jjzWV6BEgVnL8OuSZa3lP361/z1G
	 AED2NYwdxIj2ps6dZ4sqmNe4OsQZr/TnrjpeF8caLCik38ZAiG8Dm2vcqflAFz435IZyj
	 vpA0cMg0j5NKYyDTfpiI9r5YQeuCw7/kargSrkpcxW+FzIEbZhiWNagHiflmzrt9NFjnj
	 UNY5UQ3ykc/c/gK/220c7dBHo6J8nEEgTuw62NyXAAxp2FFYTOyG+cFNBnsreUzGB4Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 550831F008A1;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011817;
	bh=bSP0Q8LW8rkNnI4q6jUwUxmI5gx54PlOVRGPJENZuG0=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=DzOVRtbzPERfiDt5vG6izqeaQHq8zNL/wptCdzcH8td0UXdCwgRAya76Pi4dX82HJ
	 dd/5MpILeicrzB4vBoMOGZhxbcvEahLBEGHdVWHlARjp+V6clEx7y3VO24kDk+4bZH
	 Is5SZis7+cq2yXeGpLy8XWKwOKGOoW2gjT8RT8GSe3+KJZwWTIaMLgyk55REvMGEOh
	 hbPT7pBkhgBgwGOJK0GOWXvrqkpPBhuDSXD8OXxD2iSK1O5Yl2Q3kj/vtrASgFqf4P
	 v96BKuO/5SHIoeQTlv553Sz3f5vekzPxWNgHi5+3HWa9Dz9pZYiIZojpWj0e7mvYCQ
	 C9CAQv9c+QhNg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A01F647919;
	Sat,  7 Nov 2026 00:36:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH RFC v3 00/88] guest_memfd alternative providers
Date: Fri, 06 Nov 2026 16:36:34 -0800
Message-Id: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJRy7moC/32Oyw6CMBREf4XctTWlhvpYmZj4AW4Ni9Je4Bqgp
 K2NhvDvFti7nMnknJnAoyP0cMkmcBjJkx1SOOwy0K0aGmRkUgbBhcx5XrCmx56pLqAbVKCIbHQ
 2kkHnWWHOJ3MUWKvKQAKMDmv6rPAnPO43KLfSv6sX6rBgl1lLPlj3XS9EsY43mxD/bFEwnpQmN
 1pqKbm6NtY2He617aGc5/kHooOaJ9wAAAA=
X-Change-ID: 20261015-gmem-alternative-providers-5d98d72efabd
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=16185;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ervChwxpIQLRxRtMWrdudBza/JHCGlJ4Ky8gprxuFNM=;
 b=aPmrelHctmCBUniYoQlzg4J6Z2RA1/rLGL53VtncHCY2ICSUY16dtPcPhkpgT123J4omOjXrJ
 oynzVFLy+7/Bow3/2aMg1grzHtSfFq95yFDzn9KrI2MvMrD949dll3A
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84FA51C0005
X-Stat-Signature: d9cinc4575ic78ibezfifuwy1a34u8zh
X-Rspam-User: 
X-HE-Tag: 1794011818-776212
X-HE-Meta: U2FsdGVkX1/VKIa/n8gNvLpnIYcGHMsYEDrh9I9CzrtamkoJ19YJQVKcSpo37i2il+rBmnP0gQ5loRZGXm7yNfxvgvA3LYe5Zn4ZOlshLG7eL+hmjY2BdtFURJ+OucLPoQKtKKLMlolySCi1tchxWeF57cJwFIwMvBqNDjEaKWFDxtLTodwybO8uf0yTnVchHZb3h5O+jNJ5GF54lCoSIzjuPWPjEqF8DEP3RmT5EuSBD2++BupPRnaOiaKGbYJWqmDplqBNCEvOsGbg1yTtbDKiVz8MAmvJn4BXOBbVAtDxY9Y6+k9UO+mMIU7/G39CTOorJlt0qJQJMo5RGhMl8LG9UMdl3t4quI8BN6iCFZ3hUXrCU1yNeTXqj0XPuA0Nipvk/7ruVEH1un7LMBlbZquk2U+yZNK+mzGQIthWVmFFbJIX9Hdlh3+aePU7toonIciGmjuFsZJxf9zTIl2O79wIXMwzT80ZOw0+RzEAnaQl282cyA+13GDQqJeC5DMw7LZoZ5gItBLEezCKgkfoz1wQ9TQQOWE49Lal+0PxwL+xJKj+f59b8MIKoUpbTI7M3z/2S6CWKBSQn1FgUYPrwoDLXQLbGonUJnC9X/BZ+Oh+huJfJkAojwtdJjk4aUH0Cs2HJ6B8VIxSH6WQT4j+Ffj/oMx/hAo+AnWpieeIvCwsqwM53N5XiprBW93gEenUVIQEsCsVNUGcGycpTrEPsZtNHfNnpd2mY2FPNw4CjmrtVH3RkR7ASTcq0T97RQAJDQ1KI+b3zN9JwfOi1isc07Fwal7oT7jG0jnpNYHxEIVvi0WN0zi/sTtIqeAVimU3+QYPzGAXnte5RfKcUBPlZyDAcgeAolMyCR3qytXjaQQWn7B9BTdtvemD5LwJPRxp7Pu+U+j5bm2owxJZNrlJQR/bnKsImtMNIG75U0rgXAqEpf+2TLFOGsWavl1iPivj+dUnhBHdoZLcHUBvmln
 h/F5+U18
 ijVIuyOSy3ON0DArKV60iMKfT/aCg5tfe/WP8GYhqdQeUb9Pc94flkJ9JfhdJa/LdkgkAGLPmKW7o/NrgM/Xt+ke48UEqzj0GoXIf0BgYPV/Oz8EyseJIxNvq5kXPWyGiI5LJHjNU1IyylzeujiabXMsILiljftbfAURqSV69waHagg27R9Gx5FYrdxtEuY7LlVPYAtNIkSrPF+IQYbbEz2v2Ju4oA2atXBaX97gmgJU6bR+cvpCSLl9tbCWBTCgo64C4v0QZkQ84yVLRl2D4I3XsDWx8zfMM3zLOeI1sGiWe19BbM0YENh0L09+vs9gclWLZXXXKmcu0m3o0YqZk3M3zRsdq5WVzww0m0RAu72RRLHBf/YNO/fY5vEKkctTMn7lq4pbrGOTyiPsl38SBN7eGqjGV/z/oMq9OqX+ubEWlL9tDaLtyUyCFX8edQMwvD2Zrc/VakIHPMv3xo7w83I1Tut/pJLWT8ZRR9UjdLulV9EoqyrRszTbciYagrdHjOsJ144IHrsHDP87odL0n/Knq8h4oH1/gF3Vt2UginD6LYgH1USX1xrokF1gXLEOTAVfkknISW85EQ7VikmwG1ROrkaUjtGGmOSHUNFSKctj4qP+mnGHXNxWCUXOtjbPEzwOkYezp8PvTU0v0Vp048voFsphGNIiT6HakHPaw5W/tMp55R65m/J83snoGmYm1ej0yiuQw+Nq5WwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Here's RFC v3 of guest_memfd alternative providers.

This RFC is meant to show line of sight to a few things, and will have to be
split into a few series for upstreaming:

1. Supporting alternative folio providers (tmpfs used for illustration)
     ends at "KVM: selftests: Test guest_memfd conversions with tmpfs backing"
2. Introducing a sample memory provider
     ends at "KVM: selftests: Test marking page ranges read-only"
3. Supporting pfn-mode providers in KVM
     ends at "KVM: selftests: Test flag dependency of PFN_MODE on USE_RESOURCE"
4. Making sample memory provider a guest_memfd pfn-mode provider
     ends at "KVM: selftests: Test guest_memfd conversions with sample memory provider backing"
5. Making VFIO a guest_memfd pfn-mode provider
     ends at the last patch

I was trying to get this to work at a conceptual level:

In this version, after working with VFIO, the provider fd should be clarified as
the provider control/config plane fd.

* tmpfs: the directory fd is used as the control plane, since it indicates which
  mount to get folios from, what the mount config is, etc
* sample memory provider: the provider file fd doesn't allow access to memory
  (data plane), but is a handle for memory that is pre-carved out using
  alloc_contig_pages()
* VFIO: I added a VFIO_DEVICE_BIND_FLAG_CTRL_ONLY flag for
  VFIO_DEVICE_BIND_IOMMUFD, which partitions VFIO operations into data plane
  (mmap_supported + some ioctls) and control plane (everything else, which I
  think shouldn't be used for Confidential IO, and gmem doesn't want to manage
  anyway)

The split between vfio fd and gmem fd is this:

* gmem fd: Read/write/mmap mappable BARs 0-5 from userspace and stage 2, and
           conversions
* vfio fd: Read/write everything else. mmap, ioeventfd, and dmabufs are blocked
           for CTRL_ONLY

I also formalized Sean's suggestion of gmem requiring exclusive access to the
resource, which shows up in the locking requirements (I updated the docstrings
for all the gmem provider ops accordingly).

For VFIO, this is implemented as a .bars_available field. On attach, we take
dev_set->lock in vfio to store .gmem_inode, while vfio-pci takes ->memory_lock
and initializes .bars_available based on whether memory decoding is enabled and
the device is awake.

After setting .bars_available = true, gmem has exclusive access to the data
plane for VFIO, which should be everything needed for Confidential IO. gmem will
use its filemap_invalidate_lock for VFIO operations. Everything on the VFIO side
is locklessly checked.

Revoking from the VFIO side first sets .bars_available = false to block racing
accesses from gmem, then calls kvm_gmem_revoke().

For testing VFIO, I selected igb as the test driver since it is the most
full-featured yet can work with my qemu testing setup :). mdpy and mtty don't
use vfio-pci so they don't use ->memory_lock.

And then when I introduced the last test on read/write I realized this
implementation has a slightly different behavior between vfio and gmem-wrapped
vfio, which is that the reads/writes to the gmem-wrapped version doesn't
automatically get the device out of low power mode. I don't like this slight
difference required.

It doesn't get the device out of low power mode because getting the device out
of low power mode involves taking vdev->memory_lock, and this model commits to
not taking the lock while holding the filemap_invalidate_lock() in gmem.

The problem here is that read/write needs to take a provider side lock, but
guest_memfd, the caller, needs to hold the filemap_invalidate_lock() to make
sure shared/private state doesn't change during the read. Holding
filemap_invalidate_lock() while taking the provider side lock
(vdev->memory_lock) causes an ABBA locking issue. Not taking the provider lock
is possible but results in slightly different functionality.

Aneesh's version [1] didn't implement read/write. I think David mentioned during
gmem biweekly it shouldn't be that hard, so I tried and that turned out to be
_the_ challenge, lol. From a gmem provider perspective, the goal is to try and
get line of sight to a broad set of providers, hence VFIO's read/write is a good
challenge. Either way, I do think we should try to preserve as much vfio
functionality even after wrapping with gmem.

Aneesh, I think I'm finally at a point where I have enough background
understanding to compare our approaches, so I'll get to that after KVM forum.

I didn't get around to prototyping the Confidential stuff but I still want to
post this because our proposals differ very much in the exclusive access and
locking setup, and I'd like to get your help to also see if the
Confidential-specific parts of gmem+VFIO works, and if there are other parts we
can converge on. I left a patch prefixed QUESTION for the CoCo community.

At a higher level, I'm really trying to make VFIO not that different a provider
from other PFN providers.

Sean/Aneesh, it turns out that ARM relies on the VMA to determine cacheability
in stage-2 page tables. Since guest_memfd memory may not have a VMA, reporting
cacheability somehow from provider (VFIO) via guest_memfd to KVM makes sense
imo. In "KVM: guest_memfd: Support reporting PFN cacheability", for x86, I just
left a WARN-ing if there's a discrepancy to be resolved.

Fred, these are the other changes more relevant for the regular PFN provider:

* Cleaned up the sample memory provider (formerly MPS) implementation and added
  selftests.
* Fixed bug in the RFCv2, MPS' .lookup_pfn_range() implementation always
  returned nr_pages = 1, but it can return much more than nr_pages = 1. The
  intent was to have nr_pages be as large as possible to indicate the full
  contiguous block beginning at the returned PFN.
* .lookup_pfn_range() will now set *nr_pages on -ENOENT to indicate the size of
  the hole. This helps with VFIO since the holes are huge and iterating would be
  sad.
* Added the readonly support within KVM ("KVM: guest_memfd: Support reporting
  PFN attributes")
* Didn't get around to verifying proper support for more than order 0 PFN ranges

This was built on kvm/next, and the series is also available here for your
convenience:

https://github.com/googleprodkernel/linux-cc/tree/gmem-alternative-providers-rfc-v3

Testing: these pass:

+ ./tools/testing/selftests/kvm/mem_provider_sample_test
+ ./tools/testing/selftests/kvm/guest_memfd_test
+ ./tools/testing/selftests/kvm/x86/guest_memfd_conversions_test
+ ./tools/testing/selftests/kvm/x86/guest_memfd_vfio_test

RFC v1: https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/
RFC v2: https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com/

[1] https://lore.kernel.org/all/20261104150322.3516320-1-aneesh.kumar@kernel.org/

---
Changes in v3:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v2: https://patch.msgid.link/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com

---
Ackerley Tng (82):
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
      KVM: selftests: Add basic test for sample memory provider
      KVM: selftests: Test marking page ranges present and absent
      KVM: selftests: Test marking page ranges read-only
      KVM: guest_memfd: Support getting PFNs for stage 2 from providers
      KVM: guest_memfd: Refactor error handling in kvm_gmem_fault_user_mapping
      KVM: guest_memfd: Set VM_PFNMAP on VMA in PFN mode
      KVM: guest_memfd: Support user fault handling in PFN mode
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
      samples/kvm: Disallow MP_SET_READONLY after attach
      samples/kvm: Implement get_pfn provider operation
      samples/kvm: Implement put_pfn_range provider operation
      samples/kvm: Support dynamic revocation via kvm_gmem_revoke
      samples/kvm: Implement lookup_pfn_range provider operation
      KVM: selftests: Test guest_memfd conversions with sample memory provider backing
      KVM: guest_memfd: Support reporting PFN cacheability
      KVM: guest_memfd: Support mmap provider operation
      KVM: guest_memfd: Support check_set_attributes provider operation
      KVM: guest_memfd: Support read and write operations and provider callbacks
      vfio: Track device file access mode with an enum
      vfio: Support VFIO_DEVICE_BIND_FLAG_CTRL_ONLY
      vfio: Dispatch guest_memfd provider operations via vfio_device_ops
      vfio/pci: Implement attach and release provider ops for guest_memfd
      vfio: Dispatch guest_memfd get_pfn provider op via vfio_device_ops
      vfio/pci: Implement get_pfn provider op for guest_memfd
      vfio: Implement mmap provider op for guest_memfd
      vfio: Dispatch guest_memfd check_set_attributes via vfio_device_ops
      vfio/pci: Implement check_set_attributes provider op for guest_memfd
      vfio: Add vfio_device_gmem_revoke helper for guest_memfd
      vfio/pci: Revoke guest_memfd memory on BAR invalidation and reset
      vfio: Dispatch guest_memfd lookup_pfn_range via vfio_device_ops
      vfio/pci: Implement lookup_pfn_range provider op for guest_memfd
      vfio/pci: Use iov_iter for MMIO read and write
      vfio: Dispatch guest_memfd read and write provider ops via vfio_device_ops
      vfio/pci: Introduce vfio_pci_bar_rw_kbuf for kernel buffer MMIO access
      vfio/pci: Implement read and write provider ops for guest_memfd
      KVM: selftests: Add initial VFIO test verifying device info
      KVM: selftests: Verify VFIO region info for igb device
      KVM: selftests: Verify VFIO IRQ info for igb device
      KVM: selftests: Verify VFIO MMIO read and write for igb device
      KVM: selftests: Verify VFIO MMIO mmap access for igb device
      KVM: selftests: Verify VFIO device reset for igb device
      KVM: selftests: Verify VFIO access directly and via guest_memfd
      KVM: selftests: Verify BAR revocation and access gating in low power state
      KVM: selftests: Verify host VMA flags for VFIO BAR
      KVM: selftests: Verify guest mapping for VFIO BAR
      KVM: selftests: Verify VFIO dmabuf creation for igb device
      KVM: selftests: Verify VFIO ioeventfd creation for igb device
      KVM: selftests: Verify memory conversions for VFIO BARs
      KVM: selftests: Verify shared and private mmap access for VFIO BARs
      KVM: selftests: Expect successful conversion on MSI-X BARs in VFIO test
      QUESTION: KVM: guest_memfd: Disallow private mappings of shared-only PFNs
      KVM: selftests: Verify shared and private pread and pwrite for VFIO BARs

Fred Griffoul (6):
      samples/kvm: Introduce memory provider module skeleton
      samples/kvm: Support creating memory provider files
      samples/kvm: Support marking page ranges present or absent
      samples/kvm: Support marking page ranges read-only
      samples/kvm: Support querying provider file statistics
      KVM: guest_memfd: Support reporting PFN attributes

 Documentation/virt/kvm/api.rst                     |   34 +-
 arch/arm64/kvm/mmu.c                               |   43 +-
 arch/arm64/kvm/nested.c                            |   19 +-
 arch/x86/kvm/Makefile                              |    3 +-
 arch/x86/kvm/mmu/mmu.c                             |   18 +-
 arch/x86/kvm/mmu/spte.c                            |    2 +-
 arch/x86/kvm/mmu/spte.h                            |    1 +
 arch/x86/kvm/svm/sev.c                             |   29 +-
 drivers/vfio/device_cdev.c                         |   15 +-
 drivers/vfio/group.c                               |    2 +-
 drivers/vfio/pci/vfio_pci.c                        |    9 +
 drivers/vfio/pci/vfio_pci_config.c                 |   16 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  211 +++-
 drivers/vfio/pci/vfio_pci_priv.h                   |   13 +
 drivers/vfio/pci/vfio_pci_rdwr.c                   |  145 ++-
 drivers/vfio/vfio.h                                |    8 +-
 drivers/vfio/vfio_main.c                           |  273 ++++-
 fs/libfs.c                                         |    4 +-
 include/linux/fs.h                                 |    6 +
 include/linux/guest_memfd.h                        |  125 +++
 include/linux/kvm_host.h                           |   10 +-
 include/linux/vfio.h                               |   30 +
 include/linux/vfio_pci_core.h                      |   39 +
 include/uapi/linux/kvm.h                           |    6 +-
 include/uapi/linux/vfio.h                          |    7 +
 mm/shmem.c                                         |  126 +++
 samples/Kconfig                                    |   11 +
 samples/Makefile                                   |    1 +
 samples/kvm/Makefile                               |    2 +
 samples/kvm/memory_provider.c                      |  405 ++++++++
 samples/kvm/memory_provider.h                      |   70 ++
 tools/include/uapi/linux/kvm.h                     |    6 +-
 tools/testing/selftests/kvm/Makefile.kvm           |    2 +
 tools/testing/selftests/kvm/guest_memfd_test.c     |  277 ++++-
 tools/testing/selftests/kvm/include/kvm_util.h     |   24 +-
 tools/testing/selftests/kvm/include/test_util.h    |    2 +
 tools/testing/selftests/kvm/lib/kvm_util.c         |    9 +-
 tools/testing/selftests/kvm/lib/test_util.c        |   56 +
 .../selftests/kvm/mem_provider_sample_test.c       |  215 ++++
 .../kvm/x86/guest_memfd_conversions_test.c         |   91 +-
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 1092 ++++++++++++++++++++
 virt/kvm/guest_memfd.c                             |  658 +++++++++++-
 42 files changed, 3956 insertions(+), 159 deletions(-)
---
base-commit: 1689c80fca308978ea1c9f03d15a500f4e44e2e1
change-id: 20261015-gmem-alternative-providers-5d98d72efabd

Best regards,
--  
Ackerley Tng <ackerleytng@google.com>



