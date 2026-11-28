Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D9E606A324
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=SHOFj9zb
Received: by kanga.kvack.org (Postfix)
	id 2F6AB6B05B5; Sat, 28 Nov 2026 04:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6CD6B05B6; Sat, 28 Nov 2026 04:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCA46B05B7; Sat, 28 Nov 2026 04:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B21556B05B5
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:21:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD649A81B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:55 +0000 (UTC)
X-FDA: 85483985790.22.A0A713A
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C170340006
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SHOFj9zb;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf07.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795857714;
	b=r8Jez2RrzbwSXIwK4+pMO/A175MkCTERYF2agL9SY1FfOFQmpYIEUGJzZVPl0AIF/mW5Ed
	XuQTJeHLZGemhy/zRl578L3xkM1eq0XtiUPiwiQHGTIMTXv+pBGcoac/n9qjKwlgcQQadJ
	DW2B4NBv2qrtNLsMDyz/LhdEu7gJ/c4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795857714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yf5lFWivuM3/XS9YOi7vjzstZ6D4tWxpwOXiC4SyrQ0=;
	b=iZsyqieo3KPQ/YKarlrsX9k/SrHQv+LbINhtZTbWZDvieI9m2rgnsVrRtiib5rSmw1iD3P
	2z1yt7auv9ZUE5Jqr9pRHnetWv59wKi+qflXf0jqJEPbV0uJN4dynm7EdnFDU8hyp7xvvh
	MXOBnkdGO5gehQrDmU19Q2Mj9U/GT/U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SHOFj9zb;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf07.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b4cc793704so70129467b3.2
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857713; x=1796462513; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yf5lFWivuM3/XS9YOi7vjzstZ6D4tWxpwOXiC4SyrQ0=;
        b=SHOFj9zbUVlktwp8r1Uv2vc/aizV3Z1qD15jY9d9gf52NMhyjEsgwaDGEPJBjxkCwp
         89Wm7/iuW3vikHr4cRht7yPak88xfstwz2e1cPnKSimsmKCe+/6XvHh5lYjdQbdbHFny
         ft1H2BTIAG1SkYwWtAFNNpnk1GqAhWy5XeuT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857713; x=1796462513;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yf5lFWivuM3/XS9YOi7vjzstZ6D4tWxpwOXiC4SyrQ0=;
        b=Bs7cqs0wOIOkzhHBstK2hJYo39mlfAVnS66cz3akJuxWBIAbyVc+cYYKuWABa/duzz
         EVVEDdzvyEQlGKLY9igqn6TepId56fnQhY0S+95NoaB2lNygS6ZVe6VyrYDdVyrm5M2u
         qFgb3we4Lfn5slLKD3A2iBoBU6c7dte16YgSM2VbEcXaP4f6de+VmEQd2aq2teWoogwF
         UiQrqeQCM0nkyrQrQudMcXoTtCcj/7DoXq16i7cSY9A50svgcW8plYkfqhx5QskZvDyA
         rKDrnENdtn3ZpqwO2NAwM/BkeqCt0m1veKfZftuDJ/+GsTn6DBNl9/4s41sF36/kyOZu
         Punw==
X-Forwarded-Encrypted: i=1; AL+hErFoS8ibwZ2nHOO2rkt12Vb4ZOJt3qBW7Uu6afLgtIIhiemNWKRy6fF0R4iVb83q9GsrbZmIvWbY7g==@kvack.org
X-Gm-Message-State: APuU4Z/3aFxZSKIAyW7nQ7Cws8Vzgp2L3AGmRLAmiHiJkl/CtB7kO7Bf
	X9fKlTNErHLjDfcom1m/OSXfcHBAvLARPzdM/9jK7OkLJwg2fqWrQKByaVt2SLdESoQ=
