Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAD6EF99EA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 00:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2376A6B0005; Fri, 13 Feb 2026 19:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4F76B0088; Fri, 13 Feb 2026 19:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7006B008A; Fri, 13 Feb 2026 19:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF0346B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 19:15:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB4041406AF
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:15:49 +0000 (UTC)
X-FDA: 84441144018.15.C353A36
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 04BA840010
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:15:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NeRiv9h7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771028148; a=rsa-sha256;
	cv=none;
	b=Nbbskqq1OuhSTTL1SrkqXz38SyUBqIxfnZEk9S7foooYhcGCerWQqoXYhQFBLUZGGogKjW
	msyawgGFZt26K/8cFJu7fm8cjcQqy0xYQgUdrOPyk8DOmAPpCZDAUc3tRnYW1GX3nZmwq8
	ufpSxla6uCShIEQWb7yZdRLZBI8nR5o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NeRiv9h7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771028148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oJSrOsjXaV/MjMNYMY7kpWcAneJSnkLcnWKVI0es/80=;
	b=uLso1c8dOUOWSaTt/GvWyCbHJ78EAmc8ezkTFlnh81BTyNsuf4ZliCGGsCbQtONs66cd+d
	OxJCZJWrunCxWCc5lFI43uL+CDYsFnJqK1DgZnOaE9B71o4DtpKqUHJquLG7JvCmwWc7EE
	Lo0kxCr0JQyHCeNA2cTx81Pd6A8TSXo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8230f8f27cfso825955b3a.0
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771028147; x=1771632947; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oJSrOsjXaV/MjMNYMY7kpWcAneJSnkLcnWKVI0es/80=;
        b=NeRiv9h7d7EEeOYgzKFsiMsgIFO48g3NjAgxK5eLmvDa/X3EWl7J/15mrujnfT1QaZ
         cwoG1rIEqMDcZQEZFNrYIbWCENA7tUvAGPjEgl1gt6G4NlDMeiyGZBLzxPaFc0pqlFOg
         SiVvyQkfB8Iwxwc5IjcZEVgM7/4QZ49llfygBTFPY6kQkBfbcr7xwavAMC8wECIdkNg4
         u4thGCGjYV6WQ7Z9g+r1nLAewm9hyA2gSISLPyMMXY8fT67HQ1sqYKoBF2zLUh65LPnd
         isxhSJmC1tijJY9aaJZlqNuUg5zoZIv/xM2xMAc2ojXh7LYFkzTKMxCK0gX0TAC0LZWW
         7t8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771028147; x=1771632947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJSrOsjXaV/MjMNYMY7kpWcAneJSnkLcnWKVI0es/80=;
        b=nQY1xcwezrTmz87OaxnNx84MQPteR2i/pHT6StXJJSA9kJET8A3JhbD58UpbtgyWYK
         HdP/29QZs6XR5diCJLpMmtPDQQLE8ceH4n41Ur69k5lbPCeptbJjM4hTjO3K6n+kPdo+
         G7oUTvcmgTkl3oPsWY9hF84m3GXfo2S5eiUrR37vPFE3m0kdvRjIdGrdzDqEosXttrBu
         9RzgXsKrXauwRSpdebJwMxdZCyVpmdAZPd7NMvtSTPYTuvNq22mi2Q4xjwunB3h+qxtJ
         UDHomvgH1ynYM51QeYXfDI9lWx6qD8M1+SCHNI94c43bvHxWpox5CMBXPWGIcED0FstH
         O5dg==
X-Gm-Message-State: AOJu0YzNMvPOXsnkg4klwpravUG9RiH7J2mDZ+0z0hl7RQB2up2DNHWR
	mE/n7lA5lerx4Rj86Y8qJjWX1nCboh+xLlhKHoa01wP5Xf7q0zsiwRa1gCfoJw==
