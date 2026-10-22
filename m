Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5204B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QQcydlmp
Received: by kanga.kvack.org (Postfix)
	id 5EA366B0A42; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB546B0A43; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0F76B0A44; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 249BE6B0A42
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC8E9402F8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
X-FDA: 85351853034.30.96A35F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F1A8100006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQcydlmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711695;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXpiFdgiFADjFoQiQEm3UOPs50aJ56Xpnkv8VHvSiEU=;
	b=W/821AxI+Qcbru4DP9lhRpnXlnJwnf5zdVQWnsPY3uC85F7EFustkljbV/8y9S9gzX+NCJ
	S7WElpDJ3SU2fkrABfzQqqp41ha1V5LC9NcN+K+m+oBI+8U9MWCPE1CEhQRDGsnECCk4z/
	yZNy58Rtk/VN7KFykqod9u0tjL7BcpI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QQcydlmp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711695;
	b=hR2d9SS6ISxH5oEM+X8cPM7dr5Hsq64Nk6d/sFrA3Q9j8OKVJR2IypqDXewyntF6StrANH
	66dyHp3g6++vMdCze5szQx8jRJ9K/2gkV3ZejQHhCSpM3/WFRN9/47iXSvC9KEfCh4b9z+
	ETMKJXW1TLeZYqHAyiWB1OkaAxd4P48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EF4060AAF;
	Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711695;
	b=z7v163HmF+3lyZ6fvJETlvZJ6VsE/BPwj7m4qnPCKRkXR0G3T1JE+QB8h+U8aho2X91Q
	 0j5+qvuSWLK4SbPWs7gGMQQmKMGsyrly5KXynJlTH81ZXUJbcVwgGi05WWIVuVbO3LA/f
	 rWBG1Pz4s4m2yji23QrEnOIynClkQRHmwQlbsMVxjbqDt4SuyfaS16tKC8GBS2yYxax5U
	 BWbm6Yt4ubLkyrBO1lVJfwb6z56FmZawaYdT6YWjCJeOqjpkWWgCVMJKO7V9ZoFUq4nY0
	 PSO2b4Lr9OxCCNq+u1R2f1j2ktcU/0ibnwjP5cuxRzUo05YYPKSdIFGNUMYu8V/KQXQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711695;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=sXpiFdgiFADjFoQiQEm3UOPs50aJ56Xpnkv8VHvSiEU=;
	b=2ywg6P01OIYnzbrwYxu8pBr9kNT6ehFj6oGrRTV6a3u/nMDcEiK2OLb86/13/YCGrW9F
	 c7S4t+Rob4Ar755tppCYMOnPsA9C6qQd+sWF26ZxyiX9YooBVoD+6wuWmL5cd9UnvTJRl
	 3ExfyinsM6ziK0ykXPaGemu8ZYiYe+rGDi4nVTHwmfJDLSNW9q8hHZSs0ANljr3t678V9
	 J66KIrgHt5cS5O4PP5xWOdpQtGicHKSJMp6bLumSD0zj/KjWORZSfksLOR39SuCEipIA/
	 ou4/riMm5DzKDqqnUqZ0S1H6WPkqx49r6TOWy3nJEQLJTu9C51bcRzP/RJ9qnriNNrg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B99FC1F0118A;
	Thu, 22 Oct 2026 23:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711694;
	bh=sXpiFdgiFADjFoQiQEm3UOPs50aJ56Xpnkv8VHvSiEU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QQcydlmp2wVVdxXQLJS1BURq+EtMol6NoEmrkIK8mtLhZ30Lvnxf/BkQrJwwSDJ8E
	 fJHLgOovrdZD0d9fPWWK5ec9BZuCnbTn8Q/UW+agaefuwsOSiRRONp7gG+NccfJF8+
	 55rrp+KmN7ubExVkEqNK2T4KBjASyL3ay1x3f4ANflaOAadH1sNGFiTdjHQyjnC7BT
	 tidboHFLZmFkxpr/RGXxTe/sQ4IV1vQ5tgh0AmaHMB3BWECSsogGF8S4F5fPcC6QG4
	 HRCayVNol6z3f3F/ze/6ypSmYEjRGQFTJif1Rt51jhBdBJgqGnb3wC3qXIXJ89Exwo
	 EscNf55zIeDRQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 07698420D4;
	Thu, 22 Oct 2026 23:27:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:08 -0700
Subject: [PATCH RFC v2 36/50] KVM: guest_memfd: Support preallocating
 memory via fallocate in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-36-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2046;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ruEmL3chvd8JokhCepFOnDn1Y4smVDlYZiB5qceIgW8=;
 b=FCqs/7HJoJ47wX5RwKoAzGRk9YFXONRSv3UqgfCSdcZz7bmU5uRT6JqvbbX3FH7v7nYm/MpdD
 BheIjcCflfAD4Cb5mYHu8K4kGD/K1pgBjk09pi2A2iBPrDVvJXqGqvW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9F1A8100006
