Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA428606A80E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bCa2AMHt
Received: by kanga.kvack.org (Postfix)
	id 8988B6B05E0; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86EB16B05E2; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736466B05E1; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E32C6B05DF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB1AE160210
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
X-FDA: 85406458788.23.821FD27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A9D0520002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCa2AMHt;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011832;
	b=ngkAG2cA3kkeEJ6fJmWCeHarCgJdyCcy1A18aehKXohKjaIbSi1P6cngCRnPdvIYW0gtfW
	rtFhtX5tWgWUGM0aH8+GH8RTOaPkUj0B6TfSo38ahmtKjIt1tGcYccvNQoddBHMEn7k3Bu
	JlfQRQozk6z3YX/ZSUY10XolDU81/hA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCa2AMHt;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011832;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLW8bdur/8fUhk+KhilH/kFhEA9n5PcjU8DdUabDklc=;
	b=tsn4XTBF64E5DqHiS1v3BJzi4P4zk7tg+YFgm9Ta6PUsW8EpnRRm2+aSAcKdoKPlu0DtxU
	xC0yO5sxSbbRyPRIL3tpKJC94hNJURz2oJfes6EiRUo+zdn1mcGGcy4BWePrGFHLAIyf1R
	LuAl25kL25Gdyf/juJeywea4V5DzVb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76D434391B;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011832;
	b=Uapo4BuavcXxzV4g5lql8qbC/4xVmhLxQO9V84U7z8U3WGAKII07vSd88ScQXnOEK6pT
	 dyYnjDpXDVhC/hMJ6U+gCNnfBZqGUSHuYb/8LWfznZ8uQ0VhnNGLMOSmZe0cpB3xyoyJR
	 ALXD0COSmIzOEh/O39VpRDHp64aUJ7gzlw/FCIBaMgh4WZeJZ3HcYvNhZWE54PwGat+tv
	 yB5ZI/lVKKmxDFcyyEPi1mEndWYeMzQ/HZtDiZlVbpdF+CSoC9UYKB67mDZ1yPAY78rTU
	 ghidlgCPdNnj/n3aGw1kUS7odGN7ME+SYKpc7fDAUPEMURYrNk3l5Vl3afftlV//PrQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011832;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=uLW8bdur/8fUhk+KhilH/kFhEA9n5PcjU8DdUabDklc=;
	b=DWl30cbsuHhs8edx4V6Piyc7uyeCCSBVKzifKFK/u9yyYQ2cTNn6pEPbAwcyAftOF0qH
	 Ugfr2Um592gRpptrdSQXcv5BlS+it8o0aR5lPL8qVsFctd5U2dt8xhTS6xEJcRnxblbPd
	 qBJzgEQy2nHlGZTIVHF3OhuBi3xnD6JN7zNbrruIjl5lJmKpTCByw85E/vmUw0HhD7BCD
	 5ZLp778TNO4pU1/vjH0++R8jms76Q65IAc0FMCmBcBNB4fvF21bfWhckOagqFEpDUA75h
	 /XCAWPsdHxkI+65oTxGZg11YjUj9OZ0DYvkk7jnf9Pd5tPHMVdpExlTYWOwS297u0+A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AA1DD1F00927;
	Sat,  7 Nov 2026 00:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011832;
	bh=uLW8bdur/8fUhk+KhilH/kFhEA9n5PcjU8DdUabDklc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=bCa2AMHttKeIEbK/uAy3HZ31RCBFfqe/qpCMW3pNkvhn+8zJpKcS43a3icuzHF+Bm
	 vW3kv6erFIpvmOmOciklx/zZGh/rL7uRsvz2jxQF2XvbGg8NhqfzLIfzE/eAP0zVd4
	 6shAdr/IuP9fZfbrr4PfPhsZ2zWinPl6X6tLLYyjmm+gnBO21BKX+ELpnNRZ0zRVts
	 JOyvnXw03BBIwzEsTatyRARV2qDmB/S6FBB2ZxfYWbUMJ/fIwNq0sH5u0yHd7Onj6N
	 8uvKy6H3jSA3G3Czo39KA5dIZcOre9vXRlxaBDS3yLzoIAHLelTumOyEztSIKStqOp
	 C5+z5p7yZ7H+Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 86BB8479E1;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:27 -0800
