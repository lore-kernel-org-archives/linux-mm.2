Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E14C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C365A6B00B5; Wed, 26 Aug 2026 05:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7F16B00B6; Wed, 26 Aug 2026 05:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88876B00B7; Wed, 26 Aug 2026 05:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 788976B00B5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C40BBC02E6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:51 +0000 (UTC)
X-FDA: 85142870862.25.D454A5A
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 055964000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oHlNpW3L;
	spf=pass (imf27.hostedemail.com: domain of 3eK-OagsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3eK-OagsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735930;
	b=d0YTEnMluPvxHZKaNihkRo1J0jTwNXqA/DZtHu47caKGk9jQ0bbzdGD/0hOVKI5zw448ec
	3g8mub69da7lCWYSlsjdyNWiBqeaB/IkOBg8DhM6hCgE5oDD8FZq/tbe4Qe21CCM5niQY2
	lTx7s3ybKe8kwZCOdbJ089sW6H+4hRw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oHlNpW3L;
	spf=pass (imf27.hostedemail.com: domain of 3eK-OagsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3eK-OagsKCG0LNVPcWPjeYRRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xbSTldz0mlkeejSRDvsTzV54cN/f7YMnwUkGWsjOYg=;
	b=n+kgDexAZ6ng2U8CijqbI80OFa2jOOFgui0HoWTFILVhh4ZX7p/zAi1oQAqv/e46Wt4C9H
	+Qi2QrmvYBLhKwckDycxINuedV0CzudLeVTiho0y4f0noOsu/7x2qOF1lpeVEdbTeBzfgx
	NPEgR1yf1C5jamqZalIzTFGg48fErX8=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so980356a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735929; x=1788340729; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9xbSTldz0mlkeejSRDvsTzV54cN/f7YMnwUkGWsjOYg=;
        b=oHlNpW3LAhmVeZ6yEADgqKOE9WCSOTZraccVg3N8v7ji4DNuj+anl9skaei87Piwmg
         ct0EqzQVVAa/P1TivvSJ3J2y7y+5BmkzAa3UaG3uoGr18AiQmPdlNiKrsKulHbN614jh
         JCkl6ac4+WDZtGJeyMqiT43Tmjwz55vRMsGufaGkQK7n4knTbB9aT6i+EBGryggEPBej
         Jfyl7uQplxajGRx3BJaoM1bA8/wNuQ6zoL2BgNvMuPGRKUMl/ou9F2+lLwria5wl+BEb
         hA9C0k5V/Us2sMCkZbmPaM3wCHBLmBdJU2bQoQ8ZEoV1WauUEdaXhd3OPchBC1bsHBUt
         uogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735929; x=1788340729;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9xbSTldz0mlkeejSRDvsTzV54cN/f7YMnwUkGWsjOYg=;
        b=OzVmGs5eqn1nFfKShg7g36OLsDkViM4DBk7nLi5lAWR48UCCkTM5QFFWhrDiyENYT/
         ZcCMG5Tli92luIRUXFhbjzKLGONfaUl98HFDSkTl2HPcEeV0YunFBMWO+R/Fki5SY5ec
         XQwfJAhH2+Rw1Tbe0UzSbbDVQcYS+1zHQyyZSG6hj6zs9y4ugT4/as1rD06h45nxKCnn
         tFHuoRURsBKbaNmLyF51ia8zY2UVaAsZhKngK2GUuGUemJOEgGz3sB/TcrA0E6DxH22r
         lvPAvq6G6rBqNaHhdFoLbAG4oQnsR+Yl/3Zy1ZzrH6ZgBqVDbJoEX24awAssZSiHSN8Q
         ZRiA==
X-Forwarded-Encrypted: i=1; AHgh+RqkiKxvgobgjAfwwtBNRwH59N0SmUVH64tTsw0q0+2MW+wKJMzx2aJ3N30ASzajwXV4w/w3GB7y4g==@kvack.org
X-Gm-Message-State: AFuF++lsm5dKvE4UZ+VIPrgJ8wtEJJhxlXgD4t0Wus0UUoFwYMsoF7Pp
	xxKdgwQAPWRqohbeB1MBs+9k15jP0p3i0yh26hrAK9JpI7CSVlyHAzx7t706SC+lSsqQkkymmFZ
	7sKOaAlr2rfJPW7Qg4DwBhpIF6w==
X-Received: from plco20.prod.google.com ([2002:a17:902:e294:b0:2c9:b703:3bfb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2c03:b0:2d6:ee6b:1b08 with SMTP id d9443c01a7336-2d707a2f363mr88247725ad.3.1787735928419;
 Wed, 26 Aug 2026 02:18:48 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:22 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=1693;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xxgZV80P6tEBI0TS9iatKBLUXrCS72RFfbwoyow/L9Y=; b=I0SLEj0chvLQHB7QukPCMKxNVTQmEiLmipqoJJ+EGN6XfzLrsg82kHlLQjvE5ty/DdT4FbHrE
 xe7LXVIZZMOCZA0s06FUNYPGMQazgE0t9Oi6aKm/qrHRQUgS8sydK6J
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-24-0a15d8a799aa@google.com>
Subject: [PATCH v11 24/46] KVM: guest_memfd: Enable INIT_SHARED on guest_memfd
 for x86 Coco VMs
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 055964000A
X-Stat-Signature: 1jezcstir7n138ziqjmt8jbq531du7gm
X-HE-Tag: 1787735929-967132
X-HE-Meta: U2FsdGVkX1+Lh4VFxW5OHgvKSSQgJoIhJwArKw6TvcZsy4nnvRhGEXrWs2dQ9gU4K5kVb0m6PTk/2gKTUKC5M0gmUqDiWCKGN9q5SxdeA1v70vgrTro4cTOVI0AYkfUEiNudXvrj4y0X85018GhxnQgthLYzteOqYCIkvQYiQEv1KInd4MoItcG0RlIM1i8ZJDgBTDN5yCkiiMWlm/0e2BGzl65jHnuvKkoAch2+HCMH9gqZrJFmyneOsvODg2Mc1IVLSOVBnCH25lLBZSNIFW7oWNnw5gHVboICPBQIXWXjeOFNQh9dIBOlFVzpABRrs07cAckUQwtGr4lcC/Tj2CkHylIBQuoXWhRsgsXUwjvI5PiAxCNAIWxN+Wp28to9slMw78g7qw8pEVtSLqTM6oi9lOUJtkkmil64eUKq/VwI9vVuxlILgnodBraW0Um+8aodxjsWZ/FtomMnPxMVEIKjagSNI+NUpZdM9hbWv0Plu+BxE5bSIISfuoo1/Z7YKbK9AlYISvSRwcUZEPEUW0BCqSR8Ss6PKjLDkJ7mSCqpjGZMMgr8/M8c7suznGbtybOy0BmOKYQu4ei9MQ85sZc3xaCufMd9Nrz5Osp0sgzLTuQW93F+b776ZrrbeWXKz285DAS+0c4YHZOkBID3GXjzRjksCTNjoYKhYBsqz2CAvtUrIMBshT5TMdf3J5NjsMwE7SKf8nsmSdYNKS6Cgxw9pONKd4mFHjLM2pXjOhKimUHIMw7stq+lOMi9yDjVAm9YZTYPZeDlfj4pLhbiEE1Z6Uyy/p8D+FdwOXGsY1vMHSVNRhU91RXzrp9yXW51phmzVc96O51Vwy833SEuZ3m1wJvMBMCT9XtnezcHqs70+gALNyAmuNuKKQgFGzlL5OGkX2rTksn5RB//FvnKypxHWphOP9mzvWipE/VZOPYXubgGs1+xeR5JKtNwH8sCoD6xB6FAfNrJUUjJYxK
 n75ddyU/
 wcnowwevmUJ7quPC7dw7oEQXMwODR/Mo1Xo6Xf+0Bi9lIERjkxlmSznEBbPyaHkeCW2Orc7WpTjpbp0ZwsvC5ArI9ySkM5pHWT74lMgZEUdAnty9Y32C5M3j74Frp6DC9DD9aPRHmhteMJIWfie4WqNy5zS9A55jK6JyjvuGYuqnbpVwzBJbVJczhCWJb7kzkb6OnDy521bO2ChZ9+8wPchESiXC0ZHsoU8n4sl0jHYaYwgt3yCLA2rZrV6hKBZADwDsxEl6nfbRiKtT5fU5lqz4xAV+OnnpiWTXfw1ryxfIE++1gZEIQCYpequinptRViw2jIq02R3JNiY9dkR5IOm+z4cCI+MuseUINwAcVFBenzsZjgW18GYDW3XZ0gmrZ/F6B0OnBDg4cnwuxgQR20OVxLNqWOjFRo1P2zBn/IIBdsHTS/D7vIpfa0XRc6btPEwToNEKaHOd6XBI6fddPvc9AH6/f1v3ng753fW06W9SLvMgIi4FoS0pg/38AHrVInOSaCuv1w10RpD+S5XkMyX29QjBJ45llDJmz6YVpoH7hD+dcr30R18XGjSqwzioRR73H+dm0Dn3NtN/VBP2t5WrEVtOndQKfAphJelHqD7Ep33EIorldCzLAkiafRbZtXFJ96ocWarqBXTymrQXg/ZeCtK+zcV6CHYIjBC5A6bKOdnAIWStWAC5GxitLBRjUnQhZWP27HBuoqfKtMeadzHkPZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
is enabled, i.e. when it's actually possible for a guest_memfd instance to
contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 147b3e529cd26..45ef4156274ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10637,14 +10637,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED is supported if in-place conversion is enabled, or if
+	 * the VM doesn't support private memory.  If the VM has private memory
+	 * and in-place conversion is disabled, then guest_memfd can _only_ be
+	 * used for private memory.
+	 */
+	return gmem_in_place_conversion || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT

-- 
2.55.0.887.g758fc8c411-goog


