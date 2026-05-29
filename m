Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CF8CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D8E6B00C5; Fri, 29 May 2026 11:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D046B00C7; Fri, 29 May 2026 11:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00446B00C8; Fri, 29 May 2026 11:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4E096B00C5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CF07160C42
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:30 +0000 (UTC)
X-FDA: 84820773660.22.77B46B6
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id A548F40003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tXxto+D9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3gqoZaggKCJUzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gqoZaggKCJUzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9tlxHwsxA6eqo2SKmJcmasVfNUkIRzlQyYjktT989Y=;
	b=cgEZxETJeXWV8ZLWBwOu17l47LhVfsHbkUQDXFm++2yPMP4+OrY2OLxdE89RhQHDDG3WFo
	idkzqKruRoH+cYsUxMVT9quqJzTx/HMjVkfyFsD3TmcEqaD7C7mOEX5JT0w/T+Rxf76xVg
	02GMxs0hTXCiWw80fuagSZYc2dk+3YI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tXxto+D9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3gqoZaggKCJUzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3gqoZaggKCJUzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066948; a=rsa-sha256;
	cv=none;
	b=vG0sqtty5HhH9w8UjCFL7HQbBBVyL6rST76aiH87ACWg1MZcznDa2nC2y53lAzfcJu0753
	GG089zSzDeCHgMkswG/DUJ80ST8kn/TsMyiYQtTSWX6n991dNGrJ/RGoddvzFZdBJJ4lVi
	aDp/hvtMFp55bk4pPn+SfRD/yVK1aG8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49058e91639so46546335e9.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066947; x=1780671747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i9tlxHwsxA6eqo2SKmJcmasVfNUkIRzlQyYjktT989Y=;
        b=tXxto+D9u80KXyemvxDZEoMqoAkZ0IUArYe0yej+xGYACKUI1LBGmFF6Ir47Lqhto4
         jHQUeOLpzLkmzPA6msG2NYUuVZf2oAkK5mVBKxd4FN9Q6Ot4NTXGoCc5Dj6oChjAV7ms
         Msze9IYn4NZ+MXeZuYcSpsg/uiG7XReBKxyShKGsj+Vlc+ZbLmyJ0dElCHrgPWWoRQ9v
         Ez5hIh7KgLPZPjSh61+AdpmKLZi4E+tZ7Xs7JlXfJLzL5lU3um/rK+8Zgtjp4PJDsODa
         D/tq4YjeQxptW15OW/qwnTUILzQCPXrkW82QXI4Idiko2XVpBDmvNIbUSetFs7AAblc3
         2aEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066947; x=1780671747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i9tlxHwsxA6eqo2SKmJcmasVfNUkIRzlQyYjktT989Y=;
        b=pn9x2vvF35WcNwQ27pVpwp5w79WrUQCFQ1mGVe+iUY6DJv0UGDTg0sW5PMAIiLYqEW
         ShdiQNpcXUJUjdKMX3aAJsvsPeJSfmM9+8KhJLvk9VRUyb5Uu6G0/c1luUan3KDNVPFl
         rM9svVk5XdrM2/JjswFWbGWlSsTxpetOYMvzzg/8R6TQbk+sdfXmgJQlJI7ZXTWLxGSH
         /xbihdPfX3FRimc+6i/SM0boQNaPTTkvPmrMrz+AZWvSzH67DMMHxcfAP/9w5y/50NVu
         vKh7dD6NxU0MoGk9FBfjQYDyS6Iy846N1ct7kBnpBPI3QM82flazTeAFokLvnVXKNG8i
         Z4kg==
X-Forwarded-Encrypted: i=1; AFNElJ+EzYEn34j12b5UOeczuaCm4ysvVw87qRbMSyUz1KRQlp01IQuW6x4YBXilS+lIv2hjfLszqntcSg==@kvack.org
X-Gm-Message-State: AOJu0YzrkbQm9hvCfpxVhBgYZa97cdPph+oh9F1IAJ35wRh5JhIgXYZy
	+sIZNNnZi0fNGBL7ERMTbMqFFYn0pFuVazW5VYqWp2t55SxfiVmIpnHBXz/uwK/+li9e/ZU91g=
	=
X-Received: from wmaq22.prod.google.com ([2002:a05:600c:6c96:b0:48f:dc9f:6f14])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b14:b0:490:4b89:5361
 with SMTP id 5b1f17b1804b1-490a2904d7fmr303015e9.7.1780066946805; Fri, 29 May
 2026 08:02:26 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:59 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2952; i=ardb@kernel.org;
 h=from:subject; bh=TyyULer9eaKHyQ1BOINcFoCv1vvnMukGL48REtJhPzs=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVUboiS16Xkfr8iLbWErOKcytU4vuVJk0+76BcO5Hz
 rb1+sUdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCKqGxgZNjU07DG6GaTpezdh
 zbZrEwzidjxa865atLfK9/GeO2emyzH8d7MLuK/p3ZH8ib3z+D7vti6R81b7wgsSZrk1v7x+zKK WEQA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-25-ardb+git@google.com>
Subject: [PATCH v7 08/15] arm64: mm: Permit contiguous attribute for
 preliminary mappings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A548F40003