Subject: [PATCH RFC v3 53/88] KVM: guest_memfd: Support
 check_set_attributes provider operation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-53-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3677;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=4/4nca6vwG0g+Wn7pJHbmNNbLNupPdnyAc+KxS+ZWuk=;
 b=4XLQVntDynKX6Hg61os4N4mZ/7bH7llDByPzeK1+3F1ZkrFt6ryuxsC2lG0iwgffcbuQmL9lt
 ubm7if6Rr/sAdM97hG/ER6jDIEJ3FeCcV39rg4Ept71S/oiS0BHnOZR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ki5e6bu1jiuh1f8gys5frzo8izxo3ynr
X-Rspamd-Queue-Id: A9D0520002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011832-502899
X-HE-Meta: U2FsdGVkX193ya9XmmNepNllPhTN8EwIeSLg1lPDzAiTb3pm4Z25gpAAwPqxWM9sRb58r0L5oR/g1TopgDjVKc4zjuvowDQAJWmF6wgArY6Q37R9YihjrE8V3NEy8y17K7zb+R9FTap6QXCRhqZv4kPIBFfYOt/2mcy3+IIFHDVwaqxZNrUPoRVm/hoNGDzhqSdBKame2CZFelGXzFCSFv9EKRBhzUEeE3DJe8LpMpkWNsd72nuwoDEizL6GCs1YfxIHgfA13Sd6Cpx5W5FJwesYUYlD0CMBajKHNIbYr/AYzpYJ4m5QBGIgq0HX11RDlSFuoNYTwg0B8j98SgHL2wnSLXwaUHteu+sAEaJef2r4RaGtdMeK/HTlt5d62F1EDzzTVIzWko5ShzCUg4CI+NyOeiGnAjIOYxH4y8sta1dj50hdn17b0mjA8ZyN7Q/aPuto95vVpiWquKTCYEDi0xcgGWk2pel8e2ghG5w6MrW0849lwxUykh72hWrMfN0s/ce7yqZ1fBG0x1zQ6viXHbvPX0kldZj3iGkj3E1/EVvQl3zN+wia9m8poveoGd/GhSAxO0Lwc04jTdSyOZILltShie8ENJ0xn4TfC+1SjixQrcdzKfAg+3iT+2JNPrWyGMX1fANJfqJW2RlGE1QHPgAwUcQ122M2UQKrNbEgYJa7pdff/sNqXgeJALXvc4HQbkNLa9kI9AtdvDgHmlqdbi/KEmZiADBTr3M0VDODlU22KeD2macxVtDZV6pI9LMV8dt16Pau4CcV7OpywzWxxwuFMUG+ntQAL84yp5ZZC4yoVGxYOIjEbRP4z7oQ6cuseH4utG5ac//WvxFPuT0G4Xwk7p0Qx5bMtLVkx+kahAObwRCy/uC2LnyIQvVJ/ruFTSQ1NM5p/ULt6e0uItkdAefTeavCyjlefn83uMZC6BiKEb9sHWWrw881d8JWjC8hgwf4LZ9rwv7cHlcQjTq
 tM4Bxp7t
 haTMWtosJa0uv6pIolhCPZf7z85YWM53LSGGyCD9K6pfFiua4+ShzkXX2wrk/voF0kUS6i7K0yFIHA3WDJkLpcrkLTBeOiAsTn0WhNdpubtY5HAtGrIqb2XTDD9KxvBvWm/DCjCBrNyRJJXMdIv6tvn5PxAUl+MWQSGGNoE3iD5ju9Wznu4ywsKT7Rj2oJdb6gGNyDTnU4yF+U+BCRNnY5jeKJXQUToEVyqsB6nV5NhqwZXOpmgQ5kZR9dLScQMM0ofyq+LKzJTmJ454txRdH+GS5MhWE8XcAe8wqmAAZH7p1a+mxJpp40IsqlTXPLzGjG9XFcxFTf/ItCdetj6bjc+w8RDZsSSBhBZcROgAhKB9WA/n17TYHdyAVfLLVtgGNcArgNese8y1MtxQVaVjN2t7zijzUdavurlD/TvTdGGSx3LJv8A+KqOvzQXtmdoV16yYMirlDMj/xCXbb04XQdfm5QtA85UIK2tinQQFQWOx1zb7HDNdXnSi5eEaQqHM8Ber8tO5RC7YBTEaoy/SWpVt9jnTRfljmY98pagnL9uM6mSHVOL/R+xAEu3/6uzHEu5HIBqSjNWI9j2LWqh02LyopsPJp6eCJrsHbXH+OqSn5UDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Allow memory providers to validate or reject attribute changes on a
