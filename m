Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2B4CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF0D6B0088; Mon, 12 Oct 2026 16:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468676B008A; Mon, 12 Oct 2026 16:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356986B008C; Mon, 12 Oct 2026 16:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 075DE6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:15:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19FDAA0C8C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:15:33 +0000 (UTC)
X-FDA: 85315079346.02.A5B1E7F
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7CF8440002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:15:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="f7fN/SJa";
	spf=pass (imf07.hostedemail.com: domain of cenzhang@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=cenzhang@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791836131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/Jjp0/gGGD1R8hah3x3vcyoIOYd0SLonWaZGlFpBVzw=;
	b=uPqVBJXemMVb96SCDUlEhdPGW7oJGgJGELBIT93nJ6gKY0yB/xSZ/kp1KxpHNGx2I0r3JY
	+FBt/YLrI9WDbPK8KS8cp3DR6eYCIivlbAXPcu/Xc+jpLKAr07OYLx6lL9nD9d8POqTI1F
	6o/9PLxfx03xQQNqomuyXPdiSt/JIO8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b="f7fN/SJa";
	spf=pass (imf07.hostedemail.com: domain of cenzhang@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=cenzhang@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791836131;
	b=XBsZ9DUdMAGupB80toN0RDQP2QxoFrJuep0Zd3lWU+LTUQwW7MZqwkzfK8o+gofCrrWXVI
	QqI+TDQaos++Hm6tK/PprX24HvTM961LTu1dbexrQHglSrq3OhAPykt9a4UxHVzh/gbFlp
	/p42oakYiE50bmyMqa3RfPW0Pr3Z78w=
Received: from mac.lan (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id BC0FD20B7166;
	Mon, 12 Oct 2026 13:15:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BC0FD20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1791836126;
	bh=/Jjp0/gGGD1R8hah3x3vcyoIOYd0SLonWaZGlFpBVzw=;
	h=From:To:Cc:Subject:Date:From;
	b=f7fN/SJaeBrD6ryMhc1A8CdHsRQsj5TeJyVJCm/h/gqumLVE1HBcJI++s6ocOTDZ9
	 GDr24FY9OxuSCX3Fmzs70Bx4moJopzZ/A5DB7wSmWDFBtXlLgWMI3Yu5b7GSJRWdnt
	 If10IRPgNtDftDcQcVphI1sj3VPP9Y6dmHfRyIXA=
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	Cen Zhang <cenzhang@linux.microsoft.com>
Subject: [PATCH] userfaultfd: fix UFFDIO_MOVE livelock on large folio with extra references
Date: Mon, 12 Oct 2026 16:15:14 -0400
Message-ID: <20261012201514.97015-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7CF8440002
X-Rspam-User: 
X-Stat-Signature: 74sj3415zy8zmb753njft5ct3znx4z3r
X-HE-Tag: 1791836131-112787
X-HE-Meta: U2FsdGVkX1+jy4BhufVmA7klFeXnhoXl+frBDQ8fZGqkoGIUyoS64mAP1vZzcb9nwvHG5Jn+QnojNIHKtWyjkLNspwIQ+ddBCUh2hMihlcRVEdV1jxdJIfY3hXZcg37Y4DWXQ0TsIeLop7n8vg0jQ36CYmWtJG1vqkvMeGdTZq2qwiUBonA7hrRXDnLDHrLJ1rEQSWpKyYSebNNdc/XATZ9akIx+XX3NaOFQwtmVqrWqY96JNbL0JhgN3Udcr1NZDyX6BEOA6bB2qzyv0LTk3w10Ymg/jJQrAI27Y5lQ0kBtCE0zuSeqtcq2HU4cmafsJVG4ob6fgbtcu+FnRBznD3RLIfY/vGVWIlkxAMbBYF+ss632lNN+GeVJTuHihFf5x5QK+yFo0wATVPFwfUpzt7/cZW841h2TVDMNHNJ/tBeeCwmsUplwD+206i5S0rF8rXaD9NooPjJSR4nS0TnK/VoR0+BjpnRD8xBLr7ji8VMWQQCkAUd5TL4stRcsEJ9hidQ7CFipdJsF0NcLu2e3dK8No7uNDvpvBgVfVGvFKZfabJvgLADPtxaRINiOPbsjBVvldct87xCqKouyObTguLjcbpIqaw/vm0sOz6rFtR+/RclmvZ4jf+rUv+QM0XHLO6aEfXPR9T4ZXMnFwTQIklrh/YDvCQPCYSt5KC9dfOvQS9btzxyrqM3ZNjllXIaoHWEa+hvX3rqr7uuMlUZaodlhZ+0YkbgXLk0SKDX7O/7fBAzFIsL1w7iK9cVmKhPRvLCfecZniT7+nHj0mkWGWUrtgzeHDfJ0rMpETCgSjyiIV1Tr2Zrfr7Ke5WFutnvnlQ7Sw040UbxAcK+wHFs7QdYQYvTqHAz11kJ9u5rZ2uYEGyzZawToQa89Crw4vEDc4v7utrOKQ9cS+/LVaM6f0+WfpZ0rOCoUJhBOFlYwJ+EViD5HUtgH1/fB3UR+dUov9MBU0eXE1zCUYsZZCbi
 sXrzos/3
 xTCTtIMrOw116KG3e9Uzyl3DJeYUxIy6yidPEMPIDp5qvQKyLFSAav3Sm91aBMgO+pro35BCV1GjVifzUx+KCJAyI0WLVQ64J4i9fL6a5z/jEbk7lBBA4UtD7Dqn5DOvzpTdbtoeRwMNIIoEaRarrbAE02In52R9afurz/toIj+hdyuC8HcysdOF76UEb+2uvVGx0DcC4zG2pUNc/Q1FP3FFOmuZ1AeUPky0WvjuAXnR2eDeHT5o487wa8ncIwbXKbGgAWVgTSlmjAdrU92kMD9PufOKPQ93RNaImnlFqJhwl8vLm+M5/q3IiUZrOwWFnKjSb7/UCHET+5weEq/hNlLieaG0zFmgb7PCVBThlBzZwNPr6YBJcbmyT9mxZmuklMlrVqtwUi/IDGrPCIJoYObbTLAR1sbqW+1k6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To move one page out of a large folio, move_pages_ptes() first has to
split the folio.  __folio_split() refuses if the folio has any
reference beyond its page table mappings and the caller's own, and it
reports the refusal as -EAGAIN.  move_pages() treats returned -EAGAIN
as a transient race and keeps retrying the same address, holding the VMA
read locks the whole time.  This is incorrect since in some cases
userspace can hold such a reference indefinitely, such as by
registering the page as an io_uring buffer.

An unprivileged user can trigger this with three threads: first holds
such a reference on a page of a THP, second calls UFFDIO_MOVE on another
page of the same THP and spins in the kernel forever holding the VMA
read locks, and third calls fork() or mprotect(), which takes mmap_lock
for writing and then waits forever for those read locks.  From then on
every mmap_lock user of that mm hangs, including other processes
inspecting it through /proc/<pid>/, until the process is SIGKILLed.
The hung task detector reports the blocked tasks (third one), and with
kernel.hung_task_panic=1 the machine panics:

  INFO: task wedge:95 blocked for more than 122 seconds.
  task:wedge  state:D stack:12528 pid:95 tgid:95 ppid:94
  Call Trace:
   __schedule+0x596/0x1110
   schedule+0x36/0xf0
   __vma_start_exclude_readers+0x100/0x170
   __vma_start_write+0x51/0xd0
   __split_vma+0x208/0x3d0
   vma_modify+0x6a8/0x840
   vma_modify_flags+0xce/0x110
   mprotect_fixup+0xbe/0x480
   do_mprotect_pkey+0x2d9/0x580
   __x64_sys_mprotect+0x1a/0x30

Fix by returning -EBUSY instead of -EAGAIN in move_pages_ptes(), the
caller of split_folio(), when the split fails. Thus, move_pages()
does not retry -EBUSY and the ioctl drops its locks and returns to
userspace instead of spinning.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Reported-by: AutonomousCodeSecurity@microsoft.com
Assisted-by: LLM
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
---
 mm/userfaultfd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50..500962be1162 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1663,8 +1663,12 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			pte_unmap(dst_pte);
 			src_pte = dst_pte = NULL;
 			ret = split_folio(src_folio);
-			if (ret)
+			if (ret) {
+				/* do not retry, extra refs may be held forever */
+				if (ret == -EAGAIN)
+					ret = -EBUSY;
 				goto out;
+			}
 			/* have to reacquire the folio after it got split */
 			folio_unlock(src_folio);
 			folio_put(src_folio);
-- 
2.55.0


