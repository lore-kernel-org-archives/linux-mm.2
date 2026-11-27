Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC589606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oJiVjcfZ
Received: by kanga.kvack.org (Postfix)
	id 8C40D6B05DA; Fri, 27 Nov 2026 04:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E9D6B05DE; Fri, 27 Nov 2026 04:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7205B6B05DF; Fri, 27 Nov 2026 04:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39BB26B05DA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:14:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C239A1201D4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:14:03 +0000 (UTC)
X-FDA: 85480337166.07.B07A906
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id E53CF2000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:14:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oJiVjcfZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770842;
	b=O7wXAB7Edv4Juf3172ZouwmkhUUydI7qWhUYlZupk4sOzmr6mDYQ05LvTebBbsEsjqIewb
	nux1cc4CWiA/jCO4Cj41nYMY/q0j5Lgd8kXFzedUV8JsMF8ZLXIEnwLqWhJ496z/nnfueQ
	5FymZzk5/Iig0E86sIPVysCF0YU4ti4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kjuxamo+ARDPfXgOKJZvTzyyERo8tzr4IQwkyrTwCo=;
	b=0mBae+HcBHRAc35HkFr4M3H3tcqaWG9hrQ+nc7uiNGmvt20cn0JmJX86EtiRTrHwzyqxJF
	/dmD6FzG0YEQvVI+j3lPhznq+HZbiCYHwC4ofVKfqLMadORv5Kfb6aYio7qexLhAirCbbQ
	1RYtfzCbIEEkkQE6lDZRaM8Lbz+Cw8Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oJiVjcfZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of azpijr@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b88d143160so9371212a12.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770840; x=1796375640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2kjuxamo+ARDPfXgOKJZvTzyyERo8tzr4IQwkyrTwCo=;
        b=oJiVjcfZpULXhDi9zhjpIGf5q6ZKMyo0SWKYQCBeOD2DWbfimop+GJ9R0KMqxr+5Fv
         D65EgN2YLxwpDCyX7TxjiitIrqjI5C9SH1otdQ/jRhFQ964B5bIePDayaK4L70734SUg
         bX4gbRQXXt7JSvPNF1d2CaOSeM18FvcTm2epQaxRDiAl/zUzWEiXZOA7UmesGp5d1U8X
         5FMMciBFNTwdZ41izn6c082sRgU3qAAKUMQkQrOqrRklO6sdV/efwTr5BHluhUSb5IJR
         hF/zgXSttfq52PaXLW7q5sH3eV0x57UIP2YMIFs895CxzHpNiNPXtic5/deJP2mE5nsc
         REbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770840; x=1796375640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2kjuxamo+ARDPfXgOKJZvTzyyERo8tzr4IQwkyrTwCo=;
        b=qduJMgrLLElfTsu5NMKqeubUcVmXgu+9QUHQAprZIWNw/Ytdv/XcpNX3AB5Im+qEMh
         6lKZHciYKzsZryhD1fsVriruCEJxBBMCHKWz49EdwvZYDw3y9u0FMCw4gRzTNcvTneKc
         d7rXya2A301cP9KGith7DRk61w9HB54cWh4j2dgZy6o40t0B+o5WKABupAujdO9P/XPM
         R8G4oVQnNT1ZEP3Xp0xl7xNIhhkUbQ0MJVobUPENEZHF/gBKqqy4PLXYTj7ihCzTXaZD
         2YN/A6F+Bc0lb81vJVofyBRnDu3YkZpfY4tQkN2IL/ppHi/Wrs821Y924DHs4M7jUETN
         D8gg==
X-Forwarded-Encrypted: i=1; AL+hErEgWjgdYGpXEkaFq3fbaaIifWVBJ/7LzvTfcCO1RlY59pfUBWqtIS+jMRLDRc4uHPa5m1iWbDHHGA==@kvack.org
X-Gm-Message-State: APuU4Z+DORjIkaOsO0K1z4s6NzkLkAhUHO5u+vOib2+164d3e6ncBZwt
	RVsyK5gQi38/JxpKOXyqgiiC0TYaTFTPt+avIjG/r+ZaWc3a2hSQfN3W
