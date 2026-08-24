Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9905C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6008F6B009F; Mon, 24 Aug 2026 12:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8636B00A0; Mon, 24 Aug 2026 12:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF3C6B00A1; Mon, 24 Aug 2026 12:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21D866B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9672A1201CE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:03 +0000 (UTC)
X-FDA: 85136639406.29.8699C2B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 03F2240016
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mNGt+rmw;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587562;
	b=BKVjMZLAww3AhLiAAU0ss4MN620NxSZlS2Zs9yY6d7A5JtFKEecNzgeFpyMInIqmI4mCWY
	9X9Eb8LoIfDYt9Rwe64rjCfBW/N1QwTZyqb5RMWfppfpbi1B3u6JIH4myPaF4YtWShK3m1
	aFpCk9v6xfpsWXJBrybhlg/NsmkGCY8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mNGt+rmw;
	spf=pass (imf27.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2HODHgPFWcmpM4OrWXnRIwysDZ/R1pibvtBSqDnsLNw=;
	b=RDUIQiWOg+H3mAMGHHSj/9drUOxR5KvFG6MubXWik2kNRYtVhGvVJH7H7kimZ5SwJYlQL3
	bN6LNZDdonZK+PBBNvk8O1ISSTLlpzhi1ta9pIhP5VXRa+9Xq523LBjcH15YxCnlBuRx4m
	OSj3DnZfTkbzGRH0PaQ6r2bR7dDW9Jk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66CAC1BA8;
	Mon, 24 Aug 2026 09:05:57 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0779D3F85F;
	Mon, 24 Aug 2026 09:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587561; bh=nodn3/K9trBK+2wWrkLJGeFqd0INql6u2EHBqnLbWuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNGt+rmw+m3ruCwnhja8afWvDAIEG0qPzwe79zxnTqszfW0fgkmn7kM6QqJS5/+ej
	 jNIvAv0fF2vEvSYW8xIbW03slFbzO7/T4PlF0kwnb3MRc3Itdj++wKmSqG7vbSAzpV
	 QanHuh35qBM3KtYjRoJ5HgcXGbly8RHUXJTfOLGQ=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 4/7] maccess: Use a scoped guard for page faults
