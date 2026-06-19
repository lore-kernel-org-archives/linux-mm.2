Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC87CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803A86B0096; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB7F6B0098; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572106B0099; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228736B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 961D51C17F3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
X-FDA: 84894784380.30.8AB0AFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B16BD140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=caQZvpze;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829108;
	b=P5oZukg/3atJxCfUpPoxVRP5/sAuivlZrJn5HxfpCtJnjq2c0Htbd5rFoA+xLOg5WsKrJB
	OyiqAEcCZlOFiDADNydVW5WBhRFuv8KnyvCcDHBXKFIZ787zKP3AA/3BZphD5jWtN41IXK
	FuWog2tBoiz4qJPKczotSvNZ++vTbsg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=caQZvpze;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829108;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qv+OBwWDQu9oGyS/MmSR4LKy5PmRGc/Wo60+YvxDELc=;
	b=RN0vhwhrcfPYGtyIXR0E4mXf617xEd8inBuu2Z0bGD3DuFuQwZPRyFJwwdtzuZLsNRE1Ye
	ulZtHyiCIHd90lBi7sm/EZXEk3HGp09gf8TjEgrF0Q4WQm4xOCOyYD+X0sEszfI8hBJ/cB
	sYYNjEiHXH1BuLyCXHMCevVCJp16CgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7606601FF;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13713C4AF1B;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829107;
	bh=Vzp8jCq3+1E3fkxWdqNXAg0Z9BLe9ZDYrsSr1hV0TRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=caQZvpzecHz3OPxTB++VuZXF3fiyH30Fbme0bJas42luPEQ47VOTOMYFqb6o9dmGu
	 Ikw+prrV6Qhwv6xvWnlhvlSHzM4ygr/RbEi8J+8kvy4+gYqUz3ueVxdZfAlPvmFElU
	 euQHYy0GvsFQ5xHxnrJaOxgKRAoMCvyGdUDQ9JGA0QErIbQNs3izpHISditJeuKSym
	 vpdJrrPifRxm93o3cumFetsG6Vh/S4zVv3P9L52J+BIn1ADli5pKrttUqB6JX1VdVt
	 HrF0hoGHr7WTnAAKD9uBkuvMCh6OK/yYRFAaPsy9ijFu9XIKuaOvu8NRNcUZgg4bup
	 0askpqMceB2vQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063DACD98F0;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:41 -0700
Subject: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from
 CONFIG_KVM_VM_MEMORY_ATTRIBUTES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1692;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tPtTsemV3L/BlyDiwtBhiyBvhPxEc3sDZeI948QYhU0=;
 b=ZOXkVSHaCuMVMkipqLWNhWP1iE87BlVmktp2ZHK+axSNIceX1lSRF0iJBTpQp8efKYl4ZRk9a
 Ur1GXUZIcQeC6GUzzCDt/JZ3Fmdip/T5fngRW20wYeUkB8SH2S68e3B
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: uegnq5oh7won81fgncpub1uuxkatrwqs
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B16BD140003
X-HE-Tag: 1781829108-817190
X-HE-Meta: U2FsdGVkX18I42vGUI2KYoU2Oohf2HQpO6CGpMslIxlF6/wkcVsSZY0txFMVtPD8fR0SShKlS/PvSHUDlGfcC5AnZtj4/7hESBVk0MbLrDYwEHAbSbzUIRJK1cjuDMvP4ynC5LIqKVQxICPRKoLYRE59oT0nLT6kpF+ckt4GxSavz+ySHItLh4mHjO2PjbM1R4oFZ7fLRBGnb9scZ8tl6wrrZsuq2I69UTcUXMI+hlpxPOP/AQ0+83GFK/Hvn/JU7WRLTIixllKWApc0lTDP06A2ZnOU7JnC2EFhnljPQ6OCDSvGd0dNJsliygUWioC3QLV71YMeDiQwA1iaPp/F45hJe9RJlaKQxdyXjiYNPvYjgHvQBdcBIEzPRMlnQwPwMsqtS7J4hRL42SlFuiQJL8UECH4ZPpvF7t+jQ7g2xz8NMGlONrUwSv0KcFp5WjRMRQgb3jXL4AZMiAT4Ewe6r3Y5ib898SQ5xXN/odCIt8Vmy97zzCdootgYxSi5vD9v7B7eqf4wpXzTcz/e8ds9xZVPJC/KxSWrOiZcCdt3nVb+Y6F3Re/UaIpdQdIMOuIBLD8tfXjheuWDlVh3oJ+dIsvn/I801a+iNIaIfblT27RMxQLGBy7P37pamcbyPKP2+cPqrTVMBTOwAfiTwBp71Cl5lwtM/IRKgm2Trdd+RQQo8En6rpUqau671fCdhLsxIA8V8+C7y8fnZMr3AjSYq1HeAd7KXd1V53X6KztpU8ZbbEuz6XV9TqTc+risc6WjQ8BXRsBGWX07gojWHjdtmnW5nEI6eprtwnMqjenruopjye3Ae/yLE1FeaWIpPCZmXMVYdIcURHHoaNGguDhYk1kwQvMN+Y+dDtFVvs3wvuTKb8QrhdiE8EcR8IlXzHNV4khaCoKNXUKusTSdULwbraQANKIMaGFMDNk1jT3VsL4iwxmY7mgh8iVn6lQtAAStz66cdoEoQIDyI/OSC9e
 ovgh2TiF
 ywFbtJBhmAG7J6kOjg9iWruXco8c2Nj7Lf1AND2vztisWN19NCXuz1YQDLLRVmAX7SQ6kYg8FwspxY9SmSnT8wLcRH++F0z6+9H5oM8JtsECx2N/WJzX6W6KMQFtuSw6YHcRtKRsweIqVJhWBMtKyF9hHhgVkuTFrppViZJR81rw4gp25IGpdMmgPxKj/TaUSdGvVJEPGVPFI/8h8vzAwmAr3qjx6t3mmrQxrsP3K4NFp+q1Y6pNv19euGW7XgS7L4VVzGtAwbfNMYPmT4zmwos/Azeoc+ocbxHLngxw5k9Z8wTVPFSgt+SQow6eVIKZBvjxV9xxeLH15minAryxX4uAcyiOtm4BAJVXo/gdc2MVLB+MK8IW2MEFSgzuvG7s8c7vytryHIPSZq/EeSkDI8TH8Qhby2FO/ztouBUqKyr8pZgmfd92NYObmpsf1n6FX0tcBmllvq1YzS98L9idLSyIijEV0nJWViuyPFwfAwZyDL3k4mbkgZubIQl3qZF8OS2mLWtSZTa8855m1u7BhyK61/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When memory attributes become trackable in guest_memfd, the concept of
having private memory is no longer dependent on
CONFIG_KVM_VM_MEMORY_ATTRIBUTES.

With this, on x86, kvm_arch_has_private_mem() is defined if some CoCo
platform support (or the testing CONFIG_KVM_SW_PROTECTED_VM) is compiled
in.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 +++-
 include/linux/kvm_host.h        | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
 
-#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
+	defined(CONFIG_KVM_INTEL_TDX) ||	\
+	defined(CONFIG_KVM_AMD_SEV)
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 201d0f2143976..d370e834d619e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
+#ifndef kvm_arch_has_private_mem
 static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 {
 	return false;

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



