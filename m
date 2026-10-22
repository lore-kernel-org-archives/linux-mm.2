Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA961606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OsOY61i6
Received: by kanga.kvack.org (Postfix)
	id DD3C26B02F8; Thu, 22 Oct 2026 19:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB656B02FE; Thu, 22 Oct 2026 19:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B926B0301; Thu, 22 Oct 2026 19:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 906316B02F8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 317B01C367E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:27 +0000 (UTC)
X-FDA: 85351853454.07.2B75A99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 309A41C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsOY61i6;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711705;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYCUv7MnUeP5VLQmaz6pPtkybPAJhWsMUOQImnoTeN8=;
	b=7G6bwrrohO8iME/PPxnCPE1LdhkRdX0O4RDBfvoz+Ypn/rABlEJK2lleNgRGWtBloNYJub
	uOc6wzCYTKCyCb/3EG5n+J+vA4Z6/GwE7aCayy8NBjgezvWwedUCLpZvWcUZB+lVwTvVgh
	n2w9CM4oC/QQ6T06zDR48c/nFNYCWSI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OsOY61i6;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711705;
	b=H0On8t2M3C+ChUf3JfXI4K0gYs46xZLyjKmAxIOfBjGQzcIPDPNRk6/2xw8qLa9zgBVKV5
	TsIhXe78+yhH+bOsX8DLP1HN43IJgD3oaH18XgY0+wIaVPdeTEPdJYkz/vm6eSm9bljUWN
	CF4qHD8k5dGEwAy944tLk55OrVdrcLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8A7D4488B;
	Thu, 22 Oct 2026 23:28:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711698;
	b=ZpQUl/gS2VGn5ZwXsl0sFy7KOMqVES5L21WUfgzNpOSTvueEyq2IRSXPOkM5TRYLLSif
	 sSxLYuD/N9xya/oeZ6FnAe+YgyYMK1P2UJUzQ+VlVfteZBIKE+YK3lwGezLUjdOxo8hi/
	 1VF0GjAPDCQ7r0EdlsECIljN7ZoieK9W5J6e7/guWPOdVIODGOImuNpG4giu9VsqBsnZC
	 lRAlP4gyCvepHpEIcYVmzmjsMO3KYa8Gvpnr2m5Ze2oiKicMYhi3+hKaKpqhI2V1YZ0bx
	 AsQsG4lQnCmk9bTDSmHmpdH3sMcGOVA/UZLuSKOY9XI4dA0ggzvME7WYL/eGbhnZBkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711698;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CYCUv7MnUeP5VLQmaz6pPtkybPAJhWsMUOQImnoTeN8=;
	b=unH3hTyQS7LqUVbOAl1g/1V+6XQYf20VtZ9pGIFooU0ZAsEsbAyUMyqlVl/dUPzW707G
	 HZ/IxNoMA5AuZNCpI4+rpUSpdTNDHVNtkVvm8J7Hm3eC2cpb/xlnc64qe1E12ZCjblUxo
	 IQAgvlRad+4JR10Y2EhHFcihyRL8YyBdXoWa7/vG1wo7taS08eYejGPrLzkSrqNpgPQrx
	 GfYOZEp8OO0hl7fdfZNSEJNtVlKfAAYWyYm8C3hT8OXOQMkoKFi5wCXJtVkZS732gQil2
	 xoqa3jw97dxIGLyVTCtc+p5PpyRmVvcF9GOiKeCgh1P3XTPLqacSg0ugZ31v5RtJQMg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C753D1F01829;
	Thu, 22 Oct 2026 23:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711698;
	bh=CYCUv7MnUeP5VLQmaz6pPtkybPAJhWsMUOQImnoTeN8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OsOY61i6sJiV9m5vMJ7tr3w4bW4/ZHWHobAVp6XOMoSBoXHNkzXUjwFEp1jMoXcqG
	 uURO13jvtIjnRkbSXYbnndzY3BMxI6C7oAXuAbZ74nR+rRSkb1cufphoCJYyAmu6UV
	 +fkEBiFhGYWl5n74V1pMhMzfoUhTCoDG+9IYH2QsfZya+AnYuIj1l0Pv99rms4sjLx
	 fpUQn6BLjOqqMi+pfQiGOJfT8VCfmBE7oRNILrt14Cm/E65xSimHx54Cg9tKg53Lec
	 3mVG1ls6pFRpfnIu9OfiJDcTpvxQnqGFi/53pVCzYl0M2ZUnZEOTQHGG4UlKiNZ8GF
	 VFZup9G/YITZw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4296E420E8;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:13 -0700
Subject: [PATCH RFC v2 41/50] KVM: guest_memfd: Add TODO for memory failure
 handling in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-41-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=995;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ywimPr8xM8W5IWC+IFHzZM+XE9Py2m+UQJgTrzAxKZc=;
 b=AmJho2/OmL5iB6a3wmmUlrO/oEcg3/kVVcZkPZCjkwKxtxHbWU1NfSLey8pjERpooe/o5caEO
 cTmpBxuPY05Cn9MXbqAN6Hlr9/+SNa1XkP1V/8eVUvxLXLs831J+mRv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 309A41C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1r6whzpohz5m5ze9j68neotsrabioriz
