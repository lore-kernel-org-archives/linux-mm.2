Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1050AC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2436F6B00E4; Wed,  2 Sep 2026 15:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B986B00E6; Wed,  2 Sep 2026 15:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2ED6B00E7; Wed,  2 Sep 2026 15:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB9306B00E4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CCA4C038C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:13 +0000 (UTC)
X-FDA: 85169855946.28.A700BCF
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8F4A2180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fqupuf08;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jK2MmrU5PHerjBBjkrNgI0UI4L0yhiHtWM989h7yfSE=;
	b=3XQPNxmKZkGoPP5g+BO6SfB9TzbBDGKPVBWc8di+eYSwu2Pr12sp/19HX2OxY7bE56tAYu
	qCc9oujTU2eo7sKa55HphV/AgLE/7JFR5AG+WQ+ff3MxjjUfexiLbRA5TNRhTOFHD34+F1
	/NQRrMXTEvgEI+jfY6LdvDfabHG+MxQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fqupuf08;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378431;
	b=CQHuFucx+/7Cd5OL5SFzdJxXJYeCcJvc0nFpU/0427lzTuCedovxgUsiOkRkBE4dFQ2e6d
	t8Jis70IlcNvbcezQ5JFDeOo1WdAMlR34jE47eBg5IBpfurbcWmOH6woXaRJSK4vwnGHtc
	5aB/IOOBO5wUCNgdjG2uBlvtAz9g4p4=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-910317dc2e9so6360546d6.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378431; x=1788983231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jK2MmrU5PHerjBBjkrNgI0UI4L0yhiHtWM989h7yfSE=;
        b=Fqupuf08ZWNVRlnvwaO1uR08iTp+hHrds1sufzW/7SJMs555wV3T2IXzt1EMOuawi2
         E7hX7ihC4o3BciGd/EauWrtt9BXnG56Ni5urh+6RuKS1ZNVIpZEnosAyPIUa2LYFur58
         4t5tdfMp8RtPK7c9s+lEzIqDOc7oc4YLoCIUIRZTJLFIShO7tpxhlRQIH1E9VKH9vXv9
         4YM9FN4ABGruRGhS5qIpzPXnwhF/BvRuFu/SVC2r55S5DxhidgjdPE0650WPPt3aL8HN
         UOsHKuuMsLte5pqmbsmYB5Nln2VwXQBtrxMkwxjyFjFEqDRBX4jLWKnB3IyudQKcBn+H
         c6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378431; x=1788983231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jK2MmrU5PHerjBBjkrNgI0UI4L0yhiHtWM989h7yfSE=;
        b=ju+QMvjMZZ5n3+FUU8LPQ2lQ2lVJox9nm451TEJvSSYhXiw+BwnCJ0lt5II1xV5PCd
         7mC8FOhRqcgoQv0vIKdOSCaJwshAmqiRvdivkPpNsd0gP252T9YeZjXSrDWo+0JMT019
         lX+pD3eH8MmJLMtIAC13M9p+D4oEY99rEf+tJqGmVO/G9zHTO0uFWrHAsKCvY8e4Dm/t
         G+oRL2klIs2Yoq5u0VuloGuRe1s6g9CR1ZkuPU7y1NaS40YRY4d33Y2uqdyqdJNL0KnS
         t/9O2bPcOiSuXKJvr4FfTiofJgTlWvnwN7U8adIE9EKaw0i7ADytatVAIn0HnJaOXGRk
         BX3w==
X-Gm-Message-State: AFuF++npI8nVJAJCiaSabnkia4IJp7S84Fa3CebzlvRpd9t0/eS0Ff4A
	dcW401AZm1N6NXRuT8f/ddixTWqLlnT7sVCbE1ZmreKqhBqIQEbKEPDbsPfqS6wEeoMk8TIPS5j
	6k5pZd8o=