X-Stat-Signature: 6jyese1q9x8sdwixigh63j7cqte9fp6k
X-Rspam-User: 
X-HE-Tag: 1780066948-588579
X-HE-Meta: U2FsdGVkX1/KTGM1zikIJ8N2DMM3EA9VBsHfkRxmT44WWxbF+UmdNOh50pT4EjYtyUFpGeNlr3c3tllrhT4XazKUkZ8l+uJO02+Uzge6t79KYt1vfUwIGip51VzO/oXbHYzB354rffflskbdQ8VHJUUDwK5cGlIqP82e45UrZ8XujtLGNMco7/0K68qFylLBCSDBcpx4NS9FjLiEjgggwNagxnkWqZLctBF6RnYg1tfpH+FvEfcMGGTOWVMNS22dJYiGohTGzhQk8F0GkFIj2Sl3uo9B/l8aszICc/ak02FRwSAZbVZ9QeXZjeScgaCbPsivTDWR4wL0aNgWPLRwXDmYclyUs3/myCNjECexXOJMcC/uPynXYLlFk34lADGXHy+gz5Z3cQoh1k85/joSSMkiWze0hqb7XDihtYcwa4V88Saga3jCJL/KcB8kG+vjAXYft+gKCpzDdTSsbwzRVPUQ4m2ckc0gvgDzxCgMxFHKmB8IiGRLVWztVU1gFjpeS9VvZ7Q1HH0Fw7+k4GIi4iaYJif7LJM0iIUTf7E7Y3ARJpyyAFIK1kMc4FNFPscPo5WF44DfHFX0NjQzvErr2aHE/UppEQ7UiTOcGvtV/KQ/N17A/uWyhkWJbDUKYycuGa5Xp3vfJjDJ6LdznjOr3gdmHevafUb3j1K1jqmQvUzgHSNjGbhLpdUnaKlPswKi8dHGg4uC1L3BpAFSWXtJ6wSVmqRvxbKgPd+its5bYRpN7k+K3Tf8MTKvE9zQGYLMV2SGe5bws7jfPcDvf2Vs+ISY32CkejhlxFSdELyCxIW2kzu9M8mslrbLJYPZt80PquAZHv6FvT+2VGr7giOhwHX75hvwVw5/2UB9ph29bM4hqgny9i3k3SHD6OQfPnbTDklaLe6lrT8YfqlL1YTwg5eqDyqabFPRrVy8YLwcnksGA0sDxKzBHXVagUmwrJ+HsnD/rHOjk0mC7mgrvMM
 eVWc7gLs
 yJuMWF/5FtA1SbSgAgKoJ5wURCnJNLNN4TK6jB2uco+2HTql4Oa8z8039X73Nb9n7JY0MXipxm6eWHXOF3JLjUCMSLhhjRnYp3tfZgowVbN50S+nLrzjB6DlN7UwsSo6vToou1Z65RTLbtFPEY8DFfuseTYWMThOVV/OfFVQ7H0GVAwFWTjLG6uJAck5eXQQosf+K/8TiDo1/Xk9YtrQCMZbUzFw2K4DLVKoFfa3alHTwo49BsjGb3ki+CLgdIldx0a6OrTvxJBfyjt4pg+PKGhETABxSz3SFrWB+XkDDpimbzkLcHKW0Dlv21ijMflwFMFagett2IACd80GVv5KlYMcKpWMJaeE4bwiU1ff3+01PGW9Ju5rd8CnHc0ubzP+W6fTv7j7yyfS1aGjuvZhm66k/iFEbuOSuX28tin/WvFIer81ZjW3Cz7Xe4GFUjsKa9LdcItyublzQJx5ttmjUnJS7grneOBPCwS5Fr8n64WnknGhlhxxzOD2rIoTY/C9Jh3R+P0DWqeZ4lvNnrlRu98PwNlKtWORzW157bsPaAz5AmefKZT+2HoKunmsW7Y7D7W0Btvgqtaz0uVcJjeXkXC+CSsfFiYZupeOefXp+pWTHd+c8RfpGRHx7qf6mCqA1heuL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

There are a few cases where we omit the contiguous hint for mappings
that start out as read-write and are remapped read-only later, on the
basis that manipulating live descriptors with the PTE_CONT attribute set
is unsafe. When support for the contiguous hint was added to the code,
the ARM ARM was ambiguous about this, and so we erred on the side of
caution.

In the meantime, this has been clarified [0], and regions that will be
remapped in their entirety, retaining the contiguous bit on all entries,
can use the contiguous hint both in the initial mapping as well as the
one that replaces it. Note that this requires that the logic that may be
called to remap overlapping regions respects existing valid descriptors
that have the contiguous bit cleared.

So omit the NO_CONT_MAPPINGS flag in places where it is unneeded.

[0] RJQQTC

For a TLB lookup in a contiguous region mapped by translation table entries that
have consistent values for the Contiguous bit, but have the OA, attributes, or
permissions misprogrammed, that TLB lookup is permitted to produce an OA, access
permissions, and memory attributes that are consistent with any one of the
programmed translation table values.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index cdf8b3510229..971996e46fd1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1016,8 +1016,7 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -1044,8 +1043,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -1191,10 +1189,8 @@ static void __init map_mem(void)
 	 * alternative patching has completed). This makes the contents
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
-	 * Note that contiguous mappings cannot be remapped in this way,
-	 * so we should avoid them here.
 	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
-- 
2.54.0.823.g6e5bcc1fc9-goog


