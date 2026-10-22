Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8D0606A74B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlxAhuND
Received: by kanga.kvack.org (Postfix)
	id 918796B02F4; Thu, 22 Oct 2026 19:28:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C83A6B02F8; Thu, 22 Oct 2026 19:28:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE376B02FB; Thu, 22 Oct 2026 19:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36F876B02F4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C2F9A7D2C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:24 +0000 (UTC)
X-FDA: 85351853328.02.99DE12D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 81FA31C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlxAhuND;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711702;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UylgyKGzjd6OFxQ++q6UaMzkTif56r+Bcgqiy41Jt9Q=;
	b=X9qmhm28to/m2jJAleT2l2cTm9ayEGtCq/K7cRnQ7TxLhSaF0e/irVriELAu1DpLm0V5VA
	vRm/ePvfZ+4vyf+E3oOGVkMFTK4djuim6EDN1oFdyeVI829p9rTlrCt8HnYFUc3zVDZHaH
	lVsvlI+ZxktccKn/tKGsv13OajAUkgs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlxAhuND;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711702;
	b=ImJdu6drcztAJcM4RyfIhqPENctKcWkgrWs10ges9/kVjtyaT4JDVweLCtTMTAFBPA7NGB
	lLrdZLP5NcvL7ghz4qOwqpThZd/lViZ9CamrSKz9xNq3yA58FGpd41KKn7amMi1zKZN7Fl
	YrT4mcEsYJeEZgyfJIwQu8F4x3Ai5Cw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B13D744859;
	Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711697;
	b=liQ0oyLem02oZ4umPcqGrr3RjDXi3hoHfFbkMwsWByuBAC/FL7BFKUJMBtggp91yAN8H
	 Uv1O45L+KNLLeJk2dLRAImqPh7x2bHBT6V01hn2xJicie8UUUkHPmw61QltpNYDPNnsDh
	 zIVTtHXO3buZvTbspAD/aXbAiQ2XpUaKVXjYnZRS1ZfnHh8rkcj3LWQtWYnEWSKE950nU
	 nYwQUVF+o3UQ4qq/vJDfSdWqRZ3pmE19J2snJw4F41YlyFGdr1uEnkSaWbJ1YBzNnK3xQ
	 HhnwvnAYqLvvmpNqwSU15mVdfYEXJdL/ZVPCwgstHlxqMG9vy+gnvJoX9SjjRiP+oxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711697;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=UylgyKGzjd6OFxQ++q6UaMzkTif56r+Bcgqiy41Jt9Q=;
	b=eaPkjnWF1glwDpXDoY2ac9XRxfmaBq0vPiIOaRy2o2ygpm0E2/3PaPsWEpjUMG6YtQuI
	 7A/YO3BhrmPMPz93jSmvTuIlvu00aKLsuu2LD0sjC1nk1GfnNViTzZV8AKVTyrCcBrDyA
	 xOaidH4az4gmGvSnDYynzG13x+s6VzMcxfsphLvMgiGNVnNvYaXMO8KCbN9iT3K6BG+2h
	 GvAjvr5PuCFN9PGcrN2QCSs0WeO/M/vqCzEATB1IHe+16s7u1B22K2sS4tAB1/LDTt9UQ
	 2ZLXj71gMX4/oOdN/8iA1zs0+SfwEvT4FNZZVFp6HMGygGjW++sTI/STsyYowMefhDg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9300C1F011BC;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711697;
	bh=UylgyKGzjd6OFxQ++q6UaMzkTif56r+Bcgqiy41Jt9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LlxAhuNDvCbuazbKvwE0G8NGOf7iD0eNv1rANYzVJlDBzAdytO44b3+kGnbu97lvc
	 g63la0GGfMBpgdAeySs6gaCgp1agrHXDsyRXiJeU8xsOkyN4SQuBizpShjGWNaDrrM
	 d5Ua0GEkH36TbpBaLIRndRL6Wa1rO+LbcoerX39XWot0KLkB5PJQ4GfrnEXZQlxt/n
	 IpVVMp97DhnfHRBtR1+S3GguTy0wZ5Oza7sG8m3FB/wBwlCcjVo/ODpkmJspKq7jTe
	 RusOCzY4gh7VjsYb0HBrDfjIcxbNtbjNenWAzrXYy9e7q+iUjudYRecy0X4z3Xpq1K
	 dr1qYajhaFQqQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2B3EE420E0;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:11 -0700
