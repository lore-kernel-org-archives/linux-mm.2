Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43842C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612516B08AA; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F06B6B08AD; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B8F6B08AE; Sun, 16 Aug 2026 18:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9CB06B08AA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08FAC805E5
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:49 +0000 (UTC)
X-FDA: 85108621458.23.04F43A9
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf26.hostedemail.com (Postfix) with ESMTP id 24A1A140006
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e LcO8ly";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QVdq39AQ;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920467;
	b=lVnf5wHEQ6RPoighSHGmAOs5bQ4GyYfY0wcK4YhvwKaBnieG3zKgxOO3XfOgE86iLEMG8j
	Gk3CNlnwBlVYxbMthhgkKpJ+HHX+P0d5p9+F1NJNH7P3c1VwrwEB2cp/yR6Kk4xyz1Vxhr
	+hrjJiSqTm9QfT5Oz3vVuIZwopmwEnY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e LcO8ly";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=QVdq39AQ;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXFeu3sLpTizBLZ9/Sqsc9AjC3ALB9bfMUETq02vuTs=;
	b=W8EDUOVl41EypcQQJ/Auh0NmSvc5K1ep063QPYHtEH9Esi+CPZzaiYRHjUHu5gogJYJ8e1
	LRJ6Tl0Z5zyGLzviBgtkbpoWl9Iq8RyjI3uVzvOXyt7sBkEf0+G/aqPr7Vs/NG2uGSnQL1
	WXau5FzVmTl9OoGRFnxPiQ/SIE/LS6w=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id B4E2814000F8;
	Sun, 16 Aug 2026 18:47:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Sun, 16 Aug 2026 18:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920466; x=
	1787006866; bh=kXFeu3sLpTizBLZ9/Sqsc9AjC3ALB9bfMUETq02vuTs=; b=e
	LcO8lyAfOxw6vsbVSfPPyUPeqcUILzjVePX85zdk+4Qa/6P2XtB0oD6EX0GBe78y
	SbRWyJTI8wg5nuia8lPlnJdCs9jQtnPEEf7DN2tIrE87uzvWtoTX11UnOzY1V2Wg
	pn8AW0p+dQKPTmNzhl3ShlZJjkfHNYIRvQklrrI21hmjoY1w2Ui/7pw8jjDSLjCK
	8xyE5palO5N0A7kf2LJ2htSwjseT2dNljxr9AVM4VPHjpGDv5YonQC/5UAZyoVsO
	3fAcia4nQAwlOptaPlX+P9Vkhi9DFkHzJj5Iyn/auiZZzlnL8pgwLfelj0CaRU2O
	4X37RwoyrG+IWPcER01lQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920466; x=1787006866; bh=k
	XFeu3sLpTizBLZ9/Sqsc9AjC3ALB9bfMUETq02vuTs=; b=QVdq39AQH+YK6d1qn
	1wRVHgcj9LE+6Mkh8KyLkGFlc8HTgZ/WJynfrsg9F2dxi6jKEfLWtVOjY6qhqALg
	iyleh6gleGIDi8nh1HrpMT4+nFB31rAe40Sl9BATfK4rF7GG926621n+bkl4P0EG
	kbjaMc0aseXlqQzJrXL15CC98sNuEqLlDh+sAOSGgg2DBg+O9NScSikFT7dpSFvR
	FK0+7DuAr9HGf+U5YDaciPGUHDvWB2C43vQzUuPxgc8Uv2lcnbSwJqSsvrurXt1f
	yggRh8v1cbDQTWa3AsyItOQmX4nQruKyH1ppeWxQuaSowmdqMuR5zZjhH8LNiq4m
	Ersvw==
X-ME-Sender: <xms:Ej6CahjR6r2mktBJ6gWC_DkV80ycF8y77kBLzABUUokWUHMAwUPHpw>
    <xme:Ej6CarXMaTGOsK4nj1K_ZjpLiiEiw3xHwFLHoIBPhcuTHK_TxdUvVl_bg0HotxUSD
    qxciCRouKSQT2GIluCzZed5wYY2y3X2hNIxNpfIJDXwwTlDzGYboGg>
