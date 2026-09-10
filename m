Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8821EC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112456B00C9; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0954B6B00CA; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDB56B00CB; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85936B00CA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D76FC1A067C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:50 +0000 (UTC)
X-FDA: 85199512860.27.ADC448B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C48F014000B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=moQB4dZY;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084548;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJxtd3PT6fMVAH6FGS08O0rT6YG6bw6WahPPPtzRahA=;
	b=2GFvlbkuFQyoiEvfnDV8eSbSvhNz3oLn1M85ml4TtEoAjPCCU0ZeCuVpSk0kV422qLQ/wd
	Q/j7y2SF4dozhYS0/htIypFeNy3fy1J16N9q0bV7eC9t3VhQMRkYQI+vCI4oV53pOKYtDf
	cFb1DfsUQnlKyN72qHrOJ7YqB6A/sSM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=moQB4dZY;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084548;
	b=vMQId6+LZ4BpQy+ag+ahcXnq8yQyRsRS0sdSWX7Gm7+z9t0ZKosT2kNhj7jve22XQg9kEH
	afGQgJja0nVb7dnFdqdf+qX9I1cnyUoegA9Zb0iYHf8BD5m/sS049smZuKhUOrxRKdzpUh
	m0eZhN/QMnWV7KP/3u283AbWKOUNuZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9884444801;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ABC8C4AF0B;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=FN18zr23aI2YioULWDVANOgYN/7iYJIHXZfHK/jVsFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=moQB4dZY601NlQqsLZYwLQfRC0ErloQJ8suwJmXupKPbihBeykksEnEvJhXfgspPW
	 L52W42vFS7FK85f7O8Q9DD4Szrv/G71Bp/6Hk7/LxJ0MZnDMaM8BHj1x9/Sd37ARpj
	 oxBeBhDTfb4kc0zzgA46dznVgSGpOlYE5XzkTY6rHZkzPOrmcc8E/Jajv1y/CFUsKt
	 eRvPLj81+famV9Mtv5x9A1r8PyRpwxkP0KSN+I6hiH33PASpyJoBBAo4VhQ2YnKEhO
	 WHyM+qTMwRi0SWjMvEUJzKdogP35TGKRKaB24xdiSL/V4Su8yllUsCHSQNlH4k6LVS
	 wPUqkHeHEQSwA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52593C88E45;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:53 -0700
Subject: [PATCH v13 27/44] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-27-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2381;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=A2BGJl0NqlKbP8kqzcvuxy5LjiQiBIoRQH4XzKOaoYY=;
 b=uA13NRN/W2IUSoKc7303OoTK37SUcvedwrTz3e42gu1e8H3uBq7WyP5WSTpHG4mjjBp+/aZMt
 p3q2P07KW8cC6NLxWdSgfVBKj11vNhoMcnqd4SOfJiChTtr0SYE5kDm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C48F014000B
X-Stat-Signature: yc3u8ariqgd99anw84yfo1kr5s8inxsf
X-Rspam-User: 
X-HE-Tag: 1789084548-591361
X-HE-Meta: U2FsdGVkX19fLLp80eTsdMUhheTDQy+pU3bujVXfoY+r+yhmZFEWxu4ENaoiZXeJHbnvCY9HZUFbq8NuZ2Wd9nZEXf31tdfgz/tzcWmW4m6GfTqmcyJO4aLent3ZJXXyTUXMAe1YRWURRBTJVhhOdx8FAYow93IC56I+3GiJJbgPajNUNNTEZzpegPFrl1jTE0bGurC1bN+Gmmsx2laXVpewDdo7jZBq/ejzuCmxrUTKX3u+3XeZk/InUSjRJyXHETtsbPW+A7MZcSiOmf3erMA4qJw38X1ZqwkVLrhCnkwFFyrSCvrXtKrNacp+f1SxocGrwG5UrrtO+h9RHvlakzJBLcUw5d8Mh2gTB449BWJ8MBWktCYFMdIKqJiL1+8SD/vA9f0HSckv5x6mtDa0iCuww9JqJmMBo/SHI1i1IzJqXvnge9nOepLx4IX4tHAbCGSZqj7Z282Dr6+V3cEkD0oygWsFWfnS/zLCw+rAjvnLWxvZp7QJxLd0rbVG8J7vQvY7FQuVJUiMUVbugW72AISBJMMgyogj9FNjp54U+X2h4lZldPIz4ZhQGSQnpNVmu19w0hhdDJVG3RFAw6fpJlnGNeTc1WqDK8V2NoSXQ/TduZzw/uSmLiVdJvYoQqweHdaNenkSp6+/g4Tkyxq5jJjw/F5LqjJlccXSZk9tJWTG9kJFodpUo0sL6I5S/Q4XR9vULvMcuPmClBDfGiTtoYttbIpUMYb3R4HgJPOy9Fb2nQX7eU/exgYIxcY0eyhBBwnn/D3xYS3Apa6Noo9rNb02URM0nuTBCMjb+pCjWgp3nNPoYLIHd89pokkNgKWZIybr9xr8gZh15KoVKHeRAr2+OQPEm/rENI7gQ9NKxlZoESb9E1bqOw5CD4+sJYKgcqTJQdnKuDpyvfrtNmf0u9hsiZOD15JhGxabX/CSAW/R91lZBCqKupmV1seyuFsFzEAaGqZlZWv8Di9ljco
 5rI9NgsG
 ec5LG9Ud8Igsfcz6jSewkegi4L2uX4dh5Zgxh6A6mXB2UP1FxkDrU/hvF+zFP7kEd6cQSeIwUu6yk54ZQsLVmXnCINHFJsh0Y3GeyGqrtwn88yLHjBN8rQR4eazvpckGS/tcWRTruS8j+cKTmOaRdSebxNoBRy6jlpPyKjZFp0j9ny+CREJKwlMx0NWsvFzCx51d7XLTmrzUOemIl/L+XgRTJSRjEpN1ZjoF08AeTuntRSAkS3RmbRE93pREw+4geFkEQgJnZ2Z7l1s3Zi2kTQ/KoAlTCxkAM0BStnS++OFUns7n29aQ5gyhiDJ1ITmlPQTuy14l0hyhQbYwfvJcJnNuxS8Ak2ecvQxLlf34+JBofJfdPJ7e5XuREukzlGB5oWK/aZYsQDahgKLUFbdOkxW94WSMIgoDfTw1Al6uz+WpVWiPx7lpJ3TKgB7udcU6H+piOyq8PzzUrvGlsDujEindKz/ZYUCPSJNh0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
opposed to VM-level tracking.

This global variable is synced to the guest for testing convenience, to
avoid introducing subtle bugs when host/guest state is desynced.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6a3e16578959..d5825211f2727 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -116,6 +116,8 @@ struct kvm_random_state {
 extern u32 kvm_random_seed;
 extern struct kvm_random_state kvm_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct kvm_random_state new_kvm_random_state(u32 seed);
 u32 kvm_random_u32(struct kvm_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 08d0bbcd421ea..cd468b2bb8343 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -32,6 +32,8 @@ static void kvm_seed_rng(u32 seed)
 	kvm_rng = new_kvm_random_state(kvm_random_seed);
 }
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -527,6 +529,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		kvm_seed_rng(kvm_random_seed);
 
 	sync_global_to_guest(vm, kvm_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2311,6 +2314,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	srandom(time(0));
 	kvm_seed_rng(random());
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.1007.g17ff1f9808-goog



