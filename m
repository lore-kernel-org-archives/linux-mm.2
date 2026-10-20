Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD4D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=WuakJbWY
Received: by kanga.kvack.org (Postfix)
	id B186D6B048C; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD706B048A; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949886B048B; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8876B0486
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB229140136
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:09 +0000 (UTC)
X-FDA: 85342730298.04.D43EB49
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id D0DCAC000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WuakJbWY;
	spf=pass (imf22.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494488;
	b=YKOA6Jtg86CvG+UQG6Tu7VgkBXTXBw3BgX/11JlQh2sr0kZK1MIfcGPOn2g606n979uL9A
	tSSFatsYwXAAjwwOyt+eVJYLIM3riRGbIRS+/zWGJCyeBL6j7HRtkYC+CPxb9/l9ZAKXy4
	y6EWxK1bT9PLLi/nZDulAri6suk3Fpw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WuakJbWY;
	spf=pass (imf22.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZVhamrUSjCR8huBFZ4vUL9+JmmauW+0214OfHZAjl4U=;
	b=TiqB956+E07rv2rAcoM6A1QsvEai8uY1ju9w6JfEUeigerT6Lsax+2HNaufy1wUMU4b2S1
	z290VOhz+qV9IOjP30pmq73HLWgSgzuJ4klhyhN0gpLOtJrNeLLqaBluiQWZo/AayoPy8y
	ywF0iiObEmYB7ygiku8Tx5D1ONzCEmc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ZV
	hamrUSjCR8huBFZ4vUL9+JmmauW+0214OfHZAjl4U=; b=WuakJbWYaczrZxPmp/
	MM6Q4d2Jogy9crmRuVCMbCtgWjAdeXWiX7FKmna2O9YfrlMpEv9KTW/W7foLiSVw
	2szh3RZBmHXLEv0xk8I00a0fDarQG1TtTduVMgXS5rgYQD659BDPmJDMPuVQY3CE
	RnHO6QnJad2lEfIz+PiNSwddQ=
Received: from shaos.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDnzI2NS9dqEL_0Aw--.56621S2;
	Tue, 20 Oct 2026 19:07:57 +0800 (CST)
From: shaos <shawnq1@163.com>
To: akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm/ksm: KSM merge drops userfaultfd RWP markers
Date: Tue, 20 Oct 2026 11:07:57 +0000
Message-Id: <20261020110757.960025-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDnzI2NS9dqEL_0Aw--.56621S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4rGF47CF4fZF1xCFWUCFg_yoW5GF1kpF
	Wvvw1agrn0gF1xJan7tFy0g3Wj9wn3G3yUJFn5Jw1ruayDGw1jyFW0ya4Y9F17Zr95C3yF
	yw4jva4DJa95t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U47K3UUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbC0A2GlGrXS41BkgAA3n
X-Stat-Signature: zgqrq6k9t9xjp8xk59ekgi47jfkeryyd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0DCAC000B
X-Rspam-User: 
X-HE-Tag: 1792494486-95573
X-HE-Meta: U2FsdGVkX18G0uZXrr9bs6aNFlFss+WFxAQk5y22kdEk6cYflJS9EUvF/qEMi97oB9S3klH62d855CXfqCMrsnQEzCRMmU0bHT2tJQdqxztNW6aDvSa0Py/cwuZeJ2lEmorjhL3zwoEElmTG6BWwJeaLNpdsN/j5cB1mg5ZsHqVmQUZ8JqZo7CLeTO4/KU74QqPvCCJeM9UJ7cMMyOTBERjipV/LroDIur8dwZIrcQpbuF+c0Ssyn4GIrB1dE/TOMyXRi3fgMMXcEMiZ4Y8+UFI34qCFlcDWEAPN7YGFOd4iY20rQgeaAH7ckJYBOVH6L78lpVa40y5oDWS5kpXNWSQknlZ/ewCBrysH4b7CJe5Ktw5Z2nIx5zhYuhUUqzw+3d/JPz8r3tr0FlMfYjX5Kq4JSR9UUxk5H+DcCjHIVoZxvUSO05+DB2tRSmsfVtRJwoBoDxV0c9dEW1TKEXHai0jkON1NqPW9X/5bEN+zuTgEJNSHhyDg7H7kHEWs8UwY5fh5NY54X9LzqtxW5BiWtQJvXm7+LjTD5atkzJdIJ0tHAxUEyHKMioIuiTBnZwiJ13vsDLBSCS62nv/KvZ4BANS5i0l0JteKszz1C3psW5xYWTEvlCRqFZ0kj85vQK9shF0NcqiRBXTC6ne7r2VioIAQyU28eFn6PrkqCCiODcqYo965OGw0M/TXi+bjKg+3C8M5H6uHUfoWtHoNabjG+Gb+wfovryYR8qJHWH9URePe0WdXekDIboFm46HhMDmKzL29YPOw45+xL0ovOtbOz8J0f1ZVqu63JNjmv5hsjLpCWnNXnMdCpZ4FuS6wTQpqQeWCEPwW19UA11ALbd0s+vViy1qpckKocOuszFeeoeDuifCRQY5h+iYC1JIDWLsJpskNO7JKxfU8ob8levmFxZKIRkNHYEwaPIH7o8hzPUJlKAmu2+thpO2BGLWdHb3cTBCv+AewMN+s0/aIhCg
 j4dOLf4T
 mpeX34UGUj3o1z2wnYfKhjoh5kZ45kTqe+Z9yntYZmEIRdXIjkXOJMiBTTSC8URqHWtxwDyQ5qM4WFwvcd85CAtZPJ39Qc3qMNSTLG98kIZFL9ef2VzZHHWEGFfSWdksFSVfP6/T7UVLKlW/oYOmIP4mj83rZONF1l0ybFNxkZHoaE4jdelcOoK6X0Wzed0ILt2lc6sjIpaGXM29O3b6eMaEsaAMilyxoRqniqI8pLw8nTCIZXR9QXArWoJV9c0/pOMrmTv8i9h2hUB6ix5kgQx1AAoQRRjzAeAjayuOAfYqURIDDpn1mAI/3tsAWaViD0L+J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

KSM can merge anonymous pages in a VMA registered for userfaultfd write-protect (RWP), then replace an armed PTE with an ordinary accessible PTE. The VMA remains registered, but a read of the replaced page completes without the expected UFFD_PAGEFAULT_FLAG_RWP event.

The RWP PTE is represented by PAGE_NONE plus the architecture's _PAGE_UFFD marker. In replace_page(), KSM creates the replacement with mk_pte(kpage, vma->vm_page_prot) and does not preserve that state from orig_pte. The PoC observes pages_sharing increase, reads the replaced page without an event, then re-arms it and receives the RWP event again. A non-merging control keeps the marker and continues to fault.

The same replacement path also loses soft-dirty state; that separate observable is documented at https://gist.github.com/shaos26/9db36768f01eb83c6aa14ee9fc057388. This report focuses on userfaultfd RWP tracking.

HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
source version: Linux 7.3.0-rc7
architecture:   x86-64
compiler:       gcc 11.4.0, GNU ld 2.38
QEMU:           6.2.0

console output: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/e3e39212903e5bd5ba12f55a94ba7ae5b25bb238/console-output.txt
kernel config: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/3cd943ba8c6026b43ef016a37d07efd2533a317a/kernel-config.txt
reproducer: https://gist.githubusercontent.com/shaos26/e887665d7868dc323d73a1d678cacd3d/raw/7fc8685bb0cc01fca488fc096d4859b8b70af3fc/poc.c

Build the kernel from the revision above with the attached config. Build the static PoC with:

    gcc -static -O2 -pthread -Wall -Wextra -o poc poc.c

The program is intended to run as /init in a disposable initramfs and mounts procfs and sysfs itself. Boot it with:

    qemu-system-x86_64 -m 1G -smp 2 -machine q35 -nographic -no-reboot \
        -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
        -append "console=ttyS0 rdinit=/init panic=-1 oops=panic loglevel=6"

Two fresh positive boots reported RESULT=KSM_RWP_MARKER_LOSS_CONFIRMED; the close non-merging control reported RESULT=KSM_CONTROL_TRAPS_PRESERVED. No privilege escalation, memory corruption, or cross-process access is claimed; the defect is loss of the caller's RWP access tracking. I checked the affected code against upstream master f47d223627f8; this source path appears unchanged there, but I have only reproduced the behavior on v7.3-rc7.

Thanks,

shaos


