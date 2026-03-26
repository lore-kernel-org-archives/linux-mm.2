Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361F010AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568D56B00CD; Thu, 26 Mar 2026 18:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4386B00CF; Thu, 26 Mar 2026 18:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D386B00D0; Thu, 26 Mar 2026 18:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 229446B00CD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E10ECBCDED
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:28 +0000 (UTC)
X-FDA: 84589646736.08.A565036
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 140134000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eEHmeDUr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3VbLFaQsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VbLFaQsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563927; a=rsa-sha256;
	cv=none;
	b=xMoKhr4lmo59WYVU9Fubt8EhEGOmke3SyvZjAhCY5GpIg8JLMR7qBNMQD30o+45we38hBQ
	fdv+TZz2FDHtSbEfyq596ueNpa5B6GuRljieqpWfqnmiMaYWKP347FdEmuU+JJNWB0iJu5
	F50dXm06DN0RYciz7qRDhTuMtIWQPWQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eEHmeDUr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3VbLFaQsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VbLFaQsKCCYCEMGTNGaVPIIQQING.EQONKPWZ-OOMXCEM.QTI@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwC7doJg1Gvj03U54dEFf5nEFPJBiFxpbSbYLz91w9E=;
	b=oPn3MntbgGzk9mx9bAuzJ7Wp50FIe8yFFOQHzekQedcdFuF1LfSAcP70wLXdBeCB/OlXSG
	O/XtITo2vM8xEmuy0wUNWBZRxFNbOJ0/+NOl2jd0PQaNgfshxjvfuU9BUkikxGs3pJ77Q5
	/C5KEgLG9Bko7ZNqXELcVmPnp1LenxY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35c0bd3a968so1468103a91.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563926; x=1775168726; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lwC7doJg1Gvj03U54dEFf5nEFPJBiFxpbSbYLz91w9E=;
        b=eEHmeDUrdzeXXRsG1fm2mnXf5/g02PctScm2dNeDZ0K3zmiyXgHX2c8YjSlOy4tmJW
         XfQu+8wT+q/AD1xwajyOrZSW05oHx6dd+6hCrvZ3gPend61c1QZg4zgdpez5OoKQrAJH
         k0YG5Brl4Olz0BUIbJ/tV32IX01k5ihEPqVf/IJasHN5MYgclX/rQZwIm5Kv0SAz0MTM
         FcGtQkqg+q8sFH7eZjwi1N6r6tAumt0lP3YZFDNiNDwAWSny/ukYOzfdhPbQffoJASBW
         hSow8QbFpl87xBryWaC0a1zGDNxUHfORQNKMxAQw5DldP5FdVCnpgUVOCzBm6/hyzKbw
         xtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563926; x=1775168726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lwC7doJg1Gvj03U54dEFf5nEFPJBiFxpbSbYLz91w9E=;
        b=RYHgZyJ4Vw8guJqbBlkVv6S0EOjlt3E7EjyC/8qryZVLnf5mgtwzfCZPg0WjE9lcLF
         ScVzNCrlRPY6GXKgn0J6X6BqtYJA3zNfxXW4xQvKzNs/z62/r5OxCl2JLV+y/6H+m01P
         AW6+SQZdp2rhmiNC0lp5FgvzbMlQ/Zf4oRN8obLrLCIWAKLuds9oa9IrSW64sQmTNJK4
         9eRsqpXzPL8yVR9+9DvM/fKlapksHd7s8rpD9xefzgh+PwWFoOQCi9ZSauowhJJKe4kl
         itw28haEHizqLSFg006zO08+0QaxHhWAGGQtl0TDPJ5bnNTGKk8LPCRKz7trDlj9FNjZ
         3ZSw==
X-Forwarded-Encrypted: i=1; AJvYcCWiWiIRndeEOjATXJTrQLmvPM/w/eVmYZUEMiWN+44VRPr8psigegvuGooCHtVDNB5fl1i08Qu50Q==@kvack.org
X-Gm-Message-State: AOJu0Yxmvu+To9n9x/knzHnoEIizoy0aaDTiwIlMqI+Qt5aoHU8cjt1P
	8gO7IU7g/F3dZQnHTSIc/eIEeWCfGZRbRw7M+16Nw242Lo1kqMgAvX908auFX+/4FQLuDVGDBwJ
	EJwIcdvgMX1zupgnxcQH42ZVYgA==
