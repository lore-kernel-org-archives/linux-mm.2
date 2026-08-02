Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D97C55175
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 07:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9C86B008A; Sun,  2 Aug 2026 03:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391D26B0092; Sun,  2 Aug 2026 03:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A80A6B0093; Sun,  2 Aug 2026 03:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAEB76B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 03:40:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B4D1C0462
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:41 +0000 (UTC)
X-FDA: 85055532282.22.E20DF3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8FBE40003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 07:40:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/4JPm5S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785656439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBvTUsFpbqARD87S9WXjNTJXkVqbnPLRNoKntz2t7gk=;
	b=RAktmdo9wsKpNSKr63f1TtXy7oX3XdmXfhASigJIWFOTkEZ56/Qc8ZL6GfbtJBTZb4HeLC
	WUmL7CpaN4fqyrhQSmeevT5/N6PM+qhr+sJFtsj3GXQC8sDmmn9JYdAluW0fJuD/nVVhGy
	AuGmK4lNfPjW42z25jObAXZDHANqxds=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="M/4JPm5S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785656439;
	b=x0LSkGxiU28rD7MTQ0eOPccPdear1ZiO0yl9+KikVP9GhopcVcBminBnidWTGdjVxf7i+F
	qI3lz0ZrXEDdESih6Ut3JrepTsMVyaG8kzpTkLK654qhitNLpauRo/+GwIdBnB16yiLoXV
	8PnWf4luXy2uoFRPee2J+9OV+eJFt3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8285860DD1;
	Sun,  2 Aug 2026 07:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10831F00AC4;
	Sun,  2 Aug 2026 07:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785656438;
	bh=FBvTUsFpbqARD87S9WXjNTJXkVqbnPLRNoKntz2t7gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/4JPm5SGHOpNVts3WgVJP+6dIsG7yGugTjEgp26b2GYXzDF7dRr0o/BshxyGXjBG
	 A6ivFWO18gSqdfGjn4Q7OOrf3tVuIn5v4wISp4ia268p77o4TLkMKIcbQ363UBls2Q
	 HVsMwTyNv6byf2x6G65s86CdCUwBv3ShZtJ3scrvPSJUK8A0p47YbGrVKA5NGWWX8+
	 t2eyXR2uc3wykAoBD5g4hAeGe13u32Pt4h/+2sf4QCnuRb+dlPcqDZpdDTt2ZSvxBz
	 wER5xw3zBBqPZ4mWv4Ml8+Os0+SUVuxKiOvnuT0PkJLdls7ddnrCY/xUD9pFflemFl
	 YZ5q5Sz53ZaUA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	surenb@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanghongru@xiaomi.com,
	willy@infradead.org,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v1 2/2] arm64/mm: use VMA lock for kernel faults on user addresses
Date: Sun,  2 Aug 2026 15:40:18 +0800
Message-Id: <20260802074018.73887-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260802074018.73887-1-baohua@kernel.org>
References: <20260802074018.73887-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8FBE40003
X-Rspam-User: 
X-Stat-Signature: qexsjko3ho3oosykidjeomf6bkf9fcwz
X-HE-Tag: 1785656439-315848
X-HE-Meta: U2FsdGVkX199HVNw65wT/b1bI373lNjl8iZPgLK41B76HPWawSOBklGuHJ6/IMGfJhwA5nAuXvrw6jQoYhmpTlaWWJi2a75vsaV33H9+8y/H7y+GaQgcshdK27b64uzINMxpzfyTmgPQKzJrG7Sh/IbR6ysoz8+R4ViWVk2kHRkhuzm9ZYh5T6qRZPTXOh4Iblby40drYsJhcBtso1b7N6Fzo2V0d1L9gv0naY68vCDove+7SKA6khVDcI1STLBXf4Ajwq3ZbHtFqC+gcERv1iqK79PMcjOrHM7+5PY4qdO8phSSRzMIgn2tXxDHF8vLI/bvBvRRhd6/HmJNDCkCmVRsSeiYuzZAcF0sJnqn6HWtM364HTj0alrH8b7fUCkiCvQ/aNc5dGRas1EQhV74wHQzBaqP49mhNS5bwmkYucY2399tvQs/Zr4OUMSCHiOWyI4jX7gPvBCOM4xVvCvKWYCQ7S9HYXzFbMn0isLGDzkETQPQF5B2EWb5wIy9E3L7NFXRiyV29tnNI6jcUrDxsYSLCHF0z5ZHZe+sV2VsaGrf1cZu2RhXWLtqXSNxT40S5WDu9AO5oIlEfOMe40ohjksmf4EYQIIKlgM6pI9PQ63r6CbfkQb1tMp3/N9EkxdbLFPtDpEHFXxkbDMoQQtKnP5ty+kd34iBo+e7t0OV1p2NNf2wxyxtck+pphISGze1rCCh42I609WY47X8LOAjpMNdnw0RmznKEelSV9tqs2IiYhZep1xCyPLzpt8MeirT01ZZI1gS9u+z+TMCoHOKyNfFyKmHmYUFD5QCyHefwlo/kNASkGX4+A1xERhXccJblz2HesC3bDlDq1LE1RVKXDJ2syj78OyIGGJOQhudeJp164tyU9YJ9oKJdOJ/mh2SOGmQtLRZ/Lx/ikdP8TXwuKBpnUPWy2Ollcf3iA0ilL0Eux6BUqQeyjuI1Kvkf3VdvJDzh+DNVk5s3uoaXZr
 A2IQY9rl
 QCspIiBOi5uGW2WJHXVrL5cK8xyWx+0GZb1wG91S3PL/y1ruoSz6SDvk7AHGahF7JO+MI47OlRH9npAftej+rbo4RmjU9hHwQMFiLYT2oyL4rvZF6HjIYpe3Ur+j0DsM4LGIJh3Qwh5bD9vhFjQkE86iroM5R3bJZgR0+NTmNglOuGSuszUIBRYLw6/OrDPZjwdrQ8EJmpBg6gZo4XsgRY3APDruKfyBl9fFevz1r/Gkn2VJkR9gMPko7uUo2ahR47xrl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the VMA lock for kernel faults on user addresses. This also
makes the existing code below meaningful:

/* Quick path to respond to signals */
if (fault_signal_pending(fault, regs)) {
	if (!user_mode(regs))
		goto no_context;
	return 0;
}

Right now, the code above is dead because !user_mode always
takes the mmap_lock path.

Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 arch/arm64/mm/fault.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 85e23388f9bb..241f1ab07ab3 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -607,6 +607,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 	unsigned long addr = untagged_addr(far);
 	struct vm_area_struct *vma;
+	bool uaccess = false;
 	int si_code;
 	int pkey = -1;
 
@@ -663,6 +664,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 		if (!insn_may_access_user(regs->pc, esr))
 			die_kernel_fault("access to user memory outside uaccess routines",
 					 addr, esr, regs);
+		uaccess = true;
 	}
 
 	if (is_pkvm_stage2_abort(esr)) {
@@ -674,7 +676,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
-	if (!(mm_flags & FAULT_FLAG_USER))
+	if (!(mm_flags & FAULT_FLAG_USER) && !uaccess)
 		goto lock_mmap;
 
 	vma = lock_vma_under_rcu(mm, addr);
-- 
2.39.3 (Apple Git-146)


