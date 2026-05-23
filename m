Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C49CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB886B00BD; Fri, 22 May 2026 20:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EFE6B00BE; Fri, 22 May 2026 20:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59276B00BF; Fri, 22 May 2026 20:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1C276B00BD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63E61C26C2
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:21 +0000 (UTC)
X-FDA: 84796772802.16.DE73A34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F60620007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erFLDJS5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495499;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0Gikf9mlsBDEWp4m11uqrb/n045zbiK716KF/22A6Q=;
	b=KsiDmV/+q+txP05XQwarxkL/3ici0ykk8UFizEcg7Wscti6IoJeB3Eb7j3HNthSxcVs1Gz
	b1a38IN0a81V2n7bczFw+YaPUERT/YncrpUqSrHG2aELOpvgtU0R1YK27peeHSD9HEKoGg
	AGoSNghYQISX/Q+pzF8oTgElKIQAsCA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erFLDJS5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495499; a=rsa-sha256;
	cv=none;
	b=uqGiSjJ4A+TlQcVeiQUZuyXmeq4W4VJPfcR/ywcyjWPFE0aPBdFreQ/HmKxcp8XSUZojaq
	UjM1+XukzA5Y3ZsH6JVHha6LP4tZVcQql+Fa5XiHCDi6gWC1N1Uu31+HnV+khsIJgVCtCh
	IJ3YS+wGSiWawPWGm8r87qV0LGW4+X0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0503C44E07;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E84BC4FE0B;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=C3YqGzwV4mi//zSv1560eHzA/9c8vm4oKMo1X2cy1mA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=erFLDJS59JDVAh5FY+txdGk0ec6qjCkrfmwxMXtxzbKtRnqh99m7tLwRvvZpX5D8w
	 wJog+Qvyf2AGLtSwwzt3rAFonBYdELM3GzzY442ewvJ4fcT90FagqzjupRUek8uXPy
	 onPF+PGZdaV+z8bNoi3WuJjo+jc95Kk6bNsmX86nMMCLezjmkJ1t0qzJTG4N/e16jk
	 f4bAFCfOsJulfPsKf1G8eQcUDPbSpUd9rb/JntaR3E+T9loEG79/D3bvwriEaKjPkN
	 LuwpbZ5fwzotLixZZ6ZOu5mtv082IEJDoYACpjtdypFuCwUCRKzatTb1ZwwKOD+z6L
	 d/23WKtuDYwhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AEBCD5BB0;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:17 -0700
Subject: [PATCH v7 35/42] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-35-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2491;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=sCWEiWH9FWUfuYMGCHq0XcWxif/XLBZPkpA1dK1a8+s=;
 b=wYFW32Y/+zNSQEQOZnZy/gM/U6IoAsf1pizAV1oS7MN/e+okp5uot+XAwEfzC4JTSZPxGVGjX
 wR2Kji/VOTnBlf07GbyE48T6aZFVSSfCuJJBwu9+EX2Wm05vrVVu0CL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 3iq8mczwj4unoccfetyzuqqnrysqgt3p
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7F60620007
X-Rspam-User: 
X-HE-Tag: 1779495499-976765
X-HE-Meta: U2FsdGVkX1/dm/oZrk0aYzYxTIIcZMNCaKKgcW6uYQeDux4uj9ArkbgqMB9PLonzF8k1YYGdBdTYOFLiqUg9l4nFmhEzRBeAA25HPSIX2wmxV9l1EPCRxR+wnXAPy31BGcJTF8QjEkl6EuyQP2xlfWT4jyEX9siFjVMwXUen7Mj2NAkg/ph7zNwgGAhIomIOMe7Mtu55AYFXinbf0QcSoUDPBMBDTkcApxZjbnK4ejCS02N00EZT9BOUUcJ7Gj/gcl5S8/wrhKKjZPA2i3qnSeadWynj3PRn+J89f59qYTptnJizRpzAEthB0W51uoH72H2ypbFpBOSe9t7qdss5EMHbM1p5M/zA5pSbLNHjI7pTozP5+h3Jl9X2sPhY1iSmWR+9XR+02VBhoxyTq4AjP0Jbdxel8dV89NzRn4SduSCZHWVSWq3wCnbIBIli5vjSwyIWMYoAkKSSOoF+rTMh7Z74Tu1ep5l1ZwvyIWQlGLso5iNWwVLRkq7mxomijWE6KRsKz7Y9FYBguSZTPElBOvNFUmE0AoBQ3qmBCmzUMziJfuVhSVXPha4HLG+XqRKyUBkTHNifmvLnn6Hrfz9bi6TuL7w/k9dojd27vt9N7XnH12eYzEjqzuCGmDiXaRqtzAPXkHwQ8ToP2QchEHctWeMwENXqL/DZKMvZgw7N/mKPyngGXyxGRH0nX1nqUm5GdQNOy7InceSO7B8UJTlDs5rAqRr5UBsKHuMMEQ7OaqGWlrf8ng93mOi/a0MbG9PxkDZvmmBR/IkaZUupO1z7ErztJTr0GppcpRg7A0mNdcGtjeTvJF3UivvssnpynRmIT8iFDBAIRYzj6favty3G0452Am5NXPLzM3dTRAbCbMWZYAYGEu+9jNVabW5OO/E3OCZ40BKZ4IM8M79XgGAY3Js4H30HcSRYxIg1X+66JXzhC5kRRBXeI5+/zWY1OCG1ZOYzdRulXIogJRBuaWQ
 GGXahAO5
 tO1G0L/jifc080TgaBPviPp7UgNmsEdJ3fUnK4ca17MJNsR7thuwZHf8vV9KgrD+dfYTbIwtZA8bWakBEYPtXkfZeCRbgNbVzyg4Q8KH+vzZfFzVCxCvahsHW50CVfdWM+u04znT/v6dEHjkCuX3ydAbIPQW4zsy949qAtecUgGCA0K6h1I6zZocz1srPKO4wNaEONVbB1KZmoYPiRf1ZTE/tg06C2c2RnvL6vNw3zFsyjd1wBco6NORGEG62xtqK29GqNpRJmAgex84V/70QmeOPP6+yt/+kKQFAtFeXSVLrLSsa4Gwf1I47fUmMQZHowx+TcMJbMo7uaJ7CAyy1Z5SyCCF3FD9GWnVH+EWdawIKremZoDDUAENBklDEyNRnLqlxPjkfXw2+7MhXTWWpl6FjSz8j7ulKjAMj
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
2.54.0.794.g4f17f83d09-goog