Date: Mon, 24 Aug 2026 17:04:49 +0100
Message-ID: <20260824160523.3907021-5-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03F2240016
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hnr9yrposnn6w4unbsxdu4ud6teh5mfw
X-HE-Tag: 1787587561-629553
X-HE-Meta: U2FsdGVkX1+AFFRM3Hfzms/hRon448sF6w+qTuO0kW/cKidRZmyT2wmmU1VIcLDK2giSAoacU/Gj28/yFM/GpgoU3b8lb/k/2G1dyO74GEBCT5HVuAoss2EplpCh6Q1XNku60sm3jVvRQgmILscYIg0ut0GU2noJQlK67c+iyK33y1q/1rXgVrS0XpXuVskSZIFSr31RHFq3v/u6yHEL4rVtNEKy/cDEXoJ8tAVU0OowuZMvYfDBZUOX6Nm/X5sicSVga3sZNrrz79lqK0Cz7YwLpKHNt0MBd75pax97mff2Bf6kedJ7zvdhinf55ybSepretzBK6INhrtAt1bkL1TeZcItiwiqnEyStM2YX/a+sJOv6XH/Go9ZvwPN3+JCBomadW7gw2A4HMJYuDbCsQBRQbDKepM/e7BmS3h2ayV4SiMEQcpm8hFL0xqzMHX+Lex3LvS26mRaDowoJ84BJwJOEmjam0KPgOy6wI7aw6S1H8vMe3CHOdfqc1t3JxzfzvZRA28hqqemiU0WEGSXf5rNBQGPn2unoS061JoR1QG8aLzREJkLHYEjJE6AiN2lt1bbly+ANWrm/S/GNjV544StK6/eA3iovbcamS5tzJCuXZ12F5bplrX43e7fid8U6vHd7um1VDr5rqjwroVy5Q+dQJ3khp1c1y1rcdodq6VQ3kktpdSkh7/WzSBZ4vDB28Mc0Hc5loXpvA9dpDx/t0t2b6xFOM52b4blRL6YCy0f6mVPAPR5Wou79E4kjDYiJqoGVcsM98ya/c5e+V4+tWXC8xEABFKfvXxz7ak5kb/RA1Hlper4pmg54GC3z39xBEy/HyvnKMO9DeRd0YQ0smb7oksl1blTRWP5HL+qUiNdlMDXOm2kG6XCzQlLuSXqoH43M3UWeZwkHEIhkooBAXhfS5jlY87UlRCQF2wt5VXqbzrbrchy7ugirKvUG3JSYEDyT3fTdhaN8YZPbOH0
 6tGLrXaM
 sxcTFzCJvP/ORlCJsdVgoIXBwwgI4QId0VOBPaiIn17gKutoymhmuUW9OmTUzWbV2y9SydunMi7FEbzpYXam89GwG5dnuhRSnq0xH6MfqX0MkUxRSc48JXpXWaepVGY6drySA6QhZjZeFoAMiQq3odk1BWNoTZB81d0XaZL4Rnt6KD+6O/EVn8nRWpmaMkiTy9IaHyOPFW38PieQncZpDkQh4RuTd29x2ToUt4WuZSxr4FxLglmG3iCSiX0YQ6WfFva2Vz6oxzsCVrogct6QwxDieyEnQN+Oznnnq5cAQtAHAR0vcFoFGPwxiyr/H+aoXwf/sDGIjuNJVZRlzQ1OdTzm/Yga7dyQBR19pb/2D75HykxEwObjf/YsMR65wbR3KHRiRuuyT+qdeVARhCM6YIohE+fKOZviDKGA5CihGLgAC81+RgFhAyLSVc4Nur4JkJM4ECKE6BJfTnljpbKL70WN0u9oY9j/jHQ4glkvAcAmwPVtB535SigtEEMx4Ai8iKTpwBaRQ2k7drI2Jlmv2Kpl1dTlatJ9QvMJp0CP56pu/wqlzgC1yXYJhEph2KMkQ4DczoSFwgoceUWc8iaYITZVpsDKMeEa47PHYpDgHOwREGwy2PrNu6V9jRSLYRnYBKRMtEBuXWyFnfEWCHAtWWCFqIJmHpB8IWXFmmc29IlVumiiz/BvoUNke/x/2c51A+636Hq7HeNmNlGdqLgQMyolSwY3hRX+HfpjDLs1E7UmJO1o7iiDqVYYpJj0zGFhcqxNcf3EFuxZAbO+eMBmNPF4tOkHs/nKz78rC4Ho3RXe3oxIoFlRWi0/n5e8CucMVPP78VVR+dCs/psBdOaWcHJZl6thfeEO1uO7pPIv4K+0MgkUqJNow2cqAC2vDHd8H6pKIDSCfaZTf6j8zYQzAvXbMLfjkyf8b///6fzbt3aeFjcp3ZRMmqYavXKMMJCBwcF4/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel nofault copy and string paths open-code page-fault disable and
enable around label-based loops, duplicating cleanup on success and
failure.

Use a page-fault scope guard instead. Leaving the scope now re-enables
page faults on both paths without separate cleanup at the fault label.

No functional change.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/maccess.c | 53 +++++++++++++++++++++++++---------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index c59a0e092d24a..f695ceefe6fcc 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -38,18 +38,17 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 	if (!size)
 		return 0;
 
-	pagefault_disable();
-	if (!(align & 7))
-		copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
-	if (!(align & 3))
-		copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
-	if (!(align & 1))
-		copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
-	copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		if (!(align & 7))
+			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
+		if (!(align & 3))
+			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
+		if (!(align & 1))
+			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
+		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
+	}
 	return 0;
 Efault:
-	pagefault_enable();
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
@@ -73,18 +72,17 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
 		align = (unsigned long)dst | (unsigned long)src;
 
-	pagefault_disable();
-	if (!(align & 7))
-		copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
-	if (!(align & 3))
-		copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
-	if (!(align & 1))
-		copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
-	copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		if (!(align & 7))
+			copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
+		if (!(align & 3))
+			copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
+		if (!(align & 1))
+			copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
+		copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
+	}
 	return 0;
 Efault:
-	pagefault_enable();
 	return -EFAULT;
 }
 
@@ -97,18 +95,17 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	if (!copy_from_kernel_nofault_allowed(unsafe_addr, count))
 		return -ERANGE;
 
-	pagefault_disable();
-	do {
-		__get_kernel_nofault(dst, src, u8, Efault);
-		dst++;
-		src++;
-	} while (dst[-1] && src - unsafe_addr < count);
-	pagefault_enable();
+	scoped_guard(pagefault) {
+		do {
+			__get_kernel_nofault(dst, src, u8, Efault);
+			dst++;
+			src++;
+		} while (dst[-1] && src - unsafe_addr < count);
+	}
 
 	dst[-1] = '\0';
 	return src - unsafe_addr;
 Efault:
-	pagefault_enable();
 	dst[0] = '\0';
 	return -EFAULT;
 }
-- 
2.47.3