X-Gm-Gg: AZFdTZcofIMej2bavA0wwBB+tF/ISIBJrThbCLed3WA/vSafjq7CiMGAZVgHonXFkoz
	qYRHmqjQMP+DZjOCIf8GTnsAicDH8bR+2lQJPiIPMiQuryV7nRf6Ho/VOo//I3EHYvRtHhuuFmy
	4rUgVOfNJZmdM3atJysYrN8LbRzZL3BxJbVtnLswB0X+MqMV6VVoNsI0RArgD1Gf2LWJikaXeZ6
	SIy5Q+AzvRTI9vsXUI6xvGjKQPN7DorNdtTkAxuPed8x2n/7+QEWDADOp7VrAtXOuBnHFSEc7q9
	fj6VSrVddKNLgNg1AhoFpbsvDUxsIQ/jxVDBrOeCAiQFqGszpa8pmwNdIMUuk1dxFkF8fCV4Nt1
	WhjzP1frNFyYBE3D0u48MJSGOU2s+WFOx8xsSaqPkplJFIytjuhZuOav3X0EgKDYZSTG73pAKyn
	Y3P+UoT7HRWXMB7qq3aYGTD0NNmIZ0IChJL5IDIOuHQy0jpattnalEslKwTP90EvIZvbQdfiYHq
	U5aq7gkHXoILKAha9EAEs9M25dxeBrzvnjQXmsKyKTt7xkdxSHMwAYrgnWf1yJT+u5b8J5V5Q0K
	5/2ApdCX1j8E3A==
X-Received: by 2002:a17:906:f5a5:b0:c36:7579:fe6d with SMTP id a640c23a62f3a-c513a88a87cmr2056869566b.11.1795770840460;
        Fri, 27 Nov 2026 01:14:00 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b1ed8b6a05sm26067087f8f.43.2026.11.27.01.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:14:00 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Hugh Dickins <hughd@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] mm/memory: don't allocate in finish_fault() with the folio locked
