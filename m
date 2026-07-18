Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3368C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6EE6B00A4; Sat, 18 Jul 2026 05:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C980C6B00A5; Sat, 18 Jul 2026 05:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86666B00A6; Sat, 18 Jul 2026 05:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5836B00A4
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:57:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF4B9A099D
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:56:59 +0000 (UTC)
X-FDA: 85001443758.08.2C8BA37
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5572240003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:56:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fE6VzZVN;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XHtCFulTi7QuN+vcsXlI37N2cwZV1gauKNkUTz4LeTU=;
	b=VSFq79WmN5/gATnhBfJVPOoHHDqVoDkxmc0UhKLwvKuwmFOdNUhWwzqIjnrDV81/3pe/lT
	p/U5eYWDgaffUmwOXGo5TwBs84F/1GZHvoCoM5iu5Gs4whwpyAYJlLb3v0aOHdotG/koy0
	jjxUfw69QmLfmyIYVDn16AGWYFvg2jc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368618;
	b=6NrOt8SmvXrkmz8Vv6eCSeo0BsH82FcMJUBOiWVxFrElH/aaAgJizhRZUPh1fG1tkJcrpO
	E6aJpJKydCd8VT+FTSgYbAk1FtULlmn/1H66A5H1p+za0C1ouPEp8mV8PkzUFuIyq4EDVw
	kHyD/irwPRYKDenD0EE795ffkMTBk9w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fE6VzZVN;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dd1cc8dc8so818005a91.0
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784368617; x=1784973417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XHtCFulTi7QuN+vcsXlI37N2cwZV1gauKNkUTz4LeTU=;
        b=fE6VzZVNvoKGhyAUCgKUjYrvv4pE3wmvjXd/XrpZAoMxpSpR6UANQxqmGMMa1g0ytg
         wm3PHv4ySirK9WXaPBWq9QyzaNI0ohIG09ub6yyu18D9UDF7YeC5AgRx6Ul3uyy+LWIq
         42EZaEuIZGrJsk2aJTvoZg7vonpflu5CSI/8Z+YR2swc8TDzz1uJab51/e31jeB8AIh4
         7l7VXjf6XhvflK21UEfE0YG5mY/cSa9H0efJMHL1sacEWpUB7TthJjXP/isuX08RbZGG
         AP9cFuwMzSA9LooJi/TvNfF4VAmXr5dNF3H+bkazDNdMA9L0Fg5H+yMvNLAWhXvWfIwm
         uIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784368617; x=1784973417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XHtCFulTi7QuN+vcsXlI37N2cwZV1gauKNkUTz4LeTU=;
        b=CDX2QyFwAz8Ut5vMlb49gNRU6ypRT/NBtC1E2w89HjwlSfwDlCNal8w1ulAKVebciq
         lW8UYIwlqv8EZfY3BIZuCdT1lp/Cf+L+x5xRSw35YoFByXZ23xF01GFcWi3ZJeSTdwFN
         BI0DBWn1T2iXv1lQlK0HECeukty2aNhxdYaRqN8nOChKU6SoCt3IYHPTiKjIdN9kS/hg
         imx0XvdQe39tHTtCvrKU/O2o/p4N5pGsDyuT4Gu7oxGvOPNtY2XSpMpBbEFuWlsJKs58
         0OrmOhnXUXycBKDHLg29glpzwwRoWUem72/l6WZ1NxBwde30+jwMxvjgvgrE1vB5iDfn
         eCSg==
X-Gm-Message-State: AOJu0Yxbd4ktY154A+2R/2rtiUoMjN+TmGSh6PpYjLNOM5Bx30AHrMYc
	nEFOPlW4mdUa86r0KoVEmru0GZoO/Tqs5qomY8LafjhdsodQ9lfFCaKjckEEdqLtND5mXA==
