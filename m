Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE4E606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VDvi31ec
Received: by kanga.kvack.org (Postfix)
	id 23B376B0A40; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2114F6B0A43; Thu, 22 Oct 2026 19:28:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE8C6B0A40; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E006B0A40
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 448494033F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
X-FDA: 85351853034.09.2FF1ACF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 44AAE20003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDvi31ec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711695;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP0kKJ6BHu68oTOx+BvZDLLksWpeFQbo6JMfv8oBSaU=;
	b=SPMYKob0VDLB8zNP/leFTnlOLQwtb5HeUssZcPWbKwpTXrZCp8OAqhg9nF8LIX+9xwjmY2
	E6Yc5cWe8G2mOyun/+6coYOAkp1BYPcAXaDA/6SHayE6N/9bKok/O+oTRMs37OS9XclJAk
	5bBBbvB9OAn0V4Ui2qzR1/lm0jZfYpI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDvi31ec;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711695;
	b=JdGROWU0etSq4qVVgCLBkNJLm9ND1jcLi/yEzShzz+6ezQAKsl8glDnnwi1DzQKR6xN9bd
	FMU4eJz1SZ8Ldm2s9dofE7NHigMbTSL+cqmZL5N70u7hhWItyhIrIcryIX/bCRPguXTHrx
	e5+KvwOjwD7oihLlNs3FqARLaGBxOi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E05D860A9B;
	Thu, 22 Oct 2026 23:28:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711694;
	b=pnx3WjuTQ6aSL3aQBtLkLzqeUI1lCGrpr7XKREoptOhfhVCO1IjkZDREqwcyLQV6AtpZ
	 oY06gArmiDWx3/bj7UBjVxqHpgjAuoqticjXtivEyfNIci+ddNKgy2BbVkQjIovoyxfw+
	 JvTXtZP/+MzIn9U+uzScLDTzPb6v2tf98n/kxizROuoJkQhvdj43Z+kLsg9yK0POYMQ5u
	 j2dHVUjhmGNuP+kz/WtSG+U6wNk9ztY15Mt/5afHDSRWvOEVrnkRrB2PXY5J2HYSQlaxY
	 LLsy1Qqd5SJz6ordajHplSe/0NBY4y70YW476kNkrDg6vf05GLRtgXzZECAByLRRejw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711694;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jP0kKJ6BHu68oTOx+BvZDLLksWpeFQbo6JMfv8oBSaU=;
	b=C504uZHVEki9EB8P1CidZEz/g9wWixIDSPXEmhVZvADQXv10pkhH7YC1QW5ze4TgmcJ6
	 CxZYsCKpa2piIJC/k+wl5388SH2Qb8DBGmxku4dOIgdYAY5pdjOHYw+MkvQhPCh5w4chW
	 3PRZvzitofModQFEC3q9QdzvowUIz3J1mC9F7bzK1Dej/Nqol0p1i5hn3pkx5lYi3+gcb
	 0OV0L9o3h/54hU2xmeFSIvAePileXoqhqlFjAwQyTOaR1+w5CRHFQAd1FpXlhRITyX/kp
	 S48LwqVLfLE1deY+Dz+tWHoJpZDqz+HueORR1IuTI7fMqo4OlI7j9TyvZLldqUKAS2A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3E73F1F01183;
	Thu, 22 Oct 2026 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711694;
	bh=jP0kKJ6BHu68oTOx+BvZDLLksWpeFQbo6JMfv8oBSaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VDvi31ecxBN6xiAXSFzf7TT24Pt+VQSEZd0AmjXR/qxGMf4nBKi+3euwQuxu5orTo
	 ZRwFPcjM0AVwlVQOPchd5osMcDnj/kO2HHWw5rRuZGNO4OrPYDboJawyZ+brTzPfr2
	 gmZyJSbz2UgwHFN+6h+hPGdiFQ1ygjdzvDl0ynFYjbTl95m4Uhb88sBBvJe+Yh4NPK
	 wyOHxFVxLOYec/d3NDvfTdN7TvqPXFUYpO1ywP59DFh8Z9D1c9nNvbw4GdVnLZUs5n
	 GXOCgyNEQSxxGQOVdRtABECn7hBq5aDec4fJO33Z0iwLnyBflBBQfohCuLovKROlKd
	 /wfs/OH9yj1+Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CAD90420C4;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:28:04 -0700
Subject: [PATCH RFC v2 32/50] KVM: guest_memfd: Refactor error handling in
 kvm_gmem_fault_user_mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-32-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1832;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=dYSKWEqxzq5w5P2XdLUDho7bFGF6J44KoRNxEd5fGtA=;
 b=msD3ENL3cY/k08+ql3P8gqAAGfjehleVwAZiVcfHCC8P+96fOGxgo61lNP/yMkaBjQIQLiIPB
 L5754XD4S3SBbtLknI4lQy2w6cWqwzxnlcAPcyPlVouttf9eR85MZjW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 44AAE20003
