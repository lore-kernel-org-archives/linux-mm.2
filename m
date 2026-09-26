Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C05C9832F
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 18:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A0A36B0093; Sat, 26 Sep 2026 14:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879836B0095; Sat, 26 Sep 2026 14:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F3A6B0096; Sat, 26 Sep 2026 14:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51E1A6B0093
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 14:39:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5A0C1C38BA
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:29 +0000 (UTC)
X-FDA: 85256776458.24.ACF851F
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1FA8A40003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 18:39:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mh5AZyag;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790447968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7jles6kOLK/nYoY3nT9JUOZhy6Cidsz25VDFnXK9X6A=;
	b=7raefJubUDwCZggQQZe4R0uqxB4n/Q6fFK91QNM3FWUdvn6oTfaaMnX9LyAOm/+xb2W7Sq
	kJAOgJcQ2WdN8R7xWjAvyEEJ6sSFOmq0JlU+6Bu54xHslIDq+Gl3UgN7sVh9P7TJWvAlZ4
	aAJjw/TjrKVWnYKN2w+lZanqwxv86bU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790447968;
	b=CobxuI6cOltNJmtZAbr5C7qL8pEy1UiYlZof3uG/esY63ZZ9Fil5Cvwk5LXYfx737T6AY9
	yWri55VlicQe+6mUCLS0hniXvwt5T3a16qEW9bxmKnw4AsOny25PZp60QL/7xln+6e+cAs
	JLO1SSCFzLSnv5eampL4u3VY8H9vFAU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mh5AZyag;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887d06c669so1379119f8f.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790447966; x=1791052766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7jles6kOLK/nYoY3nT9JUOZhy6Cidsz25VDFnXK9X6A=;
        b=Mh5AZyagw7cXbkP/wAvHk3OwCribilHe0a1JLcgUMevI8P6EF3pVT5UQHo10sh0adm
         p3Z6RpZashBk8NP+QUuSPr7VHq3SaUUs/S9eJX7ZzhrUU93hO7ATlafTTR9OM9nSyBne
         TYeotZFdiA37HVcoytZxajBqr+ezOn83UnvTWHTe3x5v1//4rpJTLqIzRHbNumXGsMTd
         s4gSeeD+oWJAQHFUloB2kytzJnbRyITxv0F+GCCzBHpLFGi2TUJ6atEq2UAJ543ghtkm
         aF34PiJOn3ja9BrFNGn+oCrPfCgJ2kC4joHYBK8TOWBX0na3kWOhCGcH9HZAHnTr4HMG
         CpQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790447966; x=1791052766;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7jles6kOLK/nYoY3nT9JUOZhy6Cidsz25VDFnXK9X6A=;
        b=0GBRhzSS+d3vDOqce1gzu8PDEJsCwEYdFhLvIFlV7bdg9KEvd+wZuwsKB36cflhaMM
         IoSymaWtLX9O2gGImMC+BQ0EWzDmGythN7GuxHgqoB5ZFUYqt83w1DJey4ehcTSmduCh
         rR1jVOWtL0nZSXAsfmjc4e2lLwfUrfWcjywFNDvIuYeRoJRNbyjrktlnecVQdFxPAP1x
         xRxaxNt9sTkLQB3VKhJhnwN30oCtXIe7MtESH2kkTDfWjGCTyaZWAv67gcJsOT7Hzxw7
         oYZ9JDnabnJboqW/31xDOlit89CY6F8Sq3eVZpYkhIsojuMsOZfuuOfco7WRr3ml/No3
         xrmw==
X-Forwarded-Encrypted: i=1; AKwUvBwhdGdOcn/EbtblapG1K0aKqOB53cYM0Al5DX+pdduSWrw+5jQR7Ui6Az1aDF2YK2fSo/p9hWPZ+A==@kvack.org
X-Gm-Message-State: AFq9FYLuPViducYuuoCw8rlSssI9E8F5IvdvSbKJvKKDv/EohbDeupOW
	CGXsJ3bQu0qxQ8WriONUyYSoDTpKJ8tKVg1BwC8BGg+FoRVj+n01ZQCT