X-ME-Received: <xmr:Ej6CatK-oCE3eiv1IaeuXYhVxmS316s1aiHjP8OiYiqSoqbMgJv6m8Wz-Ug>
X-ME-Proxy-Cause: dmFkZTFX8QZ1Abcp//ElmtP0wYUsUMnb+KjPA544aOlJXhXcQAudkXa81C9Rj4L11ediC/
    SYpDnD1LvcyFEAv2YFQNL3ReIx6t28G7cFOXvsWQqNdQRv24cIelnnbcWrHqur16sY2q+b
    PHK84xbhjrx0R6ZFbdj3lDcQr+wbYteZ9PHsSvZgjQoovnxRkTlpJXxI+K+aK0DY9MqaWr
    nM0jSjvJAOtmNeFdTIuI9VxKMOFqeJI9DUUNBafqnTlsaU2K5w1xy/oDJpRmozGKRfcEpJ
    T4FDpTcqBKNo58tTW6I4nVl91YkYNyFfziYdH6IV5aj62MGBqsSUtSYZnaDODTOndFzTVv
    qOtBqEf6P9b+C81V84k4WZcgjMziTkY36tS6PSJ/ihWMzxssTaILKX1x0S+EnTMrbWn4tx
    /WsAGYeCiIsEPje2mEGeHo1a7HuyO9eOPf3nZ82C8aboYTb/FTNw5UJkzusnordR7v9U0S
    8QOawJGWzEPx+57GKu5OD7HLlhjh4MjCz7vLnL1lFlqsZN4BRmFISTdNaYhQjG1CUBsVPL
    PM5z9JW4FnIDlhdJUtMfpaAk0cPHGSL3oVddW6H3HoL/aB4BMDSxUrghJHNG/0+Ign85r1
    +HsdiW0bYOGDytlMz9aQRKxqsDuwuKKJh2Kd2LSQZV0Kcr7fx8iysiO4aKjQ
X-ME-Proxy: <xmx:Ej6Cai3OBqBfzo8zewOQ9o4v36A2oIIob5kmClye4X-6QCcLZO9eZg>
    <xmx:Ej6CalB4_1YeqpH9M80bmIFF9nfx13H8kYO-LTNP-Akc1baCQojlow>
    <xmx:Ej6Camc4n-oACR89ufga0hr3f4pWG6FPoIBIf4ooz9J8RuW--F5ytA>
    <xmx:Ej6CaoziM6C77QX3UzVy4VrufLirnqBYM9YfqH5jjQE7MX4az3O4yQ>
    <xmx:Ej6CajGXtY-Bk8nR7a9PeWro5YsVyhZs3Qhh3tVqcGqbr9j67X_Y3a7r>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:45 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 48/57] mm/collapse: assert the mm reference the engine relies on
