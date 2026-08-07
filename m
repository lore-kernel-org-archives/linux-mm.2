Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4243C5AD2C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1876B0099; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82726B009E; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70CE6B00A0; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA3C6B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39AD0C0201
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
X-FDA: 85075823742.07.C7526BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3D9E5180008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8dWiMKC;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVtZaxg3iwqwWgPcPFoIkyjgNhZPCdQoBeqKXOCki6M=;
	b=OZCYPOrimhffZbox4xRp/uzgG6o9A6i/Bllx/782ho6j32cLULmXE2RWMLUItOre2nHOBG
	+gSahLmiViLM3etCwu25ktWYz5zio/qY+SrjHLG+e1RMRbIW1QggMa2mfvWRajb1lvqGN4
	3MLCfiAJyd74OeOAf2yOGtTL0HWklXE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139569;
	b=OYVPHzRYlCTTnypLfhu8gIzRVi7e3Yc0jzyaxF6S44hMNgPlhutpNe+PJb1Xj8ZOG9i8yJ
	JnyyCna/wBondbtDMIrWzMI4FTqkoRF4z6tytJH+i7FyYe9OO+6hrwKmWHdJB/8F56fr3J
	k5flgOxQtHI2xExdBpQ0oDVPrzAlRjc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8dWiMKC;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EC714401A;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4C08C2BCB8;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=tEia40dB0p9J7pUU5lkk/Q96P0r+DPH1vw/1+oo1knU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=b8dWiMKCm151ij26CRR25pb98rPfkhcWvf3s9cOhFXfC9Ou6ytEELSTN2er4VzOIM
	 jWi6sB74GD3o05WnvwnP0wudZwjQ2sPtrTYnvixON/Ynpt2YLZGXjNuXRFCT18BJVl
	 yMJJ6nZ1YlS9g40dR3vvBh26OqJQuyQTGPZ4epbYL33G5AMeh7iVNStV6TtzWJioz9
	 TcqHrm4/+0vso4ukGIa9ZGPfKQgoT/q6JgOImYDEugM28rIJ51pW+CaAaBHcwMJl3Y
	 LTfpU10FjI7TAHwxto1kDNz5XLVwAhGNBIxvkf6cfocCQCA7Es4n2ks5PE3vvsDHT4
	 LRCaXFpwBhXsQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0383C5ACAB;
	Fri,  7 Aug 2026 21:52:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:40 -0700
Subject: [PATCH v10 01/41] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-1-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139564; l=1090;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=sAMqSCb/MXVvnJq73E9rSMuOWQstWqj6/6Qg36KPzcU=;
 b=cmKf8pfXyJOIt2jhLTeNcCrFZyW63ls9RwHVg/1LQjI5AItwXbeFEGikLMFxnoMSYbqbA+Wul
 +5dWBJzgS9oBFaZbki6inPmHvz4xHU/CUHWwk3oNbfC+Mszy+HKIiQ2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3D9E5180008
X-Rspam-User: 
X-Stat-Signature: fcea3mxe5xxyp6wqrjwoaud5nz7pfutw
X-HE-Tag: 1786139569-852706
X-HE-Meta: U2FsdGVkX18MiTeMmqLNh1y3Kj/S4ntkW1QcuaI8TwfkTnoIhxP3C3MCnvJWGc83yvuEn8+BU3dwtTjzaz0svKuRHmogAnVfcsUUQTh4rH2RH7j3pZYVm19H0dFxQPlcK8VHI+wfeqYTEXmjvzTNDiQJ514sAU9jAU06zJvScDqD/PzIFGs91jNF9kPBSzNeHvN0pLfZeUc96bS5NmJwHoyW5M3tAuhMHnJPjijr2scYYfS2aC5F0524fFTBhwGLBdybQZrOC7MOtfHH3gH6t5T8r2FSdnfk1VW/N/kvEAAmBLGQTMSqlMCx7ykDX94yvSoeEI7icM9ZZpfEys5J/I67b2DmbcAcdDeZR1ZQKpWuw50SIW0NyZ9GMmUJCT0sp/hp19fqMx3VG9Aiu/GnB1thveVsZ+Rz7Cjdr9zcV+mblkyeXgopBFjFVn0ATylnlTUIAffg6ov8/3HUjL0kKI+w22hfD04rPchC7DoOXjOwYBrKDIwFhH3/Zbk/WzwlSTIfvGI/pnFySfRs1Xv4wxrzz6dD+oeqE4AtM7kLdKf1SUaxyA0mOp/9MwxqWs7Ht59uTg0Ub8CSJTbsP71qPaYtwNf6GxxKV4npJIPcH2eWsy8gJGurFBHCGUKbOVy37PS1AXjptabE0ZXJtlplvOckSuxGqzev2TjN2P/po4p4VWYQPpn5e+BZexYE42Z/gqUP1zt6kTz9yvj/Ya3FavxH4DCbzvD15BU9a0KJMug9E8x7NNgj68Bu9sSa/GW4Ah1YPbmup3EhGKxATEHNFHfkuf7IO7HsZNY7Xs7GxeFIr1umvx3TbnMvMwBe6SKdpEZPYz2iPsypeWFDL8w4up8Tkx1fxPtjYEPKPqZekss1fQcqc4+8Ye7r6CKXnOC0mnnTnWxpgYGJpzsL0X1J5YSV9RVjC9ntRCkWLJ165+busTU5NuBo4KfMKfjiJ7Ehd9D9NLYvk1UnWKSwLAD
 DWnospl+
 i6ZgoeAeDSh+BykG+e8LcxKHx+16CFpTPKOewc/ikfVm3T5+CWeF1iTC2mP0Y9ZEzoQ/vhwmr+df3SOfoO2BPjCXnxSoYRoUG9bwRr+fq2hunnC6xikEDMWBQojx53gS2kx3fix5mIZDOeq3Y1OUGTbfmOqLjR4XtJIERVS7pA69mw8GRbnTI5+gYzgLZIICTU2+Gca774OMwI19jjDwSmMx8T4hQG57UlJmIDbiovbhWdoRt4bC2iGafcVfSzj588vYVQJgcuoYQrAzyR95Itr/W61x08/29mjtsqb0kzQt1ucSd5KSsqnkCIacpyRyaSVhE15DzRJae7fkJ1JgShVhybzIxGOtKklQ4kHzR6Ak96fjMOoFaea6ee4bH5jeuSqKZdHM6XyBXJx7w9354XuyOm7jiDX7GoYt72d7hJaTO3wyxqXkMFbIN/SMOtZDnxh6MB2N17JjFT1/b+AIAUQkRc1kzJWElj0MFRNXs8f/Rg8UdM6S5de6eEOZxj4wAahFP4qGpXpVIiDh4iN/yBOMfB+zFxUtEiK85r5euZvZDOdYr/osHqIlg3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Using kvm_mem_is_private() when populating guest_memfd instead of using an
open coded equivalent.  In addition to simplifying the populate code *now*,
this avoids the need to provide a range-based gmem lookup API in the future
as well.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b596486d184ca..a11cf6dc785da 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -811,9 +811,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

-- 
2.55.0.654.g21b8a5bc05-goog