X-HE-Tag: 1792711705-186428
X-HE-Meta: U2FsdGVkX18rYX6/5i6mKXhfRvtOGDJISZFNF/PrGY0LTDrnji9z2tij0Ncct+cOg/1CiLnP84dDk0Z7hzRt3HLrelNn19gvLM7MGpJo6jIpNKuXL8Cm0hXxd4Q1rJgvMthwJacdfEHO9my98d3JLaIjQRhfUCCbBnLm2wZUW+pDUChCnazWobRbgHnK5VNekpv8ha6+devsvuM/hCm05EgXR+wCGWNKAx7a0L+84jNzU6iWR7VWi/8e+jF98urMH4N4OeRDmFmT4yKc4/3xFVk7f8WSa5qor3PhLlWBL80nYSkdNxg8F0riRavLXUWRMTC4Ch9G6WFEy9mZlAG8jr1J7DRUgcEfAIVcZzaDKDpFF4qVsPibUs3zdfYFUvD5X3/IosZkmZyKFhlIzKZLbwIasTPPI6Ih9L4GBCSC986h+fwlCnfu0J0575TVrpdcNGQi5/HcOROYbF2//jGCBrGataDt8B+0Q/fouLym44hQot5UZuDStKNH7FyCpvOp6PFAvBqPQN5vGHSVZN/wp+EMA17pUMr6paKuBVjWX7oIy6/m/yzBEgvna/tQj6STXIcDzbZq1q8GVQ2CH2e3B3f4XDksx8EVigBbKLeH/t6wbqOtQd1mj99AbwqdrxsePkPfq7VCKr9r4AWyv28QReDNEaHj5iwcr5ESaO8V/tiheLjY+Wf+YA2MVoQZVKqPzEPx3yQdJWdN6I3HS1TshjQ90m+uwV4cgcOmbUXhk0vVEcj42t9n+tfSFkMCovceDQ3z3ajIxv0Z16ypVIDjR0NfuXnRiriRcpON5Wktskq3WfK4fub9pko/TMxCsqjs9Zoy1yHEV43D/sjV8uNgTEORptCCfLZz17zPjqW7jbkrdvkCPeu7eYxuxQm7muLzI497pr2RKZ6HD6Rq8wACVStuvE4nTISwNJ8MhfEgCPDcdnjyWIn2wQzPX7ic24eh7ZrtG6xXDboW+GU40Z8
 Q5GIbhl/
 xBIzLnrDsitM9CvezL+2dAF8zAjINk2hZykLpS9xVcZtvXPogoQYm1uyVhBMuNdgZOvr+4XngQuDs57hIInhEOvFRiHt6ONo6+dQPZnXHKPYoVJ2EsKBFJAIsW1eiZCcdIwAEo/HVC8gQCjsNQ7FnEUsDMdRkAptBYRNo+FOlgMqYvzte0si20oRxib6iv8TzukNkUyBfkK9eWqbkQuPaGR0za1kBHK1N2Gi6NAFBRmBAZJ+AIIv08Wq+NTWc5vLv8cVDKPFlT7P5op7Lk2yI+Fa7sSWK58MQ82vpwO064lvB9lvUE3RNosKs3e1FxuCmFULGeoHL0LRusU7usKdXrcDmVwiSP+bqD+ompGwXQ5ZEUAAF6OcG8QP3qmnfkYRYQdyzM+xJAzTieQLZ/dhnOS5gp931rjZ1QRUcPjAokzyQbcWWqf30U1U34aTEoeHR8eMn5lzLE/zoO4AaZilq0zjUpLv0BirssNGLcmofHE8CYaXDY54TFzBlivT2AYNB2zzjp6GrVlcp5zPLS9/W2a2vsq0rRdD9yIzJw2RWUrOmwc39mI6wwfyVl5aLMs2hW8O4qKyTvkigBTYuN94dk0kFERCCClxS/HBEyxzpLWjcoxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a TODO comment noting that PFN mode does not use page-cache folios, so
->error_remove_folio() will not be called by the core memory failure
infrastructure when physical memory errors occur.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5741ff6ab94c6..c89df77df7146 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1068,6 +1068,11 @@ static int kvm_gmem_migrate_folio(struct address_space *mapping,
 	return -EINVAL;
 }
 
+/*
+ * TODO: Support memory failure notification for PFN mode. In PFN mode, memory
+ * is not backed by page cache folios, so ->error_remove_folio() will not be
+ * invoked by the core memory failure handler.
+ */
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
 	struct inode *inode = mapping->host;

-- 
2.56.0.257.gf7497c7d27-goog



