Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6109FC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077186B00C7; Wed, 26 Aug 2026 05:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0279E6B00C8; Wed, 26 Aug 2026 05:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD466B00C9; Wed, 26 Aug 2026 05:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA0A66B00C7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BF991402E3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:17 +0000 (UTC)
X-FDA: 85142871954.13.40FD37A
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id B6AFE80002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QsH7h8an;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3kq-OagsKCIclnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kq-OagsKCIclnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLTz+QoAp4yNZ1r8wY9Xq6qZeJQ57AOaVsGWHTn9ANY=;
	b=3gy6u7OKdqxU9YOLiwzEF5bLB1CsSo0ySmKHOlf5smvgVORh+fLGxulCSNJgaz+z/WMZVa
	VpSbSSEA87H4NbgiCRbDFOVtQFi7eiYrrV7d9R5efenJr0GExvJZQDCgZVkmWoMUNHiiea
	cKMMUUb8u7tMm7hjH/9EjbKsNbz0wwE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QsH7h8an;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3kq-OagsKCIclnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3kq-OagsKCIclnvp2wp94yrrzzrwp.nzxwty58-xxv6lnv.z2r@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735955;
	b=8StUSqrvDGRG73WuPKprhTM0V8fj7Gx++1GCqZyCSGx9WtJGRjleAmVuvNYnl1hU0yX+fn
	I11vb0l++35FxcDvD2J3Hqtqc4dDXJZs9skexu59pi5XfXGn45pL8bJADL+A5ON/qjWow6
	HBiFIiXKDU3+uRBG7QeLX4DLUBa8rek=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc1bbd7d6e6so877062a12.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735955; x=1788340755; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLTz+QoAp4yNZ1r8wY9Xq6qZeJQ57AOaVsGWHTn9ANY=;
        b=QsH7h8anF1EpAwpyIm11/r6ljfuYEFdOmBiufLfypLqHmiWQ/wrg9O/X7IRH6CNuET
         ez3WtcyEIGhA6o1DMQY1SKtXv6F+QPDwNGp58dLwiBUy7s2xsZ0g6EzN4UYDAMgzxv4d
         diU22wjS+whpWatBIlRjMvzLRNbbxDH65nQBUIyhmFwV0yvuF8c2O//7wZcmK2hhw25j
         Si6avEQczQq3gOMTlvdjnFHFmq9ARb388w6oOrJ5Qj+cablVC6IaLCkjRd3hnWQXa7d0
         psPVwiXoo7XQuV7+YSusEkLgBEg2Cq3cFosq+an+nQ5QUmfbHnXrLo+FJGquJ/dVxcDk
         sAeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735955; x=1788340755;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bLTz+QoAp4yNZ1r8wY9Xq6qZeJQ57AOaVsGWHTn9ANY=;
        b=rS2bBZ/4y/jK2kpJ7TSFh0OaA3JhT2FQMVlzWWnGwHPNIxbqBjEsA3zjNuZ/EXuhLg
         gh+FKsbmc56ZKhf+mGHg3VYCJjEHrXrNMkT0VF7jLocIJ83Q4rdsPOznQNbhZmbBnFqj
         xwbRucIfWGfPk5To+H04ZA0EF9glJXs9DiWCSySoMqNVsvhDvGG1xHkV/S7xrawImeUe
         OxGEMe8fy/pkZttg9TSCv0ugJtHJmqnzK2dRqjVtaYFHgQd1/9C5Ruk9U1/6mlny1tqy
         wF8YwvrYBt0+XG8XZw9wqIeLcfnjf7hunVnFaTYKCB5Gx9oL4D614yUJm/nYG5s0orb6
         ytBg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/F85B5zht1HKdgd86ekWZvvndKwzRNC6M+ubgropCziqu98eFHfg2nWFupQfkdIU/uns1BsddtA==@kvack.org
X-Gm-Message-State: AFuF++mHpSFtCNRXmngfa0hyQz0R0jbpGV/DI7nGI786D8mkOb3R4T4H
	mSbmfqmfJJDOKAdOY2W1V2QBIKoI8wu1b0Qs4l77mFgLQsULfIVTJixjjeV56UdYV9+BNCyKkkF
	mZGHYFhF7bD6vw7EvK/gE+VsgSQ==
