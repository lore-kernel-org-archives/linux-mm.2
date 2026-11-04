Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD70A606C44F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nwxaMTF0
Received: by kanga.kvack.org (Postfix)
	id F37FE6B05B7; Wed,  4 Nov 2026 15:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8FF6B05B8; Wed,  4 Nov 2026 15:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF0F6B05B9; Wed,  4 Nov 2026 15:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF9496B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:42:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F4951C41F8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:42:43 +0000 (UTC)
X-FDA: 85398610206.08.3142269
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id E4EB92000B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:42:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nwxaMTF0;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824961;
	b=CgQJmkcIhFv8BeWP/11J47xwPUsVhStsobdK9LHVrdLd9jVPXqMuMRV94sNOUy4bXy/UFd
	hRvso4o52PAVQEA08FXv1dggnLLXWlgHOed9s2iI3B1U8rfFMBsevHvW2LLvhQn+U5LJzS
	5l9VIj8VrBd3pzaY+vzipxWuU5hQHoU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nwxaMTF0;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=h6dwKVBh50DCzDeIRT2L9U5TfDV06YRfq9HuX25Gdcw=;
	b=LGUsxKYxmjLP2koFm4NSVXjFCCAVF/bsI2mwkATj5/ekOmScMoIASGfjzf9H88KhVIR5PO
	Gul7KVAYlCycDYOvZHumGXUr6eO+iFTJgxuIv5wXugWGVBn6UsxPIClxQH7n/IRUwRRrms
	/XIAGw2qiubTKkR4jkerwJDdOIIDGiw=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so10565265e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793824960; x=1794429760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h6dwKVBh50DCzDeIRT2L9U5TfDV06YRfq9HuX25Gdcw=;
        b=nwxaMTF02O6WuuJq8/XRdvK/gVQ76uTT0tE1ROvILrrUGXKd77pKsJnSHiVZpum9Mi
         Wo685ocd4MA+PUlCSSXXN1Jww3WnsWjYwkIMtsZsoUHUl9by/Nkc3MSqKOi+xJ/yADdd
         x0JiQCw3XFxCwGlUzXIVIfaw8Ah/BQ1wIvCnYHEzHOTf8+GHEDQUnC3EZTfIw+n7koG+
         KLlpGTH2e5OYTRhrB9/vjIGeYhBxygolz4UiDW+tW8CkyZqCAH/FvoVkNT2fe6ktu+bI
         l91OEqgFuR8jMm+5Y8w3tGWWDeAa5/rJ2REB8mLXvBlt0Lbt2X1L7QsnsQRG1RughtE/
         i0aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793824960; x=1794429760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h6dwKVBh50DCzDeIRT2L9U5TfDV06YRfq9HuX25Gdcw=;
        b=QeCPBQ8G8bKAB9iiiOkGRflYpHldAoJX6fWbtvvYfc65cvmMNQRh2PzqZIs/Qh8HYf
         kuexiInDr5Fin6pbHjlOwYtMg62IQGRFANqLMh50jeKTfyTF0VU/7CNnRKC1M4uzH4Jj
         GbF4RJAcfU0HnNo3kavUp9sf6h+Mv0aqABAuUAbPiNuNA71aIEh8qMqhdrfZL6178vtM
         1xLf83jnLSa0tBluIsddpLcGsEuk2NWzBFp4c6lJ1InAJ5zI+4lFPOYLAnli2QS8ohTF
         JqWP4x2L1WIAmuRnAPngFJH+7Qim4kc8VKFTPez2BqrQ73nIjG6FheqsGjPthxi7TG5A
         PEhw==
X-Forwarded-Encrypted: i=1; AKwUvBx3ztaa+4Q7Tg97UCwDWl4KBaGynZDX1ryUlVERCLgfm1q83DsxHk5thQ1yMCs2ec/ST2PVGjt33A==@kvack.org
X-Gm-Message-State: APuU4Z/Swj1QSEmP6j8EUFpMguu+IY3nMCVYf8lQXLHxRbuHxp6wkDkL
	Udhoe2B1kcEaTwZkcv40Xv4O36WrIUWt77nCrOki5sQ42JE48mkD3/Dw
X-Gm-Gg: AYBFou1pXIxFntJmetbi5JppU19Kybp+rWZfT4KW98TJEDd8nyKZYO/CsXsSu0CrvGH
	UIF3vGQCaEAgasS9XhBLakVNWkw/SIkSKu9XVdrg1afdKor4ikfmzWPqnGj6vGUKNz7FxjFwWHv
	ITPnBCIvufQWPF11AG1SNWgzwkz0/JRnSi6qgTUYF0SxSkiLvoyHDV223EGNnnKI3oRgUYLNbFs
	6HyGNBFUifScXkUm762q+ALIrDaO9Y3LlZtrL9Fq0ChZS+4riDA2BisDIv+kYgkdXLsE9JtHxNA
	i0taQOHWD2Jc4Zb4oRImK43G8xGBsHZDEMmt+Tt6jvZAAfnGXKnfwMF8yUTG9RPYt2mHQIvigmZ
	j7yHKGmNTw+5G4oF2FniuRjHHX8CzcgRsImjJl8HRSvzKLS5fLrBMjlfzS02dkuirZ8qiTT0AKQ
	OO3129ZRz0vmXOvGFcVGvnghrZwuv8byhbyXLzkn0ukyevUcNtj5yTRjKym04QNDKkl7fUQSEZI
	UjAWUzpQZ8hK1+TH4aj1WNklBzeND0Ay2RGI+70l+vA9Enh/fMEed68v6HfuvcYZXCgV86qz7qq
	8PIHNndFscQ1Lg==
