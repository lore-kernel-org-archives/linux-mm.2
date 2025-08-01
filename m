Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B9EC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151576B00B2; Thu, 31 Jul 2025 20:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3876B00B5; Thu, 31 Jul 2025 20:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D276B00B7; Thu, 31 Jul 2025 20:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC6F26B00B2
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89C0E160CF3
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:44 +0000 (UTC)
X-FDA: 83726300448.10.FDF2C3E
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id B42F41C0008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nWuiDr9T;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PfFH/5CksO26SsqXvAjBIPtqYbrdkRKJgAw7r8E6gs=;
	b=iLXoMB4TfNkXagCd+L6r/+pd1GnSCzrQr1PjAo95rQDx44o7iiqaNmmJjUmZSZ7XwkfyNb
	3qkwvszveZig28G6yNkxZqRjWWYmRe3672FsyjMbRRyOxYBJ2JgntFCfbWwwaqie0t3T7u
	FwjGaAsQ61Ok7NnBLPHly/l+C3yEGC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008062; a=rsa-sha256;
	cv=none;
	b=AtM98bgS+2YPrf4KhYpVTXTgiytNvXjBPm+e9bzBsEwUCqK7uiXe1qTATsU67hCTNFGFYf
	4Wl3Tx7pnHvTEajnOOBhgOdgWxkkPMykTNBkeKOIqY8Qvtg12rHC+yvE+IlUXPjqyucLhl
	tdRSPG3oL1L3R0QixPeZ4CQm+J+wBrU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nWuiDr9T;
	spf=pass (imf21.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31ecd40352fso1011439a91.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008061; x=1754612861; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PfFH/5CksO26SsqXvAjBIPtqYbrdkRKJgAw7r8E6gs=;
        b=nWuiDr9TCixKbZhD2fo/WxjhH+yXhcJHYxNTFooN6X4O8bBYLh0HDKCOjQYVQi2ewe
         /f/0IeQSbCfgQK4MvtS29PLR4+aNMuM/WhAYJcd21AUN24m6qTTMl13SCJGFV7fdOQyu
         4qzLCht5nBs5lheLRo/bhJvBESWKRgcvM5CXWafSvfmOYtONNqtuDkgf/IVBlfoIEZU5
         7t9IuB/0FIDGaqUg8Y9M4qpbGLGDgzuEkpISUGzxBFrN8erm0bxybVsNBumMVfmE1izk
         55tYA2rzWcbZ0oSrCyQyiG9jPUV34CZ7ho2CnIPJsTiLO/VZ07CWXePwbqbN0DlZuPM7
         +NwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008061; x=1754612861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PfFH/5CksO26SsqXvAjBIPtqYbrdkRKJgAw7r8E6gs=;
        b=VIcw7HPf28ouQlYgHwiPXscAMA7p2yev79ij3DK7o0IblXLK00M+97sKaJZn3aIwfs
         luo4YZzppm3gXiRiCcDuessdQoCUrPg99gfFc8RPVWBpXx9ihZ/VoxW3xMJmIJFQ8hEf
         I+82TqG5r9fhvQ9T4B+3joYyxHoUGv4tDtbl2hJDZteRqt4d+va+7OIHWQVlYamnVGD8
         ccjFemyqKyZwvjrk/fImMgWXtiKGs6FnMXhSeoZkINLSL0C4yT/3wm+cOBPsRPUEk7TL
         MMMMo1eEyxcQdz8rQk5lNJ7BGpPNWZXcBaFkuRF7mR5N7cZhO/EfSg+ybUJgMpg6YVdk
         XjVg==
X-Gm-Message-State: AOJu0YxrGnQgzbiaJVoL6JqTcPelTs22RU1c5oS5uuJgJ9qZI5A+TQTQ
	GomGd3Y9AmY9xVpFBVBSBtn+4072Dznj3RsNocHDRHpmieUuqXPi6EB0XYVxfw==
X-Gm-Gg: ASbGncv5a6qgc2RfmUTR7M1qkiHmu8DrsroFZrAF62ldTxhPXJGK5Xdy2e87XzcW98/
	HBVgbbBxlf1wa0BJoRU7R0zncu66UWztm+/j2dyazdHtOOtFGJWYoOGr3atD4Vi3AIAxyjT1y2x
	xrHRrz6MwSUMC4WUBa3zxqK1JiNRvXNyGATGqBaK3fRAw4KBmtLnAmIqFwxq9JYbgFYFT4vkJNy
	jPewUQd3C711Y6zDC1wGY7z2qJvuYGrXnxP7gIMgjIuDO9p0legp0L+NIjRCuISc2nygAo0FeZk
	FCxCZKzxu/sG8Mkc+3drhbLa8QdSxsCHMR8H3d3wl9JGAXhT0OfG6HJcdj1EeT1ETtc+UflcV6E
	jyae3f74GlneAcqRw
X-Google-Smtp-Source: AGHT+IFX9OKTc8E6IqQTZzYxWlAhFuyYeJjqwUvFOABkby4ARQ+mPLkz5IqLHTXHIkeZR7lsYZtWqA==
X-Received: by 2002:a17:90b:1e09:b0:311:b413:f5e1 with SMTP id 98e67ed59e1d1-320fbf3dfb7mr1055555a91.32.1754008061258;
        Thu, 31 Jul 2025 17:27:41 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5855606a91.7.2025.07.31.17.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:40 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 03/10] mm: add folio_end_writeback_pages() helper
