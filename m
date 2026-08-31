Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A341BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0896B00AD; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4FB6B00AE; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB406B00AF; Sun, 30 Aug 2026 20:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0F26B00AD
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5DD6A1403C7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:32 +0000 (UTC)
X-FDA: 85159670904.17.5C82093
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6537220002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nj9sQJoq;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rwO0bkTH7752WpbzGo/NnSWPhKzvnEjckLxcf3byYg=;
	b=zX+aGN9gorQfj5HStWJmyG0hPqptMuzaimcDf0klFYf1YEVGgOosDJqGUXnyGRM8Abhvot
	agbqJkftNG19pmuCZefQKqX0rE8pZI+S1Asv3Fg9mC9eEBm3A/0XDHZjExHvDphMGmXklY
	XiYdGdQmimCI+uZc76EBldkflk/Dub8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135930;
	b=KYcgaWCwssKGmLriPUi+o8e0fbBLznHL5UuRi23rT5rIUnaI3tK1SCaXLv8LjzJzJLD/8i
	AuOukOESnBvQwJJ/UXJ0/h52R8hmg3nhUcg0QbqqfxpjVPbKMeYqvwcN8jmzhRqmBxsoLd
	n2LeMz520GIgLUojnZstCqi197QJN3Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nj9sQJoq;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C25244485F;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C0B8C2BD05;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=I+b7lGuVoGz+swvsL7rzFlWNT2yN4ZfPLfGq8P0JE3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Nj9sQJoqAPH0H2Yl/kBKSHC4wJEQbhF/k/eQKR8YVNhkLabYa8ZbV7iEGoFE4zoAy
	 mivPWY0LAI6h+61PLFMjO3hyDhkF6xb54oD3u/Yh3YEibteGkUS9GHGUSfFkcnvl5u
	 /YbILdp9/gVWOtixolSLpfk60LouFI0p5WsxIJFj+iTfpa1nMTwVRU5wl84CpFAmxR
	 iwafjSxSt4kPOUff8JIYs2G8ILnrN8cWbEr2bwvF2HnuLjqBwccZ5fLR3W543iUo5O
	 eaZhWAgZNoF7drPA90u5RZT+blPY7SUXSbS9TaH6K9qN/dtg6Klh1h5pl+iWKsZd4t
	 nsbCz+BxfSuuw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86861C61DF1;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:21 -0700
Subject: [PATCH v12 20/45] KVM: SEV: Make 'uaddr' parameter optional for
 KVM_SEV_SNP_LAUNCH_UPDATE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-20-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=5596;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wPi3PLQGrKXDeuAU5z9J7AGBTrQFd9B/lpdUMyrGDEE=;
 b=9k/bLEF3An1XBhsojLn0UeoSCr6PDB828IGyADWhdI3CcerN0zYcgRaFKrrd+pDMI6fEmwe7e
 Jh0JJIyXJ9DDWGXI4dES9EK0noyDEDN1Lyspx/TT+yisOfiYEXsItsu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: noj1pnysxrwf58nagtrk61s3q6uxhsrd
X-Rspamd-Queue-Id: 6537220002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135930-749789
X-HE-Meta: U2FsdGVkX18jBufZbHwWUkXOGdHOEGZLTTVULWMuefSlrBEvKl6yH0QXucICHnqbQ4sA9uLCih75SFEM7MtlllPF2X6ersDJBihyWrCOp+Y/sZtVrcUXk6I5YDMQgigMMohP5oa8Gsq10iHjVFZo9mSYslpSlwIRp9cbI0BuP/+h2tN1mewsa2M5AFUieeIRhV0ElQqzqINWvSTLnXG2o/cuMNyveZwj3fqBHxruZc8+viOUf/5bKmDGCpC5YzE62IZpFM0fGJvamEEEKxOZn2SUK6yV/Z3hiiTOxdJqqAzKBkZ6Xy9W2h6hMbe1nJf3Z1NQ9x9QXCUjnZE82TBE4slW68N9mBZwV2p3qFDM+wlXgJQ+/ebAXrIERob2GvJvQ5aYJ+xj4x+ItvZ0XVx/5eXDeFB9VcCES4kwD9OxmIe8DCHtoGSeLWlriTcLVsfRmdJUHJR582EKXR490MiJ1BkuHewfPLkEsNKYMeOCOO3wDM94GdJ0kaMheEP+IZuZP9CWIQrjTfOz2RXtDwC3H+1S7yPapAIzoooCYVO0eqvDYdMi52STI1Ytf53BAGNNmJGdK63gG9ONpKl5/Wxy7sSp9WMuepFLzca/w/2sTAfI4Y0UzxViXUJkc73/hrB4A627raPtZ0eqXkQ4zUNmSi8hqaCoO7k1bJZltSjYXmf/ZTGK/ed5Vu6TgwhxqNMvJuH64X9Bpoid+aLWHTa7Fw3Z8OxCcIk/Kuim6hSbMdWysADs5ZTQZRR9CKLcTvLnzAPAnrM7U+Z8HjyBkWcE0cZXnEWoaSwCN42rpY0R4TpMHSr7T3uZ0yTbKsBqOP3q32NteXK/Erad+rk5BOncaIsxW0U2iY+cVCyOgY8eKIceGNF3e7vFb17aWzAJ7O5wm8CRGLQkqezTgoP9Fo5MmAB5Y1+Sqz2w/myQYSnMBejQfV848Mj5RpQoRvOPfgfDSv1GvF9v1z3jt7Z0IH9
 le9Zqvfa
 eimfvKtkg2LemnqRSLBUna7FpcLWdNjCRvP8685QGIbeOzZfWiDIiRPdpUjj8J7Q0D7h0gyXrWL+E9oOKWKtEgf8tdgJi/6stPr+K4w6nI0+VM01WB+KYS4Ozhk/buMCbcStr6uk1xC+pEKI5IDvIFwK3U/lXODVoY1Qx82u90LK2BYMzfP4V8V3RwGPCoW42p+ZqBzxK5yE1h8ZubxVrKqkgPJ+GQH8JzGyw8xdGjWhTDrSBHIMh0Ggw15N4ogxHvVQswM1zATEAWZC7CJZ+Jubov/vVMcInSS7xuy/69e0mZDNi8JXLoRPTenCLtbqdXwwIAAHpyUmoLBdt3D7vH+zKuqJ2cIU7jm2mRW/EDO7ziWRjFuoBPvHU275U6L093DEwUEvFPZhLwiDHkiwBcl8UHPCqzAp3jSoB0LmtZwF7ibZoj9mlwWoYWrJb2xNBm+4hSBdqWfP6dXKkLrtZzFHBgsoIbDPwabsf90QXSKUwTNia8kB0QFv4Icaz9qto42qDCheU4vKmgynf/bo5mudlag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Michael Roth <michael.roth@amd.com>

