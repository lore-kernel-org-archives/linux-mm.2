Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A1CCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5648E0010; Fri, 29 Aug 2025 19:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A038E0001; Fri, 29 Aug 2025 19:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B538A8E0010; Fri, 29 Aug 2025 19:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3768E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 700DA1A09BE
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:03 +0000 (UTC)
X-FDA: 83831415486.24.193DFC3
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id A21C510000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PEFEm/rz";
	spf=pass (imf05.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9vAhGhcxjZCMU6jC7jJyh6R279hjjEZXVSFRANuKps=;
	b=AGDRB2KwtEcJsowA6DCzl8qaSwa0uWeuXxas7w5OjZ5KfJ00aTIl1ya8yK5+vLW6Yxaveb
	rkwsq7U3uvuWCzdyvOTkHx1tgxTZ63VN4vtWGy5rO+PIEUiE5v+Lof8az/i0zNMDISa+ay
	xc98yQ9L/yKunCrcqAfRY9oILal5lIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PEFEm/rz";
	spf=pass (imf05.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510801; a=rsa-sha256;
	cv=none;
	b=5Y+HltOpZ0SLpAFAfdc+rdg4guhlhY6PleiL1n1mZWjGcLylaixVhk8s1FqreZi33kYTcO
	QNbJaRNGpas3YwexLopBvNd1TgwOjSqBfLTg9iGu8ERRyfOU5KR3Iay+CtqJeHwOso9rYI
	0tzWKHBWbwGiG8K5wuIth1ut8JWgkow=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2490369145fso11906575ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510800; x=1757115600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9vAhGhcxjZCMU6jC7jJyh6R279hjjEZXVSFRANuKps=;
        b=PEFEm/rzj90FxtVzuZH3THZluT7oB6pSV1ORaHWkis5Bd+0ZMTYOZu4m1FSHkhv52D
         WKoskcNtDqPOy1tbUVKPru8Lj0cwsSIBiewv/jm+4eJjwtHevDDx0ZYBjqD6gWjmBxwv
         zk5J6w58Y90AAYNlhOQlftbKu5KcPNWDb7+JGQUFpgPC4NI82L/ggIiZknvOgDvi4yFU
         WXm4dFJhl4LREylSsfQ5Fayw7noLIBRiP2xAkOya89XwiG8ENFxWECqPaXWwzp/KPdlx
         8IUxdOXPOPIQzPocXHmcTbdqnrRpJxz08/iklPBHz8MFhe5R/Q1no/Nqysd/kGZ/6yV4
         DxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510800; x=1757115600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O9vAhGhcxjZCMU6jC7jJyh6R279hjjEZXVSFRANuKps=;
        b=R2sJVBOTDORFYKeLCYNvLWEoILuKlhqNxrd2dbyiubbMXw8xcWFaAD+0U0N2o3NWGa
         x93Zq/dzIi8q8b5plBxY+N/QSHYIIsnq7Isafztygd/cWsLMX6gLmFfjbjiYQRr9S8Ds
         Vei5TdzFMDNSJCjkF6TkfXDFSL1C2n8lTkPWu5IsaURurmaryaR4jKIaIXDdZbMnoR0n
         jeNPEFT2h+n6gg3v+r+Ew8mLgPwYcqQbEuykpKyRGPojpcfpsbbmF0PaCRoFaL4ybgm6
         CPyACm/BWdKm3BozlaY3RxUVn5J+XLZay23ulNPA1Pp0RDzB0O6mGfHP3X1IQTlUHyuz
         K3RA==
X-Gm-Message-State: AOJu0YwfCBMeHdHShC4OIDYl7WvFR9SWOTsLo/eeNZ06wi0AuxjYiWy6
	LP3gA8rNj0iBHMDNeK00hBswjxixqG+izPAN02JTnybOaFnTfr9bJGThANpzGQ==
X-Gm-Gg: ASbGncuqp/KO5AXpEjw/dGMAZyK/QObWKwwln/KeGM1gvV+/yELq19qSmIQr00//tgI
	l5phcMjEKzcknJ/37x/W/L2/llj9OaHcMoCOQanUCe+A/TKiXMDdkTBFqR9CmbhOyCkshhTGSWv
	fc96EF3M1FbpIK0+03l6vN/42s961JWb45qPSCk56WOr/3mThh9jZ2RCgvmy5s2ygUCoK5Y0LLY
	yduSkkkVEmQXAfqfJtHiTlwct+xXwgW11h3h47+cgxR0V6WTlfefABR/H0hORRKhk3d6GgSLkqO
	A9I3Iw7FJGAZFAb98AEw37nt8F+JWv+wvd3+3NfIG4sheRoVCcz73H+vY0hnB7YzoM3uOwkKzNO
	3glyIDUDFbYWxZNXd
X-Google-Smtp-Source: AGHT+IEj/qyquMZPhyxSDVLuBQwQxGQRpU8+69U/AvXMLMihrA3dNO0NerLtNZnudHsS9cVY7sCdjA==
X-Received: by 2002:a17:903:1d2:b0:249:3ba3:643b with SMTP id d9443c01a7336-24944b1e215mr4872465ad.36.1756510800311;
        Fri, 29 Aug 2025 16:40:00 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903705b9dsm36117175ad.7.2025.08.29.16.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:40:00 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 07/12] mm: add no_stats_accounting bitfield to wbc
Date: Fri, 29 Aug 2025 16:39:37 -0700
Message-ID: <20250829233942.3607248-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o9adyy1i8wdq4bxrdb651ewbpmfiedc3
X-Rspam-User: 
X-Rspamd-Queue-Id: A21C510000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1756510801-865305
X-HE-Meta: U2FsdGVkX19NFu22kUhjeAG+0lP2lKxWom2RFNb1jXqVQtRSIsVbML9zyxBIs2MObBt6fiP3Q9KoIfVsVYPmWr6UXraFuz2rvQTrheCuP4ranj7i0+aC7r9ASo4guVGcX/3AGMCN3Z9eNYxCw4b4OiTrzKrf73v6PHPCBFW39VtYhmzY7lBdzh6fRuBVViNYoJBz1nMcUhtn+jSQK6oTkTtzEgnwdPKHT+ukE2khALLHCkTPimtiCm/32Jftg51xAcOFEu+tfmcf/Hx3DBvR18vhrmFCxhqENAGswPQn7gntUT7mt3Y8KfFSpri+1ZM7KNsk5zfVnkjJhEKHuLXggpFmMMZyfJ/3I6CWJZfn3TP9lFbHmjAFce3CjztwGFyk7TijJ0RCyp/BR77O0s6KO6yZaWa+RPNdp/0SBTcnALSAHDf1xxPC3oe62xpI//5LXZCqhZQhAZ9mmmHMnbMC65DCdup50xnUNggCXzBBT2AgWEHl0WdexLzfa4LLbp5dtEpUsttJWQkgIVfPfMWcOGnMSYulv9K7JHX5jXTrOMPdu5Db/YLA2lKDy5hUdbo19ZcRD7d1C2Pg48VPHLGHdj5Zsl6ALxDtfwbbiTPFnG/0w+GWB62WefkZFptCrqEEkfLjlJBiOvEA/vmbzTlYHCmyK2dq6P0mxih0UmoC8tc5afeIpuHq1vpARb5JSMJIPu8V9xPkIzMcUe6WSOrs05J8Q76GtMR+MWshD1wZ/w+DC6b61MFlFBej1yHTaWoJ/WSFSVC0hya0qnQErV/+HNWHXGzQUhnYabcN9jfAejRXeOVAIlCdHtJ4ReSLB9nPIZnJAuPzgOlqh48Ow7Cmgh9XyRGGhQsYLRNQsL5kFYjpfH4Aj6SDKTrYAKH41H6+vfkU/XPhl2smjM8M+JSNToZYhs96QYZfg7CKM3pRiYISk9wx2Yd6gx/N2n89r4URR83XDdHEret7ZhkWcsW
 14SbJIM5
 6vyF8eijWbeB5n/vv/upOZ/gBBa4Qnd8Tc6/oz0vCKiCST2uTtIb0/9L+q6+5Li9HdhJ8ZdnUn4g79TtdsJFdlmujOrmpX43Prduo0gCFrCo6O29Qo4rQFmAszK3B6LBHqbCEOq3l5cWEJ89tzG1MDBJj4tAY62yMtcDtzfVjvfPL+aAkHShe1rbiOuvlZw06/E+dwVHnoF7XrQjDCFA3msihgfB4OAIAedCasxA86U6V8ty6EEZz5a/LszWFmIYQLVoQVzYL6YGESfDQHWeiWuCBf1DRZ4fRmaUALpjXbN9Ig2gQ3XOtBTOSjq1AH9VsbnhcEnTD5jeEn/k5XmZBkyJpbeiNs6RWAtDhap6gQmUCtq7uw2jHcYUTooUv+sNK8gnhA7iuPVvJqg8eRzS4dgmKRJLdgp66F5NsQVmG+CoToaOE75D9wi5qUBRkK7EMppuAhgfIHrUFGRdmJeRYVgmdKlJCnQQTi8HPL/LRvDKgoxTYe+QFx4HiB3BdjALGjrnwLHelyejsounDCLv5ZOxQcrgh0x4hK4BJPB+j2+fZXA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a no_stats_accounting bitfield to wbc that callers can set. Hook
this up to __folio_clear_dirty_for_io() when preparing writeback.

This is so that for filesystems that implement granular dirty writeback
for its large folios, the stats reflect only the dirty pages that are
written back instead of all the pages in the folio, which helps enforce
more accurate / less conservative dirty page balancing.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/writeback.h | 7 +++++++
 mm/page-writeback.c       | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0df11d00cce2..f63a52b56dff 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -71,6 +71,13 @@ struct writeback_control {
 	 */
 	unsigned no_cgroup_owner:1;
 
+	/*
+	 * Do not do any stats accounting. The caller will do this themselves.
+	 * This is useful for filesystems that implement granular dirty
+	 * writeback for its large folios.
+	 */
+	unsigned no_stats_accounting:1;
+
 	/* internal fields used by the ->writepages implementation: */
 	struct folio_batch fbatch;
 	pgoff_t index;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index fe39137f01d6..294339887e55 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2402,6 +2402,7 @@ void tag_pages_for_writeback(struct address_space *mapping,
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats);
 static bool folio_prepare_writeback(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio)
 {
@@ -2428,7 +2429,7 @@ static bool folio_prepare_writeback(struct address_space *mapping,
 	}
 	BUG_ON(folio_test_writeback(folio));
 
-	if (!folio_clear_dirty_for_io(folio))
+	if (!__folio_clear_dirty_for_io(folio, !wbc->no_stats_accounting))
 		return false;
 
 	return true;
-- 
2.47.3


