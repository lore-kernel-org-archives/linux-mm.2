Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1804DC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37966B00AF; Wed, 26 Aug 2026 05:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E2C6B00B0; Wed, 26 Aug 2026 05:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84956B00B1; Wed, 26 Aug 2026 05:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 889F16B00AF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24DC44031C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:43 +0000 (UTC)
X-FDA: 85142870526.03.70C3077
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5C3A54000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vvFY7VXm;
	spf=pass (imf27.hostedemail.com: domain of 3b6-OagsKCGQCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3b6-OagsKCGQCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlxub+uHBO/9tuD+fZ54oP42v4czhWpxNnl1EZnj2VA=;
	b=5cXw+8s5RAqbOBUWeKX99RT1gZB2bfpkj/fDEeGty143m0cNQb3dkGxd3qg3ZCCV4eHRs3
	tz/EGzvCEwcQ+wrfhgppUg1e0/FKZbeXShH5st0QH6OaH4yuTOe0IeO9dGgrFAaYZQl7gs
	Gf1VO42Gmjthy8/c/bdCY1IpBZmP/mo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735921;
	b=IIUKeCJe8eoXVkS3Yi6pxhSiGyGOGZpphMMz16866Sr33qg17NopAqwI/2VQmht+zzzaHd
	o7/RWhIiIG8nwR/pX8lknvuLXaZfh+NZpbJ0uhcLasNuV2emGAdnFtNAmi6YBtvtCYjyly
	LZvv0GWBemStroC+ENfI0M0AbqQ5CpQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vvFY7VXm;
	spf=pass (imf27.hostedemail.com: domain of 3b6-OagsKCGQCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3b6-OagsKCGQCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1cade6b71so278919a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735920; x=1788340720; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mlxub+uHBO/9tuD+fZ54oP42v4czhWpxNnl1EZnj2VA=;
        b=vvFY7VXmWHqYHewJnxQNiuulz7LxQapqy3HssefZ7JeFz2G5auAIm6J8EQ1IkYB5Zn
         FQUgu6BeiLyoYJBxJWSbAEghSEVPuL5cxXbMvH2T6q8kBSZ/sIV6WUcX7wB5GdP5e3Nq
         Q3L6+pKjGVhfy2gFyBSnALNNsF0fymdK5mxXSy1V9M+6rAIsmOV5RoY5rhDEAlhF5Cq6
         0D3LRBSkI302AzNevtIUDHVBjB5bgWQnKyj6gFXOC13+6O1cJsRRqQV9C3CZGdWXH4d6
         atY4fpujIwUeR2Ba3B4lK+G0Nr1x9aQWfq1sAn7ME6ARkeqNYx5KnLbpY1goLfA3lsB3
         TVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735920; x=1788340720;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mlxub+uHBO/9tuD+fZ54oP42v4czhWpxNnl1EZnj2VA=;
        b=aD/8VmmHn/heSiOM9eiYf6/ERJLWDJj29c5A3DkX3mRTOFXyeN9aLdh75J3ZvgV7Kc
         PD+k+JRBFwllw5nsyZ7D9YgOFUqJm1CQ3o1G0hONO6XqUftAeidUXu+/8AH/+NHyyeej
         GbVwSEY3JPy2tKqHT/6MeHVDlqjGg6R4gl2gP5h1pV/0uxplTtBAOYB/tdd1D5fPuq+v
         JK/i4oQBJ8L3iTD8+y4Ul5A5wkf2eGIlfYph4B6zC9LfsWKuOmRdd4ItuhGYBHGyybhX
         ew2q4K36w6zmFEGynjpmLM5D4pPN3psRuRxW2DZJUlutg80pfLboYjKIeroAPXr2+pNH
         Qo9g==
X-Forwarded-Encrypted: i=1; AHgh+RrmOum3sZ1KwtmZ5KIdC1LVV84wyQO/6DDQ74LueJNJPBzAKZQ/vjWpxG5jmxY7nmij3whuF2aNFw==@kvack.org
X-Gm-Message-State: AFuF++ljZBJGHs03/hT/+C63eqhx19iKRE7H6RI6AApOc9STuaFC5c0q
	/Vx+1kWGuOK3nEHf2EcgQndU63pX5Xq9oVKVEfop2zFyBRGp2b650JG1o4a59xJFW7F9tqW4LRI
	R8k3edlwJUNqjA2IK5DSE/QMEXQ==
X-Received: from pgmn1.prod.google.com ([2002:a63:5c41:0:b0:cc1:b785:2d5c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:1398:b0:3bf:8de9:c64e with SMTP id adf61e73a8af0-3ceed381cdcmr7706302637.2.1787735919845;
 Wed, 26 Aug 2026 02:18:39 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:17 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3028;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rjS7YIkj9IfMwuN6szgnaq7r9mhIQEiYfekeu/by3Vc=; b=lCUCj1iZvnbvBq8YHDBpqof0pVd2qwZfFFterSX0jRK7/rf6Au2LXCto6eoK3sBAVMPHL3rmu
 YzrbJeQTET3CW+0To48scfCtCha+gH4+4h5I0KZt9qWeSUgUInKR50f
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-19-0a15d8a799aa@google.com>
Subject: [PATCH v11 19/46] KVM: guest_memfd: Zero page while getting pfn
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5C3A54000C
X-Stat-Signature: 36d979td5ajn9r8msdg4du87y9939fbt
X-HE-Tag: 1787735921-146362
X-HE-Meta: U2FsdGVkX18L0IZC8/sH4w1ZKi4Agv8qbJVwq4FVVfapxRcmzTec/ndHz52vVV7fv+Ee6VH2P2e5mwGzyHff1zPZ8t2Ep+x/+l5fcxxbYTTDEqarENk7N4swQhVQhkdZS1S8eEuBdXv/wngoWgyxTb8dXZrOQTnRdmR5GUshzfpqgljaGE4GnSBxcziEjIXHfoTaT5PItUY9c3Talw4/2Ukfk2RImy9C4prePVqY7iab2cmVxGtB34huW9RBwCKbDMgogOFo8O5qWB6L64zjY7QIgjPC90FTphMqzNKPDwkXuU7Bu9R6HAS4I5nVr6g2oK6oscFdF5wq5XHV3kvQvb+6arrksTfKH/990XGGod4AXlJxX8MEaCIID7y9zvgJLUuT/L96aQon8Pos50dwVIaVOW73qsYRC8JugsRdVuIeLOp04F8yjS7DwD6DI5oCCXAjkE9lg9d9yWnledq4BReyx8wLzSRgRS+yNGsu9bgC/my0DgTaKICyKKxjMdEG2ySe4gPoI0/rxxu5vaWDWlEq8eNJuvboKfZBAfyyf4axRiX0q2kwQB34sE9gcdd4ZUs79hLvGfwKk/J4LvKPZ8QEayqvGVm4WUF9jqct7paa84xFO9F5zzkzq6uFmfvoVL7PQncwkIxjPIpFPSsUyTBrdfnRhxNbEM8GdRMZP2VBzUebKASlpOd2c1OZLm7gpLS2ZzqsmXypZa4iX90halUrIeo9jCwUH63gtEC6j+tfZ1uOwpPMhFcgjj8GYtd+V+0Bymf04tM8CrwYkAm02UvMjP6CwD9G//xJQua8gWBAiVkD5+/NHcgk5IPeNJ++GaEYKFZELAH/1nYKH75bgqe5z9tMmmgqMQilXarEpeB0klCitB9YeNmWCZEoypZ3NN77+yrhWtQFwC9oLMtNOGtkBxBjIpBP6uHRjpNygsiwxsSCWzxWEmoqp9E1mmEN4vNFW/V6UCfqXylaIX0
 hoF9xlJE
 6BMxd9p0qQkSAYUfhSkxhuiqSzcnfN0Uv6rSpBt9U6ySxI+y16EhbRr8HPJNf9ceG4ErrHKFSx7aUoGLwVindMmW5PkjaI0blFfLeGTXVEB/KtjHNfb2OlvWJ9ZzaS5lwxlFmBGuESAtjeI0riuAf9plWa0/NGaw9SnLqdpsxxNiL+iumXw2T5zv0YCPvi/M0ySjQO3jWZbyVjeREldEy+B+OCPs6toPW0/lrikYjBmIN+as9YFRt8408FY7K/BekfZZQ9DSOl3ZcaT47te6T/ChnsXTZak7//hQBgJxRhz/qZWB7d3fEzlI9ikRTdCKGRR75MeMGzD+57e2Lzzyqwa5N7W46HFQ/2IWcf2VcD9hUwFSfaFmbnQ4J6UdMYgSW4xkN1fBf6RFc6rjKH5QyaJD6+RAhw6Z4RM9RrbsctPTJlaoKmjjTUEO/6FORhsGgMXKeJ+DuwHDUfSwukshp4VWyheQUp7G1UYimVuJ282PhZqYNOFSOyFgc4qs9NkGNQ/c+e7DCu6Die+Un7271NFVwCAn9fcGeXcZ3nf47H6P3hCycG62/Iu+xFwSb2Gs2OYmHoXicQSv69eCGnjsxC5W3YhxJ3nq1MNvGEQmJuatwW9pvfsV8091YIpwQxAcD2GzH+FfYlbmiOpKSZqnrlGF60lWzScKHQ3ctCZXvgvg5cf4AKNJ8lwNYyUMARnxLMVUFET4FvPxL1SqPyAWaeQgxTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the folio initialization logic from kvm_gmem_get_pfn() into
__kvm_gmem_get_pfn() to also zero pages if the page is to be used in
kvm_gmem_populate().

With in-place conversion, the existing data in a guest_memfd page can be
populated into guest memory through platform-specific ioctls.

Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
might contain uninitialized host memory, which would leak to the guest if
the populate completes.

guest_memfd pages are zeroed at most once in the page's entire lifetime
with guest_memfd, and that is tracked using the uptodate flag.

Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
kvm_gmem_get_folio() since other flows, such as a future write() syscall,
can get a page, write to the page and then set page uptodate without
zeroing.

There may be some performance penalty due to redundant zeroing, but this
would pale in comparison to the cost of actually assigning the page to the
VM.

This aligns with the concept of zeroing before first use - the other place
where zeroing happens is in kvm_gmem_fault_user_mapping().

On populate failure, the page is not re-zeroed, since on SNP, if firmware
rejects a CPUID page, the expected CPUID values provided by firmware are
returned to userspace via page contents. More generally, page contents may
be modified on populate failure.

Don't mark the page uptodate again after populating, since the page would
already be marked uptodate before the post_populate() call.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 4912f90567fe8..9c2d52bdf25ec 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1105,6 +1105,11 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 		return ERR_PTR(-EHWPOISON);
 	}
 
+	if (!folio_test_uptodate(folio)) {
+		clear_highpage(folio_page(folio, 0));
+		folio_mark_uptodate(folio);
+	}
+
 	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
 		*max_order = 0;
@@ -1133,11 +1138,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	if (!folio_test_uptodate(folio)) {
-		clear_highpage(folio_page(folio, 0));
-		folio_mark_uptodate(folio);
-	}
-
 	if (kvm_arch_has_gmem_convert() &&
 	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
@@ -1179,8 +1179,6 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
-	if (!ret)
-		folio_mark_uptodate(folio);
 
 out_put_folio:
 	folio_put(folio);

-- 
2.55.0.887.g758fc8c411-goog


