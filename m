Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10C6C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE70A6B011A; Thu, 16 Jul 2026 11:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBDE76B011B; Thu, 16 Jul 2026 11:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB5A6B011C; Thu, 16 Jul 2026 11:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C39A6B011A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:02:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48DEFA0194
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:37 +0000 (UTC)
X-FDA: 84994757274.13.A6B07B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 74C8540007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:43:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5HI6GNh;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+H1mNZK4mHGJRYK6baWPpFykIVXk8y/VtJFIxD1CBjE=;
	b=6Dt0Ih/OdQ50sXVWl3d3D7vxa3RR5xVDE3iYIjLy1cCDDhWlXpB9B/2Sw/8gC2xj2FR+jL
	Std4Sjvj8hIXJ7ID6jl5KNRFSubvMnWZHlOF1lmiwhK2oXI1AoKrLGBYz60m3JBwZzC0lP
	iO5FZtweIR1QoszXx72dFaTP/o6JNVo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5HI6GNh;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209415;
	b=NL1001s9LvsYiFwYsHX/y+nu2Fk2kGXJVFYzPeBIPmXv9B14b4jC54PU1EZPJR5cpOkZPL
	V3/HsDnFxBDyyiQgaRzJ+AjnAhqnYJOC6vqx8eGIpmTpPM4Pp9kvEQ1jOFyV5533Eab2jk
	J5p7yw0OuMPA5X4Oup4T10J/v9hhuA0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7916C43E8E;
	Thu, 16 Jul 2026 13:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82D31F000E9;
	Thu, 16 Jul 2026 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209414;
	bh=+H1mNZK4mHGJRYK6baWPpFykIVXk8y/VtJFIxD1CBjE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d5HI6GNhbQ/GL2/WgLgxsxRnCCGpvu3Ixr3MEAOZbjWhOYL+Qmu7X6MLActJufiCX
	 FDh0DsWSxkdlZ0wCg2TB0rljgajZjrsTXq9KGreNF18CSoiwsc00C/o3USRY8r2zLU
	 pKcuxwvHICk9KgHSHTWhT8vW0aGiwWwzmIg3MboWMTeAMz7sTRhUwl9Z/tf6mkVY1D
	 QoxPx33rqkx5xz2rBEhChwJv7qr/anvgn/AUm85E67QFbGryS+i/ylXC9xw37ApxJP
	 tbXDq2KWY8BXxhtY6XKabzwKu+t/FKCcQiV/Kngn6cKHK4mXYjQeHqDmsqr3b5xbpv
	 ktoxcWmr4AvXQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 16 Jul 2026 14:43:10 +0100
Subject: [PATCH 2/3] mm/mseal: limit scope of mseal address zero to address
 zero
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-mseal-fixups-v1-2-3a9609bf041b@kernel.org>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
In-Reply-To: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4346; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bCnbZ236ttt9+tsOYrHXuwG+hplvEL93BRAGDdBCf/Q=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIi7n86mzzdwW33t98/WI8kz2T8GZwX69x4N7nh7qK/9
 3b9tIna0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJbNvD8N/zaJnitIe8mv6q
 h6a1LT7e1Pm49+eBHFNzV27zJbpGQhKMDO/mHp/z4uWhcM1dHTcK7zqEZ2qfec3d9DZuxYJs8zW
 e7mwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74C8540007
