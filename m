Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CA9C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68856B00C5; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8C86B00C7; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C1D6B00C8; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55ADC6B00C5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A27DDA06E9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:49 +0000 (UTC)
X-FDA: 85199512818.08.2E03D83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7EA7180007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBKt8TQD;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084547;
	b=Kq1AeFPiq1+DygtrmATPOaU6PnIJ6qW5k+FpWQ2Ecs0hFpkfRxTK/xg+waFk/rC+6HAdOO
	KjqN3J4b958N9oyf6GlbCBZ2EcwAFmu5jf7MNwAQ+OK1jO1qq3pQdap37XvAhM+VSTP9Ay
	dFIZY4uQmQRZQ7UghZFe0tJZHsoXQNc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBKt8TQD;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084547;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLbEW7Z/LOi4kMcFVZ/y/abOS+tUjbsTl/d+FQcVmjE=;
	b=kHKKWCi7adLZ5eS+SP9ZaDao7QysXYsXfXfW5kXwBWnSolggFbWjd94Dh6fIy6M/gwOQDw
	doCY+tGszRReccSGdJOoN1gqqmwJd0YytV1666SBwBVPxIJXIUED2LYQcOJx49a9qRvf9a
	n3hpp5q1d15I2RshJ3+LKsRd1uCY4Yk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44364448E0;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16456C4AF1D;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=Yr1oBLTtdwaGJyWjVIRhbbXF2lJ13BwSgT203mgx3k4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dBKt8TQD2PFaRSH2tTbwsIbxT/fdsxDWDKi5YzZMb8ka8kl7ZflJA0RnTN7riPytP
	 urTBUKr+fwtRV+9piCUjuV5dJh4lJe5ubM0F9x5q86aAXZ6WV58WMEAuEbZN1Hz7LP
	 m+ImjQMPiOnbazmfZxpvo3MGRMBYhI3mUnM/dJKhgOLn9q7zQrK5pbteMCteERaq4r
	 3pmu0581+29Yv8+XvhZb8rZKWpevCwUlmXdtXXXEz8n5DEU6QF7uhgsbfDI4GKvmZD
	 KYJQq+1AhQxp6SvkDP+W/3UUzPJ7LAj9dRNQETToZ1SwBMPvRIqw/N+I7oDa0RRmp/
	 PZGmlWPtpd7ig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DBC88E45;
	Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:49 -0700
Subject: [PATCH v13 23/44] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-23-dd6fbf94f4e1@google.com>
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
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=1694;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=RrmAu7ijt4T2BgV+VK4Wz6c8RsidOxZAmXDSW4OkVVw=;
 b=dSAQjeKmiLaKcZ3hz47vvakbuCRsgz9FVSQ5XqgaYCqPZV1uwCfGkSyysLvwAbEf1IHgLbigg
 mHLMql6CMxDAlFlXxnySZnQASx4VI9Do9ieGbBmxMLcQnNva9MvwGp/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A7EA7180007
X-Stat-Signature: 356q4adkg955ete11yg3dmw7drpdrdut
X-HE-Tag: 1789084547-237737
X-HE-Meta: U2FsdGVkX19rSRX+ulyv0pFaTd5mdIgy/f5s2Wcba1w6VBXc/5FvicWZkdngPpyH+ieutSblHwkAA3c496ZjBHLAY9OLNmMcDBeiKvQtSOJfX8546bftqX458HjqRR7yPsbXTsE3N6VCmVYWDN8hTwaagmwkkoyCuVB+CkHhqwhGeHZPYv2sJSVwo7xQVVVqbubZQ6qxtCxzj+LWySHgY4E2gQZDbn7B+2EWYkUJCI1esCNYZ7HWCvoDfChu4IhPiI7hndaZdTPuvhPyyQ5a01TiiZ0UNZ06NwSeqFpyGIIq63J/2o8n9D/a6o4kro1q6gmueMmqGLRutlNKXeyMDQyEmwklHjlVcDaZS7F3xgjAsCuZEeSWfJzaCn/CwhI0zn6OrsEv1DGpyM/rlaS8bwClHqDifcLbFm0HuQ/yIQrA+gW4UJHJhNMLg/zK/AZvRpY89yUBb1nDty+OysDZXJVxZ5+i6xTbyMdLSwhHEiJ4XPyQWNbl6Pzf8X/ici4r3Q+lE2tzbgQUMeWPRtN6ezjGbPAWsxZrAPH1eFAAcvq+P/sqj1d924m9fatM7vdZtqtkosxWXTdUOvqjaAxWg6BXYQRqH99G7Jf4Vx+KqAG/xwN0LVGlFlTDh5ttODy78onRw6CWRZLSSCxnJreBng4wlWqfS5g4QmQLy9gZkwNJrdcqTgqLYoiUIXVBG5BbWvwgYYYq/mPFA3JZoOZ/GjAYPDjs8H0VbHnFbsIg26Et1a8ZCJePZI5ug5Kf8SY+a/2yOQq1Cft0eBl9i0pjye5UGlFzz/Va+xQXpTQBuzaojilI5wDtldW5FiRiIy4jwRkJe06o0W+4QG5msaw2GVKcOKSjpDmVt4K4pI4NTdKKAsNGutSFOpjLDH54sBYXLpOBBXaWdOQgSp9IaD+2GULk/0z5YI8dGRIWS3UTdJ/1yUe2NBYEkEWAtLO2+ZCs1rsFZ6p/Q0hLD3XkOUv
 9XQywe3H
 Tl8hzBmCXKxJMwWl3B7scIhZPUF4mo83vAsYBakoPwmw4LmoASOUV7eaGBsqDbJIwZDQIVtNaCoS0XIBIC+P/CPveBfY4lUlp3aK3Q6NXpi58O2nokFuUqx5zcK2FP71joaorxyEOwDlHhNa4X0IcAG+IQ4ltTmCluyoBWPL19J4kSA8ddvrg4boXUalr2N0UoX+qJ7zYJt0+7IpTam/Qecar47jcTUXxYDhFDprI8taFLPZTaCWRVIBCa+VtRpukB7wGbrgoWQNH896M1SNOyb1GCoTI6TK3yfrbZhie7poewEjHnzxdtSDdQysS70D8PsVQVv3K91k+VeHk0NA7nCPdYBJXnWOL9GZ8Katfo1ZsUOqIKHOtlIhfrGoM6MQ1LzyWqc4iGSpTzHBZMQRgwDmYFL0ICeTc7yxu/XfqZbTghNHrOYG+tUYb472UoHgfgiv2zb3uT4KvqiF3kHCVhjhpjt745N72rPGpgphesCZyzDBR1zFN4E40b8S45GQIfTBKZFqM5iFRjSJbjzjR+QzIIjDPaMDMFKfaK+/+oIO38Lo=
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 75e03a2f79db2..c081e4b9b25de 100644
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
2.55.0.1007.g17ff1f9808-goog



