Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAE6E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5y4cXdR
Received: by kanga.kvack.org (Postfix)
	id 324746B02F2; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC936B02F3; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC766B02F4; Thu, 22 Oct 2026 19:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C974A6B02F2
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B790C0329
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
X-FDA: 85351853286.16.4894120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 32BC440007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5y4cXdR;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711701;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcqB1uG+Z9Yr4Mtabjmy4a0pEzhWKCVSsbVsmsM/71c=;
	b=WC0X2VVFY98T8cYN9WKTj/D3C1fYJaDw2PbQCGftd/W4so9mAu+qD/Vc6D//l25p/5+bYX
	ZD+o4uqDmfXN3sGiVtpNFP6yJInmhlCWNgVRJA7dzJ7t27La626HBwiiTFpN5QvNhTf2i1
	jextLd6b2DYBsEfZETAsfjk5Y6SKB1I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711701;
	b=eZ4Uds7SFlc+gGfVTIKuz4tj0TPGvYrCzqtLp+HnjNZ+TM0uP1iFjP/SXS+1VduQzD55fm
	t16tuueq0OMhp69d8sAhQ1uij5KTV9rJ1AY3pYNPeC/zVIxPYoUu2x5e3auX7WsDacMa9L
	MVTHeOdK6XqGUyn//ydDbJsSCVB8YS0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5y4cXdR;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37D46444F9;
	Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711697;
	b=IfyNIvZEkGg+0DUW92nSXt7Czzjsq1V7HDCWOh08D7jlmt7WXGopeW10/soRcbYlPChs
	 en2soezFnO5yj78fko+CEcNfTA0nq0nZa+EipBzN3NR8ucoTM3PqupNE+muWD1kTh5lI5
	 Z4ZIuGlF3DuspuRSvij6q/Iepqg/qvlYtg3lsw/8teSVbey3Z9gFajfzb3Wiq0nyx0fU/
	 89DL3gj4s2hbz52bDVSYoS60DCFcRCAztLucVEZuGzguTsIQfuvFd3U5yjAQVWot/sv+l
	 fyhgtaX0u83alOj4Lag7Bu/rT4MGKrgUFfH0tnhrUnP2wc/9Gt8pMSr7xQrOPedsjnw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711697;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=IcqB1uG+Z9Yr4Mtabjmy4a0pEzhWKCVSsbVsmsM/71c=;
	b=A/zn0n3yH/MNqTpbbQzYsWN8uoeAoLdV0pAOaVk8u2p5gZusDaPnQYhJK4w144+HbzMJ
	 uk7zNKn+nLOvbcgZTo7MHLySjFS5HdRtiAy3V3WEpt4BtV7+2VFiqsTrFLRuluCxWVugE
	 UlZYbzE+Bx3CuHGLiEK5vqx0e34VputEDhKBSc+VEeAGOvDHpi66+9GYtrEbqAbjQmvrU
	 K7wH5mmUjod0FUI8cRx7+kGmDXLGxWuEmOObrcmGw9dNXm+ubErIOcf13txiiNiZkhuZH
	 dPiXyfFJgLStaRV3RBm4A9xp8/at4+W8GI3Svckywh3OxMVHk6M922+MPBoyGw63ORQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 707061F0119B;
	Thu, 22 Oct 2026 23:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711697;
	bh=IcqB1uG+Z9Yr4Mtabjmy4a0pEzhWKCVSsbVsmsM/71c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=i5y4cXdRPEimj4JZcNEZXV/J2NhvGbkV/mrhisM97y2Zf8drjVPs/eSeqgYj48hZP
	 BtXWTqo/R7CdbBSQajef4KiTe2i8hHqiUlSXmC/0hG2rHxNtvIca7B4gytg3yy4f7l
	 h1ZfEbHqnRxSMQctsF2p6TsZl5H+0UUAG8XnHcyiO4NWF/U6i8I/Pct9TSF7KXkmu9
	 MziwZWkeQxnITLxalnlfQhOr6bolNNdJuGkrFI3Ywi3mSqczbfyr4jSAXO+UumoR28
	 HSo79XbZw7BfzcuI7HjzLs085MIUyRX0J9yt1IZNSaePBY6DkH+kZOqa7jwxys7Xyy
	 uOJanmIV0RoLg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E3BE3420CC;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:06 -0700
Subject: [PATCH RFC v2 34/50] KVM: guest_memfd: Skip checking outstanding
 references in PFN mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-34-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1241;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Dxs3RjFnzau2HBrxLaEPNXK3fpyUMAcuvPGogtfNcwM=;
 b=vVJnY7c8iTESjki2sqSSxtlQSZaRRNqdryI2wF8O3+c1q5JAPRkYJnGldQQ7yd6gwYOoJkvvX
 xJ/9Fgt59ysB0Hc7tY0257x9kOgE2MfKosIzomqD9kJCTYEzlVgDH9+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32BC440007