X-Received: by 2002:a05:600c:4f55:b0:4a3:d327:6ed with SMTP id 5b1f17b1804b1-4ac182dcba3mr424220875e9.17.1793824959945;
        Wed, 04 Nov 2026 12:42:39 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fecac1a1csm5716451f8f.12.2026.11.04.12.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 12:42:39 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v2] memblock: don't allocate new reserve_mem regions on a KHO boot
Date: Wed,  4 Nov 2026 21:42:17 +0100
Message-ID: <20261104204235.9066-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x39dnnsktbjp9whcz87m51omqzajtmn8
X-Rspamd-Queue-Id: E4EB92000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793824962-914315
X-HE-Meta: U2FsdGVkX1/mApdpnrbuwUKfZzf0ii4GC0NE9cmhr8ULhfB/OC0bbDTSGAbyqlTuj6G5OKwvAV+Nvx3DpnC5Oxuu8Hr4Mv/eCm+he6YzQ2VuuFwG3COgX8IDvFgFsqOwV4xWn2ipppkpVVzIOdQM/pH7suoo/pRma9mchLO5sZ0vnV4mBvz17AbPPQWeLeaQvnkxtPOYJpJop38ZoMvldrQPmD23sHTbYkHornmbdvqyVnmk82JA1Kqvf5qeJaaHD+1k4IxSEnne1Y5bKPLDVxHqyvRr076TrfeLWNXCeJ7Id/Q452d/dkKsAsQJKtB6r1XvFf89S9Q1u0wTNJVr1eFZtCx+Wwwdl9FVz8ggA2yRCX+GE+vF/rTamanLrluq8HJn9k95klqp1nyel0kwHjiuBKfGpMkOPDIbuADRppQ31b0A9cTSzLdJ3Ar3R/r1LAC+fOq9Ix/zZE3GhXwkvYaKkTDC+ioDgJem5zaMA9TiMXaeGqUQMCxcKND8uVi5+OU8bEiLScmEaFPdA4dViwZi6uRwzI+emYMRG7kuJIQrffZpQf3h/VIlFvwVG/sU0o1nwXMMSHpXCPcdydKU/OqcirUtkWprR0F0ZmDexdDeMlAVhcV5Q/pbD3UVIpUJrPagLUF9LsXfbt1kLY6rPI0n9trQB4QZgWbDGZK0Ko0TerHeGPsoyIcIpzb5owpKZAzHU9Fgv5oo8p+BhPvvSSlb249/6wSlzUu3VBhnpd8tYm5XP2iS6XO1SxYPFfwgwxrek8+5fk95qnkHU2X8Oq7il5ZQH8IsoezCTpCTsAn3E0sgVL9p+3v2cAOdobRNur/4b7e5VViermwxncsEZWMx4L9RRfVaj5+sk7cH1INbbkFoDKmOwsQIKRgmIHDxuDxq1jvzzu7loEZCsbMRZmKLHdowHso/swJfcHlyCUYZYlNrgBg3YwI/M42sAUKXssboMKzayeQ20H8DpyT
 6T0Vez4s
 tifV4AwYo0kFdWR6iWbGOo989WLfvcuvi84F5yMXl8EX1NeWybZdzb8NmJEyrsy7ziivLCg5MQlHD+JwVrwcfeS5YWydClJ0cA3sL26y0jUtoSOGzuHtgkHbhH+gxEbaBUVTCGUCvM/tNyEjfEUSGFNKnsBEz88LGWJt8aHRVIkvPX6MBS/HZ9AI1isA4IoXk4OtbNvOKcrFHDEHCbcxNl8FuKVRgpJR3UPP1Ha+iqrlFMiUA4IMedV/V+QQtNSk9KH5r8ULKshtsQJDLshr1dpQsf2C42yKvwle1a+EGFD+LCnyhUl2S1hlVk6cK7WOC1DKWr5S6ijE6QntND2GTdZVpiOtjeKjsrBG12gJbNkOIukkal1KiowroCaeg4JnpI0kIao84VT8l53gBkBhbq2df5hEYpVtMo2tUrqFznjRVgtFZ0coDlINP/0Sp+bmL4Tr53Mz7VN5Q4y8JtvbiU1znB6joxqN6qO8egPpA5OHn0gM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a KHO boot, a reserve_mem region that can't be revived is allocated
from KHO_NOPRSRV memory, which includes the bootmem the next kernel
boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
then fails:

  WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
  failed to prepare memblock FDT for KHO: -22

Without it, the next kernel puts its memmap on top of the region and
the ramoops records in it are lost.

There is no use case for adding regions across a live update, so fail
instead of allocating, and drop the TODO.

Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- fail on a KHO boot instead of allocating outside bootmem, as agreed
  with Pratyush [1]. this drops v1's patch 1.
- not an RFC anymore.
- based on v7.4-rc1.

v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/

[1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/

 mm/memblock.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a450092a80fb..e325e0542c9a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
+	/*
+	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
+	 * which includes the bootmem the next kernel boots out of. Only regions
+	 * handed over by the previous kernel are supported.
+	 */
+	if (is_kho_boot()) {
+		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
+		return -EOPNOTSUPP;
+	}
+
 	start = memblock_phys_alloc(size, align);
 	if (!start) {
 		pr_err("reserve_mem: memblock allocation failed\n");

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0


