Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18095CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1CD86B00B7; Fri, 22 May 2026 20:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD996B00B8; Fri, 22 May 2026 20:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB5D6B00B9; Fri, 22 May 2026 20:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 782A66B00B7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A56C1C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:16 +0000 (UTC)
X-FDA: 84796772592.14.0FE9AD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5AD6820007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rM8hJfP+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495494;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCFDH0U460Cd5q5ZDFjHLapgw9iseispm15ZDBsuYrk=;
	b=w3rKMfED8Ua9koCQo8Q/jWWFuQA1vedSbP0FzOgiWW5xPyDmy70NtDRIuhy4VK2GXVQVrn
	dXERxIQjtvYjp8rrEhrDy3wTZpjznjMIT1KO1yaJVglPnJPDoMZ4DpMsWqmKxukwFW1MmN
	PZYId7C87B2OrKhwDIKRleDkis43zcw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rM8hJfP+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495494; a=rsa-sha256;
	cv=none;
	b=FV0Ci9BHZuoS6t+gcXuT9UX6aqgDBnDHmoz+3kELBwjFN/6ELM+OsTnvNfjCvCf2oEK+rM
	FcIW9yTkru29/qvZJPw2Chieie+5dUzf5zJjfQFWpphMHMmWjIq890ifKMUXZHx21af+U7
	CmzquvfNzvTS0NtIIHsS20aleLkcjq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1339D44D02;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E5C6C4E697;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=ANakWQaknMXXsAq6xM/DVcFwZND6TYcVasm1Hl8cgcQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rM8hJfP+or/uDUXfrI4P7cBLZ5CWNFhqYHTstjSgwAzegqWr4Wl3H2S+UEIsGS9Dp
	 NPBpS6ZzHy6BoS46OoazIJ6eq/Tzz0Uvf8RIloKeteFpYICqs9t1U4wOxmlXLaczZp
	 dUaGnJJZ1SnTW8l7F/IvQZvOUf5/k8tP02wXu8Mb/u/OJLsdQMeNpwuT1/ZLg17Hqn
	 g0VLzaubS+jHibaSplpSAZu2G3vWUmknLmdRV4s9HzvE4VKqtSikqQzq1g5GwFl9/T
	 JF3QLFSGahtz8dr/V2Z4vDTzIxbCIl8HjesKWeesS88mLpW/LqGyLiaIMrcrjIVJnl
	 rpOQtPE8cs+lg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5668FCD5BB0;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:07 -0700
Subject: [PATCH v7 25/42] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-25-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2393;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=enbUgkpN5h/kbke93UGvFu3sgIUAtIDKKDJ2JxjAPS4=;
 b=cq43NauVbSuTkfNQxrY6AxxrRbsYkVnxUiU7zsR/kcjwwvKFnwaFPQdYFFkTWltwYeNv+hxww
 exhTnvT5zWtC9GsLEnK6/trmWqLRuO5b+scP3403jP2D8BlK9lODSIM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ffh5jzxkmsjieswqf75f1a43fjsttbiy
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AD6820007
X-Rspam-User: 
X-HE-Tag: 1779495494-555149
X-HE-Meta: U2FsdGVkX1+wR3Vo2IT/TLmchiyhNiQOEHFriXbPArjrOyBxjHIZnLu2O2QZJ0NGEArkWgOukOIYjWbqVmyMTCGqbWqbvuFNpYuwENH5Fz1HN6o8J8hlCK5nJsTlmovQJHD1eg1kRXJeWP9feqpYj6L2MqLmWB+YHA7lvIWheS+yw4OVRMFNpa7/9CaoCKxIQR/FvOgNx4g+Kz0K3U3W2YQ1LoouIGER1y5pE4KpLUPAAEm7NRNo+/PTVcpucMJ55Aefde3yuVOuRWOxeJhf1T/IwuJUFaL5iLf2gF3D/s3bTK4Wo8omV6Mh7SO6RUY9IjamSs+5Uk5gZnt4xAhM37oeXfIg4GDJO5X/4nv2/alB5cXw0nqTvwuB+deXaDvOZkG4K1DPtTqZsYQbYz/8/pDSDq/oJVz5Glg7cHjRqh/QKs5u0D0Kh3ssbuK1rJjf/Wjd6ybEP0k0mtOVnNKPZ9UcXBLzrMr6yI3J+VPCVkWolGEhPLrSeJDnKOJXZg5AP1bWsLRIaNU7vDsty4/6phKDaxCYT6kg3vGx9VwqGtzrNgWU8CBLJMScGvPiO8rP3rpgAzBGTqtZvcyvd3duUwi1m03zH9U+cVWqMOoagE19c7UXCq6NI7o0MoEoYxoNfARG/E9qS5uZBMRfloTEeAK5EyTMCNwUjijZHVaZf7/JLx3fOd6mZH5Hkk2+Po24isMxVomZDpKn2NLmP+eRh7tXaiSRuO9DgCxinpl+CT00CymFTW6xZOHfsjE5VuBPGAryh5M8OH3X/BYXjfetqRO+/N1/UCYvmjzxJtC4JPj4r6izO/WtRqxSE7AOeczm86aNvAw4YBS5JOC/7/Y9ZW/58+af065zdlEaIMyljWPUtbnGv78aXd2ILhXfQlsYMMhWuOqdMwxcAr+oWm/qejKhNRx/7qcN5Ifvx8gHqX9lbYKLC47kHpaSWOI9o5qbWFCHnXspX6AeHWGEcbq
 IidEfTMa
 mNlhyWh9irsVudg+InfV37hLwscRBn0KsDfk/IUZ/GjgLAMCuRjT4gRFA5EsFZn98Q1itQY/1VHMM44u0S1DGFbXnAhdIdREXSCw5MieRf+RhGi0geu/Vq3Nx4WHL2D2ha4oOH5GrbfC/RSbEk1AqUM9p4s3/N1LDUpMxkvTozLz8IJ6O9mc35kwX2Pj6Py2Gac/040iAndb2ng61HfSb8h08/0xyDQN1/6yOcGPWsR9awn08DhHVMWrN1hB3jsKM4GFqBwE6ggo8tcG4lYZ5w58XCQnbf4I6VZ83jT8jY+7j8IYv/vlZEo/WehWugtGnNOkczw5mjkoMlligGPpLeUpPVjIpdlyg2CXj4GZWLCh9JJFVII44tecQ8BFr9uRcmbQEg3wVB08CORn+d9FSjRTWdzB85hTo94ScBOHBzHsb/wfiUiyoUHkzX/FvwMjtH9MWngipnGBmrncPk//tbYWnVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
opposed to VM-level tracking.

This global variable is synced to the guest for testing convenience, to
avoid introducing subtle bugs when host/guest state is desynced.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d9b433b834f1b..c280c3233f502 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -115,6 +115,8 @@ struct guest_random_state {
 extern u32 guest_random_seed;
 extern struct guest_random_state guest_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct guest_random_state new_guest_random_state(u32 seed);
 u32 guest_random_u32(struct guest_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4eaf553fbab11..daa0c1e835a71 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,6 +24,8 @@ u32 guest_random_seed;
 struct guest_random_state guest_rng;
 static u32 last_guest_seed;
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -521,6 +523,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 	}
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2287,6 +2290,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.54.0.794.g4f17f83d09-goog