X-Stat-Signature: mxurt9g3t5z79c9g87wgo3agyyeptuwk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711701-637234
X-HE-Meta: U2FsdGVkX1+fscg0gUDernykaexKcSzx+Sq/GPOJ34EGx2h+LPunZnWVS/pSyycIu/e03vbgiGp93SV/WY8y1IeJ0P2yVhQkh8MxvjrYvg6KLl9Exn+TC0KbaC5VtbSFHZANH3WQKfAkWwpJFfyGA6h+1PJppcWJPdrCNw6WJcjGM6QxGHpSDX2oHzI7/NJX7EujpXrDAwx7WsIW7x1zkPDE0pz/5iOA4NVRabvIF+zpU4UtflVMvlj6WnYL2DbohTPG+JnOQg8gNm7eSDWBhT4/NhHiNo5v5slKBkgG19jG+wmpW3o7CATasQHtPg+vcALZOrfmIchY21mHkiFrMXM51ttfbLpxfM/2Uu4cq0AQAwS8GUCDS3Pxmc5CqUOCImyeH08HvZrPE0z80pUUDqgYwNiWKtfp/loNRMsmWLH87wS1walZ+4SOkqO2Dcz3BcVtsJQdxLvKavFt50ADaCNFAuCweSmECKkbTSbV5ndTy5Y1Atwv5Qlen0A/TC0fBXr+d7YCLb4DJNDxPSgUs0Aemy1IOu1uPbg/jX/n8yCHz/Iib16OPChMd1BUppLrBcPucDFABDIKOpkr+fMknnvP1dTUkuRNmx8QMrqbdKmpx4+96eKBBxm6/TGZFjOcVdV6qx0twwile1YIzET3TW710FYHCinx+4BYNUNOFLbu+lFjc3j03x7XZDtCayJrXXUrExAP9pVjMEuuzl1lHn5vUCT2QyfIaAsETb+fm+Wfp4COsyml8Whj3WCu+o6aFei1PzNNoVvIf5aTZ88i5bUnoQUr5O0xQhLDkDw2ZdmIXQfRzJ91gekVFGGRSLbUlt9alswTX96XqelNLRwfN2q/9l3gZVoeG/kpzVHCHS5dZjrPe2c4sQoEF0w/YTXhTsvmcATo8BQVXpsiTB2MAulaUJzIKm7DVbO1styqGX+Mg5CkneT9UqNKP+5MW+MXO5SCwvpyXOrGVsoKWgs
 pNhW9/n3
 7rK+axi1/+8r9wflcUmMnfAPM9YPXCsXE77BhKvORjwlnD4PTgpypvfZHZIBx2S1eDWgnolHrL7hwuyyKCxiIAq5u+D9KEKRNBmGU2Snzxg2cNPIe4NapOKRhZi7gm9nBC7vPlxA6xUTLh56eHHHbUzSn5IEK53eBOc7PJhap68V+LdsonCF/gWJMatxi5FUXCEtO69vIY/7eYMg1e7JIm/cGDvHkUFgurFXZBabJCVln/gMTc1/qkk5Iais6Ai8r4rHB4pdEHKFWoJcTNI5gh4XlRbUALMMfkNj7E77EY/PqQFMSDxIAZo1rGFiWiexyBMGxauPgTrU11i/O1zd6TZH9ZTzacQXc7JldBlP4SpW+rZagf+Dr/PIp60ESKTSJcvVDG7JOIzwtROq5773/iEDU+oUneWlnhhCRPlrz/rlZ62Lc/7sMBOV76M81ByVXNWH9Z+oxZ8O9JNm+RvanU5sc/HrEbXlfvmPWLE08mlCBb1oRE+9jB2araU1OYT0lqPu9CQyvg8sLHutMEtOQ7HhMAP6Q/gKniDXfguqU82nZCRQ8/l8lD4ekx/M5DcaV8PeqtKchKTES6o4m3PlnGrzyU5HcYaMe0Tz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When converting memory attributes to private, guest_memfd verifies that
there are no outstanding references to folios in the page cache.

For PFN mode, retain the part where memory is unmapped from userspace,
since userspace should not be able to map private memory.

Since memory was not mapped into userspace using pages, there will not be
any other users that had GUP-ed the memory and there is no need to check
for outstanding references (that indicate other users of the memory).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 50031e191968b..daf4541c3dec6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -854,7 +854,8 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 		 */
 		unmap_mapping_pages(mapping, start, nr_pages, false);
 
-		if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
+		if (!kvm_gmem_is_pfn_mode(gi) &&
+		    kvm_gmem_has_outstanding_references(inode, start, nr_pages,
 							err_index)) {
 			mas_destroy(&mas);
 			r = -EAGAIN;

-- 
2.56.0.257.gf7497c7d27-goog



