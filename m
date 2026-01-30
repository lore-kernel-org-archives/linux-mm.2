Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6891CE6BF0B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 13:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F976B0005; Fri, 30 Jan 2026 08:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DEB6B0089; Fri, 30 Jan 2026 08:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BF56B008A; Fri, 30 Jan 2026 08:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 313B86B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:27:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB9401A043E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:27:06 +0000 (UTC)
X-FDA: 84388706052.24.28D8FBA
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1061180004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:27:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XY+wmZYG;
	spf=pass (imf16.hostedemail.com: domain of sef1548@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769779625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PdMWH4EwKYdreFVm0OlBuzPW+/8AM8W7g3EmYmFW6tA=;
	b=yxmKx+8IZ8ABkOxtAEhnd7Yf7DWx0+42m6YQO6SJ0IqC5kxRklYjHVycgPwJDyO9Z3N869
	FO0BNPSHOJKbgHWQ1YLdBMI4wO5OmkHgCjP88WQMsH9oESnHzCoik5GkhCLvmLTJwZ+Bmr
	/8Ls1fohDDX5gDnVMjz4quDs9J3oBVw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XY+wmZYG;
	spf=pass (imf16.hostedemail.com: domain of sef1548@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769779625; a=rsa-sha256;
	cv=none;
	b=HZp8CGHYgYrTWTYiofS8TxU0VqiDxCwiVtrrmqTQcwpLT44QtL/jMWZLBKujY1/tKFjAqg
	syZlPMq/wWD0/+Y8GKSfJyQ01HFisgjAcqU7ChvJx+Y28RM6/2xSXBzZd2COHTUbaWgyNR
	16HuCHfKijINKJbgNfBrfWdFumLullU=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c61343f82d7so844350a12.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769779624; x=1770384424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PdMWH4EwKYdreFVm0OlBuzPW+/8AM8W7g3EmYmFW6tA=;
        b=XY+wmZYGQ0kQAiL1CioLoBaUg4mlOhQ6Fpta2w/1DQqbf+Q3tCy+TAx53vea0vy/WK
         +oV+lkMmBFmSymPhb4GZ1+9wdJZAxe/pwjEqSIOM7Nofu4WPh89c4gzwtNypHxTthIIt
         4V4WSz9snYuUWl550JmuKUqGyxE60zuFSeYRb7i/7vtwBtWNi1UrYyduZlj9qRfPzUET
         JW2GnUeJ67c8OOmwgBW8mrUgX16tPN9IDEMkvf1ZJITaexB1sW2haUNCALhtm6ANe0T8
         +FzEwhe8o2YK6qtGMxRObxPvi+Gz+HpHjH59JM8pPMM0zPtG4IzjM89Mjj4GF8jPkv7o
         F6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769779624; x=1770384424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PdMWH4EwKYdreFVm0OlBuzPW+/8AM8W7g3EmYmFW6tA=;
        b=UkBOg9R1gVaL/gUMgaRVlYjMAik5+wef4hpXuyZ9DVboWwHIDOry2MWs4gNtbspjA5
         64YIkTxqIS42px+6hROmtYhK4c2M23HAJT9IWrVdjGaTu5G5nctSuVmPiVo7J1w19w8V
         VfKjJNv+tfVp0oIV8kXEPWa3pe2OmWCLnNE6sjBKQbAPHrj+0IqqEFKvNcknY5oJC0bL
         v8EOGiSl1rxsQSNmpuTojHBm4qUYnYZTFwMNyrfrDTwSvPg0VQBXvpuY43QDN5rPDFnX
         Eh2dqVz+vMzbbqXiKG7nITXSkp4Q1dEpaoN5mhhnlMqOIWnf05CybPsdzGlgcfe06Nbt
         t1uw==
X-Forwarded-Encrypted: i=1; AJvYcCVAnszu3QAc3ioLMZGGGqPQ5fzPJ2l8eudkOY6TxeI9B4hXWz5lOeIihnjoLYdQD8Qa9G7XuDpeWw==@kvack.org
X-Gm-Message-State: AOJu0YzDbPvSZBMEFNsLEmpdE2hNMBDtBxRgn6zA6RswenYG24fV5R1K
	eni4ep8g7uRIlWEx92IyfV+Kjj3jWNsiEtEG+6pbX+EWO66KY34rbS1K
X-Gm-Gg: AZuq6aLhH31IgkNSUUL1k7YFa01mqGAZPFKqMPbEauQJj5/lAQ5vyxzqr3uQZGnDS0Y
	sIYqEDBLINgmQexhqHtYGuh/YEU7Itw5b3YQTuZ2HnzvAhfcdD2btTBlRTuVQlF1dzjsvuOCEVl
	IVIZACNciLhSWoqscTS7N2VreUk41SwUcu4BzZNELP4Ksaqk7NObu/s1/FElDybKDAqjZJj/ojw
	hvuy6APbAsJSF5Io7upUYSZdVh9APttfhvQ4JLHsJKkeokOSCx2Wrs2GKcJXfT+7XnccyE6FEIc
	NIPn6b80xKqiD8RdwNTrcfrXLwg8JTGLUA21VER6wSe/zuDcSMqxs7z3N2/X8IEddFhqlaY4W/i
	qFhFxSEMYcxM1pTK/Ca2yJvLsYtj4mefOTn9CaUnUNOHvT8IyzJtQpsp8WmgYwEjQO8F/yvPr+L
	9DYlXsHvvdZ0CnhVUd9ahccPxm6DcP0HTyxfLKYlw5ePJIg9t9UF9pLumOt/HyZgoVNUE1iUJYu
	5RZg58Q
X-Received: by 2002:a17:90b:6c4:b0:352:f2a6:334 with SMTP id 98e67ed59e1d1-3543b31aba1mr3644123a91.16.1769779623666;
        Fri, 30 Jan 2026 05:27:03 -0800 (PST)
Received: from nickhuang.. (2001-b400-e2d2-709a-e1b4-814e-9913-0d22.emome-ip6.hinet.net. [2001:b400:e2d2:709a:e1b4:814e:9913:d22])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3543d603474sm988748a91.11.2026.01.30.05.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 05:27:03 -0800 (PST)
From: Nick Huang <sef1548@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nick Huang <sef1548@gmail.com>
Subject: [PATCH] mm: fix typo in MMF_HAS_PINNED comment
Date: Fri, 30 Jan 2026 13:26:55 +0000
Message-ID: <20260130132656.1917-1-sef1548@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 38k3eep5awi6dxh9cedmmqdi6kffrm66
X-Rspamd-Queue-Id: F1061180004
X-Rspam-User: 
X-HE-Tag: 1769779624-461898
X-HE-Meta: U2FsdGVkX19pRVmgAUeLX0SZJZBuahahIJccGifpmpu8TcShpVuklRXdFQcT8tpzFNYYbnZNOB0ArRDA9sljlGsRFYIfHtmIOVFQHkuRAGvG7sndrXJN5Fj3vwog41OIyOZVCv3hWcbfMPVZgrWuXpa7hSEq3gM4UZ1y4m2QszxXkBDwfFs5eedX083byMHlqRdglUr8ZE97hJ5GMWB6BkJB/SL6czN0xLWNF/qrHLNaFmqzM7CyhgusGwbonClNUmrXCH6aOH0NPsLw65c2+/ivHLlQwM52gdkKMmYQ/PzMRT9bUC6xFy6CsgDy9WGGPiliD9/D1N8xiJBZ1mb7x/S0rE9b/0L6IB8z0fmbtQ0Y46bRLh5FMhcufcNrPhYboE09L/mnQyJPEigyWrHvXApNrGMChXEDs2fUMVw7cQUp0z7xuXwkZsYW8ge4nVP4Zz69HtjFtsSWh4WVKpehp3MeUPJ6JL4WRJRR89ckwCAVzVrhojsvXtEto//WqjKCjojxwJEr0ZO+kOfVX95smzyVn5DXrt9Ae0WBdBoDOp27V3NcisQ87/UtfX+hCMtnn+BPd9CLI+NBKjLFyTIJ1PHCr32nHmbONo5trYUTSk/46OcFjaOgaOCGyiDpYbFOkUE3i7X47k86MdFhtO0yY455kqFRkvYmqOBJMWx+ESAfZNUgbhD8SePrLiFLFWQUshCbI166I3av0OqtTnPfmf8i5dclTXdUbqHaLtyzboPsh/AfLXz2CrULtHebJalFpqHYoeC/SBK5LvboTQT4u2G373Ysfgfp6j2WkboscJK97XrAohWQtTChMhRs23jR83NaRXohQ5pOSxKj6V2lEbnMLP/dh+GJfIVIdEVNsafsGK1LrTiiA3KFKPTnQ+nrFZj0QoYj0Q19DBg4jG3uy1w7RJb9GcM+O3bMy1dZT0qIqiSNc24g8R/zwo8x8QviQ+8scYDmNsf6J2GTi4Y
 M7BBJnHn
 mxqRCTCG40+Km3RXNGfXkxe495/yQqksJd0/zsFKWrFjb7HTusG1yahKePB/lHcMb7XNWUFgVmCy/zcbqZXi3QSQM1c9ndtwVh9lIhdvavqZN/UzyswuIBwylGT7n3QZ/37le/llRqt2LZ5li7mf0jUAZNStefFZwHh8LYgRvYVgxsB1HCjdRHQNE2480/LKjkTX2I3F0yagZttiKrv7nTNRdwMsIJa/uaQ7BadpVhtAoTgjeK790H4OR9e2ZeIalZjqVs3Ef2jEAt7GNV0arP40aYdr5lJqzEWp7DY/s54t7skHULnZc5IqUmo/d3IdUwoAd2NIEu0PESlHQLublr/D+HMTRxGzw0wYz5FVbwZOj0DddzcUgiamhe8kctrhV0N9epvxo93wwcWXpelvR665q9SO7M8mRdB1W4rNdZ4fAal7miUKMOhOF5x/GkCKB7RWhjJmFjeObxUhq18F3iJHgYN91B9gPhIyZY/A43q/40dhTLWXqg+jRgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a spelling mistake in include/linux/mm_types.h.
Change "aggresive" to "aggressive".
Signed-off-by: Nick Huang <sef1548@gmail.com>
---
 include/linux/mm_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 42af22929..674c7cd1e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1845,7 +1845,7 @@ enum {
 /*
  * MMF_HAS_PINNED: Whether this mm has pinned any pages.  This can be either
  * replaced in the future by mm.pinned_vm when it becomes stable, or grow into
- * a counter on its own. We're aggresive on this bit for now: even if the
+ * a counter on its own. We're aggressive on this bit for now: even if the
  * pinned pages were unpinned later on, we'll still keep this bit set for the
  * lifecycle of this mm, just for simplicity.
  */
-- 
2.43.0


