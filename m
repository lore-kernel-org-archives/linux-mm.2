Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746CFCE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4C88E0011; Mon, 17 Nov 2025 21:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85648E0002; Mon, 17 Nov 2025 21:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CE88E0011; Mon, 17 Nov 2025 21:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0D278E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:20:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31B99160352
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:20:13 +0000 (UTC)
X-FDA: 84122123106.21.12FD5CC
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46743A000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:20:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fDn6n8KA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763432411; a=rsa-sha256;
	cv=none;
	b=3TUOfDXgi5Am4sTiRvVnZ6YjOxX67YXGfeCMuyQUAMJcPr2b6mjEsfyQE0Hd2o5UWP+jBx
	On+zy0+VCyyzPbXzcJfF9kLtdl/ZjMAeFQH7fD5cy8cLUZnm4P+ZTeKjW+2OGNl6k8eUZ5
	FD/TmAA0WzqJTQbs9lQbaNQi+JQacGc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fDn6n8KA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763432411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeLhe1K/FglLKQM5Rjl2nYfqwEdDA+ds4vbwWhubKBY=;
	b=2Xl3M5tHnCwdwjLcNBUKBTMFzGOcDL78bu2AVH8ZCUq3YXl4DzBD0bjmYZ7uzhiNiAfNm+
	YdSrW5Wux9Rh48nWM7GLUmG4YonkHMEVokEthvSuTL7C2FAnHK7HZlckbiju3gIXdG5bTi
	T6RWPx+/bvu5lh3+/gEEYpYB3hoU2JA=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29812589890so63828465ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763432410; x=1764037210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xeLhe1K/FglLKQM5Rjl2nYfqwEdDA+ds4vbwWhubKBY=;
        b=fDn6n8KAJj1MANFRC9AqxZkiU8KzxthSD7ojO13tl4t5RVt2a9MiVnOrVEqNi35vjW
         CFZt+MkCeo/OnBk5T63BZGOvuZgGsOERn+VEQJk1vCjUWpEDe6ft7PhVkpMfNfjFO1j8
         Yg/b7DRefL7x70dIKafyCtPoH3dAbJVwk6JOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763432410; x=1764037210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xeLhe1K/FglLKQM5Rjl2nYfqwEdDA+ds4vbwWhubKBY=;
        b=roCRZherGRWKANDv1ioNBwGvT5ZGZS44Au7mJ95TpwRtZ7NcELMTT1t1DDNiIDEiYr
         5N3LkZmqq0AzHW+vjYRGUqF4l/sC0vsez10yBP80EnbIG9fzvJ5ThrOUWbHJOcuqyfr7
         2ufGN4W9+Ue3WVB5+rErFyPyfBje/VV/EAuqi/F4ZJfI2D49LsGNGYSALJiMz2yIs7CA
         edWnhYs7/7PJkO2otCY7iA8wAl1WllI8IDXwsrquJjhCUlnAMniFz7uWoYeaRhoYhTAz
         Y7lVXdfGabkkEtn7sn4fQR8A2a0hLeckSGgE/dxk6rogJnhfp3q8KCFqG5JGx7DsU8a3
         c9qw==
X-Forwarded-Encrypted: i=1; AJvYcCXtdq3ZF7d1H2nF2iCWPBH+iEk6DwhfIJ0HxVflMEBh0ZCo0CdnGofcJ5IFzH+l/X+2jy/yZ6KzHg==@kvack.org
X-Gm-Message-State: AOJu0YygB1E5z8zBmrmwejG9iVGs/WJs08TmlwWV+bhrkzh3xX33dOa3
	TcGWgd4k9MRdbc+u70PBKGAE8AM4Wq7Ig/R+g9zwRk6faDb9C/X6id8CZB7+O+JdVQ==
X-Gm-Gg: ASbGncu1xwQTjzUadDj2Q4bH/TeTe3Fb3bFd3knJqVqf53JQphDKqJpfRK23cGS1XN8
	qGanWi2ks9fUIFirtni1ecCTxWhvB/vLWL75cJYaCJgm4jQ8Zsax6b9ieClV2mpPb+/wYLXtD2H
	HpbOJx9VfrRHfTt8gpBwkJBc6gt+i7PbZlrhh6Owh955wCRs6eiEhVE9VmQ3Hs3qahOanl1kpyR
	t+r1gVVGfo2dw3TjDfx1bTFL5MjZiEaNFt7Obiw54Ml3aDkv0R3dwWctRvy0C/jQdtZB4V10rAL
	a7pnrhISUATo4Y+ZXKjKaaBxXn/Ueh1X9MRV5O+KeilYeUc4+PEcLy+LroF1zjm9NC4tj906oPb
	z1l0+pFZhiL/gkM3MCl0Z3gh2tQy8mhggh0jDFqro2117ly8iIGaJfMMfmCmhfPOzBcHv/pJL/9
	VQWakgW2lKi622oq4VSjvOq9SMsajuMiEkS8c0pg==
