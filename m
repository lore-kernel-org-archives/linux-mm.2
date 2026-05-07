Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A23CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94316B00E6; Thu,  7 May 2026 16:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DB96B00E8; Thu,  7 May 2026 16:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5356B00E9; Thu,  7 May 2026 16:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA246B00E6
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 488B81A0613
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:41 +0000 (UTC)
X-FDA: 84741777162.02.23B6637
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 80ACA20011
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q9po0EMR;
	spf=pass (imf03.hostedemail.com: domain of 3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDRRc0jg/jx53tsGeC8eacCCEXJljCHGPEHlQkr/vH8=;
	b=a+Y1rlcOsKMjVZaSbz+G2lLk/5EyoSNiM+xvCTkVCDrmjiraN1LVrGSliSM9FFJG5P+oz3
	5TURbDQXxTPDTVLUwIkepMKn1bUHJTChAfdtENf+tq+vEuPEK2DWX5ZQBq/LIjmLy4CY8c
	osApYav7OmQhqYxZ2iTdq3k5hsxB7jE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q9po0EMR;
	spf=pass (imf03.hostedemail.com: domain of 3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Xvf8aQsKCJc13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186079; a=rsa-sha256;
	cv=none;
	b=Py8DvShAuQZ2oxGf06VTVRv3zgPsnmyQq2k3i5i3d59WQf23obDD6jdwW4swdf2Ek+SY5m
	vXuCz/r3AfPAwkQCCrbAcx6vK/3s5ZpXMww02DaVU3U6uzjqNS087q6waUdO49zgNvsyHk
	lkp+guCwgJpAuyIsWMLfoQl3NP7Ijho=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7ada7b25f0so654968a12.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186078; x=1778790878; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDRRc0jg/jx53tsGeC8eacCCEXJljCHGPEHlQkr/vH8=;
        b=Q9po0EMRfeTrmY65gZF/0tRvey4ZBo3XMZpg9+G5hwrVlmm+nAVPbnnM8iQUJ+8Vtb
         Cq63ArQLQ4S5a6CUE5SmfSd6OV7OJqxCAQAVu1z6DnHntMQjxgZ5m1RqLBf2Yt9ZMoaI
         E4yfCPUgiRQmwK1ajWqVhjnWoqfJWd/TTsXaXohje6+dTNp897bK5VSq9tDUziSc9IT5
         fzVbmLITg6X35CvBS2hN8Jx79g5HCaypyUD1wVE7dhhI2cY/FJcPKPe0rl2XTd48pzjS
         rt+PNq48q4eoP2X+q2Xt2lcGGA3n62XBodTOIqb3EnLMR/xPcBrld9r3z4gbdR+zpR0A
         Oxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186078; x=1778790878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDRRc0jg/jx53tsGeC8eacCCEXJljCHGPEHlQkr/vH8=;
        b=Wm5YCD40Xd/Hjlgg+8SG3mDNUGmbIw9aEDtuTdUw7KeYP/qMhE/vd7CfKZx9DYCTUK
         Tjh0wQ+/5AAsmCApbABTu8PYKlPJrp9F8KZww0wsb3tQXonkDsMiZ4M4uMykcNUmU0oo
         svwBK8xc8ltolkwKwdXHUFl9suIXR5d+pZa1eCHsdXseAyMleI7Hn0lQfjgjBND7pSNz
         ZlLPT3qNItCfzp2MCdV4WXYGzbdLb8nxNwUFKOvioqWGzZZLkUEn9H1ScLbYYwK7iIJu
         UzPkiAmvzGDWmWbTacTX78bY3GIg5BUxJVq7pbBHvQJmN/EpOvM6b9BvoN28atpi/sU+
         JdLw==
X-Forwarded-Encrypted: i=1; AFNElJ+lxP4m2GFabBFmhOFxHTsuslwPZ8ltZa+FUTDCJKZM4HIz0RACiZ7VNnxitoeRXfuncMNBVV1JwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy861ONV3/QnvXn4VzVJBoDpUGr4QAHgQPRbr2nt26riTtEAZqb
	i6m/WG1ogZftfmbHtOny6NhuOKfLsjW3+Qr5Dc18Mepe2X+01wbWpE/NBy5mGpmc4ozNFs3NC8S
	VWUTpGqMoF49uQq74kscdaKPiow==
X-Received: from pfje17.prod.google.com ([2002:a05:6a00:d1:b0:83a:d498:99fb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3944:b0:398:962e:83d7 with SMTP id adf61e73a8af0-3aa5a9df237mr10814249637.43.1778186078034;
 Thu, 07 May 2026 13:34:38 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:25 -0700
In-Reply-To: <cover.1778185936.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <cover.1778185936.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <252ec123d00e4b60e1adb9ac5c84e0e4349fc488.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 4/5] KVM: selftests: Allow specifying CoCo-privateness
 while mapping a page
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, liam@infradead.org, 
	linux-coco@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kp5fsmipxm83h3p4oyif8zqup618u6sb
X-Rspamd-Queue-Id: 80ACA20011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778186079-205682
X-HE-Meta: U2FsdGVkX1+hIyfczpQ9G802B6FRfT5gA9UvkpUrhqoTvBAoaIGQl2l/l/WQezoLjwF9dEx9xIzbLpc6cLYjxQYdLsFiwCNNI0gBurhBYiiTuPknmrdGq46GXExyDt8kimgtmWUqA4Z5r7QkrqUH+o/mrtSgiKm1mDZrFBh2ccndraSfnKG+lSORBQH2gzMTP/EC9IJkNWuigyFo7mtW7DtcpOhBZ+sPStxZUpqd5K+Cal/eqJebUSMB541qNgWuSZ7dF/y9XqPdZ0/cjJpiX2KyYbgLv4RXT9NdHmsIBQP+ehxqBFtJN9APdMMc5ae3DaE6Zy6FZraQT6Agp7mFpd80wEHVOt+T2mLnZQb3QvawXpKlBibFGc3cUmIyWR7+obB67JegN4GwlrK613Y/WnpohD2OytxvRVx2GfRgBhRrEAmLsvKc+u3y0H0w9fledYFr2n0QO5epy/Hy04sXdxW7AKtCdUh3LyyIhd+opkdNo15NQLfRQ47mi5XayTRM40KzAs+nDvH8X0R+0eN9MhlhQH7y/qtDAu1MuMZzG/yFbDkkYXkwa/RzhXQuAGcOLg3n6X+RwUmRR0QoxTizG+k7AFRscNjIH0JMyu/WmaZEHtzUKzISgf5c68Y+awC2gKom+laTBoOUt9sN/b7yKWWBH7+JftCwvE8QmG/j2nxcNBAKM0v7nRlUlm0oXB13SPVdfAdE3pvMaZykEe3BBQFsydkMQZG/BurV6ffpIa0ly3nbUwDMladEnkpBMBOunGFnphYT+Q3WBLN2WSOcTqKncb2WoknSD6u1VJTM5ZzLngPJD6CTQI5XtVNM5R8rJ0TSFft9NgYU8lB1N2xtDM7IRLpslBv84aeAyL6Rgp8Rmdbx9UQY6aEgVUCEJjFvo3pcFco1+OyybAM7kEXS0uCZQW9UwwJpmAgCmkK+WOUzq46Ujpll/wEyT64E59cpRTQg2z4J3ZX1enz2gDR
 7zkc7WXP
 b6qyCjrM2yBAIUa8l4KUWfMpJw6BmZfX5CbQwV+8WLSSAcC9ulUT3QiTk1pUwkjlqKD91DA8b970P33WEtuU1fEv5wT61QBf6P/OzEnLaDQ7cLW/OkxsajfCw4+u1DjHI2USazDc4b1+aQPAp6UBkwQCa48HZsMfVyKgDXQLxETOktK55YSGxRPAzFrskcJj7Was010lvoR9YDDAY1nmKX8/a1QkVKdWbujzxk4O11gIwp2zZ6Fbajyj6dKwhMEUWQtzpoTvjMlyCjhBeGKlu0mLpLhhfWF3HrUdp9umDfr/znf7u2s3M9eZm4gzGQhLruJYlNa0KKs4eIjz6mUAbyW76yF1tyGvyicuDsVkvn8iy0kc2BNVIY78F41Kl3fYqQdaXsJ1Ml+5V2Jbf1pMLrDXHcelg+SlahjTOJM8NCQu14aAdnKpS1iyKnpL/gtVTdI8a+aXGgudCvb6DaPlCWH78s4CwRjePM+iF9RQFPEfzL5AZnYHOHlkebjjVWoBvGJ4B7McEqIowPS/b8lx3913O1lEXvV7mG1JL17LqOc5/09mR4+dWjCWKj2ImJwT40mMKdoKf/hGZg1fKpIwHcEXrsDcNqQPyTD+GMMwEPZEAnF09aW9XQROGIwYl3WmBp8ZBaAkf7LxiNGLCWLyEMbLWfJ5vCgCrEMolcPPloHp9XA6grLIwkJs2lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h |  2 ++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 13 ++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 77f576ee7789d..683f21452db58 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1507,6 +1507,8 @@ enum pg_level {
 void tdp_mmu_init(struct kvm_vm *vm, int pgtable_levels,
 		  struct pte_masks *pte_masks);
 
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		    gpa_t gpa,  int level, bool private);
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 		   gpa_t gpa,  int level);
 void virt_map_level(struct kvm_vm *vm, gva_t gva, gpa_t gpa,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b51467d70f6e7..02781194f51a2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -256,8 +256,8 @@ static u64 *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
-		   gpa_t gpa, int level)
+void ___virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		    gpa_t gpa, int level, bool private)
 {
 	const u64 pg_size = PG_LEVEL_SIZE(level);
 	u64 *pte = &mmu->pgd;
@@ -309,12 +309,19 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
-	if (vm_is_gpa_protected(vm, gpa))
+	if (private)
 		*pte |= PTE_C_BIT_MASK(mmu);
 	else
 		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, gva_t gva,
+		   gpa_t gpa, int level)
+{
+	___virt_pg_map(vm, mmu, gva, gpa, level,
+		       vm_is_gpa_protected(vm, gpa));
+}
+
 void virt_arch_pg_map(struct kvm_vm *vm, gva_t gva, gpa_t gpa)
 {
 	__virt_pg_map(vm, &vm->mmu, gva, gpa, PG_LEVEL_4K);
-- 
2.54.0.563.g4f69b47b94-goog


