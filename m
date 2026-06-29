Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F04AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE766B0005; Sun, 28 Jun 2026 23:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E366B0088; Sun, 28 Jun 2026 23:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F3C6B008A; Sun, 28 Jun 2026 23:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E23626B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:35:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 667F2C28A8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:35:35 +0000 (UTC)
X-FDA: 84931535430.28.AC3DF49
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9C3F9180009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:35:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bNQ6ZeP/";
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782704133;
	b=n+I4JegpHB+yOUsL4AGbolTJ91dcypAyxXc04ePwi0FnIIEzEVaAWZK18Byv1zCpmc5dwQ
	gO8SXcjmfV0qi/RiF6OS2u1UiOUhHTspy4bqyYlGd5dFRMYByfYWOvlAaMCQDgFvTrYng/
	5AXi1DoB/jh47/mCOW2YOlvhc6GnlxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782704133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtmqN5vqMmf40dd+iSQc5lwp4GlOGai4yHRqtQ0Gjt0=;
	b=GIjsbBT8OllMmj+nfcBPbvcjXepaWNlCSTi5/vcgtLXRiR833668jAblbGOcyzL4LQuogW
	QLYo2jCcqtvHnanJKVjSQiReCfGntIHudilQKJB5N4PVwc8eUTFaHAfsE2JKz1fyNgiQuD
	y2anrMajVzGenVL7COA6J/+moTZPlW4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bNQ6ZeP/";
	spf=pass (imf24.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4624a44e152so2544085f8f.2
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782704132; x=1783308932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtmqN5vqMmf40dd+iSQc5lwp4GlOGai4yHRqtQ0Gjt0=;
        b=bNQ6ZeP/b6CzuV8CsulHWus3xAOOGHEhSpGIuq9YPTvGFhW6bUOv+x2FnW53sEMttj
         oUkTo8khFF3SYl2QFCc45kprcEe5dWOBsDm0g2hj/kE7lcC4oiAUmeFrUR16z2CACMrc
         my4pUE3rj3F+RTm2zgbEPxLVnAXCrdd7JewtKqZdi8KKd2cSXLq9ERr3fDipuIsEORbR
         v98YRYSU5rwIxwqNtoJw4Bwme1ZhG535OmFeeZE1dymdQ1UzG++xtdyoZHxk1dvUqTUQ
         spWWkzd8OYsmxFnZgH5F9Jm8kLTbkSxaOQp4TNALKxlNe34eItTXx7zkzAXfXVmrAB1Y
         /Mtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782704132; x=1783308932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YtmqN5vqMmf40dd+iSQc5lwp4GlOGai4yHRqtQ0Gjt0=;
        b=J61b62DdV2S1cl0hanGWwYoBoSOh28YFa7CCQKUx1UHM5jwemTepNMeDHHSpV6HPGu
         NEVXlC1dF0NN6QZYD2XHeUr26jXYBigoQKqXrpJUU9GeyuZaVEuYDBebjkzHbs+1VxJH
         8CO1xk0lXBpHiatFKs51w3uQKlSFaqM5Cxjg1g4AhPqZm17ChAXXVIhCZlCL9mgwerXA
         PMguAaEqLg/vlRXn4PjWnhGKaI/DOnqP68ofzrjX3+1HO1TgX9F6Ej72awpMl4dr3wMg
         ZQOPKkRiXICkV/5Bk6FxSSUCXCGp6gpN2iUG4j3LNeHsFNKkeEckMcafyWISnvG8Uxe1
         4JDA==
X-Gm-Message-State: AOJu0YxU3xQcURSzNs622HvIeDLKkAUNifp0WRphOwOc9fg9D7oxdGCt
	E0xc8Rvf30TF0QlWg2O/FxPCzy9BfRks5ucfrLEtA5f+DgTUF2JTZ/Rh
X-Gm-Gg: AfdE7cnlqe7DBdFPhdapN1ldel4iKccmQl6EbDNe+Dq6MHquEqF4e/cyTRlWr3lAdir
	bxVQC7pDEgJP4uxMestMtG9kDUSiW+l0ETomQGS6LCKTOLnftvyNgU/2YyPZyb9KRbwVlW1sjNw
	o0Yhfbugtce+cc4yJG/DVxvDtjQWqLND8yBv75oEjG8ciN1mz9IV/IeCkEGxZPBKFfcuZPoJI5H
	a9P3rL+4ODz8Wdnw7djTIPNXqNws2D4cfvilchzTEqrDffiR/kaMtjyiLFyJFZccy5ga0BftjjZ
	E+ZDqOHevSbLtTybATM6WUf1uLr7mzCNG+wRKysWHBQh4syVDUfw7KaBLpjNsP3knquxZn8oksI
	LJdLs5KeTfo+GScet2L8jMXuxsNA9PYVF435tH0wQjWLkZkDza4E+XI1RSik+wH/iLGx0nFuFNI
	9elXzMaRQUIh1Sf/K+rUSexw==
X-Received: by 2002:a05:6000:4a0a:b0:472:bdd6:f2fa with SMTP id ffacd0b85a97d-472bdd6f612mr6188696f8f.31.1782704131973;
        Sun, 28 Jun 2026 20:35:31 -0700 (PDT)
Received: from user ([104.28.162.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-472e8037a37sm12364820f8f.19.2026.06.28.20.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 20:35:31 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	yahia ahmed <yahia.a.abdrabou@gmail.com>,
	syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Subject: [PATCH v2] mm/shmem: Fix data-race in shmem_fault
Date: Mon, 29 Jun 2026 06:35:16 +0300
Message-ID: <20260629033516.10836-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <828504a2-a1f8-40ff-bf84-ed7d03f02d83@linux.alibaba.com>
References: <828504a2-a1f8-40ff-bf84-ed7d03f02d83@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbuyyb1x3ysy7ntphiwxpa5s4yeq5gn7
X-Rspamd-Queue-Id: 9C3F9180009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782704133-16140
X-HE-Meta: U2FsdGVkX1+1oLoUi4KscZ5neQ5J6v3KP4JpnFTygLCvxe192RHs86EmZFXPGk+2nf2IaQsKijHpXTGCnnOf1vsSKg9g2PSjN0nrSDcGBCS5hHF4fNyzKX4V1MPVOkBoaJUG29cRtU5aNGxHxqb5hXGwr+5HHxIK27mdEVALD4MGbWI+3PBmjlWi74ip1g6VCjZCDwL/y3vmAzmA4FIJZ2QCAXvOJz9zM/dce6AMhHh5iLzJ0XvSApdJDcYvYXnXxQXvTZBU7iCeKpyrDTFLVoEQDxWeTtGiZvA6KdaOGpdquYHdlgUEXRZI8Mod1F+ot95iwYCL57lsNoUFyLFA2NBv431X8EvroZJ9nktaqQzwEEyWuc+iKRzOL0ALXQvv43hEheSPkvm/2kr83MZQN2p7b6CtzJ2DulszMU0ZjHcFBDFid1ScOC5DlTVvjpSdBLlbluKEpsIGd9va4humZTdXWEI+27Ul3R0iIAEK2chSWwsO0iWjx+dMBlaNA0a78ufNxEt677yfVpHh3d39zE7N3PiaaXPhRP25c1M5UgmgsuMlvpm3zFcR8UrEhU3kK2wx22GSO8/X15tas9odESwxzfXdZB66bRXXDvi1iYHcrbB3nmDDadd8PPFWAX8vQ6sHlzWr7WMRjFL7cqSmDlm5hVBaPgrwA+kTIIUpKS2flWJRm0f7zeiiEecMYmUC5seM5sMpwRPCJHSWUkYETj+chZ3ujhbaTaKZWr0OcI63t8E5YsarVDWIWasiw/zD7wR7swU3bfoudv51afjOB36hiErLD6UvTONkqWNlQIGNB6UVg5xFi+0d/NQGSXkWI6a3PItDIXqFnnumrnilbjmioLdaInnayiwzotxDHvebOCJl24uOwFjPK8KnmobEZCbjjXbaBdxdNZbv5fVFPR2I7Ji0/o/KFh9eKcOyf5kSUffQV2l3P7mgvRrTtD+YF2XjT36m3tBBM4xbsZn
 dpKrEO0n
 JiZxX6f1RE8V10z7X9Zsz5LKbKNbn8YKCb0Dbf+Vh2NQ86TIqV79VMHORTrhGVV1pruMmIJY2bsk4OH8+oPn13LaxQQxp4ECD2IprQHRw9BDYJLpUq5OxCH5cF7amYy3CNHYFv+ujhTnf95pqJb4OQmkAIgLrzwVX3v6HLFyf30KPOkEe+/Tdu6M/7GZOQJLtBw3skeNhM1aZ0WXg98eLN8b6bCAWxD3CNLkfVDRyTrl3hIUeRLJck28Jft9fjZV510j8w9mEeLMdfE7Dg//yhin+/Fcu9ui8TNCCQWSrBkE1j7VQBzY/t5JJ5yq/a84BivDBjXzzaIlM3phLtk3/lQVvhs78z/EyncsrMycjBm6latrtCHkvqOAW1kZlQ0vAn2mTVGO2PtqKaz1ABXcA46X5l/wHRTVLvdcPU/PrriIMU6IibB/c8N5vudA9zGIG4CGyCm9b5veKcnLnn4tc/K5mvktabHEaSgJeTJ40GdDA3wccPLNbnAAxO4W3aIT3IJvGRrDcCT7Ic8i8sh2CnXWLfULa/hrYfy7l4GyJdzDwLBqvDm6TXQOG0374vRJCipkuCOLBwDzWRsXoiomT+kG13ns8iF0u7H44jczFSu7yoR4STKzFO1oppwe41L9x0jZKC8jqMHnONJT/pK0nlhKF/a9l6+knlKWqihz5rciiIfWKlJHgZk9uoyHpH0T6WhkdZ17tvUTEu72G2DsbW76+ywyGno6g8qwxWsuBxk4nLuNJt02GmTTjdvtIshHt7U/+iKulH0IYY267pelwu+GoZI40ycww/MzhWQkSWl7bmrlWjbWa60nRPtN5WwLntUuHIvlryO9frOGPMxeZ+KiLFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yahia ahmed <yahia.a.abdrabou@gmail.com>

Hi,

Thanks for your review, you are absolutely correct
that i missed WRITE_ONCE is required for READ_ONCE
to work.

Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
---
v2:
- Add WRITE_ONCE to shmem_fallocate()
---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..20ee24ab4806 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
 	 * Trinity finds that probing a hole which tmpfs is punching can
 	 * prevent the hole-punch from ever completing: noted in i_private.
 	 */
-	if (unlikely(inode->i_private)) {
+	if (unlikely(READ_ONCE(inode->i_private))) {
 		ret = shmem_falloc_wait(vmf, inode);
 		if (ret)
 			return ret;
@@ -3630,7 +3630,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
+		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
-- 
2.54.0


