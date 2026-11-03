Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158D9606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z4R7etec
Received: by kanga.kvack.org (Postfix)
	id 084DA6B00EF; Mon,  2 Nov 2026 20:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034D66B05B1; Mon,  2 Nov 2026 20:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66756B05B3; Mon,  2 Nov 2026 20:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDC5B6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:26:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D9BBA0278
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:53 +0000 (UTC)
X-FDA: 85392068706.02.6F8FBB2
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9DEFC100008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:26:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z4R7etec;
	spf=pass (imf14.hostedemail.com: domain of 3WTjpaggKCMwt05y10s6y66y3w.u64305CF-442Dsu2.69y@flex--bingjiao.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3WTjpaggKCMwt05y10s6y66y3w.u64305CF-442Dsu2.69y@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ovrFY2nryAzBfdCJ/BnHMNVEIRqm/CHlabepiDy+ej0=;
	b=Lzn/hrosByqZsayi2Sh3Wtq/0hnd7RA/A8CHz/+cIjz9Ey7t9nlRbRYqK/6/LSXv+ryu1H
	+BzNWBJU+06YB7vOwadIt21q/qRm+Tu1ygsBFq2WvN/RGSOPiaJ6p+zx/B2W+WKfQGIz9x
	tqiJWnG6HDbrzPXRA8SGTLA+WWlobqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669211;
	b=BUOOZsQrtpZuaoMGSKCHMOytka033KEPcgmUTFtnlDTfkqaLRhmHpIv7DUHRuoqo2I6lqx
	8X4lq2iT+oa6VP8Qnv+jBZtY1vpzXFfwFEX0cZew4ef7ipCsvRTUU7yqRsAeX4nIHnff6d
	8o2sM5YLHrJO9ZNZLdKfZScMUGFo/eY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z4R7etec;
	spf=pass (imf14.hostedemail.com: domain of 3WTjpaggKCMwt05y10s6y66y3w.u64305CF-442Dsu2.69y@flex--bingjiao.bounces.google.com designates 74.125.82.69 as permitted sender) smtp.mailfrom=3WTjpaggKCMwt05y10s6y66y3w.u64305CF-442Dsu2.69y@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-15a84442a0bso27430c88.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793669210; x=1794274010; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ovrFY2nryAzBfdCJ/BnHMNVEIRqm/CHlabepiDy+ej0=;
        b=Z4R7etec+LZsdq6obeiGGkLYSF4k586DmuR9dLpHnpDVhjyqyQT4sXB6y0vvwBTGbc
         /XDcVB58OFGPxbETFlhUGsxs8/oTEgxeG3VRg4FQDtrF9bCBuPm1QEsbYCsgnun4cIuj
         WocSl3gmRoRmo80Sm1hgcge2E0D/ryo3el4TpaZENUJguDaNeqNUYMuGX0ywoT0jY6sv
         GfxoyfeLKKEawDBfYIXRAa7UNUxsmFxCNsWMx7kB+G/TaEtEw0IMT5LKiuIlNFfgDWCJ
         EreKNfC2vGO2G2xtQVKpN2xTdbpvtjK+oOmBIemszJcnBj9ISErNrMUVmvdzbER//mT8
         utfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793669210; x=1794274010;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovrFY2nryAzBfdCJ/BnHMNVEIRqm/CHlabepiDy+ej0=;
        b=sZ0WLAkfdg+BM5WQ/ke2bKvEmrrzd33bjLXDDXd9IoTdxlNzvPljkDKnq1w+gcmgym
         kYoOUf/ncb1ZZ0i8N8Uilhhne+rHTnhoAJxE52fOKqIaqMaKpFsCRogauPRGmOOqGHFM
         6GPEliz8mxis1ItLhLuG38HE9Yjb1gZPUJcArL1104xzrZv4i+BlM9Z9Eyxx6OpNxTF5
         3G/VHylQjp25745Bv1khk3ptQGR8J2A1yQUY3+yhfhwwrEuH67oQIC8ism36gy4jx3OY
         qXWFoCJyzrD/Rr05D3HlpFEUfIXJg9CNvsMmLu9XnFrYhTPi2MmrmG121MPUWq8vE2w8
         3T/g==
X-Forwarded-Encrypted: i=1; AKwUvBwK8yMME9jyiJHk6WrDu7eW84ZwTzkfAXs2KaU92r1WaH2T+pGn6kwvMr06sRiupeSvGBgv1JUnZw==@kvack.org
X-Gm-Message-State: AFq9FYJc6E/EnVEdPKw+p9eN0JJfAJ4CqjT+ykB4AIaLLsVZzxWzYCRS
	PJJDlauR3gGeTFl9rtMZkGRAR/OJ1KBCQjyyJKyqCdu2oDDYzFnqFrKaqaYwG8dmf/c1lwAL05P
	MPpgDRbqe8IkihQ==
X-Received: from dlbpt2.prod.google.com ([2002:a05:7022:e802:b0:1a3:1342:a32d])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:ec4:b0:181:8948:f022 with SMTP id a92af1059eb24-1ac5c36b5f4mr18821989c88.21.1793669209872;
 Mon, 02 Nov 2026 17:26:49 -0800 (PST)
Date: Tue,  3 Nov 2026 01:26:24 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103012626.2699661-1-bingjiao@google.com>
Subject: [RFC PATCH 0/2] x86/mm/tlb: Skip stale and lazy CPUs in batched TLB flushes
From: Bing Jiao <bingjiao@google.com>
To: x86@kernel.org, linux-mm@kvack.org, 
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Bing Jiao <bingjiao@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@surriel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Huang Ying <ying.huang@linux.alibaba.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Chuyi Zhou <zhouchuyi@bytedance.com>, 
	Xie Yuanbin <qq570070308@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: kjc1jw4acfg1r51tfrt9pfac4wxbrad5
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9DEFC100008
X-Rspam-User: 
X-HE-Tag: 1793669211-60091
X-HE-Meta: U2FsdGVkX18sG+VtXxXgQAhU5XLCuuX64+RlyYOSwvi7hFIvp9AssdqjfdJXldC9TOO3+MzJCE3/xGGhksKF2esAdR4biYXKh1mJ1DgouEyFWu6GueeKwKr88LhR4b5gJhr1OnGy7oSO/xCGy/581OvfBLn96xMO7wC3F7fNXgJ1oeMdmM8708As4wQC0nOI1u0Ic1sMm57xnRsX/ID+Yk8/CMj+BbIIo9RkgBnWnIjFkRQHZQbiZjlEh+yUgwQtlrblxA1YUuBwVpYEX5XNXji5HW0T0/nNXDYcaCsR9qmkCzLXatfu1dKQPP34fKNbRR0OwgibrT/ZnsQ+F/VJulMJSSbXMPxW2b1E1n1qJlf8WJHPo82/IzQaJqKtWm+yJKiuTKEM+bKvnZCW+1zhSkJKUz9hr5NutlsFnOV9BHXl0JRMjNMHbZSmQsgoNF1uGmFjd3H9HL5oZgmKcDReP0xA0FMPMJT2NEJ6KaLx65uE6rEs4EILf7dtfxP4XADUCdfoVRrVbwzAjBVYpvnI+lXNmuFHp10J/AkOBT5B+m7XTLhoYbtrgF6LiFOcW4caiy6Eiccg/iBJygDluf2rmL60DnxOce0SsOh2LZVtEXdCcLwhrBTp1Vn1GIRdVS3bm4U9HhGp8B+OR3ikMdYiqQAcZg8Yub7IJX4iPowTofcQ1nXY2IYI3krJDfjC3luDAcI/Pt9gtyzZ0EPBP7PrpC2FlnYj8r80Y7h7Gf/IDZSWdkhA9Qvlhdh3iKGb7x+eJu3O6eI74uYH4WwEV9ZC+6vD1DIE4ZYl/gpK6YTj3YUrpsRP8E0WOu8I4955vUQlVKnUmxTBefbGyFE26J+6+/GKnuFIsgPX73Zsv7f01Hb9EEnUAKcMHUlm/VasYqFrBjtvA2Swbh5wmFDvJ1c0+8Z362sXLUlT1l0+bKFE4JgvlafmEhfNW8bIufgg6tykYkfyqSNJbqLr1PbSYKE
 ijrjuWN7
 138z+f0Vek3pFRZJGnmJNH32+AgQH0i5uf+HEKbrecPxlSREDWRmSDpxEjo57X8h09HN/NfqFp35a6fgZJuUYy0d01ajOR9IMliSZGtYwCP5m5oEvbO0sMXoOgWznTSypuvF7YHsgJRqUr3OApKd0XqVNb56e0fcjcYs6q7Lcf0Q7I4lbysaMCmxe3Or4BSugsf7YcDlndKiiW+LSB0UuetYm9Nqu8eXO1JWOBMC6SIwtoworPKS0onVLRp7Iux+utMkEM05Cmzq+vbGMKRiRIpQhBWe181atEk0uddxVGUSNAKR72afChnA918+8tgILInHpmGkqYNLRBaWf/Tqzu79pWV2YNmoTvYOzCD2SxTZoiXr0E18JEpq1zcKTYMha16QF+jPjVy0LdAUMIn0cNI2M6LiGi1Ph4ls4Fhhpbl8Ry2bH//JavY16IBq6458jmVrXu5L/dbDf0D2E8K5IQp6hD0A6EkYiOc0uBtY6jn+GpeOSp2A7Xa5aFCgKrfLstskp6zVd7YdeFLhmPaIgTfZFvVco+9I+MKtByVFt65o1Em8Coye/FSi4778/nzcCqMmEHxVDTk6Yotn146pX1y2JFO8zsdAuzspl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 209954cbc7d0 ("x86/mm/tlb: Update mm_cpumask lazily") and
commit 6db2526c1d69 ("x86/mm/tlb: Only trim the mm_cpumask once a second"),
context switches leave outgoing CPUs set in mm_cpumask(mm). Per-mm flushes
(flush_tlb_mm_range()) filter and periodically trim those stale CPUs using
info->mm, but batched TLB flushes (arch_tlbbatch_add_pending() and
arch_tlbbatch_flush()) pass info.mm = NULL and end up sending IPIs to
every non-lazy stale CPU in mm_cpumask(mm) on every reclaim, migration, or
page demotion batch without ever trimming them.

Patch 1 skips updating batch->cpumask in arch_tlbbatch_add_pending() when
X86_FEATURE_INVLPGB is enabled, where arch_tlbbatch_flush() uses broadcast
invalidation instead of batch->cpumask.

Patch 2 tracks up to ARCH_TLBBATCH_MAX_MMS (8) unique mm_struct pointers
per batch and filters stale and lazy CPUs out of batch->cpumask in
arch_tlbbatch_flush() before issuing remote IPIs.

Tested on 112-CPU Intel Skylake, 384-CPU AMD EPYC Genoa, and 512-CPU AMD
EPYC Turin with CXL memory, all using IPI-based TLB shootdowns (5-run
mean). Following the setup in commit ed15468787dd ("x86/mm: Move
flush_tlb_info back to the stack") and commit 7e12beb8ca2a
("migrate_pages: batch flushing TLB"), a task with all CPUs set in its
mm_cpumask runs on 1 CPU (2 CPUs in test 4) while the other CPUs run
unrelated userspace tasks:

1. Pageout reclaim (81,920 4K pages reclaimed to zram):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs   9,092,156          191       -99.99%
                     Time (ms)       2,974.6        763.0  -74.3% (3.9x)
   384-CPU Genoa     Remote IPIs  31,377,184          157       -99.99%
                     Time (ms)       1,652.6        483.1  -70.8% (3.4x)
   512-CPU Turin     Remote IPIs  41,859,670          119       -99.99%
                     Time (ms)       1,695.7        476.3  -71.9% (3.6x)

2. Page demotion (81,876 4K pages demoted from top-tier to CXL):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   512-CPU Turin     Remote IPIs     958,699          526        -99.9%
                     Time (ms)         213.0        168.2        -21.0%

3. Single-threaded move_pages() (331,600 4K pages migrated):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs      73,370        4,964        -93.2%
                     Time (ms)         702.4        699.7         -0.4%
   384-CPU Genoa     Remote IPIs     252,899       13,899        -94.5%
                     Time (ms)         392.4        347.1        -11.6%
   512-CPU Turin     Remote IPIs     337,426       18,193        -94.6%
                     Time (ms)         370.1        368.1         -0.5%

4. Multi-threaded migrate_pages() + active memory access (656,940 4K
   pages migrated, 2 active threads):

   Platform          Metric        Baseline       Patched        Change
   --------------------------------------------------------------------
   112-CPU Skylake   Remote IPIs     144,610        3,362        -97.7%
                     Pages/sec       386,385      391,050         +1.2%
   384-CPU Genoa     Remote IPIs     493,035        7,730        -98.4%
                     Pages/sec       673,166      725,680         +7.8%
   512-CPU Turin     Remote IPIs     658,193        9,685        -98.5%
                     Pages/sec       670,288      733,020         +9.4%

Bing Jiao (2):
  x86/mm/tlb: Skip batch->cpumask updates when X86_FEATURE_INVLPGB is
    enabled
  x86/mm/tlb: Skip stale and lazy CPUs in arch_tlbbatch_flush()

 arch/x86/include/asm/tlbbatch.h | 14 +++++++++++++
 arch/x86/include/asm/tlbflush.h | 17 +++++++++++++++-
 arch/x86/mm/tlb.c               | 36 +++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

-- 
2.56.0.385.gac671c819a-goog


