Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADC7C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782916B009D; Thu, 24 Sep 2026 04:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C846B009E; Thu, 24 Sep 2026 04:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB456B009F; Thu, 24 Sep 2026 04:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 395636B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:52:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4F89A02CA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:51:59 +0000 (UTC)
X-FDA: 85248038358.24.2B2753D
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3D5C120004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:51:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JFPj+/Ww";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hctX/mdgTSlb9MzYkRKkR+yanLYBHuXFvc/9HELDaoU=;
	b=GRqaIPWDmEOpayBwSGaLvEu+p/R3L3bsBgwVKmmeJRCJEfVNMtQn2lzQMCt/HHWKlD+rGQ
	LeaDdlZOxJohAdk+8uRXOnGYHxcE8aiw0ISIN38jLWi48lRnofdQ5zW1skFO3IOyBcM75Q
	F+OW0bX7u0zeHUS9QcFrEP6Xfx80UuA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JFPj+/Ww";
	spf=pass (imf29.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239918;
	b=Kfw8dywIo/nkcSRf9eRjextwsbfd430uPz3m2jCSZEBk9oDAjBtKT6+2kc0QAs1K0I3I/Y
	mwRx+KojYptvfG09HcGoWEjkMWomt+w0nwSQP3say69pR9HYrtQsk/SpZxSlqEqzZm8ETe
	lULXtsytef3AeZnCiU0aEaEZ5wSWuYc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VMcXVA6Q//nucy9IuPEO+cpUVY2addflHX+2AAjGN8s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790239915; v=1; x=1790844715;
 b=JFPj+/WwpV+GK99lpdLKQNokzmXaHwqhfi6/luOa64C8H60i3R+Qa191jjlNu20k1qnI39Y0
 WHiu1ekU4wCvBFHf8hW0Gj9/eNhlFb1Og2nab8guypD+hx7z1Q2/Aj/uHhc2fBeZvej83b1lNB5
 0egrPQHSkJQ2cPlcFwlbe7p4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4de7b20785afd569;
	Thu, 24 Sep 2026 08:51:52 +0000
X-Mizu-Trace-ID: 4de7b20785afd569
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 24 Sep 2026 16:51:39 +0800
Subject: [PATCH v3 1/2] mm/vmalloc: fix vmalloc_dump_obj address alignment
 for last-page lookups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260924-vmalloc_dump_obj-v3-1-5bdee3da37b3@linux.dev>
References: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
In-Reply-To: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3D5C120004
X-Stat-Signature: j9hc9s54e1kgymqtrkcat1j4f6j459j6
X-HE-Tag: 1790239917-761512
X-HE-Meta: U2FsdGVkX1+/QYOapSbnKrNFdVWgNjMM2Fm+kIOt2GvkGd1m7YTkQSItLdVk+b/FkS0cV+JvNu4r9I+F6d4aR3DbptOvcl1FQBMl+Zvc7VAxm08v8Q7b7cBQD0LoyldwvOvYwnL30YUwVDvr0mhfGPzrdjE86elCwjG/1+nY4u0r6Q2eudAyAtfaqPQab2FcVdIO6d0B6BCMa4MIN00TVSRmxPSOGfMIpzvPMh3FDM44DFOECLFo5Pvc6rv4du4VuTI+V0Tx72paoF+naeF+HHjmGab+O2/4x88diZbXc9dmmc/K7OPMFcas6flPEjWQ3X59ErtZRZkbRqc39s1FcR/0SlnnCA0tNDlX/pkLKoUZd7fka4ibYtQO25IkDvfqICSa19kvip53i8B7l308kaMFIC7cGjC8EU6W5CkSdRRjymJ6Z4FvJjwZGl/4+fKUy5w0p88oiU4TlGpm+VGtiaIfF8WTwPOkwNznmlDVXfv82vPZnszK7C+CoOfwXMN6kwA8gFYkDQR59GpmmZQfXjoVKHFipIAMvA9S0ZVDDYasJ3jyGgHle8RAo17HdQNyFd6spxUzThXl1UcZPP5uMFBF3oF+Lg5P+41M0AdcjxBIBVb2l2i/iy16MCBNy06di8DncL06E1jdwQKez08fduJjt2x3bdu+HCCsgc+l8S4sjP/Au2rj4CPVgP1ZJiaynlvU1eEYhwqyHKYH1sjLlKrg0daInDrutaK/NDrI2I0GqqXlqPz3PC0/AIGbfRJO3HmeH0l1KaiCoBLLxkoHKsDkvRtnm4E+y1FOFW4HJWauCNpoioMhYwhnxsx3DA6Q945hBkkyR0DO2kyPZOQgzXA4VyRKhKflhnFkmyTtVDN1sOHp6SffYRHqum8+RO39k+FNbplYRHEGIUI+1LO1mduFYODis1Zc6funPm9LQnndnbwNp+fvtSyu9JOgWoTyW3/OCbQ+A8YHYmnDVxy
 wnrrlpPd
 2AXpW/2M7BuZinGT3mQjd7pH0ir6YAYlG8MjS/ZKxAAv7nwyiMkviw6U2sfWIbHdO2Z9ipladJRTBm9ZvRaDvFAxbnoQVOMddrJrsOZ1Ocq1FLGx8IRwGr0thwaJy5PvPLzhmwazyZLSL6Uux3Aprmp/ywg12daYYz0DdO7tF8ClqU8b7UCSPNlcZ9rQiJQFWp30PPdxYgUv7jrSz646iPai7lMZ6VlGhW0YQewi8HmeJ23SBYO5H01EcyHd6pdk4KCOFEes2TC3c1kR4np4/2eMb5Tav9gfKf6n4d9mo6Rm1NpMtoHvoMEuzNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() uses PAGE_ALIGN() to normalize the input address
before looking it up in the per-node busy tree.  PAGE_ALIGN() rounds
up, which can push an address in the last page of a vmalloc allocation
to va_end -- outside the [va_start, va_end) range that
__find_vmap_area() searches.  This causes the lookup to miss the VA
and return false, degrading diagnostic output in OOM dumps and KASAN
reports to the less informative "vmalloc memory" fallback.

The upward alignment can also change the addr_to_node() mapping when
the page boundary crosses a vmap zone boundary, causing the search to
hit the wrong node entirely.

Use PAGE_ALIGN_DOWN() instead, which rounds down to the page
containing the address.  This keeps the address within the VA range
and preserves the correct node mapping.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 859e6d2d57a3..df42d8a6f058 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,7 +5277,7 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
-	addr = PAGE_ALIGN((unsigned long) object);
+	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 	vn = addr_to_node(addr);
 
 	if (!spin_trylock(&vn->busy.lock))

-- 
2.25.1