X-Received: from pjqx4.prod.google.com ([2002:a17:90a:b004:b0:35c:2df3:c081])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b06:b0:35b:e52a:7d23 with SMTP id 98e67ed59e1d1-35c30117e64mr191331a91.28.1774563925502;
 Thu, 26 Mar 2026 15:25:25 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:39 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1963;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+wZOcpFDmRXwMUiTSKOEYcZYo2gBc+x0kj6bHpNQCtY=; b=aIMdopLnLwO2DBw/+/pPTRO0PTRtL85NVIpPoFXjBwUu+m8reLPqJ0xX4iIa55xeC6M1az4Vh
 4yReKUF3iOvDQCxU+P/EwvSTm1mCOOA+k1k+K+iQe1qoaGLasqt7PbD
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-30-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 30/44] KVM: selftests: Test that truncation does not
 change shared/private status
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: uj1eg11zxsrbzmsw5bok1ocy4fr9x7p9
X-Rspamd-Queue-Id: 140134000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563926-310106
X-HE-Meta: U2FsdGVkX18dEAbIVEbq+3dotKpjGc/nZUrtwgx2FyjhtTSL6EV2YKY7v02/i/YWTDQgKlyynxIWe5m60CI7jskW4hUuyR02Msx/XpsFliGB7O0gvzsRXFZX9iba1GSpvF6Th4hebS+7iSNHBTTyQSG65TA+pPwR4Oi8QLzvs+E6UQJ7dO7VGLygKrvDTAKisRnqRMHdvuqbTaFbyE987p98uG7wcUbRz0C6/dFYc7SW9FoDkMvGd9Gcnjon8DxraKiIOhl9uemKUywkkJtMtmrdaTA2Vsrgln0cw8JiSe51AY7CD9RxMGkMylMdHUHFiPrnesqmSzja6cvJzDz6gemBfrTznPSFb4UaaUUA9SygOeIVQ0XOcMBQ8Mh+HMEj8hGQ1J5okYPzLtJ7lbnHxxfaXXCyV0KBVauwAkvqWAYTzjxKyRlNL/zMd3E2EvUA3etrX0xiI/d0/I/3YeMwMuR0hO43mLrwa/Wz1UDGbU2w9Gjo4o7UYrSuoYgA5tkak5VH5wmWevhVaZc6qmKdcGViYVkL+zs6OjCz9yBgbH9GvyWYbz/pj7v1tX4vFoV8xvL3VLF2ihentiZjsk27NQwXVjkA6g3zzEyx0JStbxLjPsVlmxC3OY6w5ASC3fEhE7DSox6U4JDlwOZ2VCQJlEwzHRcLithBHJa2OlFoaozIMGpOau3d31BvnD+jsRn9hx/gHMdH7FRoyT5ebz4oRAtWq3yWchWC/3Cooj2m48JX4LUYRsgZknBo/GcrBgMU/YGgb8ccYvPbD2qjgvofAZ7cGtPcAamRNdz8ccdokzWbn46TVIlhEt+JclojKh9Hw4Tc5N9K0ykNvNUErBAq/+ZfbSo36QDVDHi9gIryaRqDUi43afJ8TLm9RJqHp9lyXpM/UqhfBt2VUHliOhasyx7EEe6/bDqYRwgwVaTX+8htJPL8DcJq/2T5JSEF0W/ZUXapwQGDaZsBxGpGpZH
 PYIjB1Re
 rs6j4Hs0C9bB6jvCOQecxbto8ps+Xs+f4AFuA4Ge/yw6H41Eat9GVrBG2XzAUyLaIvo6gIWB66Ta++QrGmkDNWsDjCVtvjl/EHhzgVKOX4s9MHO7t2hlh47sDgVKwFQWLvuWYmCdwxAjeaqbhNG6FEqQZRJ1YT70RgAvYksKaDum+/dgl5gJnJiHCM9O15SEPJdRvhs/9MgmsKPZhQliZ6S3Ix9yrshAb5uGGPMAmpsIBZ02Kzp0YBwMbk1oG9kQRhi4Ap7AlbgJNbq6UqZiV97F3HfdStNtIg8dsTM9HWJi7TFsnRVmQaprFzCLwGjE2Yw/TYVoSQdi+yB1OrwMEg9hv/Y3EfFSbSGg2RjuNdz2fBCd4nGNCL68SlgzW425bvD8rEFwmJTwtFp5euFHdTvleyI6fW/JUVnLV668f/koYuRZbD/d+66fWXTHHi597zEArkdK2vzC0/KM8l02eBf1yu/MFGJynw3SAYdsRMVSx4/Ha/55J7KKbMy+a44gsojl35IQar6ZVyEEQ+4bJC2HzyzJRez5QhiPQRy9NUXw6oauiX9zvVNKWZQl2Yx1P03le6m09CspsB1ojt+iK6ZYjb+2T09rmpf5nS8uGURV9VzT474wU+SOTDLmLt9bxxdj6Yj1fiFVL0mrSM6UB8Y35wWa163n2tjhw2KjA8IM0b2Jf0eDeFIVzRbFHG4vDTKE2qIhjLH7U9+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test to verify that deallocating a page in a guest memfd region via
fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
status of the corresponding memory range.

When a page backing a guest memfd mapping is deallocated, e.g., by punching
a hole or truncating the file, and then subsequently faulted back in, the
new page must inherit the correct shared/private status tracked by
guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_conversions_test.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 8f09671505b32..f195a202b3785 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -320,6 +321,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
 		test_convert_to_shared(t, i, 'B', 'C', 'D');
 }
 
+/* Truncation should not affect shared/private status. */
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