X-Gm-Gg: AZFdTZc1OhXj+Ypj4AkyjWHQ8T1T2KgHch+592JLI85NF+Kn41Gr3jSfqwBIjG5b+Ko
	20sT9mOPQaShu7IuYTwOmfDhfwXHKU+or7GFTB+1yWcTJvOPJEDdn4WVlRQqRcFL091efDFhuYu
	U9q0FBVe3dAFM3SPCADDrFmLrLnqvtsXcJxTjzaV9IXKlRHGRDZl/nziZ6SOOjyomngcFPcm04c
	reWjUPPeMCofExiQUHLsAUsBQ37m8mA9+WbhObKS5zeG59ARZv1iH0MffY53+00+Dq7kpSlSRg6
	oCHSi7tfZkex+b88pVWQqCAVTSBTfsGK8KqKzdeUisuUPKS6NNiyqSN8hzoaLqj205u80BbI4rN
	s1Mu02ZVnergIPJLn5nQsECyPbSHwgqCKCXOLikdq+0YoJVKgYZcJyv+n1JCJn7E7xn9N9jh2nG
	9WFwCh8s0H/m1kBNDgdE3PhyHWJZgoBcQpIZm5uaTdMLsdpc3tRqdiIKbrX6XKMKGBpsT0J34lr
	kLWPLJjMsLp4ewDNhdDLnoJLTIRLSvSRM8+ltCdbOoWfOr8eCyNq+vukBCNbfaknJ95fQ78Rq/L
	hKSxAqEwE49yDvutSHs07G5dIY7hHnBhbhX8In1G2B90SOTljx2UZS4HavZ2EuOzxXCMErxkn6L
	GJrF+fwhBmB9CMKicW8AJ5ndFawEMR8+Do/m+q306ppQWFhwZ/3djXsdpMHEEt8sTS4hMPSn3oH
	l+zipQBb4w+neId22vQz0L1GHzD19Yb6NSWoHQ650t8KJoqcBNreSfGzlymlOEHit3UwGGQStHz
	B4GJMGx7oTSsJwkhSrGFs4=
X-Received: by 2002:a05:690c:7486:b0:8b4:d84d:cb9c with SMTP id 00721157ae682-8b520519ae1mr103219017b3.66.1795857712909;
        Sat, 28 Nov 2026 01:21:52 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b520309d3esm104901847b3.30.2026.11.28.01.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:21:51 -0800 (PST)
Date: Sat, 28 Nov 2026 01:21:49 -0800
Message-ID: <c9c7b0465b1b27312eaa170692836dd30541bba0.1795835884.git.chris@chrisdown.name>
In-Reply-To: <cover.1795835884.git.chris@chrisdown.name>
References: <cover.1795835884.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 1/2] kho: don't release incoming bootmem areas when
 kho_init() fails
To: rppt@kernel.org,
    pasha.tatashin@soleen.com,
    pratyush@kernel.org
Cc: graf@amazon.com,
    kexec@lists.infradead.org,
    linux-mm@kvack.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: C170340006
X-Stat-Signature: 1rbghpog1ye5718dgxf5fgz4fmsjjyjm
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795857713-265199
X-HE-Meta: U2FsdGVkX18y2j9s60RuNzr5jWfLjnKKObNBCT1BhXV6kXxszM7GrA6ZXqyRRr9HPANxrnZZg+0BqnJDaXdGl7uRoev2jdl7/oQj8fPSfqlXGq6I9ec8+ouGRhYLaRYuTFPNT8YOFoQpCfBHbhQvDH78Rmv4hsmjMzFyv0bQ+t7QF8VsVpv9mX3mOlRNCJk5kzDfh4NRZiibHAaQkNUHf2qSj2NK5VqLCUlWSz7dmOC5dAy4SlOuqPz0/Og7XXwaNLdzw5LVq7ACZVRyle6fkAcDeLuCde97cN7m1Z/jU8nDkhtnXUM+nM6XlTAJUwZE0UairOdFwr4a0BfF5OJHJySzB43eIOoJIsXeOOTO+kkUUKk7ISkrgkqIVc1jvbCfzfXBAB0z5NpK8IW4E6OdnzRuoiBgJ6ZrJL5xATGRNeFkoGDVByS+/waygVTVWMIlNH8SsE2KBNjJzfqPU5yKBOUc/arZJxHPVMZijUGJJWXXMMRpyqyYZ5A29sL/01I5rJxAffN4EhQbauYSuiue0yIz10BZBk0dJ7xz2m1wVDtB/hn4bMS8BmEM0hIiu94QGrgWXF53GFeO4qZ6i1l4xdsF54wJpjEyRw/Cn3+rRBsDpIBUs/UqifjHKYQvLUWjApIV7ZPBAp3My+95/hl5qGqESGCjv/sn59WG+H0Dgb7oaP+BQLQ9jXYADO2mYBVMAgrQtpXCEpzcmkQbUHVMoRbnwG6ncaGHj8AqS08wScTfR4l7LAYKHkhHCmeFDdpGLp6upao4BBbtuBCfecyvCuqPjKKzVcA8cH0DrWiiQ5Ut1BPxZ81skAEPluHagjyKEq+FNn0ylErEK8YbV6VdwR1+H9MQO3F/dnahrs9VsEWKTAkt+CX9oaie/VZRJfKduea7lPHMz4W5L8jO2Qa7wBd1UohwIrkiuBkj+ueBgDkoF69g8eXQqJonkzDvGINVBDXPVeLy6wb8fDTERhC
 pFKEEpxc
 uLStWwjeteFAFxiufehdgiCMpjzBW8EQmxb6IRmCtksMwRS6fJ1IaBL7madc5p3TF4JZEW4I1E7EFDWK3/YMpcZGOzwavt6flbwBS3820y3FK+con90ma/kDeEeqLn0dn28MeFexDl959R95lo0YSosjideKZm/G+R1Y1c/U5KAOxOTu72/jb76a+g7SJQA9/DyWyLirH6hb8Xl2sPI93YWrsNVpFlbbUlI3fSKPlO9fPs4xZ4grQ3sgj2kl3/RXTtuh5gymTEoRr0Fq9eKxu6S7CfSm6xXzfOmyPpEEuguT0rRZtNYNTrvPQGS8vYzlTijHAYBTVBEuYBp6OO1FJqXp4olSxczJtJXzM/zZtqKzwdd0TEFLPTNKcoF0B4quUcffPFvpdMkBUlGAGQu8Wuk8g+jWpFuxwSdi7hdzfiUP2+FVjKwpldEhrLsX44dOsFD6nigtO8sXD5CjJsIX4eBooLhfo2Cl/WMehoxDu+LFXu/mfkVe4eHvyhsvEWFK3UDOXiwyppqBCTXq5RVbQaXY6QaZcArW/8aVcML4+o8Xe6kWEhdoxvmtySATqh61ogu5I9AAvBiZnoTa2ZYargH+/xC/NNlYZpVkSGGybNIw53UPGB66oMvmr4ZES6h+Y0wte7yxxNk/BzEclv80hhFedf9Dgui0eBkaoCIV3pGbW1ezdPnuSods6MpvIVVZ58P8ialkUIcer9Mqbmn/5YsOSHEfSulniJTSstZx2ZEFBK8oZXOafFuCfTEDmeVqfw5Dul9ovP5op+sE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a non-KHO boot, kho_reserve_bootmem() reserves the bootmem areas in