range of memory offsets before they are committed.

Add an optional .check_set_attributes callback to struct
guest_memfd_provider_operations returning an int error code, and invoke
it via gmem_provider_check_set_attributes() under the exclusive filemap
invalidation lock before preallocating maple tree entries or unmapping
userspace mappings. If the provider rejects the attribute change with an
error, fail the ioctl with that error code and report the error index
back to userspace.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/guest_memfd.h | 12 ++++++++++++
 virt/kvm/guest_memfd.c      | 16 ++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index a2af279cd3c34..cd634576c9af8 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -88,6 +88,16 @@ static inline bool kvm_gmem_pfn_is_cacheable(u64 pfn_attrs)
  * @mmap: Optional callback to set up user mappings. Called when userspace calls
  *        mmap() on guest_memfd. The provider can customize VMA flags, or reject
  *        the mapping.
+ * @check_set_attributes: Optional callback to validate attribute changes on a
+ *                        range of indices before they are committed. Called
+ *                        with the exclusive filemap invalidate lock held. The
+ *                        provider can inspect the requested attributes and
+ *                        offset range and return 0 to allow the transition or
+ *                        a negative error code (e.g. -EINVAL or -EPERM) to
+ *                        reject it. Once @check_set_attributes succeeds, the
+ *                        provider must ensure this result stays valid and
+ *                        constant until guest_memfd stops using the range. Do
+ *                        not take locks held across kvm_gmem_revoke().
  *
  * Used by filesystems and device drivers that provide memory for guest_memfd.
  */
@@ -103,6 +113,8 @@ struct guest_memfd_provider_operations {
 				unsigned long *pfn, size_t *nr_pages);
 	void (*put_pfn_range)(void *provider, pgoff_t index, size_t nr_pages);
 	int (*mmap)(void *provider, struct vm_area_struct *vma);
+	int (*check_set_attributes)(void *provider, pgoff_t index,
+				    size_t nr_pages, u64 attributes);
 };
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index ec908419e5faa..61a3ff7fcd84c 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -210,6 +210,16 @@ static int gmem_provider_mmap(struct gmem_inode *gi, struct vm_area_struct *vma)
 	return 0;
 }
 
+static int gmem_provider_check_set_attributes(struct gmem_inode *gi, pgoff_t index,
+					      size_t nr_pages, u64 attributes)
+{
+	if (gi->provider_ops && gi->provider_ops->check_set_attributes)
+		return gi->provider_ops->check_set_attributes(gi->provider, index,
+							      nr_pages, attributes);
+
+	return 0;
+}
+
 #define kvm_gmem_for_each_file(f, inode) \
 	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
 
@@ -1083,6 +1093,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs))
 		goto out;
 
+	r = gmem_provider_check_set_attributes(gi, start, nr_pages, attrs);
+	if (r) {
+		*err_index = start;
+		goto out;
+	}
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {

-- 
2.56.0.455.g6c5a503b38-goog



