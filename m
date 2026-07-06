Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C98C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE49E6B00A2; Mon,  6 Jul 2026 12:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E286B00A3; Mon,  6 Jul 2026 12:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D626B00A4; Mon,  6 Jul 2026 12:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81CD86B00A2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:39:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0EA5C08C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:39:01 +0000 (UTC)
X-FDA: 84958911282.13.AF6DA2F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 191EEA0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO2KuBq2;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355940;
	b=N/ZXc+0FR5aYdQtwb6V1i8jO8Hub6owj7KKhiwF4Na6YDGEU1g98yta3HswfbTlh1MFvla
	1OXl1xLrxo4lvlH2zWbon1cNRalcxY6RWix1y93gjMWP4x4aC7V/FPHJhDZetoRt9wp8dW
	ZzqgcKFMC6DjxJbE16V6CLQYBBPnULk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iO2KuBq2;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Yf91G0E96liVZH8Q9brrUTzp4Zjh9n4mTBgTUdMqis=;
	b=R9hqzpI3I/e4VoQNWMmcS3rxrQ41B65jo6Lhu/UWUsbB4FfnfhjRhNCMoWAMHb+SgVgxBp
	rmadFiYNTtdSoUufxwgL0YvKoV/+0kiZtLqp5ZZ6kzh+FDr2hiZcy0oEbZGf63NEw2RU2Q
	8ZygAmLLcr6u1zs7TWafC61Z+WIzaLM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2caf4496889so335ad.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355939; x=1783960739; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Yf91G0E96liVZH8Q9brrUTzp4Zjh9n4mTBgTUdMqis=;
        b=iO2KuBq20UoQB+hoO+lLDXLyCo2qd6+OrlQrGRaFtzH7NtAreP2hNOdijMc6YSst9/
         c7y54RyCmFROMF1bjrx1x3kprvSVxWgJK+GccCfHd/EGYU4rzLpKe0QkPhDq/3/Ygv8F
         unqMFkJZAkA0uhW7hRRoTeT9vGWMmy3VA/OI2qbsYMOSTI9IENK5VnSGyLw4RZpqiO9U
         BGeHMJGZPrPSGC0ykM+CB0fXJw5ijrRY0qJDFix9OIRyHugaqOJA7jpL13ugzhRH8k9t
         iEcrXVrqpo7VuBkUBVy4BZZgt+Y/H9E7l32flU0i3PCOlXqAAthTyRlHQD7YRWAdIopG
         Strg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355939; x=1783960739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Yf91G0E96liVZH8Q9brrUTzp4Zjh9n4mTBgTUdMqis=;
        b=qecJtAWCwR4aR/+jAruo1Lv2r5FOkfWUjVimVZysZznpTo6iwarrDqR5awk5Xtx69e
         4d3Vhr/duvLSbmPRTOFT5G8iC+/mAQUB7tWgKb3lcaPhjmmSOHrcQXlSAEDmsZkIL3+s
         jaA8KHV2DorgWJVfvc8dneNok7ma/32K1NSnjVR/clAbFd+MhjOmHabQH7B5Be+BrvSy
         cGiQ2iIE24GWrePp7iyoFDQIma3x7bHAqrw8x1jTu7Z77LrLPZ/hLUQ2tl7OYpNcm26J
         OChTcg00bMN2e0XgOTmBzcCu7EPjpXJFczqXhDZrrryOUhZmDdhYncxHdbmCxf7EOlK1
         x9gQ==
X-Gm-Message-State: AOJu0Yy49LDYLHZzi5gYH52NE9M8nFK2U/hUGVhSXdLPBQMfmm/aDjYJ
	dmv5qaoCna5itAzXQIMz/7vrjM8Vkb3Gn3yKAf5I4/e0ij+p3ed+XciW
X-Gm-Gg: AfdE7clCn6DRhp8O5lAysaSc7PslV8vAP4PymXObC46ikHOQOqLlEHOrcctxIdg1d1c
	4FnuAIp9/CzkNKpQnE6EwiQiKpYuEbLNyvWwQuNBu18PDLJsXuzeEhsGRSzu4SZvRO5rLhctyxH
	zSH+qtHlZspu4Hj4pEnsp76R3nhrPJP53/wIbu9f97OSBVyEpeCQYbDgTvadyqJnt7ifVMi1wVn
	ofI35djqHyA4aCE7Pf+io+C0aCRQtLEc+7kXhhxzSrnwbmWxzOhtjmCnSIWdvXD5X0NhlHoJpyF
	I5Zm7EvliENHY8SU2B8CDvetUDWZDO3q6SAIxPgZQoZAzHQ/1gyZ/QM2ouyTYnzerYniB6eYs4I
	8NH5zqynureKtSDR73cJDdghJvGIKzHKDNEBAsoc2H8CAhIKHmq0jXwbrD23HKf4dSnedZx9ItB
	LQLI74OQ8=
X-Received: by 2002:a17:903:3903:b0:2c9:e9ad:3ed3 with SMTP id d9443c01a7336-2ccbd7d2afcmr15968075ad.17.1783355939040;
        Mon, 06 Jul 2026 09:38:59 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:38:58 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Max Filippov <jcmvbkbc@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