Date: Sun, 16 Aug 2026 23:46:00 +0100
Message-ID: <20260816224609.308019-49-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24A1A140006
X-Rspam-User: 
X-Stat-Signature: mbk54gxtzfnzmd5jmp4r3hzs6ahcqj5h
X-Rspamd-Server: rspam06
X-HE-Tag: 1786920466-154522
X-HE-Meta: U2FsdGVkX19Zdx2u2NbQmpBVpin4UFFKjRnkuyKy5Iq6Vq+DafYL6fSahFWLzRPF+DaGDCaTAsx4ng1YsIUNQa3FsS+g/VernpuSb8l1CF/FuhoWlW6d4MxXfDnyRn5bL0uRd846+TbM/QmnQ5UZuBYowbXsNF2sHBG8GKHGEMBb+OQHoAhrArRxwGjdAdCi24vxcVAliLq54oO13zc3xfrqX+FgnHqTQxFenHRPGti53zYCbdxxmxEPH16e3t4ceD7fLzbQJ2zIobuHJTloCwLrfxUGzBfNS3E0TRzbrikRkOg2Y4b6npIzV7OYUSqkJUmyEWRk+qABsINIe6raYY8AIZunzFidxFZKF9TGOKYeIvhYZDJhkHm5OCvuxU6Gah7I5co+nq3ABG5Dj/BbpbMTY7h5SFFDNutFFIuyQiU3FMPOcFT/0/Yl/CuhZMXrVZclOo+wgeT+1fcl3YZhznrJF1XJIuw0Yxpr33mErCw8uRAZoSaBg78oz4xaqv8KEPAhLydTzTZiLbX//R7i8AZG2NwV8F7kJTBELeeaiG+j6ML2t5TVdDwWk0pSplJV0ON2ZsQmtQv3zwaUtteO4zgN3rqFCGZouCA9SbiCSQmgQWjCUftQejIktvqhIOCJckc0U9ZMQerRE6Pblfg+AJx5bilRQHONJHafUX8MJFfQmvQwDbylrE0LAeiURKAzBhPFFnnuSOD1FxwqbcYNLBNnrxMuhGyWRQu5tb6dUhm2x/TKhQMyVgu2GoDjwC6o0TCTK+2e1IBPmM8Ou8opc7Xn7SQrGd3G4Xjr9B9ROqyg3LZh7+RdtiZT/53szKNZAJ82+5kV+hZXR17zYEyqBNXFkOqbdLqBRRJ7z3968Rym8aJoo5hOlB+F3fm7ADsDBvjZRZeyuvYQtFwU5ejDP/5BZjpPvHsE2criU+Yt7256rO+lb6A7lt+WrqCThIjxSAPkthkdxIs5x4XRUTt
 wLmXAFgb
 yoPffGWM3mDPNQX7S3yKMW/bR8TkX/2eqRNom4VR4vEn7BT9PkLrUI1/DiDuCPMJytKAgknhd9GMHSFTXuKkyRtw9OcVOJTYUBrm5Vw4FOvx93+aOS/Q75oEJ1Ns146FNOoCuMYfZSB1NUtPOf6V/wX5lqgsKgycal87vR90GFu7mLhPQPO6bir5++swdNm7foXPjcFYMhJr2KW4stDAJuJJsg2FG1XC++lHcAKrD5T+LK6pWUzV2G6ebhjyiIw+758q3NO1UPBLNOR9qtLnsjYNhcXHhBi6kPnayci4jU82H+r8l5vi7MSVDXGSjppboEhFIKKpg51duINiajU2zZz7cCNUsP3TbUMVbUwdP9LB0uBID7PMjGzCxbguBePrbEU7i9HwLTer6Myfh3F28Y/nEpBr8aaGMDRaUxDGsVIiHrzguLEMECXjMT/Kexg2xlv7ws8opLc4hI44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Every caller of the engine holds a reference on mm_users for as long as it
works: khugepaged for a pass, MADV_COLLAPSE for a call.  So mm_users
cannot reach zero underneath one, yet collapse.c still asked whether it
had, in three places where the answer can only be no.

Ask only whether collapsing was turned off, which prctl() can do at any
point, and assert the rest where the interface begins.

A caller that arrives without a reference is a bug in the caller.  A debug
build says so there, rather than leaving it to be found when an address
space is freed under a collapse.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index 1e3b2d202ffe..28631c734fcb 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -473,7 +473,7 @@ static enum scan_result collapse_revalidate(struct vm_area_struct *vma,
 	enum scan_result result;
 	unsigned int i, nr_live = 0;
 
-	if (unlikely(collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_disabled(mm)))
 		return SCAN_ANY_PROCESS;
 
 	if (!vma->anon_vma || !vma_is_anonymous(vma))
@@ -3731,7 +3731,7 @@ static enum scan_result collapse_file_pmd(struct mm_struct *mm,
 
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
 		mmap_read_lock(mm);
-		if (collapse_test_exit_or_disable(mm))
+		if (collapse_disabled(mm))
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
@@ -3762,6 +3762,8 @@ bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 
 	vma_assert_locked(vma);
+	/* The caller holds a reference on it, so it cannot have gone away */
+	VM_WARN_ON_ONCE(collapse_test_exit(mm));
 
 	/*
 	 * What the scan answers with, so cleared before it runs.
@@ -3776,7 +3778,7 @@ bool collapse_scan_pmd(struct vm_area_struct *vma, unsigned long addr,
 		cc->scan_file = NULL;
 	}
 
-	if (unlikely(collapse_test_exit_or_disable(mm)))
+	if (unlikely(collapse_disabled(mm)))
 		cc->scan_refusal = SCAN_ANY_PROCESS;
 	else if (addr < vma->vm_start || end > vma->vm_end)
 		cc->scan_refusal = SCAN_ADDRESS_RANGE;
-- 
2.54.0