X-Gm-Gg: AYBFou0aNH5AvCZqt76ZWwAX62p7x6T5pHmCfePYlPCaovqsMcvOfPUaG0LApspbKA2
	d+jrlPKtivAyGrF0W3o8IbXMtxdTP6ObfHBa+g1zJg5XZdv3+lYSQOrJVSORJkxpE+5ME27yh4/
	VboawsI/MJdvTnz8CaaC/Dxq88jeoQ7ajtkdN4gz1SE9ElUpXfr/dedifdUWKmcpd/caaQaEc37
	Xu9s+stkxgjcRx8LbjK64xsTvyzod0TKZHcl0weEZkUNKMW+UVVk97c391kcEBDlQI10okfibe6
	YZvZmDkkFmzKu/sGvdtXLIqkQPrqaQILYfWxiuwKZIuB1Imt2TVcjbFiuSshkRShqEub8AjDEeT
	OCWYZl18XEIZ1kdTYtTl1UwUwmXoMoeoyPs45ZXTYkQZ5ctu4tJCBxIh6uVDi+A9L5/ZcYdxj8j
	EcnfSPHwSoOGJDZeK8TBIfkz08AOrlcHnMup1XiQDcYIktRGve+lS7Vv07ueDGJwgWKPhnU8JtZ
	cxX1ip6DTWdqVAIReHprPTTuA66XamtUsrg1mJ/UAlB8g2YKwWd0vSHn9HoQJ5JOiopiKg5FIqN
	kJ+9qm9ibeXZi9ADYsbzokSk43K9C+IkmGlhmtcyB8dQuQXaCKBSjFnGYp4fwUGlfRQi4jNDLbv
	EjQ==