X-Google-Smtp-Source: AGHT+IFgnrwBGVvnNemFqa0iZ9eZXNHLWkG3IlWjONUzoUMyhxXmmvIdkXpepLq8mpGRgS5yPNAvdw==
X-Received: by 2002:a17:903:247:b0:295:290d:4afa with SMTP id d9443c01a7336-2986a6bf9b5mr158238435ad.23.1763432410069;
        Mon, 17 Nov 2025 18:20:10 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:54de:ef1f:fc04:3ba4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3456511845asm10961801a91.4.2025.11.17.18.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 18:20:09 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] zram: fixup "introduce writeback bio batching support"
Date: Tue, 18 Nov 2025 11:19:23 +0900
Message-ID: <20251118021953.1794503-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251117184414.CDFE9C19423@smtp.kernel.org>
References: <20251117184414.CDFE9C19423@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46743A000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 7pfqrqjp6hij16fqf8xjwq35gecobmfk
X-Rspam-User: 
X-HE-Tag: 1763432411-983024
X-HE-Meta: U2FsdGVkX19m3UI60tFL1siIxhr7nMlvW9ty+2FuMnxZJzUNHMG1x5aBLIWXXGOCnR78cXXl5GQFpALF9FIrTkDi7dYti51FQI6wz19HkrAjHhom7yWFAetLY62eT/E4PY0r5y0tVfXuhW47Zfdq5FAPCHB/f7P3zXu6S99Ig1POyzDJGXmKOKZnHAN3SGcHbsCzvGd+KpZRz/LwHesTxlRa7Lre2nEFs7058Ynucsz2FFRM4Ff+HVb6Q5MSxnoBPLta4p4+JHNhIZtA9VJvrZjWmtzKHBLcvHBdfZobaq+SSlYgbHsrWPrt1lY84Jr2SZgRUgh4zIb7hvCIx+i/eOs69bKXWnScCsKT5oPlEpaAb8ZJNy9cmnKEI5tFfOjlmdjWpFIkptGw9/xJTNVuu6+5Wl/3s7VBnz0g5RSVmuMXHj1C455uql3siS4M4ycrH60txkwJsoEjPrzLKhg5EsMDWH6srI6J3JO58ZfcsMnC6z5BiQNqFl1yo981BpB3QL2pf6cF6vRogr897GY0YwMKfj6ID8IxiHqDp5MudECBcKzq3SKuo2xNyOlQENy4ovdlY6R/vw6+pFHAG3v7MsDWnrzwV/bu5JN457fTsjXiwnAu/lkiCLkIgqSwvMOI1Hfrzlnb7foIvt8n8Bdobsa7UP9DlQzAuFfjlnAdKg3+sK1aKRejZ44piT9KVN5xQLZobo5/v9Pq8RGDdRsJUu4kQ17nkv4BY6r7GsixRqQtqzyKaiScRpKTJ3VF0p76+HDRtBrA10kOGmzgOz4IBpFKZeuwl+kLQoiATdDWx/0nzgFuazuh1V2W6GikNtX3Q8w+Y/xNYLL/4Ow6ciQr+dvdrkGPAoH1zAgcGoyH5szXK8Y1EVSviRW1QnRdyOJvu6cwxaEaEfJ1AlAGFVcQdWB88g7il35Jwd2NyWe+CKCSvgjPJOPz133rUkrP0ACV4iHak7htqe0HTJqFhOf
 7l5Yujm2
 MGLX3C0OU1XemQn/fGiLTsd1CLzeu30pHU7eGf+kzrQ86gbvTPoSPySI4Avhnz6CZVR3mpCXJcR/CwUiIc19yDaWhcfPHL5ke3xLXLgp/0jOsE+A6O/ICJy5dUzMbcS8yUapwCFt++yuGgB9j9D1KHu9lGESi4r/D4ZmoEGWkLQzyncR0+EzBiV4+av6inQehu1qXO1ZD+hzSNDS6bhNB8bNoajfPUHJ12ywH7VHqIq8T96qBYAsMH+Izmqp3qE9Y6om72bficK3Ybuj3ZOzivM9AKlV06yXQDaE6TAdxMSdKWDmkpPDilnrfQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Set slot index to current post-processing slot index.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bc268670f852..0a5f11e0c523 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1015,6 +1015,7 @@ static int zram_writeback_slots(struct zram *zram,
 			}
 		}
 
+		index = pps->index;
 		zram_slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
-- 
2.52.0.rc1.455.g30608eb744-goog