Date: Fri, 27 Nov 2026 10:12:16 +0100
Message-ID: <20261127091344.113688-4-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127091344.113688-1-azpijr@gmail.com>
References: <20261127091344.113688-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: zh1jnc4tsmwehuywiww8c7c1mskj5jyk
X-Rspamd-Queue-Id: E53CF2000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795770841-748299
X-HE-Meta: U2FsdGVkX19hmhu7G+zn3oZ3o2/hawQ3ox5GU+aY63BMCayt6B3U7bORZFxGysL24Dk5bosfZhAV15bq1/UBR4wQLw4AjJAoub1pDCkxPEPpamT1LHlVWC2KbTWTb2VobgusBDqKYJRIxcWRlRRtnp0jZqFDpv24iU7Bpbc984xPhb3GZ+gkTdZsc65Ko9uJAvSYnhWZ5cEjRo9qwhLE8CzQx3Yu95ZYvMxFCMi269OicIkGYZyNWmfB5y+6jw2XwTPo82KAuckawKYNBqF+yRIY9p7IWLOYNtxDKmGGG8B0xl5zSQFeGnDUsY6WFs6NR/9XEFZpykhF7OEl5h8QC63qFtDL/lKAGgBpzq94yoa8cWGlyhp2NIDgrynlG3c1Wg9NdkWDFi6dbhCkk0bFgMU0HIN5eLq3wb4v1Gx6Kcd65keXrkZ3LSMRiyCV3oNkbAPGU/6VglBdVhY2wKWqTsANmAxd2tiUJlFYruSp94WsP5cb8EWvwkbiI+0ACCcaXSdSC1DRk/7P8QX0eQITxqCAgpW5ur3oVFEhX7bbODSL7lYTM0RcCYrmOmvTl0eIa0MRvm8a/A0XQy3qMhHM8T+KnBIGpA26Ibg6tUGxnID7rIiZfuj1CRMMrDDHs3wyYYXClXt4YLadxD1bhuL54gV1KZ+IruUecFKLnABe8Ctl7KUl2tYkGLnuTVKLeG5a2vHm016GqUO8xH63o8oe8RxnDrUDbwfOmRfBFxe/HQ8l5bq6FzGGZMihnpf8AHEqzgZdtBsJUdxblngmTRGA4fjqQZVLOY946ULHb9jiCIuwE52EL8a0D5tLpNPDfolqKfCoH7oRkJwb4g5ul+GwQ1rrIiNXzrgJBtfegLvd84zUN9x0GMgjCXCPOJtVa7AfxPMkx4Exor8k/XkcyP13qEo8d6NyQacy9Ldut6WAjxIXgtsxLptG6zXc9ecV2PtD5vss+WXFp2HPLxqsO53
 0nPBBtDG
 kuqjtOkLwdnclGKB0BntPwzKhCYwBzERItKZCF5EIQISQPlGnUA+QCDVh1gpwKGySn36l64f1Taa5CD8KEMctAvVs45vkPtQ6RfvlhSRR31AIQZJaOO/l2uA+XjhSShx3UMW9yMpJH0j84Hwbt61ETix82waPbZBjpnunGSKhRQIgsdsLeuT0erJlQzNIH7ojkYq66PXJ1JruLRkSScHjDfZw0YMNOUVkUVg164aKViejSiHmW/Qg/cdt6R0OTeLpJeaZebI58dJmTZ7mJcQpsrlRxxDRR/tPHf/6nTuspnZN8ZTUlNhLkU9eDzUdVtq8VDGKgq0b/phK7OkkQP6crBuQ82WG+FbHoesnewDlLUr5iO8nhf2UdNwhNQysP6ERm5Ql/vp8U/4cdXBg+w0DBIauIORwApAwAnS10DT4dNVjURVso5Q2gMX6UzsZ0upt0PsQQ6VT1g8MrLTz2VZ+dLxSKPCEnAbrQaNm1RcxjNrsHRG/XPDGfsdbV5PBhm25sR1UprziMIkE1LkP90KOOati3+yMM1rIWfrLaHLqtI/LjBmBDTt/pVp9+J1Pe5NK+YhZ2os1mO5iY7cPypBYdLe5UtKvKHO9tXVzYQ6nlukZvrPy7+VnXJw4ZrG2yf1u5veBYWwxd5iz5ftPBcV/o80OmtBb3+fWeQQZlM/WxoWdgGFnamYQk5yvzLW+xjKAL0Ju+LA2E8KTruM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__do_fault() preallocates a page table only when the PMD is empty, so
that finish_fault() does not have to allocate one with the folio locked.

Since retract_page_tables() no longer takes the mmap and VMA locks, the
page table can be removed while the fault waits in ->fault().
finish_fault() then finds an empty PMD without a preallocated table, and
calls pte_alloc() with the folio locked.

Allocating with __GFP_FS while holding a folio lock can deadlock in
reclaim, for example the memcg reclaim deadlock on cgroup v1 described
in commit 63f3655f9501 ("mm, memcg: fix reclaim deadlock with
writeback").

If the folio can't be mapped with a PMD, return VM_FAULT_NOPAGE instead,
as we already do when pte_offset_map_lock() fails. The retried fault
preallocates the page table before locking the folio.

Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Cc: stable@vger.kernel.org
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- return VM_FAULT_NOPAGE after trying do_set_pmd() (David)
- drop the ppc64 sentence, do_set_pmd() is handled on its own now

v1: https://lore.kernel.org/20261125100058.15200-3-azpijr@gmail.com

 mm/memory.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 05d03b32ce52..dd0cb09ba7ef 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6000,10 +6000,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 				return ret;
 		}
 
-		if (vmf->prealloc_pte)
-			pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
-		else if (unlikely(pte_alloc(vma->vm_mm, vmf->pmd)))
-			return VM_FAULT_OOM;
+		/*
+		 * The page table was removed after __do_fault() found it, so
+		 * nothing was preallocated. Allocating with the folio locked
+		 * can deadlock in reclaim, so retry the fault instead.
+		 */
+		if (!vmf->prealloc_pte)
+			return VM_FAULT_NOPAGE;
+		pmd_install(vma->vm_mm, vmf->pmd, &vmf->prealloc_pte);
 	}
 
 	nr_pages = folio_nr_pages(folio);
-- 
2.56.1