X-Gm-Gg: AZuq6aKSYXeORPEpD6+66GEHk9aRUkaamKdiH41qidTEm4k47LHBieGu6bA8MI1QuRj
	JkzMdeD8X4uzoc5iXVEJmd8j+rkH54qhZnBw1cO7NdM74w6q9aAPv34zIB6jVvVB9t1V4FNRzPY
	F6CFAqrtZvZASYpMNTiyLIgKWaBlmpcUKkA98qUGolcFDpS8stDbQSyYroS6yQVvhAWepLRd0cF
	BapGG+v5yA0jKgjZSTXlwobDVasMIUuSp7+UMAE9prXdl2KXZHVfHkTUDBN9hXzVRzjw49YBoW8
	1jHIFbZxTCaIv1VLzwrlgJUNUqNIH1qof9+c4Uzs5HHuZFuV8v/2D+d+FzScBcYDuB3Jv3uh8oZ
	hBsXh2JMUXAPSJvO7LPV7W5eHOME/b0eEFEUFb+JcZgeduf4dy7MyTdMeJ03OZdjtNPLYrG0Yf1
	An53S1m2IJotCq8DAfvHEh4G22n8tExnboyeE8PsTHasgbP5aXDgiDYliR+7QwoCVyHZwrpd1Pw
	7SS61kVhvX2dnlK
X-Received: by 2002:a05:6300:408d:b0:38d:ec2d:80e5 with SMTP id adf61e73a8af0-3946c9220ddmr3409951637.45.1771028146749;
        Fri, 13 Feb 2026 16:15:46 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:1ca3:229:a9f4:8c87])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e52fcfc08sm217762a12.1.2026.02.13.16.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 16:15:45 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	i@maskray.me,
	shy828301@gmail.com,
	ackerleytng@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH v2] mm: thp: deny THP for files on anonymous inodes
Date: Sat, 14 Feb 2026 05:45:35 +0530
Message-ID: <20260214001535.435626-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04BA840010
X-Stat-Signature: 1w8gfdnq14nmqnh7arwo3dhayrfphsee
X-HE-Tag: 1771028147-879537
X-HE-Meta: U2FsdGVkX1+rd1Hqgw/N/NaVaskZYY+8+wV9p/8V4V3Jfgj+wyFoA1OAKspQO4cms6jGCSG/Hz7z/OdWgCajlweXuwSyaOZNe2NWe2P3ZDbc+msY8A6M0TtCEgsCPsal/3doYzYFnL3adRWuLBdgI4MVnLQVwCDIDEASpWfvrSmwfPyW4FtnkEtBKE5B3B9Z0wylLRzYvAZjHXz0nCRBXUFIQgXI+TusmDekxUjLPlKjRqZMYNyYPtCP9cnbt5eZanQzjezMqv5qbr4YTPnrAiH3Bs6VbK6KXxlcXiclgwQgbdAmNun1Y2OKZ13Gyj46PVzWgOUlFhONu02jidVn+YiDcnbQon6Fx9WJ0ABTgzXpSZ/uGER7jaMgcwtEZ5VSf6vtq6myR6eU+YqmBGMmOtig3aGF5moAlXWCO6wKZFzmuKLbqxmNepv1PNM6pdQW/KxrB6zulvLYZMJPI2YQ6auui5zMVp55RWUENQ/t3v3Anb1LeIdHQljRjonm/2tqRcEJzX9SxH06OJwGUmo4KwTmYkckz2f6eD9ALDNMrTvMHJ6o41utYVC85WYdmORvFtI7btDQM4Tgi4Axz9QC4AU1MusL/lCpFgh3KNTrD+H9OlTNlGT6uGbTnocQ8FuiquADfcC2xiPbl2cOENA6UV+DyJ3x8ZWdHN3x29fDitb2TmR9floksL4U3t3IMcEk9TOv091WvB/6cwWlw28GWoLBmd/kobJcL7IHGpBRtVstBzs3px9DnL/mRQ3I6nT3WoNR+8VLuSkQaMwmy56YPdkxYkqxHzNJgEt3kQ/PGzwF6RAYi5qaSneR8aKjj5Bk/gjoEUslsFb5SpfcY3UXHAOFSv3BXxQfuERMLUz5bvDJozEt3wJ/h1858fNdUeIicTc42xXlxjQqJGeRoeWfwMLkNSeBFcUUBYPj1o2AbQ02u1t4UZL/aw17kgnN1jxcHK2+E5Q6ndXykSz33pM
 oce1IXDf
 RO3BmEMaEgNDWyBtPG0qlnP/psH2pdBamSj2VumPiYydw3WBS3YSf+x1b41TtTgmn9s05e6OSE3QIfoWXrtEPV6J4u+LbCEvAQC3I30Oe3OwzDsiltCLQDH1Vf0i76YrxCidizRZcuWoo7DKBi4Q1AD4uXhkxeRiu2+vJOpEJbD5+WL8BC4M6yUwiC4BNAanvEaNGACkC1rJFvPq9DYB8ZfIXNXmyRHpyfzeq2DrV36PVWJyFkyvfar/L10tK8LJu2fOMovb6aIb+lAnSfBkhsUwLa9wfSrMMPh6qHZIuKyG3iB4ZiSH05dk7YFKfYFfB2TPx2MHXmn7eB38e8IJ9LT5kACrh1ZhjNB2FY2CRnZuP7/T9e6rl5rh8/IgaUQB0VW8zM1xHtMO6wTC0MhWX6KT9D0GzX721W4F9d5OYG3dg9GZ+TEpV+WzwdEiA8gOfF/olmsgOCZRuMPLguaK7q5GU59rQcyV3M59uEuO0I2BOGVDdC75WlRmbDgETM+Fb1mS+mTTS6/6PEKjAKaO8rch8a4h0xYS4VYJpE+0mTxxaDGSJMHM2EBt/x+7gPSqPMNMrPaEjGgtreq5RVGysMl4D8lRqduCZSD5d2urluASKo3/RqsleASKvIHsuijZTneEFcrOo5AXHQRpbB0+DPyD+wF0f9vuQ4atcmhEaUSoKnj9bkXTqT83F2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file_thp_enabled() incorrectly allows THP for files on anonymous inodes