X-Stat-Signature: hmb8mb5hoa6395pmhrncmeirm7gxymnr
X-HE-Tag: 1784209415-707748
X-HE-Meta: U2FsdGVkX1/PRwduwxYIeS8pA5WHbiUj7o853yEIeBbNgAmbKDDXezuncmKePLzt5CcnKK2T0GXjwr39VwapuGcH++sBJnSucEXvU+qwqS+IrZEAsl+rbaFZ1E2cDSMBwf0/O5FZiIY8n+WMRaYwo2WPLuvpxy5OK2Z3HukbI26OWTYszTm9M7d780t1KReT2qrpcgOgZCnPWZxdLtdCUvlJ41AS/Vlys9bYy9jwPNWTj+ChqJhJFSlv1DD+u+nMoShKaZv/wyNdKCDT0g8HnXD9twd3lF9AVsarWQg4q8Z3tysx2o9RoKGto0L+KKPxfbpgmlY89GAZe5uURkp6v/Oo28iPchXMvBcDJBCFyP9v1EfSU5tAZjZmxvOzYBPJDF8iftyXsI9TrgrQvtOBMvQwKaPN9+MZHnwi1WTImBYFAeGGomZJ4UAof0SSlclkWrLFahqdobEG4eID8+7tWpcu3LMLW82pAAd1Rc1n7D34fuxuFz4QfXr9K7N/sIle8OItavMGP/Z9IZNxnB25MU+Nm6Zs8RKYYt1SsXLITmBHgtEg/m2V4/zIorE1xUkwIBXsHwjbEElPTjoA7mMBTiclX4b1bB7UApWSeLeoVCxMgZdlb18QS8yC43OG1+27y3PGeYkHKLl/c3wzDVCLspqkThj6j3xsmkDZ1/sz1gxOjA3WhA7INhvf3asFozCqYNesfnMVNSlA1D4nes4XoatE55P4FL5Gdczq+firVbmMh+ngVay7k+OqvCN6Xpq2pz7BEM+j68iiS6tVHspAVNzzD9vvWuC7V53RnpafXQQKZEQY72oPzpvQ34UrTvIg2qiKk29X0+vtUxB0cXnagDj1P3tTCs/SoGe33V8Og+p7w2RTrPAeWXFmQKsetE1oEi96pl1EjrIWvGQtIy/cXz4IgoH+dV1RykSQQv3U86BDBaqlu5EZIh8SlbrnQgfzu4rU4U95L0UzUI3GEkG
 HXgDz+ok
 kr5FkcwUWwGLpGJMJp1JpkVhgEp5HoAgMruYCyam4JuO9jAFQrz/XOhxA/phq5KThoTdSzOwJDxeVLHs9DVsnoP4ZIDsxAmf6MUquIUZ0Glw94jrFD/fiypKloHLXfodGZhzvOMdw0+CmDVrWEufWl6CwlgeNxoZ5nxwuHNDq/HLUDroX3/XKZhHpFLpuTrxvEfG3jDAL6E5BIHucJAtJGpIOr8pveRdB4x5HAlO8ofGe0DC+iYzuDjN0gjbeLoxzQPmJO7sR+xRvvgOngerGUbiH6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
provided do_mseal() to any internal kernel caller in order to address a
corner case slated for possible removal.

It also incorrectly attempts to mseal() without checking to see whether the
mapping even succeeded.

Restrict the scope to the corner case by providing mseal_mmap_page_zero()
which asserts the MMAP_PAGE_ZERO personality.

Avoid unnecessary checks in the start, end range by abstracting the actual
mseal()'ing to mseal() and have mseal_mmap_page_zero() call that instead.

Only try to seal the VMA if we mapped the VMA.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/binfmt_elf.c    |  7 ++-----
 include/linux/mm.h |  8 ++------
 mm/mseal.c         | 48 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..e3131a311995 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1353,11 +1353,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		   emulate the SVr4 behavior. Sigh. */
 		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE, 0);
-
-		retval = do_mseal(0, PAGE_SIZE, 0);
-		if (retval)
-			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
-					    task_pid_nr(current), retval);
+		if (!error)
+			mseal_mmap_page_zero();
 	}
 
 	regs = current_pt_regs();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 550fb92957d1..87feaa5a2b78 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char *name, phys_addr_t *start, phys_addr_t *
 int reserve_mem_release_by_name(const char *name);
 
 #ifdef CONFIG_64BIT
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
+void mseal_mmap_page_zero(void);
 #else
-static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
-{
-	/* noop on 32 bit */
-	return 0;
-}
+static inline void mseal_mmap_page_zero(void) {}
 #endif
 
 /*
diff --git a/mm/mseal.c b/mm/mseal.c
index 207fea89c61e..5930551d84f2 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
 	return prev_end < end;
 }
 
-static int mseal_apply(unsigned long start, unsigned long end)
+static int __mseal(unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
 	VMA_ITERATOR(vmi, current->mm, start);
@@ -66,6 +66,38 @@ static int mseal_apply(unsigned long start, unsigned long end)
 	return 0;
 }
 
+static int mseal(unsigned long start, unsigned long end)
+{
+	int err;
+
+	err = mmap_write_lock_killable(current->mm);
+	if (err)
+		return err;
+	if (range_contains_unmapped(start, end))
+		err = -ENOMEM;
+	else
+		err = __mseal(start, end);
+	mmap_write_unlock(current->mm);
+	return err;
+}
+
+/**
+ * mseal_mmap_page_zero() - If the MMAP_PAGE_ZERO personality is set, mseal()
+ * the page mapped at address zero.
+ */
+void mseal_mmap_page_zero(void)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
+		return;
+
+	err = mseal(0, PAGE_SIZE);
+	if (err)
+		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
+				    task_pid_nr(current), err);
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -118,10 +150,9 @@ static int mseal_apply(unsigned long start, unsigned long end)
  *
  *  unseal() is not supported.
  */
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
 	size_t len;
-	int ret = 0;
 	unsigned long end;
 
 	/* Verify flags not set. */
@@ -144,16 +175,7 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(current->mm))
-		return -EINTR;
-
-	if (range_contains_unmapped(start, end))
-		ret = -ENOMEM;
-	else
-		ret = mseal_apply(start, end);
-
-	mmap_write_unlock(current->mm);
-	return ret;
+	return mseal(start, end);
 }
 
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,

-- 
2.55.0


