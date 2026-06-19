Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40FD6CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09166B00BF; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0906B00C0; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82156B00C1; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 956BB6B00C0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0414B1402C0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:09 +0000 (UTC)
X-FDA: 84894785178.23.A09B89E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01CD5180002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pStgbSQ2;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829127;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NvtOSqh6FzJUg+B5GOqwgXr04AiVB1Qkh3ppsQfb8aE=;
	b=peQmzmWOZnyv5gDaCL0PyHmMNP5yZ9tYZDWVwPK85m/cpZmPFNRzI5gIGpQT5IfzR4W3OV
	TDcQMOtrD7tk5eZKsw3+wkpphOAaXy0HV1Cg/pV3kPpVsW3tqYBP4xhCXr66I/ZB0lm19U
	KnqpsduKMKmwJKOefcAiZKgKYU2FE8o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pStgbSQ2;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829127;
	b=ypArlOi7bYF7zM9VP817Q2kBjp2L643CyodvVIv8Uf1iBZRhtrmCN+Ut8VDtoAA5igRZ7B
	SpXzqRUUY3NOnwVJiiV8lPmk6ZIX1M91+ohZu5TQ4C+IduMlx7qoVYLVmJcqB6WQ9IioZ3
	qV5K+7muF+mRm6xLENQy7sWjBSy9zoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E9C344E0B;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E77BEC2BD01;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=WAKMADTKt6O7kXXejUyNTeb3Eo6paCLBo0p3xffhwco=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pStgbSQ2h11d1WPWC9k0eA32vwoQcrGhdQdekC+/WHrfD68n2B6AwP/6JxoLiluEe
	 l4cA1guIxhDPTaGSXJwgXI0TsSw9TuSL2Wz+rHAdsOMhjofwbkU+QF4PYu3C0u0hAb
	 VRLZsJDJsjENb85pnJAAAQOAIdQpLAz4zjG4QDPFHioxgUNxMiooMF2jS9TlRKUQXs
	 RALziDG9qveXEifabMXGlmn8qIvS9vTUP9n0fGKA5kxAnSOYoVBMLuE6JBenC8pEA4
	 CvvZaPIWElLi4yMG8dHjifWKDI7IH2y7yY4C/N+XbKPMK+bh3lXbNSUQHR/7TL0DoT
	 xp5xdZxIIym2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA054CDB466;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:17 -0700
Subject: [PATCH v8 40/46] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-40-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2495;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=igS9huamOm4v4JvNfe5w6YBKw3+2FuoejUp2nlG0FvU=;
 b=pCifBfxclI7NobLZIuHYqQsS3pr5Iuhjk3gv8HVyjjx3XOEbwNCWg/2MHXDW6FskpMp3GEgR6
 iGlD8sgX9gtCzcEQxL+owaYUWzgmXF2EGVplcjtqHLscCN1CdaJCtl9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01CD5180002
