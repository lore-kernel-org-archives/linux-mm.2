Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22BD606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=abcUOXL+
Received: by kanga.kvack.org (Postfix)
	id D3B406B0488; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7876B0486; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17B36B0486; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8393D6B0488
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:08:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21EEC16012D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:10 +0000 (UTC)
X-FDA: 85342730340.21.A81EA94
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id A57A41C0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:08:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=abcUOXL+;
	spf=pass (imf21.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792494488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ywrnWoxIOGF6M2OKCJynf2tZcjMgeFa7DuGTFYZmyBw=;
	b=DqLZNKgrs3dJl5pVLHk/yT7ewZqDkZcVR1X3h8NBUvgt8VT/aB2TNiIUusxcPDda4WjnBS
	suf+h+dAcSpsEKtJLFpiAjYeE2pq7LKZs9dQkM3q64rxipgs1T3Mauje9f6hfLv/KP6iGF
	hb2Ftxh2hJzGkRL8kG+MFz/CHsy+UOk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=abcUOXL+;
	spf=pass (imf21.hostedemail.com: domain of shawnq1@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=shawnq1@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792494488;
	b=m2v2UQbk/PFqrez5+TnlsqEXAclG69cwR3ZJtkhIDRKmkGkyzXhk4mnb0lWjc6fhsaeuxG
	DUAzIfABwUTm4Y87K0+ws4QBlsD/vFP84b+FkXKXViK6iVczhb216AZIZfsV0azcp08J5E
	vx2YkWexaJ86/CxrlyU7YwPZ6q/H05I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yw
	rnWoxIOGF6M2OKCJynf2tZcjMgeFa7DuGTFYZmyBw=; b=abcUOXL+oEpOIwnJqe
	DgoqpDDVP99Qs+yNkvgQGkNlTDTNFe1tW6J8L4PNpcqiOKv7HhXeGCgt5p2euH2r
	5nQU5wY5FKONfxmmNUx4YgfF6YL+j0EJUVSEAJdUHwOjIO9b0tCN/zuzTi3TA/Lr
	LLwI6D4vhwFQ2XuIZ0vQMqUt4=
Received: from shaos.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3F3yOS9dq_hrHBA--.7622S2;
	Tue, 20 Oct 2026 19:07:58 +0800 (CST)
From: shaos <shawnq1@163.com>
To: akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] mm/ksm: KSM merge clears soft-dirty tracking
Date: Tue, 20 Oct 2026 11:07:58 +0000
Message-Id: <20261020110758.960048-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F3yOS9dq_hrHBA--.7622S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxury5XrWxtr1rtF1rtw48Xrb_yoW5Xry3pa
	yqy3Z0g3Wq9ayDJ393ZF1qva40vwnay3yUJa98Jw1fAFZxKa10yF1rt34Y93WqqrykWayY
	vr4jgFyqqw4v9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U4c_hUUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbC0A6GlGrXS45BowAA3W
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A57A41C0007
X-Stat-Signature: ezwpqrie1rt3jz7m6ehx6o1yi8zzwraq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792494487-543763
X-HE-Meta: U2FsdGVkX1/yrXCRFtrgochWVwVQGeZ7m6ETK1VZd0iLf7BH53LBktNr3xT0dqILV+47rsuKKladQoqWCJ/L6ynsWrIkFhce1kMgLBk2Y+rVIgUxCBGhxRjq/g7B5Ixx4cCX9ZXotmVKdBMCVSusNCC27PceprRRbqfRDS3H/J3L6NNK70ZOqfrjwLS52yXHNPOvlR6M5R3JGZhqfk6zor8XOpuM4TiWOiDe6Ch4ahTpR6GxgyG/wpml03RI2U4UQOe8Aeii7rWS6hXUQ17ejspRwQ+r3/peVvr1zNn+aEMBDQvfuBq5doV1mvCsM//01FeKS4LFc/qDTBh0JCevkwz5EwdCtVdqvUzT4fnqiB/q8yRgSIzlqLdX1e7UrLAFDFDCR/GBNThEGE9XGjiOHDoNWfyBREzn5HDUDJ0kUJKo7RAi39p1ckU8EOZc+0sNa/AutWcgDRkGWmrkCV/jCEUrS1HNvN4/o5mgUNJJsHjxkvB1pQuagSSQWAAWQfag+8UbPUDYOPULrUBl/au0+RoHQwb6H34Vr7c9InBCX1kLT5kEkFpvSswqyJxtNxT1CZgIBrPC/axNurL/jHb4GgP8hMY3TjQTQIFCC934aKF8opHw3VZPP4hlcM8F/L9q55OPNEdp4vvmbdbjopZ2h4IxsTpobCI5k1EmiMc7AVxak/NV6pa4YZ9Ngf3sH9srddR6HyOVWMpWX4s3ZXMSFKSjqyxG7JG0bZWa8j2GPUWZcPnYT6bco3GrR8Cy0TNaWjt9KO9RmMruTI5kplWByZvNamJrS0Fwv+r7u5oJdmtb5Nk3ufXLKh9Vb+HiKTTPcsH3Hbro5Zi+oGK4/1oxItvlxITj+toAKaiFkzirNyOqJZeT9v+ehMeHw28KwkLSEypa0OI5LS7s+99lpimtBhxow/wUc45jH3LouNncTEdJnwVB4O4LCyd9cDsGPC1Eg4CK6MGFKeTiSExkATI
 B05yPDsI
 Y8hhQCDA7uAGSqShYhBvFTYazjsWD3+f2tUXE6yBxCyf9VdDtsLTveAVdkM7A6YOfODWP0psWQbuKCvUwT4tz5BIY1ynK9983uHq5cqreo7UL0sX6jMBedJez2idr7N2vhfdEFX1Fo9lHrhkB2k6bFXlufkNMaVuznlTZpiC6ENm3TV3qA2cpqZP584PyifKTXSyWWzqQxKuH1/he9BGENN89gP+4kW8n8fO9sSmzSCrTnjVy4rr4X7s43KnSbD2GziLvfzC4CngBwT/SZ3JTcWgm/xBwpbB1I4+Yovsx25pKBf0LS5HFCFZxRsCMgIj/Pqdq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

KSM can clear the soft-dirty state of a page when it replaces a PTE with a shared KSM page. After clearing soft-dirty state through /proc/self/clear_refs and writing to two identical MADV_MERGEABLE pages, both pagemap entries show bit 55 set. Once KSM merges them and their PFNs become equal, one entry has bit 55 cleared even though that mapping was written since the last clear_refs operation.

replace_page() builds the new PTE with mk_pte(kpage, vma->vm_page_prot) and does not preserve pte_soft_dirty(orig_pte). The marker loss can make userspace dirty-page trackers miss a page modified since their last checkpoint. The PoC makes both pages dirty before merging, so the result does not depend on which page KSM keeps as the stable page.

The same replacement path also loses userfaultfd RWP markers; that separate observable is documented at https://gist.github.com/shaos26/e887665d7868dc323d73a1d678cacd3d. This report focuses on soft-dirty tracking.

HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
source version: Linux 7.3.0-rc7
architecture:   x86-64
compiler:       gcc 11.4.0, GNU ld 2.38
QEMU:           6.2.0

console output: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/59077135f035791493d6d487c9e619c16380518f/console-output.txt
kernel config: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/baa5ee61ce748667104c480560ab5116a100e3fd/kernel-config.txt
reproducer: https://gist.githubusercontent.com/shaos26/9db36768f01eb83c6aa14ee9fc057388/raw/06005564982eab5cbcec26c5d62ad86c7261a155/poc.c

Build the kernel from the revision above with the attached config. Build the static PoC with:

    gcc -static -O2 -Wall -Wextra -Werror -o poc poc.c

Place it at /init in an initramfs and boot a fresh QEMU guest:

    timeout 300 qemu-system-x86_64 -machine pc -cpu max -smp 1 -m 2048 \
        -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
        -append "console=ttyS0,115200 rdinit=/init panic=-1 oops=panic loglevel=7 vivid.n_devs=1 dummy_hcd.num=1 netrom.nr_ndevs=1 rose.rose_ndevs=1 max_loop=1 comedi.comedi_num_legacy_minors=0" \
        -display none -serial stdio -monitor none -no-reboot

Two positive boots reported RESULT=KSM_SOFTDIRTY_LOSS_CONFIRMED with equal PFNs and one soft-dirty bit cleared. The non-merging control kept distinct PFNs and both bits set. No privilege escalation or memory corruption is claimed. The affected KSM replacement logic appears unchanged in upstream master f47d223627f8; runtime validation was on v7.3-rc7.

Thanks,

shaos