Subject: [PATCH RFC v2 39/50] KVM: guest_memfd: Support arch reclaim on
 inode destruction in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-39-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1330;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NdiG9FPDlnNbsz2ib8/wlciF0KncQRew07nTG0ctD40=;
 b=CDdMamphZIbmfallZAf+zAlCSwYwHQvFF250PUqCiYstDOGo3XzHcZzpxt2LRa0pH1AMCoBPE
 zaP+413XJ8UCDzIJFydqCEK46oLrN7zsYHXw7ptoxdrrTrAK4IvEU59
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 81FA31C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kyuccnc45iw33r83wy6pqkht7ujec3rm
X-HE-Tag: 1792711702-945517
X-HE-Meta: U2FsdGVkX19zoyF1FGnMqQ2E821DqQLhQYR0JZAghx0gi6o3UrguOB1m9M321BrdmFuQ/AXdpbBL8sFTbOI9xNWCgYMlb3U+PFy6XDoo9NC333msEauNBwMjA9jGgBqe5JZ45nntlxLfWWgvcpZIagmIWasKjvxegKRvtT0DTqdBvJTiiv5tD+68iNjCfHldLmRpy2PLRuf7sF6zRHIb/nfO1QSzZIuACGc3qDYOzRjk16ccrxMiNFVMURm37a1RxRIgChXb8TsZUwPPazrvVgOcYj90bGHzdfu8So+yGM0tcDoWUJe2LhdX4GQKQjBNe0LGRHvJz2e7yYqXQMFWJBkzvMo87pDWQo9OGK76+Pm5ZO9zKkvrlar+9lBwMRHrNhLXDmAgfaZnVkePLN3IsoPy49yqZiYnw6gjRqZa78KcmRZ+iRhuSfUXkYsfPSYetAfBvBrz5vmOkve1tA74O5HOEsPeQqsiJ4YPGRvJmiZuI8LKYVdsX1RtD8Fo7lDukLTt0uua4PmU87NytycM7ke8vj1ZlDZfhT3H2nAVWeFrZvuZOEHcFGHPIOrFfLMKDSnpmsMLVqlcsfoCoqNoCqk/t5oNEpESNAeaICxHeqLMbClY8gVmajfOxZnPjupMSnmQ/bO1PwBblFTb13B7sgLfNJld1qYO2ickJY/KhBloJDeradx2q1N3RTCKbhhpGykCt+d2wqZln8XIbOPOEOR8Il1ciEZ0ZKQT3GDjOwI8jH2xTnj6P+ugmdv2y9BWZPLfOEXVPnHSdOeK05RxgObTJscTVNYnVwL1cYMf1HzUvhgZlqJJdvYAT0O1pX56DfPwIbwKBrQrYfie+QL6R2D8Lca6GxrRDIZkATppDgE9bz9LH16eeHXmocp/JspZP2lEtYt/yqeQD2Zfhbc57pwx5Ln/98+accvLtOiWmZrJpHZA2CNW932Q+LRiyRdo0advYxVb8TvRKdDkIWN
 CzhZrIYP
 uQw5A03Pg33t+c893kE0BKmEjI2OD4DJ1NfK8/Cnp0daklkL1qFVsNHO2eTrvje11lHsuwGM+yoOigwse+7Xny2Ix4Tf+O0m4Buau+V4wnTNCDV4BU5wpB/EMg9+VYyK+2LAgcpoIpW4LkTjlufjJGyHIZee49uR6yO0HIr3PJU30hBkBrcGSSevsEQ+u/83VgaNPZRBBd0y7/4FUOpb4YA7CadVxHBxCCigZ9pDt0HYmeHDvaamp+EE+zbuA6/TQ/LuRbGKuLDg8vqDE0EMrj+aFStw9sn7UVGycITyMs6/a5oPKzWPPiOhGoIIh6NkppvQxKG/FygcXvX2unrsQB7SMIa5x5cM8TGfQUNfDUR7aov8157WBBtWKqalZmQxFqQvvNaoXqXTMOLSoZEP55r6TBXkCUtYouWRFhBYiTNgcmBWWGx4YX+o8J4fyXK2SBemMUfMb4egbikKFHeGTP8KYv6SAIdiQkQzbSDOllEvI3qhoLOumbe+f71rRyD4P/e4+zI/3Ab5YKew0CUHnj/BDbkYfJYQ9he6KAsCmCZ0lYLucP/xq5NjKLIzr9POOM5iFv2UIFz50FDnlJIReebpv/Ev02Iw2LOGq9FePRcV5qIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In folio mode, folios truncated on inode destruction are reclaimed via
aops->free_folio (kvm_gmem_free_folio), calling kvm_arch_gmem_reclaim()
to reset hardware confidential VM state (e.g. SEV-SNP RMP entries).

In PFN mode, memory is not backed by page cache folios, so
kvm_gmem_free_folio() is never invoked.

Do the reclaim during kvm_gmem_destroy_inode() when in PFN mode across the
entire file range, ensuring that any confidential architecture state on
provider PFNs is reclaimed before releasing the provider.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0819c3653e88a..88eae9d6d249f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1643,6 +1643,13 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
 {
 	struct gmem_inode *gi = GMEM_I(inode);
 
+	/*
+	 * Skip if the provider was not yet set up, as iput() can reach this on
+	 * error paths before provider_ops is initialized.
+	 */
+	if (gi->provider_ops && kvm_gmem_is_pfn_mode(gi))
+		kvm_gmem_pfn_reclaim(gi, 0, i_size_read(inode) >> PAGE_SHIFT);
+
 	gmem_provider_release(gi);
 
 	mpol_free_shared_policy(&gi->policy);

-- 
2.56.0.257.gf7497c7d27-goog