X-Rspam-User: 
X-Stat-Signature: eiam9jn8npf5q71u84ywn68r8q51ae5x
X-HE-Tag: 1781829126-707992
X-HE-Meta: U2FsdGVkX18Qxj3e0WgVhbOx4ACinKYFxMzwpBscqlZDJ5CXqaJw6QKf8jX/5eILzmp/OVDvQ8mH/G00FNTTAbOESAY5e3+Kt+0D8Pscd659/JzTnshQitD9GE32fAYBMHa/NBRKWZHuN8RgCzFOVPo64C3U7Uma3DX+x4kFDXsw8ht9tYZJ/lSpd/uqIqx6GM5fklEhZel/euu1KOT2Rtk2vRojuVQ38BSZOozGrcAEJfqlhoFUnUyCgoddFwCkK9ZIwAtXEYDNz6LPYxSni9twFzfFMQua8y6+59YuOevXNUdhiOKHhp3tiE5ub8CZvhMZuAKyShK+k4U84Fm5n37TZvNv2dQuKlBQo+YQy6yqESynT3syFphop3yyDMaKqzu71QgTAgw9JP/DmOvGzFVOt7X3kTVLc66hDPNESX/YlLB1GuvbYQ8yuvAQWf2y3oA4VgdSDsiKnE2Sy2RVbJ+JH1OK+qy5mriWGmkkkYfvItpO45I7Y5gfGqW15BxAAOkRtJ7QDYmK98BsQQA1NyMQd2zVbeFPVLJVKP+ku2PwJUTOn0doZ/sQ6mGO+q+bNA1E+9eOcNOxpb0+qFRftPI/xtSxJqXvNbMqIea5r57TlgfBDw26hmmFhh63JeCNvghxZFc7LQYOPyeYm1zoDfzaxjOCgHVnmijs56gnKB1OcSv41ruirF2ZRU1R3cPSnKGv7+Wqo2NFXYTghdrGUR0TVtvdjvbIGQaLsaDumYF4oWBL9FMc2yxy/tiQTXlpwKpauYClYBAj/A+/lfu12io0PXhqovO46+wUOZWKD8V/UmPjP26+fjErYtavyw149pdfQ6xXpsf6aeBpH8RlPS6BnZs4CUGdPq3qzgAhdj1vn3Rks1kjJpapKA4+vROVN0KmzhyRa2oFdMiKzNI+ZPAAw/SJEnhXuaZG5eTdR7pyRrTRAR0ZWdgX6GXsGA+ntlA5Fp0cKPgt3wkUW3T
 pmEzaQtP
 10DLS/60QQ3Opm/mCtK6RywXgLZOuHjcvhoyeysJIfszLPhvWw5Lw/YgYIJsjNguxPFenrStaFSf1YySq1bHUIE1DJEAUvh4jPEMyUny9TwAz+GZQpwIeTbLHg0H6NQEsvdgHbnryO/AH/WJEwN8qVTrfqvVfBkeyONYybqjo4wE+pEHSsCyqOh74SB13+gM+1hK7j/63SlyHrBuyC/siGaZBfyM9trgX78CytMLtwmRS2TbMMwnz5sOdmY6rfSkOoNEJ2eA5COtGGPPRY02MBZPXoyG9sgvCNmvgpUqutlB05Zi6MEcBnTYkKq+LWTp+1aCpAz1uWagpd5PPgBGI5j+xZ9qsTfrGq8+inKD3t/yxWiY4JzZKDYHj/dhJrBzScprUtVSOoEnzD0dLIhj2wKUEB2ENFrBkhaoWp+ip670Iv1AvATykKBN2+2onU6SzhXyW9T8Uc0zybNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

private_mem_conversions_test used to reset the shared memory that was used
for the test to an initial pattern at the end of each test iteration. Then,
it would punch out the pages, which would zero memory.

Without in-place conversion, the resetting would write shared memory, and
hole-punching will zero private memory, hence resetting the test to the
state at the beginning of the for loop.

With in-place conversion, resetting writes memory as shared, and
hole-punching zeroes the same physical memory, hence undoing the reset
done before the hole punch.

Move the resetting after the hole-punching, and reset the entire
PER_CPU_DATA_SIZE instead of just the tested range.

With in-place conversion, this zeroes and then resets the same physical
memory. Without in-place conversion, the private memory is zeroed, and the
shared memory is reset to init_p.

This is sufficient since at each test stage, the memory is assumed to start
as shared, and private memory is always assumed to start zeroed. Conversion
zeroes memory, so the future test stages will work as expected.

Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 861baff201e78..289ad10063fca 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 		guest_sync_shared(gpa, size, p3, p4);
 		memcmp_g(gpa, p4, size);
 
-		/* Reset the shared memory back to the initial pattern. */
-		memset((void *)gpa, init_p, size);
-
 		/*
 		 * Free (via PUNCH_HOLE) *all* private memory so that the next
 		 * iteration starts from a clean slate, e.g. with respect to
 		 * whether or not there are pages/folios in guest_mem.
 		 */
 		guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
+
+		/*
+		 * Hole-punching above zeroed private memory. Reset shared
+		 * memory in preparation for the next GUEST_STAGE.
+		 */
+		memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
 	}
 }
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



