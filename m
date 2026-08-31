Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1884FC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279416B00AA; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2502A6B00AB; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EB96B00AC; Sun, 30 Aug 2026 20:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2EE46B00AA
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DF3A1A03CE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:30 +0000 (UTC)
X-FDA: 85159670820.26.7BB5167
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8415720003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4XDKKI9;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135928;
	b=HXsvcrA5ulODKTRKvFPve06XYcewNoQgZkn9JxJ9J89zbhMIHqMfN3xBVQwwGtQxZb9f9s
	ZKUzfXoXaskU5rgkbMape8Iv0c/Wp3nY4Xx35fLQxlw6Wzxz7aUcZ4se4HOqlSZ/fenQ4Y
	YilPe7m9BM2AYKlBAhNmV9/D9jxK4cM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4XDKKI9;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135928;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5m1svVYiyrAZtzLzVHG280jSxc0WG9zXh0ngFgKHWQU=;
	b=5lUmzzrTco0B0PRdjOIjGWwTEaHRaHE0FcwICZ+5iHQ1JPxcKKjemhTPIPsEjxxIfw+Hg+
	mW+ow7Wo6F+LwWvvtpq6u6FOr32VGH7C+Dg9f0P31m5fKM+h11GtxPG7Z5zar9Q/w8Ju2b
	E7++9r6RJ8R4iSV7SoP1T3++aQOoafw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E6F644832;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A282C32786;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135921;
	bh=0u7TejSHMad9bYL2p6sJmzMrRCXcgVnE5lch746jIL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Q4XDKKI970cDwrlLeOUyPXzL41fHU8ixKdjKvqGjaArmtm3P47QWIbAtRhaNOzqyb
	 +1i/fJnnXYIf3u/mZ8lMtWzBTvlYBxs9+ErohCEzzYLLMjA/3yE66N1ASko4Gq81dG
	 pndUl+FiJaAZRQTFsTP7SBd7DYFlV48y28KYOklloq6f51TTC+9J2A3EmaY6+s4AWv
	 60p1/q0rVQTJQn8RTpTCqKxMrJZc/MCnwzHODOapdLD+Fg3Vrg5zvFwPxLP7NMKIeN
	 h1TH9DbipEWqk0soO5LzCrkaHmA6OmlViW/Ze8+jBEntG4wkOCmDMddn5bnkIfTXFY
	 MXvuZUpRMzEQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38934C61DE4;
	Mon, 31 Aug 2026 00:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:18 -0700
Subject: [PATCH v12 17/45] KVM: guest_memfd: Return early if range already
 has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-17-85e5fd25252a@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135915; l=1963;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9VNi9pEuvRkZvdOHV26sDWiemmZK8/yVnQLh7gIYUDA=;
 b=CFxkPT3CEVpS6OYk5q/nJQbCjkiuG38jxjI0AEn8ybxQssVnDPdSR4CXvx5zB8nUH7yz3IHXZ
 FIdLJl85tJiBVhY6bcB+H02CGuqGFpIwiDvHRM0IWlde4lr2+MEuRAp
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8415720003
X-Stat-Signature: y5crf7485b5szffy9htwkforwh8fmhj7
X-HE-Tag: 1788135928-168547
X-HE-Meta: U2FsdGVkX1+J4VOMTMXo29snjAuDHp1yLbr69jvRR2GIX2r0hu64LKbTcVf+pZXe8u5Gjl/z+qqMM0w6hAZkbwJN5Y/XNGb86qjTE6VKO7cU0PvVTla22lHjFpoglbygy5Q5yU9MpqlLqz0+FjOSNsPuB63HwgdM9t4rcY/y8DcGh9qGGiV62AON0IOSfRbqT2/RwYkqBgBAPzLzZ+6zc/2uzJXcTlgMV2G25sJ7+BEtyz3DEb9ioqjoWcLvuLI2SYLjl9js92I1JTbdEDvuzetQZLJMnSh/6wNsc2gJWON5s2t4CEoJrffauUOcHXdJSG2rAr3ChyumeaBL7q2iFHA+pHbwZpQi3oLSjhw9my46/R1wTTWY+PbG0CZ3OJC62KS7NvWhVJqg0uhpJe99BkCgYhiQ/Y8A32mJ5+f3ivq/K3b8cRpqSgZR0dEPmviyD3/8lzTFmsKa9w1RulK0joKkME0fQfckGZbQ6rOuEnvcuv5SlYzJiNtbZ7eVy14PBqpf+uxgEFh/Tt+O8k+SRMQXXkMJ2CZmE1+QrrIozXtSPFDE84dtDMFPD7i0cwDaCvR4zaFS8Pnx3J6tEA4kE13KHEk0lDfEWPUBjazySJwcLXj87wk4qzeSAqcvb6fefeN2/EcqpMtmJ/11jcdD5ma6qyR/IakqGl+FB00aAYV9bg1bAikBRVX1xhLra4xuSb3lTzm+0RXSEpCAinsq0qMoPnBNnd5v8EV49zwVj7XBLgcDVedpYl3KxQAOqvVNnRr1uHk6AB0n8ghVeMsoNw4MG6T2wHW9+afVY01k+xtj4yqDvRi3pb0DiRLrfRfbkrRaENTp0jbe81345FAJXUHB4+AV0GVI8MRNhhohqQcbF5lqjuunuT+j4cEyFGSus0+pb8Mnu1L8I9Akl0X2OaA84lNYHFR9J+ju5xU0EIJz1XqzdRjH0z+5MYeyI4OBtCyzjGrfzJ1SluLwNxd
 OcUBMubP
 FnWhGn+2roEgZE4JhqWs5xr6CycsZFQoZ+/pk4UFg0DlhG1D4Y+TyhtPlVNpDOXK4ruNpS2AvPJSV1NCixgrMHWEiT4Da7+WokqCSXYUogCSqwhmih7+CcNIWmuaOL6jZZ/sSdNpAf+FL7GlG94H/1v63OYO7G3vBtEzcyVgLDimsv0Kp5wsAk0emrdg1r/YwY4ifSX7NDNde7VeyE2RvowVdYj44gHkiRPSZFUlCFL1+VZpsrp29O01WBz96AV0QWoTmlu6h+sC0aD0yGJnm19qguwJOSzYy9jsePO9vHW7ffBwLUEEDUAVbW46frveAJS5HFdxQM2T6vQAKDsSUgQg1piSpkritw7yh3iPq+kmVf1kALHqrb162C1gMflZxMss9GoTBgUHRbRXLp3F8kN0IRt0CUMTDi4hY26g+eFfXed4CZwN0hzgOLN+qisIq8EgSnydJ89KNhFQUYDYWovxQbz64FINHFs8LtWp9BZM63qh/xEKvoUQcZ8sjA+EOMo+1Z5mp97JwAFQIALt4TyQ9Yi9tfVEj5Zel36VyXZkvUZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Provide a function to check that a range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already have the requested attributes.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d14a7024bdc7b..ac8e0c6d6e942 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -98,6 +98,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct inode *inode,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	struct maple_tree *mt = &GMEM_I(inode)->attributes;
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (kvm_gmem_get_attributes(inode, entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -623,12 +641,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	pgoff_t end = start + nr_pages;
 	struct maple_tree *mt;
 	struct ma_state mas;
-	int r;
+	int r = 0;
 
 	mt = &gi->attributes;
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
+		goto out;
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {

-- 
2.55.0.897.gb25b4bd76c-goog



