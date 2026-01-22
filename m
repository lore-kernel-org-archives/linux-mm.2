Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A10D3EE67
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC206B01F7; Thu, 22 Jan 2026 08:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF7A6B01F9; Thu, 22 Jan 2026 08:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909C46B01FA; Thu, 22 Jan 2026 08:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5C06B01F7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:36:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 285F48B380
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:36:53 +0000 (UTC)
X-FDA: 84359700306.20.4748FA9
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E5FA1C0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:36:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOSLAMh+;
	spf=pass (imf20.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769089011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=opvHDwiOpdiGMuXFIvJiRhV19eFW2enM116TYEfgc4s=;
	b=69dlM0uv+splxX6piepTUfG4XOaC4EuGp7Z7jRp300R1CQBYookfOha7hkXhw/1kKBSVn+
	3aONVSbvzH46L6GysU5JQaz1BJvjuwicshpXQiWwrQ2zsyO9huCr2aRiXZw/u4MJBWlddX
	5Cwz0ApYlFg3ynI/oKCPjyHtdBnnNSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769089011; a=rsa-sha256;
	cv=none;
	b=8SWKfICSt5qZQCHOGnPPQQcLq1IBwVyJxS0j6PptywD/JAOoqUYBbxZLvhu5P5EJ9dwTCr
	03nnUvkP0rfeeIg5b0gLUCSqmXiKyTYNQZNhknqw4kbIXE2nZYJuGQuhrCueh7ZIEICbpB
	gJ/oHYBuFFvHeZr9NBOfy5TTwnJMuss=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOSLAMh+;
	spf=pass (imf20.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-12336f33098so1013731c88.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769089010; x=1769693810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=opvHDwiOpdiGMuXFIvJiRhV19eFW2enM116TYEfgc4s=;
        b=SOSLAMh+6x/Wsviw6bpUf76oXOuLyplgU9ukiy+9YmXP2UzfzIPtGZ4daTI4PVba9+
         KnSjTTZcqYcVdx9M7efIQSi+vQByJYHuQzmKfhMUlnjniuG/JtmExJni/LMeKcVVAj+b
         4Z8JJQdB2V9grXg2oG9cvPqN8FVngDLqIS7YIIe8EsJJ23ssbX/ZifOB0u8v/RiE+zdJ
         hk2DuQ4/NW2Ec++FjYQWulq1hoYtfvnZ92BLxhCbr2kMX3H8TEDIw0on60g4B2oa4MAJ
         NuBgn/XVdJiZU7LesxT7vogqBqy/VqkpsDaDM+fJKQ090Qal2k0O2zHhdBdVSXDoDkkW
         Mj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769089010; x=1769693810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opvHDwiOpdiGMuXFIvJiRhV19eFW2enM116TYEfgc4s=;
        b=vWJ4+FXHEdOz26wn/ZK14sXzpC81vSOwjQGuo50tknddO84Fbu5bwCx7N6Y/AwICZ6
         aiaqtBhexK1hXpy5a88L6FgHlgJ9JHVUQOsEqsCNngpf41VRB/IHuSdwNzp664CWvZs1
         axHHjoSKWodLGWa9FfAgHSJwAq317NTwLVzRrTaF014InKdwXY9EhpTv0RvXPLqSOPLE
         XFxR9xxh4qoprRzJagk40VdeO89VNpslwlMWUW1fVXiAn7NJ5hCjp6OVYKRDuPw+0ubC
         8fP7sVD87KSRrQJ/FSFSKUMcqSlje2ch2Z0ntMGSZuRpDHbuLbKfv/5R6jLRAb1nnMk+
         nVig==
X-Forwarded-Encrypted: i=1; AJvYcCUco4AcVgNZX0O5ID5yYvoLsMyYo71v5dQPdGdpPxmdvRA8UcJxLjPcGRIrLySEuWQjdVmFDts5KQ==@kvack.org
X-Gm-Message-State: AOJu0YzEHYWET6x3I6veIoYO+x7AlLeIXfej4dciQqKvNgXH8qg1YlCX
	eO3pOsIPAEB85RVCKViWPT3rxKHOfvxa93IHle3foZMQ9glXKNfouc7r
X-Gm-Gg: AZuq6aJWsnW/Lu5+yB+cqbCVdrmUEHmv4WHx58MvLv9MwI9Yd3hmPdjkj4Sv4SGmMpD
	oaSYb8hMZXdcHsrGWbbw0ll/LRyAIcXEcbzjyDYf1E2x1+uqghNF12Cx2IEZVg/BmbwZ5QELOBL
	duR8lpy3ZWE/xKcB41C9KwAnwiwVm10s0ly1Uktl0HMU5Sp8fj0VdZuAaVEnhlcsBsIVLOd0dSX
	5NJ7O+JuwIe57IOzfiG9TbEq8pTEvkI0xU2MXK64Iqd0brpFVDWuUQm8CYWyrnxh/M6kRdSyb+C
	ldEbesMu1asI16fb7c9d26m+voz7vVI/gF8HYw4HQxrDpFoTwsMFKrsfiLqZCB/KSJ884tg/HKS
	xfFxlmVcPzVk12VSpFIm+fBZqswuNtUt5qPClb52r7CEnQgM8JlLk3mi192fg5f8TkWC4JMOqYX
	dWQvzPRz5rDAQPzfwhB8g2ACQuzK4xKhep7LI=
X-Received: by 2002:a05:7022:b8a:b0:119:e56b:91d1 with SMTP id a92af1059eb24-1244b307e4bmr13222512c88.2.1769089009918;
        Thu, 22 Jan 2026 05:36:49 -0800 (PST)
Received: from 9fdcf7ea0ed5.localdomain ([38.207.158.12])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af108absm28378188c88.13.2026.01.22.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 05:36:49 -0800 (PST)
From: Wentong Tian <tianwentong2000@gmail.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com
Cc: tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wentong Tian <tianwentong2000@gmail.com>
Subject: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Date: Thu, 22 Jan 2026 21:36:33 +0800
Message-Id: <20260122133633.79792-1-tianwentong2000@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E5FA1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: w1hscghxdrcdgkw1didu86qn4jbqpour
X-HE-Tag: 1769089011-126555
X-HE-Meta: U2FsdGVkX1+W6sLsBkNCoXjLFUorY6Odcd+l2VaaOL9G4mmvd2ichidx7SS4GHyCXPqOizoW0/CP/IynfFK6cel1RyNphLAkgC/H2K2SKWhwxEnybwFc1d5hldURbpr2nlC++FYk8b5JiZ4+4AxAvUrymmM9kVrBoTR5TRm18j0+UniDtStv4LgGfwYYj2L9tiYEM1jj1GOOqpJAsyAa+m+8s7UJILp6hFNG/I/2+uEfJa7Qgcc7i29iFUvFzXtqFn5Pe56B4hqCGup06MHrhka2+9Z1s3TOvQQFMXLEeVbynr997c7kbwW7t02BjjBS/QVmnPRHrrmImiQuo508rF+AyQA/vlJxwtyBeY92axJb4PzIAJEYg6guAifIoAskq2HhlWG/gq+g+cLe/FNT12kcYN4y7fx6RNoshJxuiTiyfdmMbDwzkvuVxHcp2r73QmpPE5THZsgBmAY6H5relgJCDmFbYBxDYNqfQU6zu8rVP27N+EX0SDL/JDNPqBNRbMA+nviKTDpoSfVhDpHP2/Z0FsuIkdK55Ehqi3uBu+mmXm8gLrFR+l5KixAtsGyTdH31JQOIGG0oe5AsTotfG5lUTFuBLh3+RsTm2E7KrFSwmryHwvLPa0oQ9MLvPzGgmKL8IZ4SOBsG/6DTHV+ANhgPjXqaWKfboEYBTA9/fFo0vkgjV6V26aJHiMPr7FknpIZarH1kt2HUSZ/VBmV9v/idnoDIrLcUgIVBflkJ6a9UXKSMbdGHXi7bLyuBTcn7nkWdXWX3WivNma5Lm6Ii2LGeptqRzIV4m1HVcD/8CtNg6j0a4XEBy2UkQignP6J1e1atRfXJDZbbx0kpPUgKIMzGrYbkeUPQ71rwFGFTuSVW7pgW3OX0eQNGK+AGMuFSzt7MRSpwtG5xsgTB6WL+idjScnGIBbbyfIcgom1d575oN15sErj/XXCFs0mvPGdY6AVtcYc0zjSz+NdVilW
 Nzo+M+Hd
 6NNXehsHPSoTDSeJYBQKE+Tpf14lMJlvjyFxOOnvtiMitxlsWg4P7v4YfNOhzdL0ua1D9HnvfPAcaw8YT4o7HVjX//56bNDsYpH9t9oL4uKp9kXqxcPCAKH0lQJwTWxGbFozW49MGKaUCfBbohHu5gODjPRB+2YEZ7K87HoJauPU/lEG0jUYsZuv/vWHVcZMPXQOP7UPPiPp5/WYScg/VRrtas7O1MycssJCjybaN6EQju3w+EWniHWH2GKgDLS7j8MsLCyzE+FzHHojVoPV94zlV+Igi+DddBRe49dFcg3NA4xmqUrqSww6nKH3VHluxIjZymWABgOnZYKIAPE4SkULIxAWqH/3h7Y2ChPrpOuNe7l0eEZZiREtI2A5bBLfjp3iiVH0PnELxSFMFzI5ML5boVKUefWf47tSJTzob7IY6YSkaA5O0WY/uiOW8c2q3cYiOC9vzBaZq3KlUlfT5eywMFWOGtlbGObdNhzIyye6BswIvrbg6TWsKVBi4oyGgJQF1VybXunyPYzOxv7lajUJ2Y3jeICtKA9W6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_flags_t type is the dedicated type for virtual memory flags.
Architecture and driver code should use this type instead of assuming
vm_flags is an unsigned long, as the underlying type may change in the
future.

This follows the cleanup in commit d75fa3c94750 ("mm: update
architecture and driver code to use vm_flags_t") by converting the
remaining vm_prot_bits usage in SGX code. Also, update the vm_max_prot_bits
type in struct sgx_encl_page to vm_flags_t for consistency.

No functional change intended.

Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
---
v2:
 - Also convert the type of vm_max_prot_bits in struct sgx_encl_page
   to vm_flags_t, as suggested.

 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 arch/x86/kernel/cpu/sgx/encl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index cf149b9f4916..814edcde225d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
 						       unsigned long addr,
 						       vm_flags_t vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
+	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *entry;
 
 	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 8ff47f6652b9..0e0b97e91905 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -27,7 +27,7 @@
 
 struct sgx_encl_page {
 	unsigned long desc;
-	unsigned long vm_max_prot_bits:8;
+	vm_flags_t vm_max_prot_bits:8;
 	enum sgx_page_type type:16;
 	struct sgx_epc_page *epc_page;
 	struct sgx_encl *encl;
-- 
2.34.1