Make the source page for populating an SNP guest_memfd instance optional
if in-place conversion/population is enabled.  If KVM can convert the page
in-place, then it's possible for guest memory to be initialized directly
from userspace by mmap()'ing the guest_memfd and writing to it while the
corresponding GPA ranges are in a 'shared' state, before converting them
to the 'private' state expected by KVM_SEV_SNP_LAUNCH_UPDATE.

Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
for 'uaddr' to be set to NULL when in-place conversion is enabled, which
SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
copy in data from a separate memory location. Continue to enforce
non-NULL when PRIVATE is tracked per-VM, not per-guest_memfd.

Signed-off-by: Michael Roth <michael.roth@amd.com>
[Moved condition to snp_launch_update]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 14 ++++++++++----
 arch/x86/kvm/svm/sev.c                               | 11 ++++++-----
 virt/kvm/kvm_main.c                                  |  1 +
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index bd04a908a8dbd..5977fbe33b98c 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -503,7 +503,8 @@ secrets.
 
 It is required that the GPA ranges initialized by this command have had the
 KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
-for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
+this aspect.
 
 Upon success, this command is not guaranteed to have processed the entire
 range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
@@ -511,9 +512,14 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
 remaining range that has yet to be processed. The caller should continue
 calling this command until those fields indicate the entire range has been
 processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
-range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
-buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
-``uaddr`` will be ignored completely.
+range plus 1, and ``uaddr`` (if specified) is the last byte of the
+userspace-provided source buffer address plus 1.
+
+In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
+ignored completely. For all other page types, ``uaddr`` is optional if in-place
+conversion is enabled (i.e. when the data had been written directly to
+guest_memfd while the page was in the shared state) and is required if in-place
+conversion is disabled.
 
 Parameters (in): struct  kvm_sev_snp_launch_update
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dff684b88f153..63e8cfa9bf559 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2400,7 +2400,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
-	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
+	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
 		void *src_vaddr = kmap_local_page(src_page);
 		void *dst_vaddr = kmap_local_pfn(pfn);
 
@@ -2433,8 +2433,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
-	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
-		 params.gfn_start, params.len, params.type, params.flags);
+	pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
+		 params.gfn_start, params.len, params.type, params.flags, params.uaddr);
 
 	if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
 	    (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
@@ -2446,7 +2446,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	if (params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		src = NULL;
-	else if (!params.uaddr || !PAGE_ALIGNED(params.uaddr))
+	else if ((!gmem_in_place_conversion && !params.uaddr) ||
+		 !PAGE_ALIGNED(params.uaddr))
 		return -EINVAL;
 	else
 		src = u64_to_user_ptr(params.uaddr);
@@ -2493,7 +2494,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	params.gfn_start += count;
 	params.len -= count * PAGE_SIZE;
-	if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
+	if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
 		params.uaddr += count * PAGE_SIZE;
 
 	if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ea8198821917..05c518c9b8078 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -104,6 +104,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 #ifdef kvm_arch_has_private_mem
 bool __ro_after_init gmem_in_place_conversion = false;
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
 #endif
 
 /*

-- 
2.55.0.897.gb25b4bd76c-goog



