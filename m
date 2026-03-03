Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D32EDEBEB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16606B0089; Tue,  3 Mar 2026 14:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4206B008A; Tue,  3 Mar 2026 14:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6E76B0092; Tue,  3 Mar 2026 14:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD3BC6B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:40:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C9311A0318
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:40:15 +0000 (UTC)
X-FDA: 84505767990.30.972C6DC
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A9A7180008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:40:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6sqBgmb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s0LzZqbsFyjwhFyViO9olNNXsNlK3p/4McW+/0gNLsM=;
	b=ELtjOMdRzOZJz89RgnVpXeon1/eLKNDVxyADJ+b/q60uvgaBiPYw/EJjSXHPYviJpJ/THy
	cQjChVrshD8sjnvycPsjcjLJyav0f+7LN0VOaG/iCRda++8YHnQJ8wZ+pp3wafbzjBxy4Z
	zdvK7rJ6J7H8nTOPtmGfLRnc+XFJK9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566813; a=rsa-sha256;
	cv=none;
	b=3UTlgMr8aINCObQhWkzoZuPAegE59TQ6yojRnt4SmF6nI0ukw7oXhsgPl7Ihue/XXVQ7fH
	wlMcRAw8YaLERSLtuYc8D+w8YgibgyvPSTiGN239+1Nn2dS+j1mOqS3L8IPavvB0iLva9h
	zwIlInNd6lZoWhuGNor+tieI+mbP6pk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6sqBgmb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2be19f05d7dso3621788eec.1
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772566812; x=1773171612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s0LzZqbsFyjwhFyViO9olNNXsNlK3p/4McW+/0gNLsM=;
        b=V6sqBgmbrpeoEMJ8CRqfve+6vPTnqGSzSk/rZsVkpa+0j+sTB15e8Px3Vc6NDqGc0d
         s3ZDIwPJFilu/v5ror++QWrPut7ODKLtTjQ3Pl0IhmuS01XxRa7END34uqiznRtw0Snk
         fuBLa3+MNkMbcfXTqTKizduDH58lEmT0P4cFeKyiIiqoAiuJZTLgRF7A+FdZhdQnKDK0
         dukM/8dWwq4daU4RbxjAUfxVwkmEzzsYPlcYmDq5TMA71GqkRHUB/q2lggkxgfSKCW6h
         JmpKoGPv9jMne1c8NmmJAnRdwVlO6foiZCsSRUfA70qsUQoezAGPQsrS+D1649C1LicZ
         fmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566812; x=1773171612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0LzZqbsFyjwhFyViO9olNNXsNlK3p/4McW+/0gNLsM=;
        b=BYfOzk9QPXMUwMh8js12S7PLo18cZXm0UUUGS+JCbg4S1+C74Pm3RejPaG8cIRIAtz
         X7wGdd+Wd/CWLRtfDv8Rz8UKubNHOcOzG87fwn9cxUAQtWtUgD6vHtx//EMzJKCqTYaR
         vFXOiX1y8+Z2P2eWbesVY0DpQ+iex+a1eSWUj+JKRx4CzuE2ibwBdCAq1C/4J92+oR6e
         JxLvKMCYPTjRBxgyHsohRUsEIs4+ir/UoMpwtak063+dmqY17A5Or3QJIiB/LTh9Rudx
         oyN3JrWxUfDjFyMWuioQzbugJk5u7inI5Dk01E4oDv9JZKzKlhPWaOGFCDOIvjFkQLDr
         b/cg==
X-Forwarded-Encrypted: i=1; AJvYcCVb3y3GLd/HlH3WGGA9fsS3R/l8NKNMWKjBmWeV2A2oM66mjam6Om8jgDfYLehNYB3uB1MHmW8lSA==@kvack.org
X-Gm-Message-State: AOJu0YzRbI6f8lwFH37bIeQOATp5ZVlhStYz/hlgzgrHq9Q0hwbFWQ0G
	J/YYp94XktBIXpLYh18SPiIFbq+n88pTA0+oiqPp5yt7pL256QhxOX48
X-Gm-Gg: ATEYQzwqcYDeCsg6tcR4vTkX2f+tHYV5FDh/V9pm+5pZQjYV2UUN/m8TAsGD4rlbzvO
	WIl4spmLCBTs557ZMq2/hAVL734zg9u10Yi2Zgs9wOkJIPZAGlKrBQVfCjpH9RaQnqvCssMFP6L
	+8S5eXZqiS+jz8ze7KD3ex7an9M+wSuJd4yivaead0M4LmCCkvk7JK/UbNbj2CD50Nn+zZAeNQG
	cRqrc/IHEI/+LKzBJx3hnx9E3utJgKGveBQzG5HRnYmWAAicwuxdkTC8aWhANqSd797aLQBw8bk
	gXYbnHdZD860E+IJtLTNQiky6JWw/J5NEFkRrcUR5z0ryJ8XOeazzVbpmRNpyhnkRbKLfkwGUBP
	RbPjUPEUwUvwF792pkv9W1xvXY6jQMbo51dM/JRJiQc92VxhTGyVzsMRJrOlVY/RDwkroe4sD6p
	fo6APlNLdMUZb61z59DIxqOfoQhOFTfm0dfX300JEdlWf3btILAta9hHvcdbnX45q3FFoMHasKq
	AfzeDbYpsJAvwg=