X-Gm-Gg: AYBFou2+4EmuKfz+lCODiZrTEKsgd5brJl0HHHEE08ycGv8BnmwmCbC3n440ibYbAfR
	IcBPpqulgHaw33SHe1QC+XmETXzL4Jxfem6A0sN/b7ag2iJzVAbB8xhVtDWw8A13iFZZtNtNcVK
	CQuvlhsnDP6V4eBZjmMUDt9+2kgH0tzke/02+xR+mdiKraiujzwy4+Jjh15VKqknEwxghj0hXPq
	3oqAsNFU/WUIdz6A19MmUqPNG47a3swuR9KOQ8woGd1ED8KICBDkGospstHWB5y9iLrsQug6Aiu
	ymZ/QgWUaDtbW+K7Ysz1ODSZEX1nY/lCMp3f59PezQrvGATKPXr4brcbmgrjUngKIXiqD+V+1Jx
	lGKNeD0/e5JxlnJZriA3v+PxBVJ1tCZF4+bctHn1cWVgeeAwHz9lCkFTsgMKXWUCkzGEhHXzFEr
	L5vU8hRp7jKeDy02xg5lYopKdLtAj6cMMri3zBNIxLPRAHp0mUAjGhzWBmSBNHNP6fi76gksxNs
	6EEGjPUxB9qh9kM8VYDzFtsPYerYWym7/u5uvycVXJMc/Ig7Ith/DOhBsKj
X-Received: by 2002:a05:620a:3192:b0:936:ea3d:9313 with SMTP id af79cd13be357-9396ef7c45bmr114112385a.20.1788378426620;
        Wed, 02 Sep 2026 12:47:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:47:06 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org
Subject: [PATCH 4/5] selftests: KVM: guest_memfd: let the gmem_test() harness bind a node
Date: Wed,  2 Sep 2026 15:46:56 -0400
Message-ID: <20260902194657.79075-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i1kpqqr7scfz79snhu7m3ef1ajcktn8g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8F4A2180003
X-Rspam-User: 
X-HE-Tag: 1788378431-419233
X-HE-Meta: U2FsdGVkX18pX7fPud8dvgBnfi1SZaY+Xikl9xWem7K4gKCcjiBHcHYtRsmE3OTwhHPihB5QDyDgkV6wDoj82f19mR86p+AW6FznJaayMTGpdu4ALE6j5NLr2C7Cwe4VBxf8woivJ9MwvWwEbXtR/2YV4Lb7Yax6KPYckN+6Iftw1I6B6QYcU9Lcwmp0oLChi40RGZFQO0fleKQdVtgeiOaR89n3nvA4JFen+oq598bx750EccHfZ4Ou4l1/guPyMtehUKRNnE+AinJArTf7oeaU26aYBW1FQIpp3NeAeiL9wc68XKOPxkjHEHHGi5MlqbQVMbuVdCldgY4QSkfD4ngsMsRKG5UKT11pNEnFSNlN15C/3VR/boj4T7ntb0DiZIfAtrhGYs0U/N/JXG9AkRRxWn3NTS1oietRyrwzoEIwCpcgx1MS4QsaZcviZS94QHSWZhRBrzaGY2ukxErjfZMITQpA7mo0WdrDZgZM5ylgmBzokrHFG/8uXOOL/hAOMJ5ssatQdITz6DkGrif1ae114DnhDUcx6VZaBXGsEqxLPOmFXa+uzA5qFEktNN+KrdhSVIJK1LRBuUc5pToEHtVMIVPSKSH48OPbEXyTLoZb3wiJlIMfoUiyjBEkvLYWINdptt3c8L/MjrGidruzSfI7Inov3Z6MlenSMsOTidW3RzAkW0sHKTbtlbecmetLUPKw7x6NuPFd7L9/dxJx7FA9kLp46pUvNtMx3sdTyuKsk7kjfAU0zv/dHK8M1Pv2eyGGAn9cwRUo9wGnvAp5AQw/pO9fyGJjmijWLi4DWV1RqwY4DAcV+CpD6iSYqWrdgh4JxO5cgDPyj2mEUHX9089qAjpLDaFgBP2i/pXSBjAESlrlAfzKl1LyUj1p+IW1bmkcfVn74l/B4Eu5iVuLPe3prJr9TkP44MwdAOQNVfUqeEgRn/ln4/CpE/FfLckOFUL8tloRqA8iS039zA+
 ZXVxJKpm
 AR0JeI0DywKbYp1O/TmYdGFXu9COLXv9LMuVsARyRyE92E4WnZf2AZuWoSS/axSEAeNCFgDing+Ke+ECtw04bzRuamV0ckCzkZ9N/okLMs5Pe5cpQNc6AqOEsoMHa9+HWxwfyEjQ6SN/ARxy3JqWAHkn1WtsouKrTG77eNV5KOl+LKpr3D7Q8nVlE3rgyxEYOvzQ3CR9oakQhezoMn7fayp1dBNRbwq0GJz0mEYalZ4n6/J1bTpw4zJbc8QasF5rGwp8w9jwdGCMURi281Lgo0yhowzltW7+fKVX4/PExX2mDJoh5ApSEczVvA/DW/gwgPjmbPG8GzNierT0ix21Yfd5CUjDyq8f/EhkeMjfGHvQF/rNs6VIrGc9m9Mxw0jVxRVgq7p0jTj9OtODx+4yHMo8D1nl+BcR2MZr6bzBC4pOA83k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To test GUEST_MEMFD_FLAG_BIND_NODE - extend create_guest_memfd() to