Date: Thu, 31 Jul 2025 17:21:24 -0700
Message-ID: <20250801002131.255068-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B42F41C0008
X-Stat-Signature: wnh39grut5rfiie8ak7fseyiqnmy5f8i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754008062-737617
X-HE-Meta: U2FsdGVkX19UPg3gLfsV2LUPcZ19pk8+GNOrdWsX61bo7d54lhiS8WVRVtm8B7gKZ22tiT0U3MrwCZt17gDO8GZbLFWWd3xFJzr2M1Ip4ZDfnOlij9OKMWFkXC/4Ru83rrXo/XMJTtEkixU0Gxdli6POdqg3HQobIQ7GDTTGltnb30CMjqu7jhl5t6nLE9mW1HXFBndrt8i6ScQsR0pEGEb2vRTOvDrW+Qkaj0A6TdffYbQjiVcV3fieszwzmZYo3BPpa/lzHHaYp9UXgmWqagv7Pn56Uh6bhoc+Af2WJC4OvHqta9LAzbFEq5IATc800w4KnnDsjacTl1beBlFOz7+PRVDHl/nk+QEQuN5AsaC4Ht6QqknRfWqJmbWA9pcI2tM0vkJXpp1CWFQ4ic786ZdI2HUO+XFIg/6JQHb2IMVPzYg4eBwPCrDotfN7B9APi87eRoJtPNT+VBXHvvaD1BsYlGzmTxZP2Tx67nn7u62jyckydL/HKH0vMtzOgn4SHj8BWAL7dy88f8yuDIzZSGynaUGnziuj7oaNxByVlv5uNkDqlDCplqDKGLxBxMIk1GP3vQP8gc8zqtU5Hb6uLgqOUI8l8fl7zpigDU9T7o2bNco+P0bJtRSeKWl/2UoBBNTM2eIdtK7rWB1KRkc/GpgXCbPoM8gvU6BN5SH+6ocTLFUsEkRimBbdMFlhkoIV0rsGB09sFd23UiePGgtOg+Pfiud+cvA/joF9plin2r2s9MIYdNZkMRkJGB2q4Fi4yeAaeKaD0uSj9dTDW9Hc5vUlWev37OviAdxnwxlgwf+FMTa2rRph1ZuPiLiXUnbV46iqz0JCJoLqIBgUsMwvDss1aoU3AQTojW47YZ8utcQNTKG7UYE299YDTM0P+aWmSZy7M4h0fxMDs/WUhK9SdgBpXDBC6JpzcW2PNT/dKMyqh9EHcOXeRKdkyWtDJOTXPehXoUPlh77QdkVdhuF
 FdGrlq/q
 Cwp7WGhugo3AR7+xGja7P/xQsJZIqlqwyD+IqhpW4FDrQvDFWxh1H5e6XXolvyEl296nYVaaGk8ADYUuMMTFhQq19XiSrdTMeHDDSDrHTW7N2z1U1XEHjkHqNdEOKPa85bhYu/5rtLjVni60Y5GnF7JRdA1UuB1GYCxTYO0csqVuWZ00M2iMQ7Vv2vvC6GKOcwELBwdyD/zahCycMrSYhfVlczneupueGSJ/UEOF7TPwdz1pw+fOe0dehovkQFdhRfy7CGq9D9xsqZ/Ik/c28caAf5yGOJg8Hov0dBcrEdhMI6eTFZhWutlk/6eRZZha3nPo92xaSKl+NgYN7/Xvl7E4ZSsjdkT3N6Dv3lN9XHtfggk5SvdKl9HtNryaWwkKGgPjki+Xh+o2WfktWkBegnpq5lC23dJGoDv+dn7hfIXmj1Idy3eZ2amqlNzx6WSEclHufXNyOBl3hreaPYNagV3FYSL8+C6KT4lMCtdlQKL7GvTdflhM1R3GBJ0aRKf9bs7vpeh9zZEqbhTmgGlTihiLyKgH9gcjD4bFuDYxy8j861Pk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_end_writeback_pages() which takes in the number of pages
written back.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 25 +++++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e63fbfbd5b0f..312209e0371a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1202,6 +1202,7 @@ void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
+void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index b69ba95746f0..1a292cff0803 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1626,15 +1626,7 @@ static void filemap_end_dropbehind_write(struct folio *folio)
 	}
 }
 
-/**
- * folio_end_writeback - End writeback against a folio.
- * @folio: The folio.
- *
- * The folio must actually be under writeback.
- *
- * Context: May be called from process or interrupt context.
- */
-void folio_end_writeback(struct folio *folio)
+void folio_end_writeback_pages(struct folio *folio, long nr_pages)
 {
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
@@ -1657,13 +1649,26 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
-	if (__folio_end_writeback(folio, folio_nr_pages(folio)))
+	if (__folio_end_writeback(folio, nr_pages))
 		folio_wake_bit(folio, PG_writeback);
 
 	filemap_end_dropbehind_write(folio);
 	acct_reclaim_writeback(folio);
 	folio_put(folio);
 }
+
+/**
+ * folio_end_writeback - End writeback against a folio.
+ * @folio: The folio.
+ *
+ * The folio must actually be under writeback.
+ *
+ * Context: May be called from process or interrupt context.
+ */
+void folio_end_writeback(struct folio *folio)
+{
+	folio_end_writeback_pages(folio, folio_nr_pages(folio));
+}
 EXPORT_SYMBOL(folio_end_writeback);
 
 /**
-- 
2.47.3