X-Received: from pgcq30.prod.google.com ([2002:a63:751e:0:b0:c9b:2759:d240])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:6681:b0:3cc:9288:99aa with SMTP id adf61e73a8af0-3cf6673e199mr11680996637.0.1787735954249;
 Wed, 26 Aug 2026 02:19:14 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:37 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2579;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Z2tr8qvCMQ6vCwWclEIKVEn4lsWDwgpi8MEvWzFtaCI=; b=uYPyckNcYtbmNIce6USQWE2ZQN3yzQ5s9PRlHn/kQiqauAVRj01fYWLdGSn4JUn4Y8ICRU4i5
 SrOFy7IMtVFANbmMI9ps1KJiTpkrRcJ6bBbcMXjogb2zUhXxCkElfSO
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-39-0a15d8a799aa@google.com>
Subject: [PATCH v11 39/46] KVM: selftests: Reset shared memory after hole-punching
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: p55y88c7aropiaemzyjxupqy5yt15f4a
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B6AFE80002
X-Rspam-User: 
X-HE-Tag: 1787735955-39435
X-HE-Meta: U2FsdGVkX190nCCPntUyBoetzM45uG9QN4EgnATk4rBN89LisDc3HhhVQppIviPZ3G6+FxTEDAoRzZ5JOKQmKEV4QpNuzwNWWdKsPvc1SAaFSKSympCHrAYSt/LcAy9JhgMQzL0XOXLYnpmmEMyipFEqjIx+OUUXhoHZu8XrUZbhr9qe79k8h6xvx8+yULa9Qju4+zGdvAUzf9heUPni42mgLzv7GmSnkV+0G/zt6zfOuIt9uOKEv3MeO+7MVsWUuyDdi0p5zs4ZJ9y5lZcPoD+XnEEC54AHGayX2Dd8soWMddVix9DSbkf3QpW6Qy5bIKwl4aa4lcISVvCukbg5dYej5gFIxtYkG+lR8v3/VZig0psytzSoARV1EVQBGcDnBcf/Okxh/w/5q6auPs1vHPX6ixv+YUqAcXMkABX4nKo9lh5P0w+7emQWzdZiBn3Ju9DlIoi7zS9gwLP8sXYqFw2fzCYpGePR1C040eydCjWSOEro7jhEKAx1O2vfB51ZBDnqMC4cdEG0Azt4DBYaiT4ayF2b/KNQUVe3uQGtFSFXYsKvlytpevTct3PBRJcjh/BJ3m4mGEP4zNpp3UlbatEDHmdMBMlu1Sq1VoctJwHYYpvb2/qWmOAWMIz9UYYRFogSbdt3H86YlSzj6TasCS+8MowXDQWBkF6Dq2vr7V3mUK61dz1X3LYglyVWyhl7zlfCcoLEGmqwndCJJAnavHsG3+H/EGBgbZJe0NvDlbLcInMQ7J0J9p7mqEL4NwOTOFKP05kGsPBnqcFUrY45G1oLKrJHRrHdnqazE2PjoFYTxYNumsxysKB3q9y+V2Rqy0o9tJNWUzO2YEUleqe9SZLf1cymOi0X8h0ozK+iftpCpZbSSTsx8tZN9k7xiopAej6yo2xVcm+ot82AIN8MSdmYElSLu32/k3nUKnP9LCqdfqWzyw8joHbT8B2qXLRb3XjqyB21heQhdP0iZCU
 wxUFM0FQ
 9p+eZAMak4tPuSsLCwOCfF+ILTlQagrjDDmIvajkChg8GGJSy3heUtaRIfM/S9Qt5VEz5IOOTjgtwMPcUvvUEjV+BV1oxVpXSITDjW2yde96JynDQG+YAgFHnoSnDnrhT9WdifF0uHY7p5pG6ebzblvb2xCJPOiEDVyIatB61tsVqZk+t5mhcOO+LJNdYLxSd0p7mcoovjG4MvsHvF3OUPwNydS+yie05fUxf0P+ONUKsWHqleGtKNLLs8mKkadhu68Xc/5g8J2CQAHVrR/+LgoKqtgM8o/ia4lzeAVvg0My6xtZq5M0DABk9fHhTBliZoSY64C75ZJQVO58qoxCtXBnKZM4frO7fH5Crej3viByxLXKOo6tkB3aw4W65VxeQz9NWCE9RjRjCuzlGCjVdmylkbwtI1AfzegfYLyygpAOCnLUsMDsxyEuLK6fNliszZcsymKBtCWv9Hbmt5HZy9l+ktxKhq506Gv7QnjQmdjrVF+Pdbr3n8GkF72gIjMnk7hrIs+kFH78clk9GXXnuVWOjl1pud4o1USFuBTculJ6pANk7xuskUspn5Z9psjFIgGkloaSyj7E68bJowxcaapsDO3XiHbClqgPtBZRIuN21zfLn6fwG6dkRIq8uUKDZrEcbUZB3wdHgEH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.55.0.887.g758fc8c411-goog


