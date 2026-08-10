Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D5ADC5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23826B008C; Mon, 10 Aug 2026 05:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3C66B0093; Mon, 10 Aug 2026 05:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2AD6B0095; Mon, 10 Aug 2026 05:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E976B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:45:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B890AA28D3
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:45:24 +0000 (UTC)
X-FDA: 85084876968.08.F8F202B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14227C0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:45:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E7PNnZW/";
	spf=pass (imf10.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786355123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dNGakf2M6oPelBo3WH3aqKoEk48xxZj317kKXaenRIw=;
	b=fnNMv957kZELOqt9eA2eU5VmKxo+x1dpXCOshB6aPwRG51x0+e/sHY0EJj2wky1OPK9sfx
	ddeoAzDzJ3i0SQT7qD7ayjhO8GrUp9gKY6vN9Yeyn4KyMBzYJhxL2Z2aGRTPjjUHO4gveS
	SwbZ8qfJONrSdad6TO/fzJtSOE5NXJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786355123;
	b=lR9diiwXs6fSYPlPzs32ITKL70zsGlnui+9eub4+GIDRvhmEcZ8hkKoMzns3oEwCQKCMqd
	2PvFu+gUzbCZQJBiih/vMF1pTPgtQR/OvHWl0eGtx6e1BVj1ZEQvBF8mgkonvRtptERKqD
	rXDwn7VEdAl0zFGwO5BHESmObv5lYxk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E7PNnZW/";
	spf=pass (imf10.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cab973140bso24371235ad.3
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 02:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786355122; x=1786959922; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dNGakf2M6oPelBo3WH3aqKoEk48xxZj317kKXaenRIw=;
        b=E7PNnZW/Yo171STYbng5kvaYeoj9SI3uPeBei6ynKywMbShF3gNzaoAd07bbSmS2tc
         4N6MPeynO1YhSS3Z+fkpgO0GDRXRwavqYy0QmyHJWyKr77wghxe6soz0LU2Thu9v3u2a
         JVMRJqzQ+f1sHCc7XwOTLfNQm9LIdq91TiPp2sNn73xYfylFMROwe8IiemWvXZzYGgB4
         SdnzbIDQ2OUp+7wMHbDsvmNYxIHLU9TORe/fOFs70b/sVUPu05Q+knnRfSu6e2yWbni2
         tUiuVywJ/tZngVLsjdmCYkI0K0IQ4XbizmsYXeBMoAeYezCsIYqyqGFOSokemx9hwFKF
         IaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786355122; x=1786959922;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNGakf2M6oPelBo3WH3aqKoEk48xxZj317kKXaenRIw=;
        b=I9MtyqhV1HO2yxBGLNrh1A8lp2BW51GtZpeHXrwsMpYYRNSkfvPSaJzO0eRgw2ECPx
         pZ0MT5lbwPu7F1/M8hk7vcnDnb/ooKMt+fd5mNIiEcWg6HaCsXPRb/Yltz7VQUwhr7Uk
         ydLKIBUemMCWWUKDQgeoj40gLUX9uORmq/2I0ppkWvsT/uVBuaBK9rlsHoWdLDQ7rZYP
         e7C1Cm6AuFCnXo77pls11Km8R1K8+mB/d5Jj2uW/7nvtM/2aTSc171rfQ2oyAzPiBzYv
         37jKO05ZDrLd85Y57RgWCDT2A+flqRKaNV2bMIZvd5rLgu70mVKNceJCZZbcA8RM7F2j
         Uarw==
X-Gm-Message-State: AOJu0Ywq7SGV3Mv0wadCU3/q4uTcG865No5WlGAY/zLSkWZ934UV7M2U
	xVa4SamjnByhZrAqV8O83kbe7QJBF9Jpjz1jzcK17CR8mdXdqhiYR+Vh
X-Gm-Gg: AR+sD13TfjJuWZYBD04RJwTFWG2itam4UYfJBAQ8acV0MWYb8YmmMh46SgzOfV+B6E4
	xddvoZAiDrvG+Go9mFwKdnvKf8nYsTj/PsKf+QzwgwxQVlbH18YJYTAfu5HlTEWMEJU6WK6CZzw
	EuKcAnekBwRTxBSM7X7g1XWiJUb8AYAbefdc7ZJED/U3hR0RdCbp77sawxipsTms39wIFXBfMba
	++/P3UdU5r4KJAM0YYM9io36UHGuDdxJ4nyTyiK+Iwg9M8Z3bs6hETKMt5KwT2gwC689IVq53jb
	mKDtm98s8rXo2+xrlTeXwDEYjkup5tDqV1k9i1Of2GsQsDF/Y8lpxNvVsQqt5R4hZlfQokcKvCm
	yaWq7zrvb1jO8sJl76MXh/Ayy9cQBiw+hgpW98lM8dSdlloB3JEqkn60DQqRSeCw2aDnd7f10e0
	g8HoFN1hzPWo2vMz9Yu9TX+P0IoE7j1WLi5wOEkllXhoDHuCLuFqEkJicTM5Rpd6jFRd9lHjxAP
	8omTfdq
X-Received: by 2002:a17:902:fda5:b0:2cf:82e6:a5 with SMTP id d9443c01a7336-2d2a8d3b8d6mr245246815ad.13.1786355121841;
        Mon, 10 Aug 2026 02:45:21 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14da67e21sm31904325ad.37.2026.08.10.02.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 02:45:21 -0700 (PDT)
Date: Mon, 10 Aug 2026 18:45:17 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
Message-ID: <anmdrYGVqM-U4vlo@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 14227C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jkygeons38gwqo8g1x4ezbtsexqk4sqg
X-HE-Tag: 1786355122-143428
X-HE-Meta: U2FsdGVkX1+75LgJt7KFZxdQ9HpXXUXwWr08aqhbGXYQsYM3nLex7Lk7eDScafVAbEuXs9VKqq34DbXLKd3DNn8MnMFNzCTXXgvBIBQiOPWyXsfhtulCD9acBT2oepAGD5dwnnwHz0LyaKxHcgxISZb+FgBoqjhueBAV+YUxukbgBlEMsJYOa/ktzHmoiuAa9www2+LvpATIjzbpLpsOXrzPL5Ka619oZdwfEfbDktdvmacHAE8C5OqsLSRvo1ENuUw2+r8QeICsmIfqtWEw4oFnaRFrnfcJyjYS05+z/Aql0wypZAVWCLwAyD26DaOBkYSszOqWWlUkgl7LjEqYckDY0LZ3427dvJFfxBJNrkNPhRVxFwap4EGLIYzRa0SDVQvZ2wOOuOYiLGEpV+U/3Q1H7DB7ll2bt46GBOTFEJ1CoSHiGF0zo4bQJL6PSTo7dGq698+D1XC3v+lxLDu0L6J50Vk4tXp9kuamCo/G7yE1hC80D3zZoAQsCIna+DvzpOx09wYQD8mdYZTWX7ADfgXp4+Yq9cZzWq2RU94vKvwxF6JyGXH6dZhpkFfTlGm0NbAZBlBHnMwYegO2ZC6MNe3h3Uwgo+9K/wwoGaiIXkYxiC0VfNSvsecZOTj/mVKNVSXG15eMBjMMSZykYU+NqnMFoAZePhqW766hcx7ddLKcGdpzNJSZYcgVwjNUBLykYS5RhhofGo9Mwf4pPojqZdHjRFzLVnQc5ZtfMh2VHoUPvXd85ALtV6Ua106F2SoZfDS9ZeSdvh7uTg3tor4GR/ODhlc3FWE3Y/eZil8zpX3KFcIxjXVdUWoueMMKtK5y9TqXKEEV5XokUKFDPclOEPbcT6NNEoslt6N4yXLJ1/UXtJHlpunZ8J/myxhbc++/Jhps9N6Uy3Oui7EVc3uvALXC1/LMnTs/1IGa4286QCygXjNlofPoffxdgbKVb+Rzbfgf/e6tehMaxV3LE2m
 Gh7NSTNs
 uMJgirN8B0oVFr3BVQCbIdZu/HMGDrLFmqMKwjlKE72pyurMZATGkcz/7z3pNyPHQT0YsZMw8XeSXObjXSGGVIWvLtmr/WrKOKVOK/LxULwHVPgd3Uq+fRp+u9xceT3W60G3RWm0IcSvVXWlIy+KbYH+xKWEG/pa70aRkYfH8m3yj/iXicmKuYm/Ix3jrVinMKObOFha1R2g7HoS2ZoGUZeGJXoKS8wj8xWaZv/c2091nOt8hIlDALY0TDE1vRsgxEXhaA87aQ2dk50tmGlWxENbm1/W56HuCDUKAT3iVJwEsUivzEWu5IHGNo0vhda99Xb3DX6WN1w1OZs4sYYT8A5WKhHu3MShvcz1sdm1LG2DhHBVRDgTqTc99C7aw5RfSOrxQbLi4iuMAeRGDgu3XBznD83PZO02sz0z88zV+MbHSZYpUm419sxcnsMf8VFJcpFgJNwBOE1I+JSfsRKIu4KHDxfBDm56hOkflX5YdcXA9TNn8HD3h5VAS3mpZUagRt1JimGE4QCLY/Sw+63+FUJF9Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_pmd_range() resets walk->action in only one place in its loop body,
and that place is after the pmd_none() branch. For a walker with no
->install_pte, that branch continues to the next entry without passing the
reset. So if ->pmd_entry() sets ACTION_AGAIN and returns 0, and the PMD has
become none by the time the loop restarts at the again label, the reset is
skipped. If the remaining entries are all none too, the loop returns 0 with
ACTION_AGAIN still set. The ACTION_AGAIN that walk_pte_range() sets when
pte_offset_map_lock() fails escapes the same way.

Nothing looked at that value after walk_pmd_range() returned until commit
3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
turned that into a problem. It added both the PUD check that sets
ACTION_AGAIN before the loop is entered and the test in walk_pud_range()
that picks the value up right after walk_pmd_range() returns and walks
[addr, pud_addr_end(addr, end)) again. That is fine for the PUD check,
since none of walk_pmd_range()'s own callbacks have run at that point, but
a value that escaped as described above arrives after those callbacks have
already covered the range.

For mincore(2) this becomes an out-of-bounds write. ->pmd_entry() and
->pte_hole() advance the walk->private cursor by one byte per page, the
buffer is a single page from __get_free_page(), and mincore(2) asks for at
most PAGE_SIZE entries at a time, so there is no room to spare. Walking
the range a second time pushes the cursor past the end of the buffer, and
it does so again every time the race is hit. Reproducing this needs no
privileges: run mincore(2) over a 16 MiB anonymous mapping marked
MADV_NOHUGEPAGE while another thread repeatedly faults in a PMD-aligned
2 MiB range inside it and then drops it with madvise(MADV_DONTNEED).

Move the reset to the first statement of the loop body. walk_pud_range()
has the same shape and gets the same change; walk_p4d_range() never looks
at walk->action, so that hunk keeps the two functions in sync rather than
fixing a second bug.

Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 mm/pagewalk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 5d87c632a25507..d3bfece3193366 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -126,6 +126,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
+		walk->action = ACTION_SUBTREE;
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			if (has_install)
@@ -138,8 +139,6 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		/*
 		 * This implies that each ->pmd_entry() handler
 		 * needs to know about pmd_trans_huge() pmds
@@ -196,6 +195,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 	pud = pud_offset(p4d, addr);
 	do {
  again:
+		walk->action = ACTION_SUBTREE;
 		next = pud_addr_end(addr, end);
 		if (pud_none(*pud)) {
 			if (has_install)
@@ -208,8 +208,6 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		if (ops->pud_entry)
 			err = ops->pud_entry(pud, addr, next, walk);
 		if (err)
-- 
2.43.0