memblock, and they stay reserved until kho_init() releases them as CMA.

On a KHO boot, the bootmem areas are inherited from the previous kernel.
kexec loads the new kernel into them. kho_populate() adds them to
memblock as free memory, because early allocations are made from them.
Whatever is still free afterwards goes to the buddy allocator like any
other memory.

Unfortunately however, if kho_init() fails, err_free_bootmem currently
frees every area with free_reserved_area() on both kinds of boot. On a
KHO boot this frees pages that are still in use, the kernel image among
them, and frees buddy pages a second time.

With CONFIG_KEXEC_HANDOVER_DEBUGFS=y, kho_init() fails if debugfs is
disabled, so a KHO kexec into a kernel with debugfs=off added to its
command line is enough to hit this. In a VM, the new kernel then oopses
in kho_init() and panics.

    BUG: kernel NULL pointer dereference, address: 0000000000000008
    RIP: 0010:free_pcppages_bulk+0x10f/0x280
    Call Trace:
     free_frozen_page_commit+0x1fa/0x430
     __free_frozen_pages+0x205/0x600
     __free_reserved_area+0x7b/0x120
     free_reserved_area+0x89/0xe0
     kho_init+0x301/0x3e0
     do_one_initcall+0x89/0x260
     kernel_init_freeable+0x1e0/0x250
     kernel_init+0x1f/0x140
    Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009

To fix this, let's only free the areas when this isn't a KHO boot,
because that's when kho_reserve_bootmem() reserved them.

With this applied, kho_init() still fails after the same kexec, but the
kernel boots and the bootmem areas are left alone. A non-KHO boot with
debugfs=off still frees the areas it reserved.

Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
Cc: <stable@vger.kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 kernel/liveupdate/kexec_handover.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 42c6609a1766..663dd22e7172 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1899,11 +1899,13 @@ err_free_kho_radix_tree:
 	kho_radix_destroy_tree(tree);
 err_free_bootmem:
 	kho_out.fdt = NULL;
-	for (int i = 0; i < kho_bootmem_cnt; i++) {
-		void *start = __va(kho_bootmem[i].addr);
-		void *end = start + kho_bootmem[i].size;
+	if (!is_kho_boot()) {
+		for (int i = 0; i < kho_bootmem_cnt; i++) {
+			void *start = __va(kho_bootmem[i].addr);
+			void *end = start + kho_bootmem[i].size;
 
-		free_reserved_area(start, end, -1, "");
+			free_reserved_area(start, end, -1, "");
+		}
 	}
 	kho_enable = false;
 	return err;
-- 
2.56.1


