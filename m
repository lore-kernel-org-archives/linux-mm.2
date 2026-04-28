Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C20FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9146B00CD; Tue, 28 Apr 2026 19:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D13A6B00CF; Tue, 28 Apr 2026 19:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28226B00D0; Tue, 28 Apr 2026 19:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E26E96B00CD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1112A8DAF8
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:45 +0000 (UTC)
X-FDA: 84709549050.17.673F928
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E653320011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orkSpLeY;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418743;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqJTUdcLUpM1xKw/Nmx6TftTKwKDKhiH8JQCmKoGZLI=;
	b=ato3FHVGIEihdJ/mpt8VTOSZLuRAU2k3pqPofMHXz9iaFR9PlUwOTrpliLe9r2Xm+kDvzJ
	/+rwhgKeUxD+UvfRvN79mvJ8swNc4mglFwmiIcxVSLdt05vn2Qg3Q0EBN3LaTbztL3jE05
	ICbj34DUQGBPkJw7dbcvguoU0WzlcI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orkSpLeY;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418743; a=rsa-sha256;
	cv=none;
	b=chKaMHQqxMSykQv5O1TaLpJUrvljRXEuTzF235hJ1jqw2fdfYwp9j10s6d3Ea6zV2JQ4qA
	gDH3ZHUNL2cvmtRulbyX2CrLODJGNAzNnYC5MH7X7BEjBXoSj7Q9iHkPIa6J3KtyCqF8mS
	ZyDX6KdAlVGLzLdxNbSa3HqziqLetx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 234A24437D;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1581C2BCC6;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=QI0czbPihibpXCD2kQtktaad48rPB1vkWaJ1I6GpYvk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=orkSpLeYcwzAa7qy5LM48A13FLHgij2k51J6yMyjX1stw7i/KE5YLcpXL7eSvB4uf
	 zZcdEDlTRbY/9aPbl4y3IMYf4OCAjGOhvboey3xBFzIiByYL9HaUV/oiYCT5/+xxBX
	 i6JZPg73USXXRrfhUdYGQ0VbKQ+zR6Smr9Evmae8eQw7+1fYFokYwwhQqoNTHZBuZv
	 Nn8YFETKZ4ncjN5HcgAuAgkUhg8gmEt48NRaQuFg4DL5+l2kyIZY6MFKdUcPQu0or1
	 xDdNwv6egPsHnqKRsTCmkoF7JV+TimZk5lw9gUXXn7OtQwJPv+tIq/bVg/bqih8iTR
	 Kt+WH9S3KQgug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7395CCF9E3;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:40 -0700
Subject: [PATCH RFC v5 45/53] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-45-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2491;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WSIF8DMlvu4DIEQtmUrMjtQfocHXchi9Geu1zzxLD0I=;
 b=kuPxD2GFOGoFfxlviY04qf8Sq3zByZ44zvRNeBcRqsFNI56KizuLJBgckTtLQ4utLIPJ7dv8b
 EBG4IOrjJg1ApGbwerboMAotA0X/Wbh8yTgowQ9HiOfeFlD83CgcFa6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: E653320011
X-Rspamd-Server: rspam06
X-Stat-Signature: douqyz7njokj77bn48bpr56he6kxw9q9
X-HE-Tag: 1777418742-212568
X-HE-Meta: U2FsdGVkX19/TLwt8DcgmH/NpmHuyXGWbT/aqmlLZp5QGrtGs+TmeNM6cYFuWl5EuFVRDP0FxLwAGbYGiC4MdnG8j5Z1+7g576BWjVNlO0oD1LWPMhDfFZw9wBxGz+RJ2DbGuERQhd2/nvG6UIiNANbnuS4VrgT80kdHcyOzMBkowZ+Yp8aE/XyKoFKgDNkvqc3E8fDc1k8XPZ/iJ+TWGYI9RoaAcR6J85NxKYBoMy1df9CBLxCt/GD9+69Aid5WH2w3ZJIw/h1naheTAsD9KxsDUcTWJ32gbk84OupRK+WUFKx3aSfXPqfxwi37NTH86rZMEQbJNdH8wzaMYk0ETMbxmGOnN9ZuhM4MjgSEhlzG/UJ/fDqXj9NUTR0gttdYkQl+vQnAQwpMnb4K0F6idnX7s/Os0U94bv37+kNjOtHstF6fPEF1R/FCOH8pIexg4C2TgNe2nNPB6Ue1K3TPP81+ujyQx1bItgJX9KgObxDIC3H+p5I+jmyuw8s4jXNy+Xao11G/k1Q8KpoBY/+iyzLKY0Lj8/Ci/Ur4sXWgpDmxumB4LHO8T9/UflsEASkLVRlTxCLhh0rXVllsNqVdMKaIjewo3mH5z61yJU7H0CFtc/pka1WwMAPhZWzi3RhkJ7e6e1+Yx05XsoQFS33MTEPtSbEz1kM2Dl6hDR+zatq10p5wjCYckoAaQ8qB6mstIcZ+pAJvdjbOTIYX1XzSaHKD6qF9WzW7PEz1tmYwxJA5bNzH7m5Icoyu34IdBgkWVqRlYWNzKOx6x8S0JqsysX3Pr1vbSoIif9hXEbT/mQaQ01hhMF7Z+foXbEANlurn1dUfmuznwjn7yX/d/MHHiSgSEF7lbVqOLHM6HyQrU5rWZid6X2RS/xZlppePzDm6MszHsMAcTqzWZZN/8y/9qAbNU9oS2pnEvkjmdSYs7JLAwWp3s09+qTV2CRrvXVupGido+VI/k7s8K/gy6Fy
 Lw1Kz/UI
 1SVfb1zuT8qF2OKdMQVrlE6MeVlZ5oKX5gSccbQ+Act1j/MXmuaETsRpnf/TWfD+zVfjl0bvHQ+I9cbUmMqdKn47FMFZXY0xX7vmed6BQ4SzWjsErbWO6w09nOICst6v77P27hI4tvZ1Gt1vMQLUyyzE4L0cVo2jsVcWUTCOhZuWILhrAK2V+6GWU4NVoDTIJtkyZGkvv3ToEb4X4P7zsE9IDXl1uZUi2hOom7W+/zXfJi4l19DRVM/3VdRpTnhv9cRaY0Hpd3uXOTT5NqlmRYp8C3z6mRr7omU8uV7hlujPqB1Lj6sXR6u1Wf4WzM1XiSuFPWK66b5APa21Q4/lDUR6Csh4TVWvkwDEDSefM6z7KkyCM1y62oJLWZHehOREM6+M3JuMNXWSusuWhP776WTgdGZIjvO84Kb5a
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
2.54.0.545.g6539524ca2-goog