X-Stat-Signature: 4p4e3cwpxsmbdayriuizrnzm5t75tcus
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792711695-37390
X-HE-Meta: U2FsdGVkX1/gBGH2COr3T2m5UP9XpmooEScyZ9YhUFeOoS0xdIJrvllBaAcFLT2dN51I/TGyr5Bh00f40wK1oBVe4E0h8K8GMPm0Lduw7/xIBMzKkaI0kIcyIA34YTmq8LmbMB6uYaSdWxuuu9UTMOJEIJz9Qizna5d9D4q51+kz8CFT7iTfkkP9h6RSpV2ADz4P2653BI4mWZ0tAmq5wUrFkvAaQ9iX4v+8JE1sVAw4+Inhm6ZHnonwu8vr8bTPHPSiVJDyHK6zEOBrfKOht8iqKS+5yzRM3pY0afAc2N4twM/q0LE52+x0XlApfd3y2eIC+t7K8StLFxMp/WtG++IDBHGMpEmJ5tkt2k2vgnq+btQa0++chEE6Ndnj9PwG8mQ6OwJOGqVBu/oqLv0Dav4nO9BLoFtoMhf4cj8JlUYkmR6Ye5DBKeHTAYMMh5XKKNGvSbvav5d+vFOXFIcj+bpZJG1xzWgVSn3SDg0PoCGMZTxwPuTTLxucCeOBvZFXrxfq/fez3ua7pCVonsB4CzJ7l1CDU4Pz9V8liSgLkXQDlACl5kxj3HNlM1BjVaStig2vuVsVHdb0vgZwIleXpOW+8dlQfLexpM+1MczywKwhyOT6b+13ngUMK8kmeSH6sRkH+arxubnxkSYwi1s6UCk/iCtQdPnefqiLEmUu9/AMWXSI0OGjXs954CTulrUQWs7NulwkPN40WE5y8EECbkCEt3wTve+4tRAUDZ/c6zcAe6vdBbU3747gsdanz/wOAfG4k8F9pmKC4F/R0UQ645lYXGtTYpfcWyifp3k4nA1SYQwo5sfR5u8VSgYBEW29T5bXX3P0Qb3wjKRFQsayqMl7nGIjnw8lWJcxymN5nw6NVBp1C6TgyCTxrN5qx5nlGIVZdWI3/jiP/wTCtthyCwzyDXiYh0v2QED4+NhpItbzp+F7VeNGxsZbN6EJ1mqvJmiSu2cxyLAQ2IsI7x6
 PuGN/Cdc
 GM9etoebjfN0uGnFBd9laJKJjOGEzDctyDaEEj9/a/lycTprsnk1l3Rpy8CCpqRuQxIG6GVbmmItiVI1XBI6HuxaE0lL4HEXwf8YKdJFlPBvQ0fy77VkLgOL8ZBEvx3yePDzE6VJYSh/N9Whk2wvgJjobrnault1Ql4z1TDhNCdO2xRcY0OVdjIKCtRrueCQ/olMhAmToE21sUWDEAaSYfYXhf7Q0QpCGaF9KrZnMZGn7V0X++V/93OULDKBc9b7es/IvU1SL8tQdFb/TKk5+d3MYyXuXMLyYIOxuGnpogEoKZoEAGNoIHGtfhpmCV0p3j22iFzaBxwlmErPPMhPhgTPuktA5rQz94wTSvhcmyUwpmZxkdqFMczdMJ/GX0xhNRlkaIhk9ymdr585KNKdbQxIw9/85m8Z8YFeURJvwZwrYPv7dxFupwEVdqPRP9E3Jria+29uClaeIuJwQ/hNZG4mB6ufHlV7MZcKwesScHQSBsZ3dfW+/u1BBnGMtelEdyg1N3tMqglO4AF6ul7pH/qB84CQIybEIgynZGATSkiHnbCS7B7Ti5JtBiOeJZV9qm42WtoDm0VcIqDgYIaMd1n0tO96yrrKKlaqn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Track the status of kvm_gmem_fault_user_mapping() using an explicit error
code rather than encoding errors into the folio pointer.

This moves away from relying on the folio pointer holding error states,
such as synthesizing ERR_PTR(-EACCES) when memory is not shared only to
extract PTR_ERR afterwards, and prepares kvm_gmem_fault_user_mapping() for
PFN mode in the next commit, where no folio is returned on success.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3d89bc76f3867..8588912cb0b82 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -562,24 +562,28 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
 static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	struct folio *folio;
 	vm_fault_t ret = VM_FAULT_LOCKED;
+	struct folio *folio = NULL;
+	int r = 0;
 
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
 		return VM_FAULT_SIGBUS;
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
-	if (kvm_gmem_is_shared_mem(inode, vmf->pgoff))
+	if (!kvm_gmem_is_shared_mem(inode, vmf->pgoff)) {
+		r = -EACCES;
+	} else {
 		folio = kvm_gmem_get_folio(inode, vmf->pgoff);
-	else
-		folio = ERR_PTR(-EACCES);
+		if (IS_ERR(folio))
+			r = PTR_ERR(folio);
+	}
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
-	if (IS_ERR(folio)) {
-		if (PTR_ERR(folio) == -EAGAIN)
+	if (r) {
+		if (r == -EAGAIN)
 			return VM_FAULT_RETRY;
 
-		return vmf_error(PTR_ERR(folio));
+		return vmf_error(r);
 	}
 
 	if (WARN_ON_ONCE(folio_test_large(folio))) {

-- 
2.56.0.257.gf7497c7d27-goog