X-Received: by 2002:a05:6000:4707:b0:488:5fcd:c1e with SMTP id ffacd0b85a97d-48872a72594mr14913212f8f.18.1790447966239;
        Sat, 26 Sep 2026 11:39:26 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b162-c701-4960-a998-3de8-2fce.310.pool.telefonica.de. [2a02:3100:b162:c701:4960:a998:3de8:2fce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a648895sm15430376f8f.28.2026.09.26.11.39.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 26 Sep 2026 11:39:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karl Mehltretter <kmehltretter@gmail.com>
Subject: [PATCH 0/2] sh: mm: fix hugetlb on SH-4
Date: Sat, 26 Sep 2026 20:39:02 +0200
Message-Id: <20260926183904.76186-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: iso1h5skab4pbxnpuy1joybrmagtegcn
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FA8A40003
X-HE-Tag: 1790447967-374242
X-HE-Meta: U2FsdGVkX1+JpNoFkwS4u/p0rV4Tq0pTYE7rOv97WnQeh0h4j+lC9hKMlxNrSacUHTskwazCyA7/2gPJxK6Qsk4T76UIwHrW2tw/JrtQkfnyCpQj1hwowWCCEcGasgDrFnKAiSVbmSCxuK1xLhTiYCbiiG4x3ZstU9hPctpCo5BKL6lbbG6lIfZ5jo0DJFbwlDT7YpaBrYM0b82UOwHC5lSY7kdQbBKw7zz9hObZ9yBz8/h9l8B/5TAJ02ZSUX+TwYbiAsYnb1hRtNdRwDXLNVeCErqAOt4oRRTvgPxWXbVkrfViTeR3d2dJ9PLF+D94KssiVR/EUGUcRp95xtn+zvH4gbxPWRq4T051IxEYnepA/YgV7MWsNEfvLd/8ckahJyvFm+bb51FKiNdxFqrJa92qvrgdKkSXG1sNNYoB+o/NoHRcFkz5jv5DitI9CxhRCNdJvgdDFdsCzJrH5B0iFjKyKnp4kP2gTemzCsBoLXFwVY4rkeDs+arIpwcKQaueST8zQsKkRu8CVj6S9u66KIpMvEaX1yIiE5QYcWOd776bR6euYFW2wM4uX7K1zMWaVOzxoCsr+xBWj+dYtfTrJ+dHHroFUlnpysER4rCNQPDDSDQ8oZD+xXhVE2lI4V+uyUP6CH6jS7oJzSEix7jOCfTGZYVGm/Y3LrDDf1tEpyUEDlMOSCksmO6hFfvPaBxc5kaLzh8YWnbSz+czIn6f6qNiFYCPi8261mp5FtYNyQxCKdXCPp+4UFysNzCaFqMo+nCMG3tvo3PvzAhhmRVMN3bu9j9IVZHk3TOBde2e/fnzEy61p335sIpUkwTBZuBy6/xm5pD81mAvEu9+XWUgTG71Ck3VNbJhikdgA00qjlHVJxjHN1ZwaMtYWulK9mrr6Zdi1ZuLyu2xl5y09ijm356gBlQ/vKxAmoveo4OuogbHqMQ0jc+FdhnRu0YwI0wRTlxE8gSIp9w3yt3FZ4V
 dCIXogoo
 YpVrwJOPd+o2CRFlGb8ntWfJSSmag0TX547C/9ctdxJXFUFapjiyPX3o6lwRkbLdZixgzzMx2sE/Yvc+louiOsiANt9KuLhZ/E6cQxtDcSbfSdQ1CDxSnXcgjfH95uspxI8AsRIeUZ3FziiEan4qoILtgsLFb+jydmP48QV7GLlFICudxTeRpaFjgMn+azAjMhqjr44M5dmM2QbtDly0A5vwwXsawvuhHUOaABcIDwvPh2RO264cFOh9b/faSJ44w/S9Ykfb2ABuZ702e8HdiSxsfL9UorQcMeCwC3Fie1hfOpNa6/iLUbGw1R/BlEHhacdOEc7wpNZuGWImRxDEaxLY/dgKEuknB05JyjkR9ysOw5OoEqZxxmdPoI2e4ShKp47bFSw7IKWwN2Di+mW6IP95LiPl5DCIaIhd+Gw6v2KYD6B1ithVe/HJ62unz0Q2lqnrg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Muchun Song noted in the review of the Arm hugetlb alignment fix [1]
that SuperH has the same arch_get_unmapped_area() gap. Reproducing it
in QEMU turned up a second, older bug that corrupts memory once the
mappings are aligned.

Patch 1 fixes the page size in hugetlb PTEs. pte_mkhuge() ORs the huge
size into the base page size bits, so 64 KiB huge pages over 4 KiB
pages are loaded into the TLB as 1 MiB pages. User writes then land in
unrelated kernel memory. This dates back to the start of git history.

Patch 2 aligns hugetlb mappings to the huge page size. Without it
mmap(MAP_HUGETLB) can return an address that is not aligned to the huge
page size, and process exit hits the BUG_ON() in
__unmap_hugepage_range(). This is a 6.13
regression.

Patch 1 goes first because patch 2 alone makes the corruption reachable
through a plain mmap(). Both are marked for stable.

Tested on QEMU r2d (SH7751R, rts7751r2dplus_defconfig plus HUGETLBFS
with 64 KiB huge pages, gcc 15.2) on top of fddfc3ec3179. A test init
maps two huge pages with the default and legacy layouts and with
MAP_FIXED, writes and reads back every 4 KiB, mprotect()s the mapping
read-only and back, and checks a COW write in a forked child:

  kernel          MAP_FIXED       default/legacy mmap
  base            memory corrupt  misaligned, BUG at mm/hugetlb.c:5215
  patch 1         pass            misaligned, BUG
  patches 1+2     pass            pass

SH-X2 (X2TLB) is only build tested (r7785rp_defconfig with 64 KiB huge
pages).

QEMU's SH-4 TLB emulation flushes only the first 4 KiB of a 64 KiB or
1 MiB entry when the entry is dropped [2]. Keep that in mind when
testing hugetlb on QEMU.

[1] https://lore.kernel.org/r/5AB6FE85-4CB9-41EF-A700-BC5E071F29F5@linux.dev
[2] https://gitlab.com/qemu-project/qemu/-/issues/4598

Karl Mehltretter (2):
  sh: mm: replace the page size bits in pte_mkhuge()
  sh: mm: align hugetlb mappings to the huge page size

 arch/sh/include/asm/pgtable_32.h |  7 +++++--
 arch/sh/mm/mmap.c                | 11 +++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)


base-commit: fddfc3ec31799a932bb92f1b8a84cb3d1f963be9
-- 
2.39.5 (Apple Git-154)


