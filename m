Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A07BEA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD286B008A; Wed,  4 Feb 2026 20:35:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A176B0092; Wed,  4 Feb 2026 20:35:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F5B6B0093; Wed,  4 Feb 2026 20:35:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D4216B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:35:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0ED851603AB
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:50 +0000 (UTC)
X-FDA: 84408686460.19.31D8EE9
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30B8340009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ChV5L5iu;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770255348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xsXjcal71V7M30wDGHtcG6yU9RvQM39U1r88HTUzJhY=;
	b=VfG2vH7TAeYVCD95BXfmAgWhIDM21xO6V2TCPBGk44GwZD9574UOSmlNNF+Nk9S2gwkYvF
	A+OO3SAxbZTd5kVqppMjd8hu/svQ3oR4VwV0+MHJq8qwo+wJ0rvzTTLjb2BWr4WEifAES0
	gb9j88O154mbxu1vPp4fxVi1+vp0I10=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ChV5L5iu;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770255348; a=rsa-sha256;
	cv=none;
	b=qHOLesP/eWEdKLpcW/JNhlQ9xtQOMZaVEy6VseG5Q9cZJF+aXX4b8G7nYTdjiRUiWEopK/
	YWdEP9L8TxhFY2YSChUFOP5919EwOsxM9d5Rr/wKpmyvW2IZR+koopukbwgbmXQe6lfXQ1
	g5doIaWNa/BK1WwyOq9MtZ5y2Mllsqw=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1233bc1117fso956910c88.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 17:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770255347; x=1770860147; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xsXjcal71V7M30wDGHtcG6yU9RvQM39U1r88HTUzJhY=;
        b=ChV5L5iuwIXTpVgsKd8/HPcZjSrM34MBdskACzubktD0/5LRP+oHXEclDGN1PUD6HT
         hve0viKr6P8DtaOCBbaDcT2/hynG0MGNse2HCvjzdvwqjaClCuhTkiQH1ahk2zX/9grb
         FagyMBSrYhqQgK7TWRcaeIpgEnVgmh4EBevifXrB+edbpLP6G4HshM2gqi9pOUX238rU
         aLLwNSRZn859pwkLxcWlbLW0UFOMsyi5e+NdgnwNJEIPtirFIYL8VYkyPrHZJ3Nkjquy
         dbXg0essAnf0q/Z1imeTicb33Ecuy+F2FuDOv9OLW77QFDrEBG7go8OKwU5Lg5iCRCU0
         W06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770255347; x=1770860147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsXjcal71V7M30wDGHtcG6yU9RvQM39U1r88HTUzJhY=;
        b=r+b9XlrwNPXfczgyNu/kXYJJKjBlPdbbQ4qxTMiOHAu9sh6gll0/zE4lX+mqzImNeI
         e4S0vQ1QosdJm/0IcK2du0usIsfCLO4j8dpGjDVaHM3mruahUW7pyFt/VI2T0pOjyKgp
         awxJK+qqsufxvmU4X6wMxSZVf+Vv1F2PvYnCnYkpFFyWNtSJ/AL37LSLNXRe8V3gqGJm
         32ZlN8N9GzPoqZiJfCSdzPD1KWLX8o+5JBuWuYyYQ1ZR7s/deciKZQ5bMobbLo9cWIMj
         eApjxhtgaMYQxktlIZFZqrI/vR5/ujZRkmhZVxDh4MIJEiiQi/PoM4N+H54l79MwCiJ5
         EnUA==
X-Forwarded-Encrypted: i=1; AJvYcCUDRQ8sS/e7q5WnImlgL0RMc28mfvlU3SAec3fCywxtiIDM4yDAuB4xim+RtH0fzCl3JCo6k0tgwQ==@kvack.org
X-Gm-Message-State: AOJu0YxyDZ8LeQRpsGQCgSHfcld56DYmsVo8idXkvHHJD/PFGOi3Hlm+
	WmJ/9SqDxhCkwzQSQnE5Bw1wfYtOLS81FaFn9+KWTT0rRjm+JCcOhoLw
X-Gm-Gg: AZuq6aKL0szBhvETnK7eB3SlVKhBXCpoGCSNpZzpzznA38nKrO6rfZsO7pUPpKR1WYr
	bZwo6TAI1rC2VS76U6vu04jyP1RD0PykaZkoQ8sEO9VbyIPRgmAzFnlf+E6GdnWXyICelQyhLvB
	AijhOqO/cWIw1TkZthG6NDHkIncR79iXkGIkoJXV+2r21qUuL3EZPRBdutBIeo6JTx/7e1l7V8x
	MhsZ0j1ppE9iWxep9eiue5vng0h0m5OTQuOJ1lK97zOoXsQA+bnaS6NwTvNOR9mTw9G1fsMN7T1
	voyU6hh19Tej9Y4eeL9JjHD2g4f89HS+5HhpNLjPevLZ/ZYGJ5zRtMgsHQDiFGlLyaqXH0K3+Fl
	VPPxQq9N0LuxA9ZFoFzYa5yRd6X/lcXyo4xoy8Tl6S5V0Qd27Kh6AItKeJEYJHOKClmCaH8RcRR
	iwoL2HdLZu1CjyT1LvqgNRGrqS0fC2ZyXzo13g1bZSwas=
X-Received: by 2002:a05:7022:404:b0:11f:1e5b:2dd6 with SMTP id a92af1059eb24-126fc1cf977mr673452c88.17.1770255346736;
        Wed, 04 Feb 2026 17:35:46 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-126f4e0f98asm3424982c88.5.2026.02.04.17.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:35:46 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 0/4] Convert 64-bit x86/mm/pat to ptdescs