X-Gm-Gg: AfdE7ck+5zcU96yEqll31qKrZ6twInemUPzIUjHOq5i8Yl5DYH8zwJeeUMffBKQvfwZ
	dakeFkH0YtPUtaIUgKd5sX/WICi564EuLAb0a8V54Cr1PA+gZeVZi2r/BQwIR3YrRox9lRt/07B
	ZPAE0DTrNS59PkH2sXpuMQ08lSp/3Us33gJNRX8w1CFAOkahCYirl4ZyOLFHbNIRUn9d9Ochbxb
	bWOsbefuC22P47KxBEvqF5cNuRDbFtZQDpW6E8iHvh9rhkXJRqXp5UVnQ+KHN++1viL8/9wihKZ
	Kk1OYLP7OXz+JBYuH+PRS631g3sRWN8Dnz90/IBFRGr04JmTaSr5aim1wPUnqe8CuPptUmTiL//
	4DI9TISJNdkPnkcUagwQzIuGYRMHbtTdshGPSWSLWadd8Do4tJKHM1FvCS5M3ehriyw0u3s4y1L
	r0xzfW2mcDajB3olUC+tAoCynDThJFRTx99/AUoNTSE4ws
X-Received: by 2002:a05:6a00:80e6:b0:842:5a15:6fa6 with SMTP id d2e1a72fcca58-84c294b7ad8mr3410940b3a.3.1784368616755;
        Sat, 18 Jul 2026 02:56:56 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af317c8sm2417248b3a.30.2026.07.18.02.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 02:56:56 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v4 0/3] make persistent huge zero folio read-only
Date: Sat, 18 Jul 2026 17:56:44 +0800
Message-ID: <20260718095647.182592-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5572240003
X-Stat-Signature: kq5hro1cfz67tcphefimbxds14i3tutk
X-HE-Tag: 1784368618-422838
X-HE-Meta: U2FsdGVkX19yv/SGU3ooirDfIN7H9d+3pxl/IaWij4T90lXD13ojvxFL76PziFVWE0OHPPYLGvMl9aa0eSGKHrz8xcRtYqUZAYiyKmGNMdOU9DWrcFxE0Zs9XNp1/YhlJqAKMB6hPFWwrLmGNfE8WLND1BTpQNbhDanAkg5mtJpuC3Du0jpf5Wye7nFO8xDBW7bM4i1iTAWVMll075IV1VII5gZoRwFZghfoOGhJ/sHvY45zamPDqLk2a0xQX26aCk5V17ZMfySWOEwn6o7VplIkgGkhiqKMQ35JXt8+Kc70P/FLfrvLmMP+8+juKcN5ywalcDhwX58DgKXKLT5LsvbwvINrtLpOLUu/mU6uHZaq8xydbm01jiPgEkvEYshde+AguJMD8vcx/yu7wQr4a7NEeDIJxweZsMM5bU96swvn4IF7O+4gZBNHQrx/5osJh9uW4PsOf3Qv4tf96tek03T19NPfCwg5lpsfy3cWW3TQzkIY5hNHSZb6oo+UEjSSymEvgBmBeEfeDgDnxthL5EdJpmB/kiHiQhWLC11RxjAYiXkYfVvO44eAcLvzcVIJhRYNTPZGHNfIWUhi/1JH0I/bZLnsu7QdE4djVypAP8eCiuLnPU7qyvLXSdQ52BHBb0SkIhcpp9FivbW9Dj/gkZpipsefsWeMCvccQpIEz3Erisp51lwgPRrmmfJF1DHIUh9AtYdkZwT0bt753GREmfl08k/Q++6CyQiWfefzF8qyxP6ve8E4cMGUGj8wykPPuQnLfwv7T/BgUbfSSlFmUm2RFFRDhuu6VPc+ssyZgBFWqaTc6h+MJs3pvbd9sM+Rdl7gk4hJ/QwCrayWsY/N4CYPzkS44Hp6pyABtjFf2rgHRTQ0kKGi8toaDmiVTnf672dCojMygFMBHLjZfGWPAysmc0yC+5K3VEtrTii/8SNOlM7hlyXAoehswZkBIvJwPzYdnUIMYwqKGz55Hu/
 oXA5OPVb
 LxenV/4mYwT/idwKKw1WePx9MO7hZZyXcXYTW748xlJtoEOJ/egAxEI5rpsOQ1dH/89446cv6UaHyKmJj9VeWtWOx6oa/gqJrNuLe9l4hYEnktonqP0ztg6Pd7gW5QCa7pAK2rOHiof8Nw9IaYdlNCBPi0YOp10OENOCfcpUIe1aGixa4/mW8syEMp6JCaAdp7waYKW6DkgxE3YEWt6k3kt/ElCh890QcU4dmHdS9rvAfhqvHiBF7UpFEjhEoEVIiez6qMP4nZha6Kxaoblv57/XxJ4NWN9LNf4gQDZAbtEA2d2qtDNzvsnNMX0/DjZ6Vj0IovyEpRsvfOFmtIeeKzkCtcGZapFh1bvVzzs/Ay2lAMqNqsMIodMIoVq3L6t8MFyYyh4hzcBLEA5rT4fXqfN+I4nfhhUfDR/PSSZCXZ/azeyXnTxdVGDslJ1JmbDTfWrZTHZp1qFRsCgoG0FrZ70oLBpP/LRE6u8EJsYMRyPRG6B7UQDf/pq60B7g6HJmAwEj/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The persistent huge zero folio is shared globally and should stay zero