accept a node.

Ignore the node argument if the BIND_NODE flag is not provided.

Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-5
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 50 ++++++++++++++++---
 1 file changed, 42 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f4..1818e0fea5690 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -25,6 +25,31 @@
 
 static size_t page_size;
 
+static int __create_guest_memfd_node(struct kvm_vm *vm, u64 size, u64 flags,
+				     u32 node, u32 pad)
+{
+	struct kvm_create_guest_memfd guest_memfd = {
+		.size = size,
+		.flags = flags,
+		.node = node,
+		.pad = pad,
+	};
+
+	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
+}
+
+static int create_guest_memfd(struct kvm_vm *vm, u64 size, u64 flags, u32 node)
+{
+	int fd;
+
+	if (!(flags & GUEST_MEMFD_FLAG_BIND_NODE))
+		return vm_create_guest_memfd(vm, size, flags);
+
+	fd = __create_guest_memfd_node(vm, size, flags, node, 0);
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
+	return fd;
+}
+
 static void test_file_read_write(int fd, size_t total_size)
 {
 	char buf[64];
@@ -418,26 +443,35 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
-#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
-do {									\
-	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
-									\
-	test_##__test(args);						\
-	close(fd);							\
+#define ____gmem_test(__test, __vm, __flags, __gmem_size, __node, args...) \
+do {									   \
+	int fd = create_guest_memfd(__vm, __gmem_size, __flags, __node);   \
+									   \
+	test_##__test(args);						   \
+	close(fd);							   \
 } while (0)
 
 #define __gmem_test(__test, __vm, __flags, __gmem_size)			\
-	____gmem_test(__test, __vm, __flags, __gmem_size, fd, __gmem_size)
+	____gmem_test(__test, __vm, __flags, __gmem_size, 0, fd, __gmem_size)
 
 #define gmem_test(__test, __vm, __flags)				\
 	__gmem_test(__test, __vm, __flags, page_size * 4)
 
 #define __gmem_test_vm(__test, __vm, __flags, __gmem_size)		\
-	____gmem_test(__test, __vm, __flags, __gmem_size, __vm, fd, __gmem_size)
+	____gmem_test(__test, __vm, __flags, __gmem_size, 0,		\
+		      __vm, fd, __gmem_size)
 
 #define gmem_test_vm(__test, __vm, __flags)				\
 	__gmem_test_vm(__test, __vm, __flags, page_size * 4)
 
+#define __gmem_test_node(__test, __vm, __flags, __gmem_size, __node)	\
+	____gmem_test(__test, __vm,					\
+		      (__flags) | GUEST_MEMFD_FLAG_BIND_NODE,		\
+		      __gmem_size, __node, fd, __gmem_size, __node)
+
+#define gmem_test_node(__test, __vm, __flags, __node)			\
+	__gmem_test_node(__test, __vm, __flags, page_size * 4, __node)
+
 static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 {
 	test_create_guest_memfd_multiple(vm);
-- 
2.53.0-Meta