Date: Wed,  4 Feb 2026 17:35:23 -0800
Message-ID: <20260205013527.322157-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: g96fcqxymnx4htaxb1uf9664piqa95yg
X-Rspamd-Queue-Id: 30B8340009
X-Rspam-User: 
X-HE-Tag: 1770255347-716380
X-HE-Meta: U2FsdGVkX1+P7a4k3pLuFc6HR0X81K8gTvLE2mL9XS24w5ZmPAqpygrQKrKlBheSC7YnWkpaxpCQnEgA0ANz8BRLOC3SwKGXE1SPnO4HjwKRkssWt2HlshmuaCSd08r0NW3H01vZcYaZmvYZ9W5bCf64NqCSgvmLEth/zInI1ncKoEZ6g5Ld7RWZiOLA/Ig5ZsBFBR0Qo2ENIMZDDz4t73DAwnGSynzZXRNOOz8y5ghBtP42dMycVT5uBngvD52hGaulM8D++BxBtjr8yExp7u3/ZeQqEdlMOiamW2zhgPb6stq5oMxmTcbwX2nFrocS0NbFXf0sXMsyFeBjKWqMCfLlFRkjogZNyfYVj+tBa+ei72pg8Nk7y8C9jlO+8K5eED5O2rnD24j5aB678HSHy13JqCzzoTENpAkI7s0O7fT6/FOor/TBNbMSNi0uWPH8q8JQtcfl0wUy3EbLELSeeNx6XJUktLsF2Z+mHfdo/X0pB5WS76wAvqohW4+7+0x4KJN9bGe4AXlpihx55lQ3stMVWnt7B5foIxa09d9DaWmJwl9WnBra+REYHUWWx8YGWQ0vIBq5aH8j6dNZQCqRk73yz2x4Pwdt2D9ypGd2NxwJoj31e9xC6sSCyjIVURPYC02lcBV+N3RLJAduocibwn/DC+sSADagLNMYF+JPLAXLeGQAzGWdWeyh5Wq8n5KCGz/52/U5+WcRS40CKas+2IpCMKrcKB8Fcj0qSu5IvxapqdDtUMo0jFyWPVCF0rkwmEJlqjyyGVj18OcSgUw3dL/cfDHnCwmxoeCCddmOoI8eLhyXAZkVAOpr3eGXfSVDp+n88e5BRhNZqTjPuWErlv2aW3E1s1Oz0bOW8Rb45N9hC26lXrpSxqcaMKq3g35v3vO/XgeT8eKyVcd9MKbCOy4i0RQkF5qkJRjMXHaE1YkL6jQff8RqxxOKuInW+0XAfgv/cCJaRQrE4YTjy+s
 vY3F9Das
 RoP5pQ6Cm3+PJ8RlnB7KuuEt5cLEQHbjWbcNjZ/8AeXGsXrpxDd6hiBHGwzxvKQwYhia4YKg/ZHRRSRshRjTGDUtfL+Hzm5y6NC5+cKeSq+NC9L34Y88BCfm/5wtcR20yVoOSQYU8k8bUlN4yqeTvfuJ3SmX4XBsipwa4Lsg6Nn6znAsEwcPANfogp7dK5LmOLxRmG77eqUhfmHcpKIoZANYttIOpdl+ERo528Y2uIrF6XnajFAB9JFeYpAzx1HEawacQKAGtz/DcL56LfKPAYZx0ljecR9Q7rsxmkHc25pxxVQteLoHcwOxksT23akxLBQFpb18EXwo8zEceQbrLoh7O62SItpY+QCVeqrIHy4UbAwNCrYnrXDrWXL2ojugUzoUYMAxlwo7s9mxfxkrBeeP/jfqpmQL/zf2zJiczzBhKHNGeSGcsheR6EJtGVMzSH+v6+eRUyzIkpzIfVGPdbMoR+EmUOMVbWP8SidmRtc/IQP6ymmYLenmN9XFF949hweXY0oTDAMD2rEUfGAjd3lyYIcIfAeVVUEJrpDhmnTaNiTFeXBhkPda+QvP1RvKDHiGNREYJgCSQwFpdOpdgriHTkNdcPEQiTqbl6meq59Dx2lnhHfig4O2iPtwm+UxYtg/RnmTeGn/bnRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86/mm/pat should be using ptdescs. One line has already been
converted to pagetable_free(), while the allocation sites use
get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

The first patch introduces new ptdesc apis that operate on addresses.
These are like get_free_pages() and free_pages() helper functions.

The remaining patches convert the allocation/free sites to use ptdescs. In
the short term, this helps enable Matthew's work to allocate frozen
pagetables[1]. And in the long term, this will help us cleanly split
ptdesc allocations from struct page[2].

The pgd_list should also be using ptdescs (for 32bit in this file). This
can be done in a different patchset since there's other users of pgd_list
that still need to be converted.

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

I've also tested this on a tree that separately allocates ptdescs. That
didn't find any lingering alloc/free issues.

Based on current mm-new.

v4:
  - Added new ptdesc apis
  - Also renamed the pte/pmd free functions as well
  - Explained reasoning for renaming functions in the commit logs
  - Updated the cover-letter

v3 link:
https://lore.kernel.org/linux-mm/20260202172005.683870-1-vishal.moola@gmail.com/

Vishal Moola (Oracle) (4):
  mm: Add address apis for ptdescs
  x86/mm/pat: Convert pte code to use ptdescs
  x86/mm/pat: Convert pmd code to use ptdescs
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 49 ++++++++++++++++++------------------
 include/linux/mm.h           |  4 +++
 mm/memory.c                  | 34 +++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 24 deletions(-)

-- 
2.52.0