after initialization. As Jann Horn pointed out[1], kernel bugs have ended
up writing to pages that were meant to be read-only, including in
security-sensitive cases. Making the folio read-only in the direct map
turns such writes into faults instead of silent zero-page corruption.

This series adds set_direct_map_ro_noflush() so mm code can make a
direct-map range read-only, then uses it for the persistent huge zero
folio. The helper is direct-map specific, takes an address-based range as
discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
the caller.

The folio is allocated and zeroed through the writable direct map before
thp_shrinker_init() changes its permissions. thp_shrinker_init() is called
from hugepage_init(), which is registered as a subsys_initcall and runs
after SMP initialization. Writable TLB entries may therefore already be
cached when the page-table permissions change. v4 flushes the exact
direct-map range immediately after the noflush page-table update. Keeping
the flush at the call site preserves the helper's explicit noflush contract
and follows existing direct-map helper users such as secretmem and
hibernation.

Patches 2 and 3 add arm64 and x86 implementations.

[1]: https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2]: https://lore.kernel.org/linux-mm/0e5b23a6-4895-454a-9dfa-6dc21adc2991@kernel.org/
[3]: https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

RFC v3 -> RFC v4:
- Patch #01: Flush the direct-map range after changing it read-only, since
  the folio was cleared through writable mappings after SMP initialization
  (per Usama, thanks!).
- Patch #01: Keep the flush in the caller to preserve the
  set_direct_map_ro_noflush() contract and make the flushed range explicit.
- Patch #01: Clarify the noflush API contract and the reason stale writable
  translations must be invalidated.
Link: https://lore.kernel.org/linux-mm/20260706130440.9295-1-xueyuan.chen21@gmail.com/

RFC v2 -> RFC v3:
- Patch #01: Replace arch_make_pages_readonly() with
  set_direct_map_ro_noflush() in the existing set_direct_map* family
  (per Mike and David, thanks!).
- Patch #01: Use a direct-map address and number of pages, and document the
  direct-map-only and no-TLB-flush semantics (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for
  set_direct_map_ro_noflush().
Link: https://lore.kernel.org/linux-mm/20260609143801.7917-1-xueyuan.chen21@gmail.com/

RFC v1 -> RFC v2:
- Patch #01: Drop the READONLY_HUGE_ZERO_FOLIO Kconfig option
  (per Dave, thanks!).
- Patch #01: Replace the huge-zero-folio-specific hook with a generic
  page-range hook (per David, thanks!).
- Patch #02 and #03: Update the arm64 and x86 implementations for the new
  hook.
Link: https://lore.kernel.org/linux-mm/20260527035607.14919-1-xueyuan.chen21@gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: add set_direct_map_ro_noflush()
  x86/mm: add set_direct_map_ro_noflush()

 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 10 ++++++++++
 arch/x86/include/asm/set_memory.h   |  2 ++
 arch/x86/mm/pat/set_memory.c        | 15 +++++++++++++++
 include/linux/set_memory.h          | 29 +++++++++++++++++++++++++++++
 mm/huge_memory.c                    | 16 +++++++++++++++-
 6 files changed, 73 insertions(+), 1 deletion(-)

-- 
2.47.3

