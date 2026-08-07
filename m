Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8382EC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B510B6B00E9; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27526B00EB; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A12D6B00EC; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB916B00E9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1F041601EB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:07 +0000 (UTC)
X-FDA: 85075824414.25.94C3E6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0247520010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJDA5EKz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139586;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ix2hdut+zGnD2FMp9MZuQjYaMTmc4/qxgsbiFktyvYY=;
	b=r4Qw6f7nPc4Ck+aVu15eeG7/N1fhzFSTpOWCuSJ9H31heYKu1bLC7hb/Q6jybiPQLmOxN4
	2dlbZKs4NkjwEXF8gt62xukfhTRy3ZtsLi6Mb9ZWF4rR+ZcN0b6n4jk2nBFjYXf002M0T4
	nh3sez34ED5sdv41z5MSLe86Ta4DJI0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JJDA5EKz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139586;
	b=30BiqhRdZ43sTlGQAg0rtN/5RSg/B+Juk2qlsUWIOJnLL5cgpHhmE3beqTGkTyw6Z5P0it
	oNmdpwH2YMhYlGMh3r5NzW5IeVxn6YsEKX5NEamuX/k+EIj3npU58dxjeVGiXStWYTFaJV
	e8e0G8BJRbzBqAzZdIkC3oc+2q50w+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E435452B7;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5412EC4AF64;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=qqzdiyNUgHYhFJAhz2OLTx3xm0dCCGWmIe3EV7o9RvU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JJDA5EKzDkEVpIFwaqK+GBznZFtMm+NkAQXGGtzqoZ9e8nAndBIZqjUdDpjn/QQtB
	 B0fcTB/uztCdVzuyQCx4ZaFN4TvLTLfgq1Cy8zkcK0pLrWhdftqxRsuc1po5TkqPpY
	 jIVFa/lPH7Y0Zx4gu0wlcqqyEayvVCz3vh6+rBzTipL33RXO9HgkDhL2LV4l6Mb0fH
	 xPiDRJA4Rk0JgG/6j0hQiXVPoigp9HqAcoa3rJzl3pEFGVLVGAnyfyC4b3xOAuOWV4
	 NJ2jnUU7HPoiHw40omUiDenTp6D2QyMHVhL1UjvNofTSxCWOf8uLSNW7jwlL0TQnh1
	 hM4P66OZT+IIA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308BDC5AD44;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:15 -0700
Subject: [PATCH v10 36/41] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-36-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2579;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8D4fZWoQ61fs10P4wW1NWAab+kfHlzlVCGaPrK13txo=;
 b=SszwThQ1P/kLbfeBg41IjKPAR4N6GnShBqcO1dZvZxJT+Hz6+KdLfcFuRLAhHEL8ubXBszGre
 tfZdFUYbGbtByPo9jXn86svXQxTJzOB0LlrhT+0Wrj+3oj+THtZz1/L
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0247520010
X-Stat-Signature: wypw59kw1o6be51bb64w74dama7s1td9
X-Rspam-User: 
X-HE-Tag: 1786139585-577988
X-HE-Meta: U2FsdGVkX188cO9yhokr+EIPQUhFU9Gez1zZTbGLAD+sYjPRFNZ3PmfFT/s7wyhgRkYBYdam8W33BL2yn3UZWqKWG2pfOqfA94XjUMhiCPijo0T9w1DMhoOYLWgCSvsSn3siPEAfA5fsc2RBrils7WbX8IE0FIdazB3mZRxgxlFgvMcvGJsJQ52fOky9WLFQEyB7Xtbfno1CIBdpI1wmvqGtlkLY0RwZXZtOs/IPjt19Pw6txVh618GHGF6zmBC9WkKDN712zAhHXRtzQ2WXjSBwUFVzHYud+014Wr4CQ2SEWadjXI0aQyD1WP99cxfd6BKqgq4h9yIJtZZcKtcb8eO6O6WcfSHjZB9PP5ehqvNHsUb4LW/AFdPR7yhqGKirB0+iroZkMyP1OcXdOSTEziJgBwM0RCqbm8sw5OA+BoQyVaSlFEQy6Z+73irVyWdKk47lb8Lpnya/SeEF8YktgT4bEKtibBkXiG/+EZw33azyoi9EDMIwIr/R1tQ3sT300CwD2yR24hGNtMiQG5XJ0sNCTO7Lbf32tKrwxkyRQoc1FE1vFcMTTa6jAHDdFZQIc4D9hQFUswPnRsw27m8pK00XRtSpS7PcgS0iqfZCmNsrnXSNG59lLznZYfaEx0fkLjv94WC3reExz0qUCNbTFM9d1YgETh6Md3Typu2U4bSqg4CaRTIwYsHVCPhaVF5poVWn8qN/GurLabkmpAh994G+w1YugDRwTjOcZuN0i4kFI4wshf1RSDZMMMSZMvVxmtF/zn8/ziT4DbmbgwQa+TD6qHMYTkmKoVuyyy6wLX+7zwmyTDDTxAGFSrV2tYgaEI6wkWwg+BvxIfKDQcTqHPW0cTk832zKx6ucrmx3w9X+nFpEFf1O6+BomH39XT6FRgAeH3mTJpCwgFQCd0tAlqWg3aT5fpBaO43Bsb6E+MhAYZ055vR5QJMljk8OXqrQ6e8AzKfvI1Ri66XuVS1
 PGlZknzO
 usnhueS8LlCnRQx1Ygd1qaUAKoJ8CL+EJeJA8xXWGo5Ml1KkSckYbSCqqYyDIRcLZgPcH1ItpM/t4fkJwB2iM0ZyoXHJaV8XQ/6+IZGfi05WP2VASyq1oZ547SWWAfC5wkG/rxJh6i0GbqjqpleK6fqgJDsJSf/zTmH1roTxIPjZOgpj7YtzKk2SgxRpTEQAkx86oWnUR0QpbMApjkQI/onpfsNmCeixbQMUHcABJ2NGmqbHysf2/IRbyQudg/7Ydd5V0HfyANf4QTHnh49C+natJbVZPbIDOo1MLpB89dDnW5R6hOgBlOU+khAd4jSnW2J9BP7YnG07wLoV1U9yhIrhJ4dnhvZc4pq1R7ty4lTnA6ymQQE/2J0lyOU+T719Crm5CvHWNobGfoxfvFXs4w7R3Kc5a+PcY5BLek76gGPhlsRtb2eUeLxpxY7CqTTZlZnxySNspk8JJFiSjgs/XgxvRe/uIhhB97KWuyjYI8+anqyRpi9WMRA7qZBbOI2SezMPz5gQgwEpbOOs=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index f3de2a4ab0551..cf50e9a332c5b 100644
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
2.55.0.654.g21b8a5bc05-goog



