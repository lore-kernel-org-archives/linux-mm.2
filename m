Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8210AFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC806B00D5; Tue, 28 Apr 2026 19:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3C46B00D7; Tue, 28 Apr 2026 19:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC91A6B00D8; Tue, 28 Apr 2026 19:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF6656B00D5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:29:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D58314034E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:42 +0000 (UTC)
X-FDA: 84709548924.01.18C85D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7FD614000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5SAxy13;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418740;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXc3Ets3ZNo0wgA3JxiO6XBoVwzlx2pMvFuV2Ws4wa4=;
	b=FX8CsrlbReqRdR9zPuRHC+8jUb1BIkw9RJ7DfmEai26Xie3M72YQj53oXdxALvN2i5kKmd
	OYHI9OgAwtb4bNxttxWVt4pavxiiLGkzN3To1uX1kxgsMBqjmjitY2jMDMrvZp2u8EHhbt
	EmvbFeWu6E6q3FGnjwKJK1btFuSkojg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a5SAxy13;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418740; a=rsa-sha256;
	cv=none;
	b=pRcXE3fhbVkPOPluu7smli7qKhqSfc5B3UgGXpKbsPbI9FtS50QrviWOGOpxvegfnba+Xm
	SGLVC3jET+6FGECZykk479VtWolcFEDbXXWb7B7a8cauk7a0abUql4Suq9gtU50Yv/Bu8C
	aUM47tceTX+R+bs3XnVlX/ElLOWOdTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD6324472D;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7725C2BCC4;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=IkAEdxgFQSCePcOD0KI1OLzhhzwrFCotUetQZ59Ws/c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=a5SAxy130HMQEbD8PsBjsAfQVJ8v5McxRo1t0frjQsvW+fhm/mdth96pFJvKEw5km
	 iFXSxPCCSbFwmHfgHuAXjGfzRcO7nmJ187/MjgpGpD2YeMMcP1lXBvyN/GVhoJJvG7
	 7lvDBH5ysmzlD/sV6xntrX4TBgtzwUDPGbe+spSBoXTMzmGENv8SZ/SgkSRyhEDqU9
	 +whyviMabBlg+/7saH6ETlKbn+Dd62+XH/AZIEF3rwGBM6i4llNXNcuZGW9+egxZET
	 ZcQ1n7xhxAb/XkzsEwWJvw8nYbCYXL16h4IBnnqlqYGKpwaohzHfHUXmo8G1KbjnsZ
	 hM3C6FdqJ66Ng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD820FF887E;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:37 -0700
Subject: [PATCH RFC v5 42/53] KVM: selftests: Test that conversion to
 private does not support ZERO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-42-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1307;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1/xHeFjZTWhRZczDGwQ1Jx9lj8BRoFI4Rw461HTrIgs=;
 b=9CgTbYMxC9JsFpzII614O+d7fbdprDVtfo6d7D8lw8ni08UNZgZcln0uVEjpkx6k04MiPFJfg
 QxJe2dg02RkACTOyS3Hdd2KOFVsbBQx6ftQ808D36NvFDwoR9KUB/VQ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7FD614000D
X-Stat-Signature: fp38yig9phmbetg86wwk7y9sbiakz1tp
X-HE-Tag: 1777418739-16967
X-HE-Meta: U2FsdGVkX191Vg8R6teL1r54hpBcRR4aHpGyY+ambDZp3+WMa7aEFFtvJcv0+PPl/1f9jNpePzfY0iMSxpkyE+AKd0KYSChpiDePRb8eyax1oe/6s4GBZubScRTYINVs7ZhXj9MSCDdD+DR9asY5/hrHf0q4pQEFnHrWgyWuwGdiyE7q37lfCX0kwHaC0l6ApZiep4skN1v/rFWdPaFt6QHgsBfuP4l6dRnWBeoUEIcHNuPRy5Xxm45oycfIxw3GUe5pEDVsHX3ZswiYkJEjbyRSMk3Nuln1DVeoVT9vdmcKDAusIqJZhq35Tkk7/OIzRlvxc13sfpICWO3cKNZFQSgs3Y9uhELCnJcrxpzWMo5Vxnn8wx3dqsbyvXmBH0S+wSmZ8YTROFfjAboFgUiHdvTAsdZcen+xFq+T8QIQI7LJB53atlqLeljMLkw4J1QMon+fmoBmz8WtxVZmZevdup1XsblYG3JHl/KZ++jKTQ8nset84ib7AftUCckNB+XG60ml2Dst3e8YS+RZwoy4o/6lpd9ial2joXOrbkVI6+ipAJeU0ubapRr7USubbpUrtjEsArqZSUwDtonrr5/g5ET8ZRaEnzA/BX7MUEH2Hob9MnbB42KEUB7AfmViwDB1i3pnlTnirYh4wM4LnEt0LJpBYLJP5xcQm9TrmhyXhuChv9VMJDexc/pZcmM9Brh2RQZPq9jSj3BKk4DmFDWbOzLiWT2Hl63ep6yDMQNOcxjE0f2x9vgZztulqgr60n1agrUB9dS3dtY46M4PlIuH8KWdDlm4J5y3zhViakNc1CACvZ5wRsqcgSJRR0tyoH5i0opAiWOv6RzzFZyBapIrtbQQnWhY66gaF0vN8t4ns1xR1n63V+whM/Fc5dL4XKi9lV49i/52Kwm8SzKkZloCdLOEfLuC3NaAwYZKgLH0/8IFXTWbiebG4p6sxBx8v3trLBuhIZi7M6ksIeQlZ6b
 3uF8w7Mb
 /sS61u1CU50kiK4U17WErxquie//qa/CaVQUKdUplH9adYHxdsXPViH/Z+WnRUo4kd5HBVPnOsB8VIoZCDv6o3o022rMHlw80HjEvF0r9rhbBzp/GKfupoXU2mRj7GMu4GSrEgFcfjnABcUT9GJuIRXEukyKHb0mRxInydh3+MwntWQ7Lz/01qhPh86mChOb5vZ9MoeQaIOwtvgG2A7ceIsWeltjDaBqWCQ132+yYcB/Vix/andMua4gLlEpQKM6aXuM6lde5d3sV57ZE6qZvVBRiZQbISxaMT5SJ3IN0iQ2E2EbDI3e8XSwIpNF3X7FHb0J3lVaB3QfintKF1/E6sep+lRDJPnF3F3gXRUL/YavPZ2DB61n4GXlZK8o0sfCqbQA3yCMsbfqFrs6baKgyc+xfaV5xKRrylow3ckPdThm8ho75sxSrtyFsnVZMLdh17UPd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Test that conversion to private specifying the
KVM_SET_MEMORY_ATTRIBUTES2_ZERO flag returns -1 and sets errno to
EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c      | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 13bbc361eaeda..922261ebaff96 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -488,6 +488,21 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
 	}
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(convert_to_private_does_not_support_zero)
+{
+	const loff_t start_offset = 0;
+	loff_t error_offset = 0;
+	int ret;
+
+	ret = __gmem_set_private(t->gmem_fd, start_offset, nr_pages * page_size,
+				 &error_offset,
+				 KVM_SET_MEMORY_ATTRIBUTES2_ZERO);
+
+	TEST_ASSERT_EQ(ret, -1);
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+	TEST_ASSERT_EQ(error_offset, start_offset);
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.54.0.545.g6539524ca2-goog



