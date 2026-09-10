Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160D9C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6D76B00B3; Thu, 10 Sep 2026 19:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FC56B00B4; Thu, 10 Sep 2026 19:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A566B00B6; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C20B46B00B3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5434B1405CE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
X-FDA: 85199512440.01.68632B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39863C0002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGIJEKj8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BGIJEKj8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084538;
	b=1SDF/3HCxbQKvv3owIxqbN7+7O0sEyjwbtpRDkJeIIJABZeeDHa09Imp/vBBkUosmigkfK
	ySWGVvAyPEa9IZd9i9A/G0m1a9E7Xk5FvvgrFcJMyuejzEcyTGbnqi+Tt9ZaeWgNBmITyK
	W1yvJtVPrr+u/rAzxTxI/U58Hmzbc6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084538;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xARBaNjGzdsr5LntnHO3thzeve90dXtIspe0cU6anYM=;
	b=K3L00mdm8ouYmaRaT07/O+JL5yZCIy3hYaE2G2Clfv2+aBCHVVd+u/Qa3Itw22MrPNpOF1
	ukIyFrbrP+ZQmpOyjlFh3l76c7I6m/jhzlCnETfkHJFKYWd/6ZefB2tHchEu4uoyxef0/8
	RZ2aWHEy+vk4OrS63xV9uz0QQaZfdfg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB49A41697;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA19BC32781;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084536;
	bh=BhQ5IW1cdYY4/D+Pfwjb2BH2ZNvlUKlV4VeivpRJOSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BGIJEKj8Oq1+UDALX+ziDvBiXlbgEWGrZIaXV6mJMCsHWYaK3cilkTceEck54954i
	 RFolxUsihSJpeH6N4NqmVWSuOr8GyP40I2N/nTJVV8Sg24H5s1IultFS6i4oY1n8fI
	 PcebJG1lZ2thUGIcQY8tuYWN6SWy9UZkbDh4582V6nWdDi1beliixUhJCSyS23HvOA
	 fciZwuCcRrNCV2v8xOyhf/TC5lS538ObcHZKOMLXb751F6TIPE98yl9AIH3CycrLeK
	 GXVzOk1MWo/bkDQflK2gsoW+Vn5c4Tk28HMxgtXDL8FkiMcM2f6/nuW8qWzb7wd3yc
	 ajnUGiZe9chKw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDCBC88E41;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:28 -0700
Subject: [PATCH v13 02/44] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-2-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=1294;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xBY4/PDaaQtcraLoiAXWiRvSzJvbVV+mCywqqocyhZQ=;
 b=jHExpGn19+46TGPhs2mSl/iRUELt5TmexnGBnzViqDnulHKSXZHs6JhnFrc0k/g5LfTsHjFl8
 V2SEJMaaAvDAthuaxmPPzBuyzANiE73i2fVJSedDfp0EMUynAudIhb8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 39863C0002
X-Stat-Signature: 6b47ujts6bmyo3roazpghosj141bzj46
X-Rspamd-Server: rspam01
X-HE-Tag: 1789084538-967881
X-HE-Meta: U2FsdGVkX1+obxZtJa64rE976H7zF84Id6CxtXRZOnixpjNXhohuwJVWVXN9GDsBY+/fWVfzA6V1nd9gosJEO1D5ikApvpwLWvpcD58OQA5uiIH0sloJOUlYqDz34gM6loDZ7dsisCk/omn//5y5t/uRvhJ0SKZ97pYilHPjGFS/oumYLObezA2QjbTbUZLJRTyB+qu0olk1L1ViPpajXKXKFW9uxW5YmNONnu5oBZUwoNYwDWi6cZ0cwPAGxPfXJUilglXCJjpA8jBOcci4h0tdzbqS5wcYEDPxwXfEEnqOVEyONabW1OKvGUAhPDjv3a9HDKs8YwiSbOa04ZfhNYwDrTlbvZk/OU8RG3bzbP7rFwPJcbcLraSfc3kxBMqO6+0tCgXcuNAlVf90mRREOEFHMALTNIo3rn6ZBkMu+v8bTPGWvZmLJ5aJVTCEwYDgH6vV8G+LKZISYhVHv5TBBSV5sH/K58R0V1iMjZ6PqphboEZcJltMEa6dh0SsPq5XotmAY6aZJi2fBUxP/beYjaxvCz3VUg+WTIaUVrpKFd+QQXqOXq2wGOd8mO5Fxsd6MwvjO8qSBAKY8Ty+rk4bkj06GX2Xx9/iAPg/mvqo0yWNAjHBYY+Mzc2rADXPDbXRzKp5x8nhat6wKxPXJ0u7eK7E8BEhClkaReM22oWOiaa7EjxlbGPpBHk9rCgs+FLhKJRHGqVgJb/CDsmAu2gcrdv5T7Ll9dsoHXnUKkye35UgRoJow1WYyfhX5PhFiYXaXJEnPqnqJxOMtIfn85pcmbY763KTi/ML71UOxZdw/FrO00Gzv/SAmyLGjdFUoRNDGVkKDq8J3vLCG23lo2QcZgbN+2+o4MFUYwjXtp0NB1NYwW/F07jvIH2nn4HPXOFa8Z1OymmsGPY/0KlYs7x3sON50GkKunA5two18Z3Dks1qvoDKWNCqDx+2XFrlGrDSE7oONfvWojpGGeXhaR9
 jO4vmpio
 RGIyxxVTEPCgn6vprfVr3QRLoWXejbdZSF62EE8KpbRK7cku1glJSuLkb3bEe3HZ3TV9AkecTKmItXP1T5aYhgWNbSSRAeniyWKhrCK69FyXEOxkhbCkQgfLBZp2yMkKAEGxr0fdubtTMmdgwEnUYQlKXVWewediBBHQrNKfAMAtMDCuL42gsxcicSWAlmp/e90UQakbVs6R7+alUX27+HLdWwhcFxWJVirVFByZourMtR43aOC1Ch/R+QZANicUSFhcedNy+wts1oWMz+HQ407Pm1Ks3+dHiZysTguVYeq5UUNk27op81pjqs1GNwH3/JaUvnrArWMVgqRQcaY8t0T2qtoxaBXGtjRBmTw/PUZrHW/5SeZztnAICgydIRc3YjcMjlJAS9/V9DcITs2MR9f2s0Bm+D04y7LomOpv3oLg0eI8aySyK0TmeSUUzUy+cL2pf7mNKGclPHLbmws9hf8SOIeSIeJJGHKL2xl7EvIehuTnQ4mFk+OqwOlbHmgZCYlS6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Use kvm_mem_is_private() when populating guest_memfd instead of using an
open coded equivalent.  In addition to simplifying the populate code *now*,
this avoids the need to provide a range-based gmem lookup API in the future
as well.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/guest_memfd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2190e4d6b6bea..69612bf146be1 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -805,9 +805,7 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	folio_unlock(folio);
 
-	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+	if (!kvm_mem_is_private(kvm, gfn)) {
 		ret = -EINVAL;
 		goto out_put_folio;
 	}

-- 
2.55.0.1007.g17ff1f9808-goog