X-Received: by 2002:a05:693c:2c13:b0:2b8:261a:fbdf with SMTP id 5a478bee46e88-2bde1d6f211mr7246055eec.39.1772566812173;
        Tue, 03 Mar 2026 11:40:12 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2bdd1f23c01sm13732913eec.16.2026.03.03.11.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:40:11 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v7 0/4] Convert x86/mm/pat to generic page table apis
Date: Tue,  3 Mar 2026 11:38:53 -0800
Message-ID: <20260303193901.1406065-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A9A7180008
X-Stat-Signature: kfxpuu3wpm1s4kbzixxrhgfdhnx4otto
X-Rspam-User: 
X-HE-Tag: 1772566813-316135
X-HE-Meta: U2FsdGVkX1+jHxVICtVzLyq5PbICgOdHCkD7up/pd9bMyHO3tvx2SrCTb5++iCMUwR8nj0fNjI8BZNhEPz6KtaaJ63gVl2jVnjGQi+b5sI19DqrfDb0tj1wEG/nvKzX5Jh0BiHSbOLOEDwoHJbcLF5OIHbyMgBrye59SLaIcIKju1lLxEEyBSfWVrQcD5lDb4tUJisXgDS+nLs1RxkxF3MQqB6fosyTElFzU1t0QFRGkh6S7uGyovuxVJwv+/g8kTN2ie2iM0Kwtez7gyHeL+NMvDUxXBygGBaMgRH9n5knlrecbsHFZGFxb2UybaAtwXmGQrzYG/p8isNL8q9BYea9jTgty9aoBHSuqCqcmZdflJbk4aop55agmXDL8oIzrgOEuOt78hMWDpswAPQd7hFPVcxBkgnPf96th6aulJha4D1oHzsnzSFEm01X7K5ypW0wXwOqimU/dHVi9Hn5LLpzKRYUn+8UyncoUuUoWu914lX2h4s1aZL6Erplr6NqBSB4BFkSKI28LHK6MdxJidvYDeLBzcTo/fYe4VrLJeRLo2LPXX0YR05L3+wzLgCgOJDFHvOFaD4Oa7LEpRvLmWITyZF2hOJL/pHEHdYFw7Vre4ElKc8EAN2KEqHHLyWXwQw5P3an7+tqeU+f9wTUrYAVu/8Seh2b1muuMESWNKVjsnK9bT4oCSMlO0FR6zVtYFYOqIleguugHtjpvbKoGalHN/XGQBNs25to38QYhphW17WmmrfYgvsRdQzvcH+S+RxjBefF1iwFZW38g0iuCljzdQahLFv+FuokRJeAtloehhQnzoYx4mVENtcAOcZmKJ/OIbInwKOlgE/j3cJ3QIK4FIUhr5H9bYCADbZkh00W+JKzKhU+W14i9Qh1em5N8NKRY4Y0U2I+MQKgorEY/+81SQ9atM5tc9jq38e27nEMo5p60g/J5tqDYPse+0BfSn0myxz/L4QUTP9onyG1
 lLB+hSY/
 aAyc1kmaL6XTwtZkVlTzA7GNwDtw39rpo3ezY2ldBB1Hgba0ed/S88uliZQWoUaJ9Yn74yRuke+8vifBVa7yMr0toD+ycIk4pFuNmyyeA/v5HAFWdiPSXuy0iL9gTBnefViPFKWrrwdtyWHJNO8w8VfJ3ClQTQsg0nr8lA9hlO9GGZwo+j5Vj5oxH3FSAnLmaqdojGpsgKG+bPpbEk+2O6ImIIZclLPneINAtTEdD3XRPL7g87uS5+EFkg7BnaU2VZtZET3l7/O79xjR6GFyV0MQurUO3FuLRx6G9i4FHgEzSwaD04F9nZuWM/i4lF9PKS/Fe7Wa4bVOxq488dAOAw9TvkpSqLKx27Zmgiy/B59/5q/HQ5REboPMpGhJDq3z188Y1m4Y3GHoQ2dd9x9afH4C8YjtG8skXodf/hWCF27hZqApf/L8K8ecc630OmTO7AE8sFa9gQqgvCZeNV4tYrgEFg+/L5VcbvGWotHoumyo/7tjvh928GbAa/wqehRQ8q2y2vtL2qUjnDBUZmIXAo33i63lbqGf6+27uYSbyVO2+jscLbMB5IMEeA0KM8M6U6QvbIYZ+zEQh9LAmlA+ls6BUKzMa2VVAeIYvqloQJNw+VJ0ee4McfTPXKefOBbueotirhmdU3dDuN5wy1vnG9lhKSrmytfo7afNvaPWHCBG3dOgLZXldgMcNCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the get_free_pages() allocation sites in set_memory.c with the
appropriate generic pagetable APIs, since the file already calls
pagetable_free() and the mismatch prevents separate allocation of ptdescs
from struct page.

Use the generic pagetable APIs consistently for both allocation and
freeing to simplify and standardize the code.

Enable Matthew’s work to allocate frozen pagetables in the short term[1],
and prepare for a clean split of ptdesc allocations from struct page in
the long term[2].

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

Based on current mm-new.

v7:
  - Collect some Acks
  - Fix multi-line comment style to match the coding-style
  - Reword all messages using imperative voice (used an LLM for this)
  - CC all people found to have edited nearby lines (through git blame)

v6 link: 
https://lore.kernel.org/linux-mm/20260219020354.321088-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  x86/mm/pat: Convert pte code to use page table apis
  x86/mm/pat: Convert pmd code to use page table apis
  x86/mm/pat: Convert populate_pgd() to use page table apis
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 37 ++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

-- 
2.53.0