Subject: [PATCH v2 3/5] powerpc/fadump: remove unreachable memblock_reserve() return value checks
Date: Tue,  7 Jul 2026 01:37:51 +0900
Message-ID: <20260706163753.193875-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 191EEA0002
X-Stat-Signature: xp4b6pkqft74jsgui56r81m5x7jfich8
X-HE-Tag: 1783355939-324043
X-HE-Meta: U2FsdGVkX1+VQ6Z319sC2ucQfeA5mIHsdw97h5YKwiGnWTbY00Zd6WhL4LN0saVLaus6dDWqw5K9XY5o5icortfGApGaG5ZZz5O4bz8Wtb1UhlBaf+V0xZgR6RJOWLzwLsIl1qH9thsgj7Cz/kpRs4i8prI4OQCATw7hjiccNZ6RR28LJsjmJ/wozu5gbm4YvotxD7LbBxbQ7S1IJBSRnXO9wXeNw+srU63HFaSdCB9IJZQTk/vVHXtmuVuZnr8B9aR4UfS6zwTmubGyH70nxA8ywxITkJgM+fJ2pJhQtx5xln4ob2Djft05lvikEVu6ZLOMGVqV6dpGg67ST4dKUL8m1vEN2MZkcJi+LJEWWECLp5WCae9G9+gjGrtD6CuFcAQq1qA5RdKf9sZRbhuYj3MveM00Bq0hcobiiwTjq+lEUmAhgqpxaB0nneZ2QOfbW0pbJA4swKJHlUbIBnEm5B3uSWyviT6WjPa++2jkl614In3Ct9HRs2I/fGf4yAe9/Dva3A4aJgAcRxxv7fyHP0wVPJGFYaO8YjYeLkoIGarbx4Jj8G5+mzR/6EyhjJXLyBC0ADe3u3wZrEj8KIwNBSGpr0Pty87jajmc6zZ05/GqAX5ZWjNHOQHDOCfDDDr40M1dIpYgVmdPDSd+TGC7MoiE+L2I9CGOQ4Y92kcpNrbxpaOhBl3UFlgTjizXQRQRB795wyb5M32lsBlWtMUi1FVEnLUHDjYPy2j5n1gkbbkUdzYZyqh6yNrUa207OqRgSuHzv0vifLUwc5RHvJVgu8g8brX9ymzXC8CL5IB7jFMaWjfElHoMYE3GxsOdInDtP2oVdmjYIGT+dLpP9/EWM+YfpEDg4bKlLXTh/a3KYvpGMoIYjFIdQWr9Zz4iM5/fFCJyhsTRHke5Yc1SU2HwwM/rA7HFIwftAZ95sEYrQoBCssDVsP0BRtWEoRbh7f/Ny/RXvBNSkgxkDJQMl7X
 wWcbL503
 wXQFvYEJwr2AFOJRSYQb6XqrXlrUdj/EJa9apf3p2D3JcIe2m7XfreX/9051bPxcz+aIXJSXoHWlm2MpnGRwvM9C6Fj+FRgc0XLq/91mGGee7sb7K1NtE290LSblEe5nLs3KRe6lqffcXtAI0+JNNCIuUOYbSNEeqxjLgIRkqSznTa7Tp0mw5BqdKM5Gk4SpX+iuN4V96vzyo7CmxGRqTGmht/Fhy9bnPAHsSEgeEi3PEaXcurZq7hkcIl91um/+w0D1IDy3UdH41wZWt2wcM8qQTnZuvgXC9PC6k8AOKEE4eVSn7I1ZNuyges+DyUrhLeUfdS6KYstrdYCj9HiHOdmSJaMQuQWTuQX3QDLG3stk2RXfGwDMMDN0TT+K105RpcUOSLTmUPEJtPs6/dkD9fKcyXb0MKHrdUYce43r0SkaMtqlhIxdvQ1jwCcW3nYDi0CwYC32rAtvlFBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fadump_append_bootargs() and fadump_reserve_mem() both run from
early_init_devtree(), before it calls memblock_allow_resize(). At that
point memblock_reserve() either succeeds or panics, never returning an
error.

Therefore the return value checks are unreachable, so remove them and the
related logic.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
---
 arch/powerpc/kernel/fadump.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 7f79c9aea4a9..1629a82b9528 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -154,13 +154,8 @@ void __init fadump_append_bootargs(void)
 	if (!fw_dump.dump_active || !fw_dump.param_area_supported || !fw_dump.param_area)
 		return;
 
-	if (fw_dump.param_area < fw_dump.boot_mem_top) {
-		if (memblock_reserve(fw_dump.param_area, COMMAND_LINE_SIZE)) {
-			pr_warn("WARNING: Can't use additional parameters area!\n");
-			fw_dump.param_area = 0;
-			return;
-		}
-	}
+	if (fw_dump.param_area < fw_dump.boot_mem_top)
+		memblock_reserve(fw_dump.param_area, COMMAND_LINE_SIZE);
 
 	append_args = (char *)fw_dump.param_area;
 	len = strlen(boot_command_line);
@@ -632,10 +627,7 @@ int __init fadump_reserve_mem(void)
 		    (fw_dump.ops->fadump_setup_metadata(&fw_dump) < 0))
 			goto error_out;
 
-		if (memblock_reserve(base, size)) {
-			pr_err("Failed to reserve memory!\n");
-			goto error_out;
-		}
+		memblock_reserve(base, size);
 
 		pr_info("Reserved %lldMB of memory at %#016llx (System RAM: %lldMB)\n",
 			(size >> 20), base, (memblock_phys_mem_size() >> 20));
-- 
2.43.0


