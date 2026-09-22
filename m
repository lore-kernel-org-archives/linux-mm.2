Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A52C98305
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929426B00A0; Tue, 22 Sep 2026 04:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9276B00A2; Tue, 22 Sep 2026 04:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816996B00B5; Tue, 22 Sep 2026 04:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62FE76B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:50:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFF598040A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:55 +0000 (UTC)
X-FDA: 85240778070.02.A8218EF
Received: from 9.mo575.mail-out.ovh.net (9.mo575.mail-out.ovh.net [46.105.78.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 67F0A20005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=btOoQnal;
	spf=pass (imf13.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 46.105.78.111 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790067054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7/Bt3TycCT1K1u24fOFFkzDbe41NlkwbsLDq3UP4wk=;
	b=nUh3UYKR4GY1hjyEIIyJrr7U7L6Dn7XXjhqu/g8qPKkzxphBUWgBMW/7hIa8A3I4lUf10U
	eSDTkAe/Wp7PMUgEWKvF/A4SDhYMAWkgOtKsT6rvz5AbB89hhJACk0JyronKgWvih0yybf
	CFmApukS1rDhumH739AklapQ48LTlow=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=quelquesmots.fr header.s=ovhmo4049951-selector1 header.b=btOoQnal;
	spf=pass (imf13.hostedemail.com: domain of l.wandrebeck@quelquesmots.fr designates 46.105.78.111 as permitted sender) smtp.mailfrom=l.wandrebeck@quelquesmots.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790067054;
	b=Vp/AUPmkt9TdOfzhxIhu6Ng5c2eyL++KSgRPvoQumvv9YWJKkJd8eGt6f6sG0Z4jAj76Ye
	Fe2WrgwMtZaLmgtrfxHRzLiyWu+JOzBan5nnxD562eAPDF0yMjpOlroqBjI5Y/B66AEH3v
	yv+h+tinCD+OS9lbaO5ZgMcWnaHnglo=
Received: from director2.ghost.mail-out.ovh.net (unknown [10.109.254.39])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id 4hpv2N04ymz5yDb
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:50:51 +0000 (UTC)
Received: from ghost-submission-c7b579475-9ghvt (unknown [10.108.54.199])
	by director2.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 8661CC04C9;
	Tue, 22 Sep 2026 08:50:49 +0000 (UTC)
Received: from quelquesmots.fr ([37.59.142.102])
	by ghost-submission-c7b579475-9ghvt with ESMTPSA
	id ko1GFWlBsmqwRQQA5nG6ng
	(envelope-from <l.wandrebeck@quelquesmots.fr>); Tue, 22 Sep 2026 08:50:49 +0000
X-OVh-ClientIp:109.190.254.62
From: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
To: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v2] x86/mm: don't apply va_align to hugetlb mappings on AMD F15h
Date: Tue, 22 Sep 2026 10:50:32 +0200
Message-Id: <20260922085032.46144-1-l.wandrebeck@quelquesmots.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
References: <20260828135747.724789-1-l.wandrebeck@quelquesmots.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 4713861437617077698
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEndq6tX/CQOnJbBL1bvW7qnWG6s1JBVKliFUnDNJkSxhs6tCh6LBOj0r2/2cK6V41kyiC2nj2s4g159XkSMXfCZYRQoJhFHrcyRqYzMHG3g1k+PFdH38SuCUGdT2ovNW0/0y2U4bhOHnh6c4hC7mmtrA8usIr5A1s8CWvjAa/5zpQulOxa5ysIZxvZFZBlylIBUtR4aZ7Xf6aktD9ZnPtnQ8JsE6foxeN/4QxGGfxT3Bq8GWp1D73NaMN95+UL6GM2v4kRF+ArYtOVRBeloZWqEf23Cii64VFTzze8k9PD7FEooFXP4heWwVCJFynA0zDR+uiG6F8Wg37K97iK/K2NNvpxlIGds1UG96f77QDIae+FZE0w44Tj8UaD66ZEgKVpf3SwgnIrHI0awSviL3D54xFf+Y0jnOpK7P3fCgFVS6WTRyuaIVAvmt+Hs4begBcXfW4nDKaYfuTw7yAFqoWfIq1V0HDxdsSDNQfDKjpHOZiL9MYjg7JTPZrp84w4Zo+wiBD4mi9M4JRV/xg+iD4sLsppiVmmlTli9/xIVuRAL3Zq/16+z9TPLdCD9BwwPAB+GVPqtYWI3NUXR5/ZGJWOCWwv7y1uGuhBr8s/tRrucmkKd0rGKXVgYGmvrvwvufMwEgTlLnJDJIvbZYO6+6wl3jmboX5lF5cNLkP+o4F/WA
DKIM-Signature: a=rsa-sha256; bh=w7/Bt3TycCT1K1u24fOFFkzDbe41NlkwbsLDq3UP4wk=;
 c=relaxed/relaxed; d=quelquesmots.fr; h=From; s=ovhmo4049951-selector1;
 t=1790067052; v=1;
 b=btOoQnal1HWj/hiMcHpU39Ke2ICCZWeNVfLWKi6YSwXUlRCla4MHP3+C2yqsvKXPpdEMIov7
 MmSfqJp5n0PHAePUGyL943kX3xp6FxScv1Eyr7aqsBYK+Fr/Va9TylUdsQ0x3gZcseWfu/T9O19
 e902TbnOicWRGvd6AsG3EyYVNEr77IY7cbvTtOrv2zz+Mc0lmMtluXTo3Is4oGIoZuUFoUyEh6R
 +ta3ybyHjDThoPU9euTCbViAuEVsmMGBWq6EBpLfqcV5c+YkUbLCeQXxB3eplHtzeCqfgAox1e3
 p/is8SY/EuYObEa7mQbTovhzf9fclkUENtTM29G2JPhfg==
X-Rspam-User: 
X-Stat-Signature: 7r5gbeyt88a6brudwoisdiqn3d4yhg8g
X-Rspamd-Queue-Id: 67F0A20005
X-Rspamd-Server: rspam07
X-HE-Tag: 1790067053-356232
X-HE-Meta: U2FsdGVkX18GSho+QkF/WCOG3n58dQWdqZjbc9uQQpAzmfEvfMyJWSYLd80M6OnIQsLwyOUS/RELcmUyOYQAXQ9Al4UdTnjSBO5JDX+ZcmMgyLNWhtX+4xE4NQ//2FWkT/jOXbeTujmXI1jb0ezcybe0NR04IcbLwK9VZdEL4nYIXeaIm/hNlrEEJrgOf5OQRxLl0qjhVOqM+dWmN7jgbAbbas13RvLkseuCDlbLgL8cK4WA4iySIrJJcpZSgCH1l3VrDSItG9cb5tsM+7GjBir/k6BnXyPaADks4yA3Tfqh1uSatacgN4UJYMbQKTNHyC/gAlC23SqkECzAbzmtwytAsX4fASQlLJMvxvwCovKzcbeMdYTG32tfy3CQFZezCIesMwHCImM5qaYMDisIIxxED7Z4/WIq528LFYXsk3D779E63mZyEMNj29lPYh1RVoRG1PFc1B0+DXuF0OwxU2EnEEttgVaL6QJc0RSNfnmmYXp6p8s8yX9+ICJ+f2FnnUzGhlV4yox7mBV19tX9hOJUZIrN4/TrtvjiXmZaTzpQZKV6tmWotke9B0JQKWl/L+v56vuLaKbp/TRFsC2pRFfd3atFAEMJkg0/VsB1fHzD+0oPsfb3id1SObR0mAMnbAgAXfHm+7E4N8GzYHN4hcHhxEXkpU9/aDuFJGUahHmkYP1PjQ8hbDRTRc5PMtllNem0pw1owy0/jCcoxx5tZ4o/H7jEq2npqEeQfYpmWTAMMPB4FRhWV7i9fOXm911/crpGvB47FnGezRJjjzvculnDJanAes1fzXWYJd9JyhqzfMPzWRxHthaSGFOm1suRq+4bngTexS8hFmjFOPMSlvNsp/N1OPZ/8v+oeD5kfWxvvH2a7t0Z3eHm8nRd09Fpf6xheTIyQIgWxJZm2n9mt+8fiCr1mPvHcmBYFMZR0vXqu/aaFdO6atTEL/ZA4ZUkoFkALGEl/KLZnwlrNCU
 hG6XxdvL
 HKSDUF/fhJcVj7Wz9ut+YeqfaYHlNpwR3Y1WiTSKaOwYClmML+zwgy8ZhCjbfAZ2fjlmC4fLVoFQlTi6pI8xeEyHAo7kUeu4PqWPYveeXQPt6HEuYG3guXQyJgkLk4+lsNtYZn+zPdU8mybWbPoyGeEO0SDYxJfAURc+42p9yy/vlb+tmuoyhNV+DF9QCzotk/NF24lc7tFbRBZSAB6Oy/yJP7lbbfmRYQtJmILBZ4Rvt5uIegPwXUVFrptsz2jFb3TgNNDwUqpeEMPvieGevgyrQ+/I5T+mU+A1nPKCnCgYyoR1wdP7uvFaA/DzX88TaAOaVdyREFFdyyMR8EHcbNlEl8l+GYlM4WN5B5sc40EvMNgGMs3nMyQ4JTzegd0beEFN/Jmr4ro+ED6M8tzJL4eTc+u4b5plSCtUv/0yCMguHUOp1EWgzsQkhIoWp2ZyBpIuJFm6JSvf9+woD3V6B/andVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_align_mask() returns huge_page_mask_align() for hugetlbfs, but
get_align_bits() adds va_align.bits regardless, so vm_unmapped_area()
returns an address off the huge page boundary and
__unmap_hugepage_range() hits BUG_ON(start & ~huge_page_mask(h)) at
teardown.

Pass the file to get_align_bits() and skip the randomisation for
hugetlbfs. Reproduced on Carrizo and FX-8370E, both hstates.

Fixes: 1317a5e7f7b1 ("arch/x86: teach arch_get_unmapped_area_vmflags to handle hugetlb mappings")
Cc: stable@vger.kernel.org # 6.13+
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Laurent Wandrebeck <l.wandrebeck@quelquesmots.fr>
---
v2: put the hugetlb case in get_align_bits() instead of guarding both call
    sites, per Dave's suggestion to pass filp through. Masking rather than
    returning early cannot clear the bits: va_align.mask is an L1I way
    size, so it is a subset of huge_page_mask_align().

    Re-tested on Carrizo, both hstates.

    Link: https://lore.kernel.org/all/20260828135747.724789-1-l.wandrebeck@quelquesmots.fr/
 arch/x86/kernel/sys_x86_64.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..4c078827f26a 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -50,9 +50,16 @@ static unsigned long get_align_mask(struct file *filp)
  * value before calling vm_unmapped_area() or ORed directly to the
  * address.
  */
-static unsigned long get_align_bits(void)
+static unsigned long get_align_bits(struct file *filp)
 {
-	return va_align.bits & get_align_mask(NULL);
+	/*
+	 * va_align.bits is smaller than the huge page size and will
+	 * lead to misaligned huge pages. Ignore it for huge mappings.
+	 */
+	if (is_file_hugepages(filp))
+		return 0;
+
+	return va_align.bits & get_align_mask(filp);
 }
 
 static int __init control_va_addr_alignment(char *str)
@@ -157,7 +164,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 	}
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 
 	return vm_unmapped_area(&info);
@@ -222,7 +229,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
-		info.align_offset += get_align_bits();
+		info.align_offset += get_align_bits(filp);
 	}
 	addr = vm_unmapped_area(&info);
 	if (!(addr & ~PAGE_MASK))

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.34.1