(e.g. guest_memfd and secretmem). These files are created via
alloc_file_pseudo(), which does not call get_write_access() and leaves
inode->i_writecount at 0. Combined with S_ISREG(inode->i_mode) being
true, they appear as read-only regular files when
CONFIG_READ_ONLY_THP_FOR_FS is enabled, making them eligible for THP
collapse.

Anonymous inodes can never pass the inode_is_open_for_write() check
since their i_writecount is never incremented through the normal VFS
open path. The right thing to do is to exclude them from THP eligibility
altogether, since CONFIG_READ_ONLY_THP_FOR_FS was designed for real
filesystem files (e.g. shared libraries), not for pseudo-filesystem
inodes.

For guest_memfd, this allows khugepaged and MADV_COLLAPSE to create
large folios in the page cache via the collapse path, but the
guest_memfd fault handler does not support large folios. This triggers
WARN_ON_ONCE(folio_test_large(folio)) in kvm_gmem_fault_user_mapping().

For secretmem, collapse_file() tries to copy page contents through the
direct map, but secretmem pages are removed from the direct map. This
can result in a kernel crash:

    BUG: unable to handle page fault for address: ffff88810284d000
    RIP: 0010:memcpy_orig+0x16/0x130
    Call Trace:
     collapse_file
     hpage_collapse_scan_file
     madvise_collapse

Secretmem is not affected by the crash on upstream as the memory failure
recovery handles the failed copy gracefully, but it still triggers
confusing false memory failure reports:

    Memory failure: 0x106d96f: recovery action for clean unevictable
    LRU page: Recovered

Check IS_ANON_FILE(inode) in file_thp_enabled() to deny THP for all
anonymous inode files.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Link: https://lore.kernel.org/linux-mm/CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com
Reported-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Fixes: 7fbb5e188248 ("mm: remove VM_EXEC requirement for THP eligibility")
Tested-by: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
v2:
  - Use IS_ANON_FILE(inode) to deny THP for all anonymous inode files
    instead of checking for specific subsystems (David Hildenbrand)
  - Updated Fixes tag to 7fbb5e188248 which removed the VM_EXEC
    requirement that accidentally protected secretmem
  - Expanded commit message with implications for both guest_memfd
    and secretmem
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..d3beddd8cc30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -94,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 
 	inode = file_inode(vma->vm_file);
 
+	if (IS_ANON_FILE(inode))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.43.0


