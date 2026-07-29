Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460A1C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D806B00B3; Tue, 28 Jul 2026 20:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14296B00B4; Tue, 28 Jul 2026 20:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC1D6B00B5; Tue, 28 Jul 2026 20:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB6776B00B3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48873A056B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:21 +0000 (UTC)
X-FDA: 85039945242.15.FAF5651
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52FC380008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKdypWQp;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285319;
	b=oKw3bEjBZQvEqaEbVU6Cya8Q5wlzgMBoWghjC1+/H2RUfXPRl9GbOAIQotnpVDWsvvQ8jm
	NFw/6S49B3uoG7v9h558EbdunBqJwxdZ85rCNttv40MbBZjqrT001ACptqxKgmwW/KxQ5p
	5HR+zEop3YWmFxHec2vcwqVfDoZysP0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TKdypWQp;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285319;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xponwOBtcNSQTI2paxsZvX8fhFgD78jI59TTL5T3bq0=;
	b=j4mPOOgdb+kP3yqR3vhlwpWjqj6s7iKHplitgSuyL+PmT+bcceDcZuUAUJjDOa/AFsFCJz
	MPT/JYbsX0DXfHplluGtbzidUafAZHEn/MBNgbQo+2lh1+Yu/SUOQEKPCz090Z9kRDxeDp
	xvEMcry1S9qRIDop8jzeT62gcuOrkto=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F57645288;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D97B3C4FDF6;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=hMvA+0a3KcvWoUzzj7q8wiq30aZ48ZPR5uLoFDaJKBY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TKdypWQpKwamluqnAmQHqPt9pyr8VpqWB2NWyOyyNM9fXhxQAJsJ6FvIAWUNNMqHJ
	 Cps6bSGK0NQ0fGkM7W0YJ7vamHnJ/Bd2QOut7+VxMJ0OuO3CYTfoBT7uNG+kozdTi2
	 5GzPxYR1L/XmTkuh+NrAxeqqmQc70SxvVaEC8s7Sh2X2HyhpE+0t9WSopLnwsWiGw7
	 3MfEQm8XqaFRunkj/Ybi0qaK5dGgrzQr2gotyVhYkBo75r7gY1bLGmXSjhYS+gFjJo
	 0NS/Eds/ujQoIkCF7Nct+IE1kyJg5Lk2gWQNyaYifgQoHmgCuDWRROJ4zj0qiI/Te1
	 X9539JaXuoIeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B743AC54F5C;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:24 -0700
Subject: [PATCH v9 25/41] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-25-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2380;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6z64Yh3XQft5nJ/QOz1ShFn15iZbmRUTFgmDtTKZig0=;
 b=1xAWrAo6YI26Sy6HBtLO8YdfC4fzQ+9moT+u/9w+NwY3jljyTVsHumWL7NEbU2qyFnZDgr8RZ
 VrzFCOFTjppBfBtXPKxmdG0vvWyQC/0jF0dlbQ23Vg/DTrb4WLP08wW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: pj57x3eoppt9sjwyfmfq9m78atzqjwpk
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52FC380008
X-Rspam-User: 
X-HE-Tag: 1785285319-388392
X-HE-Meta: U2FsdGVkX1+DDAoPPMb6wtQBeOw62OqyrJbPVzUiP2/BGJhj6HothPR2cEz90YIuiJk7lG7AFdZCBoX9ocstKnfJUAFHk9sZaEIQyrffIozNlVU24yDvl92C13Go+sf4Xs1hyEEIe1bE16AyjMNZzZ+ciBd8OBzDeEO7wwFdvtHOEvKhF+PvSwBREUCEphpGvdF1hJ9y48RL+KT82zdpBr36aSQQGks7ZpWrU01Ifi0UrhfCvQ+NYOzKdxezpmkP26XH0CtsHALfe320cjc9Q5cAYHgJMbjd0uID2318bH4QrmR1n0hgl7I2PK/EjMTyaWA8DjU2c9RgBejRmqnKOMRgEBH+9aWl/hF41lGQVuKXWEp/YaB5z0P+LKaKqNTthtcD2KTuiMKxolIz20bsbKfskJzWdlZ5b4tW8zss4YASVzuEjreEyupS1H/GWbd5m1vxGBlXWf3yLF5RwOPQfXIAZ0OcSL45CVwbJegoYTSFl6mWCrtQKdTJ0CbGzmy9Co+YlEZtxake884wxrgwKLrw5KPu9pKACCsD4j2qgduF64x5taosqrpoenbX/1lxV6Xkyp6Zy69WjWiDtnIJqmrQ999mWIye7yWHX+U8TO1xVeaBBBViToK2v/UhlKvdFLy7ri3wlZR/GHd6Afqu5lSzcvAj9ErRTfXlBqyNm4pLpc/AwrP3gXWajU1m3T10QqWQ6JjwE6pp9iupFdbC543N7Oj2LicOgP14rO2nNdIpJsEpq1DGAxTSpuK7H1c6bZea8kxtJq3VZVOz+lbNqaI5zqWVBmigfnH8+4TUSrZ0ab0QpPODZTyMkpWkrx5wPJ42ovbfTyPX169rabsjXyMTihV7/UGZJRKDvFQAuzB//vLsaLS3dPEcgQJ3LV7t2F9CYMBf3x5gdjKNKh7W90a3Zw8fJX8yqSyiYfOLs9jJSzbgMEoiSbUIHhhsOLRThDKYR58NU3oDTdIVZLV
 r4i1Ou9e
 YvD5kNAVDocl/ukHxe3NjlbmsSWWFNnJhWv4RHeyOc74rhHiVQMUnoghgI891h+2+QTMWjtDpfXGvGs3OdobKszDDhbdDWHn+XgBM+f1nZnw4AbK4kltgL4LgAu13+mcTPplsRIlUzLw3ve+hy4wnPZ3X5yNxsZIetSGq7wWIJJAzF8YgaTdsy8Xg04aDY4j6RcKS72w+3w5LVvw5uZrYrI2ln7J5cHZSNSifjUShRZrKe279REaAQUxMwaIknrbeFqYnkP3cTgp0SB1XFTYiV+YhLmB9TLq0Z5Woe/HXvcFpB6bMJEqUTJDs6Dl1pmZMbTSTnRBb/wgYhOE6S37J1fkP8Uy/IjPIT5PZAHmdMjeMjyau91/bTEmBvV1LAq7gcVKGrVJg8EQU2lf3Ny4AgW/wcXgfxWdn6l8iC7vTr2rW84WUwQo36WU53+xFg93BPmEUykC31lYgfzbuISX3eFqwIu/t/Fj1zGeVeJ63INgBRJxusQ4MJzKMQmNTaGfhEhHS15UxLPBuMNg=
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index d64c8a228207a..c6492a29ee901 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -115,6 +115,8 @@ struct kvm_random_state {
 extern u32 kvm_random_seed;
 extern struct kvm_random_state kvm_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct kvm_random_state new_kvm_random_state(u32 seed);
 u32 kvm_random_u32(struct kvm_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 2017dd34001f8..e706669596947 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -32,6 +32,8 @@ static void kvm_seed_rng(u32 seed)
 	kvm_rng = new_kvm_random_state(kvm_random_seed);
 }
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -527,6 +529,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		kvm_seed_rng(kvm_random_seed);
 
 	sync_global_to_guest(vm, kvm_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2313,6 +2316,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	srandom(time(0));
 	kvm_seed_rng(random());
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.508.g3f0d502094-goog