X-Stat-Signature: zejd1rgm649wuh991asi15jhzoatahd1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711695-659134
X-HE-Meta: U2FsdGVkX1/mxNhXGv4PQnv8kKcMdw8yJ4xskXYrhLQz3G1Aya/fCjO5Wby6Aks6qZg2qZVBdC1U3eSmQrH0eP2w/ImxKhsT8bxbZ/mblTVtgBQ+azsz/XRX/20UmYCP8YjHo0LrUeI/e8XznGR0E244L/Wj3R0qVaHg9lWktr8mUomDJ11VzEn1fzjjrCmzqjK7vsAPOLcopU4LPfFsFtyuiUUf+ywVb8JAFWep1eSdg06I0gz07Bw4OoC2kRO9h4V3wWmIecoZwXvdqoCmSjhDPmAs6A4FKUiZB5QliLTI2o2J2ugTEcbShSr9mYOYpOlVjozbKuslh4nX/gYQrIeS9EFJ7nW0jMSadgAT/axQEB85mbboB16SFxANRWnL3REGb4ZhCM2z5ZAQymH+QW7ld8sLuJvMU5pH9bXMOsa+jb1O/3op3UlobJh3QM6NGHv5A1N8EihEgC309kmmQh20hfjZJ41Fk3d4PC49Y0tDU3W1L/xBG8FNQ1WdX0alARLGk/J9guKhK8HAllkll6Bd8jYJazYYRiBtbfLvKkTaIURJANdANg5JEeCwt6xGgCIjJoWrO3b2Q4s2EpjwAoLEP4xnoqw1ILCuNeKrTGSm22xN+i2QoT/ZMoG/5VBQZLiNuKsC0P6NU78gW5WbY69ooW66fsdZvLnHxI0lg5AiHrfo9oCZmVF8rRZCC//Zpuf1wnom2sTAwSCBCbIzJj+eoKGkVFUm2VE+14x4ouPN7fGWD9nxQ0FuwHT7gSNpSomQIO09cMj8XXB9KrGfA329oI8UIkBeCOHbA1H9CQlb7l41CntdpbzBvnswo6gEUsobLRIbge+1hu4woxoEVgEo7+CpJ4t0bX7jW9QUTVdEW1sNr3b5aDtvVfBGjaxZ1HPi2aWojX7NApq64Etzglp71ZTQV4mDgdzYlhzJZY2oWSxu9kD2MTHPAwX9D/1UVAui2bwvkOhtsba/dJi
 m704zKIy
 42RslP+11x1KhK/PcG65WyH/V6nZiS1lcP/UNdXP9WQnIQwZaFdOndkn9ZxTygqHcbdIIVWEpqCbQddgBAmnzz+8zkQstgqbJFUJqga1Iwfi1HvFORPzwA3jXCyGy0BzTkM9OapQlSXqOZfQRP/lIwukOqiUE+OHuET1DWdkmr81y3qu2QphPwPylAvxfzZAhC8V/cDwd8GUFbPlwnEJWeQobzxh/YZxBsf2Bxd0Q/RGDAQiUlHVBP0OCRNpY7pzosVCpvv2qXXDk/aebHWv5y4on2sp100ihKZaTtFqMAbSEti25YGgoC8Z5jlt+Ys6rJMOIuo8XQjWbHi//cpVS0goXcrFmpOAEXDhF4vtJEqhiWJN+jtuYMX93pCRS27q6Qoa7RnNq58yb6JweGZ55z2Sz2wkA1dXGI9WZSpZ0gFycILjiRFzdVj3uF+X4Oy8m7S1L7gjEikHP9U/njTDD4zRp6kEsV+FVwTFlPGFu4JyXnWKb4LNb2F8yctb1IQt6G9Vbk7YtGSO+dVHrCjkkgorLm/NUCXpcbAH49KZSXNfYop4QJwOL1gXJuF2muBa/JQy1JhMrhFk4Y5NojGIzxrzQq990pOFgvr/B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, memory is not backed by page cache folios, so attempting
to allocate folios during fallocate fails.

Support preallocating backing memory in PFN mode by querying the
provider for PFNs across the requested range. Step forward by the
contiguous order reported by the provider so that large contiguous
allocations do not require redundant per-page calls.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 734107dad63ee..f0c5162cc7a7f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -405,6 +405,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
 	pgoff_t start, index, end;
 	int r;
 
@@ -418,6 +419,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 	end = (offset + len) >> PAGE_SHIFT;
 
 	r = 0;
+	if (kvm_gmem_is_pfn_mode(gi)) {
+		for (index = start; index < end; ) {
+			pgoff_t next_boundary;
+			pgoff_t max_nr_pages;
+			int max_order = 0;
+			kvm_pfn_t pfn;
+
+			if (signal_pending(current)) {
+				r = -EINTR;
+				break;
+			}
+
+			r = gmem_provider_get_pfn(gi, index, &pfn, &max_order);
+			if (r)
+				break;
+
+			max_nr_pages = 1UL << max_order;
+			next_boundary = ALIGN_DOWN(index + max_nr_pages, max_nr_pages);
+			index += min_t(size_t, next_boundary - index, end - index);
+			cond_resched();
+		}
+		goto out_unlock;
+	}
+
 	for (index = start; index < end; ) {
 		struct folio *folio;
 
@@ -444,6 +469,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		cond_resched();
 	}
 
+out_unlock:
 	filemap_invalidate_unlock_shared(mapping);
 
 	return r;

-- 
2.56.0.257.gf7497c7d27-goog



