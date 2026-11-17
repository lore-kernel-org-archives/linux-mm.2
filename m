Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4159E606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SgSkeowH
Received: by kanga.kvack.org (Postfix)
	id 5F7B56B00EF; Tue, 17 Nov 2026 01:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A84D6B05B0; Tue, 17 Nov 2026 01:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BDE66B05B1; Tue, 17 Nov 2026 01:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261016B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:20:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2CF3A6B08
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:20:34 +0000 (UTC)
X-FDA: 85443611988.11.A4BE363
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD8B840006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:20:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SgSkeowH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794896432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1DDRt7N0cPxO/KFQj7wkx+g70GiGI/WkpRraj+SxGOY=;
	b=S62Zb9RWln56eKXm9oZapCxh+V8wQhkrYCnPlElcew1Xh8FdzwgpM9P9IgEEGBAx1M9X7y
	Y6jngpy49yDZoRcofglfWhhlQTekHHnLKC1e3iCs8fNKdIl/FFUZW93jEj6lDnQSVOZmFd
	a7ir+xk5VfkdmRygmrKaVC7Tdt2uDbw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SgSkeowH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794896432;
	b=g7eC/Kdj0b2GrnVw0EcT5S7BLAnf4zDzVoi16ygMKew57e+F4zBUJfTMyLpzymstrQGaXX
	OZ9kNzZgL+0FQ2dyJSJq5TT3VAolwlvGZeuPouyjPyfeQEI+xftSw2TzVJhBfmxsI2BcWV
	yiilNzXp4hIDYFwoVLxyRHpNMGnbLfA=
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2ed408b0d0bso24535075ad.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794896431; x=1795501231; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1DDRt7N0cPxO/KFQj7wkx+g70GiGI/WkpRraj+SxGOY=;
        b=SgSkeowHUmLGBR+T9MW7g9IlEI3MFRn9Slmz/mNEQw4kPneU0DvFwdiejSg1M8AMRf
         X+p7lu0CCMvd3C1ar0WS0gcG7A9i5PXVOzlxhoN/yungEndN0a4v0u/TwHnOWZAWkmuz
         znkmeJvBs4URJAbteFnNNQJxzxuHYgrxiuhh2Lf7SF0eF9yv8I8LM16Z6BkKN/q4zXCr
         +u6DrftaHsbthjB2mwI6KykiApSWzVmd0I2iv9mdN7EyC/yu7LC04RGKzPvX5RfqbQo2
         jlhpLhTPft/ZKLUpZI1JeQOhc5Pv/Clp4dLJRLzbI5Wdprrx6GPJKdnAqKMvSvpgehIG
         LkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794896431; x=1795501231;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1DDRt7N0cPxO/KFQj7wkx+g70GiGI/WkpRraj+SxGOY=;
        b=R7hJ0sAUPVzPjY4SsKguq7ntB7EQ7ntApTNtF+dCoGpiPiiUOl4HNcArCtGfLVcP9e
         l3XxWbCBdm9ZoY+sNM9DXecogfYL6SjpTvPb6bATMv1UyA8Y9xPUSEcPFaauF6PcoQVg
         kyUgiq+cfju3yX16v0Z4As0Ks7A5/R/p2NfNbepQ1vE/xUICig8UeuhsS9esxZ4S08yD
         md0S0090d6JoqFJIYdsjZ88gTl/YdHG/8RFazjnqsG5Buymb7lW4BsIFjwXWMpkg0Mt5
         rwoJuIINCBAOymZgVg8P3HSCbD9HrK9er7x529kiK1LpEVEQYHIDDSBLaAVUy3kTlIuZ
         IU3w==
X-Forwarded-Encrypted: i=1; AL+hErFfGOzt6fy5IP9S5cJSniBZ21vsYqWR34Y5j/ATG2ZVo9sumt8fqdOOFwBFMMPZZqyMjMTDYTUQrA==@kvack.org
X-Gm-Message-State: APuU4Z8FMUZAFwCVpGV7/7mvV4k8kssRNC6xVx+sJGZ6pTKRfwEo31D7
	GBGbOEoDgTrpRgRxsOX7MHS362TYiPvxsyoxZKHZ0s1x7//1KwdpHlwc
X-Gm-Gg: AZFdTZcCV2B/ju5BEopaRdq4re1uhJvV6gCwYzyOs3fvYJz1lrUaoNNr5pLv7k/V9jO
	m6isP1uhOFdWnxDbBePIPk9EImewEiPqYDA1YygOBXfP1oqlJXa6B/K+I9J4uovU6QO0QiQJkl8
	wEl7l9fYSbi5tqyB5zux/7nn7Ey5zwBgZRF9XJj5OyeMlKO1acFX4LCd6XymqvydMck4aPhwY8f
	RwWPqOHMfm5+PkBayPpXXJ4l/05hdcSIFO/aH79IrluVlovCzkYeVk8DI0FvcltA6IiCUO/XJZZ
	vp/3pI4J6nEvDFwnBd9jg9F1IZ9yUWaKzD6tJxrW/0ngQ9RwtB3nTfXkSLNZLBJdUS0wO0tYTqm
	F3dBulCjLcRI2SOXJ/LYRh85uo3nhCxCWOlUCUeBrIw4/ID74QqTBjs00UzuqB0bsEy7qOLKCg9
	sIW7x9YBtpT8+mkIZ4wyDPPEbC9m7o+0sKYDSETSLuK2H4EUBhXjmrl0w7G+jsAThKbxywJhjkN
	v6829IeVddlDvqQhjdNTnqHbzUixhgvgcQvm4uUFFp0XtqXTBcKnp0r+oLDcMfO1tUimYbtWm1l
	ePUZIYR7m6QP8T3xXp5/iskzjQOJbXk0AgnAiJxNQ7ECx/TKjRdI0yZmG9g11R300BE0FwGfOAN
	IxJb/nOf/kkh/SyA/8vYFSGLMS7G7gwdahkhhg6ru6IroXchCBI1OWzrR1QlcPZ4=
X-Received: by 2002:a17:903:22c3:b0:2e9:6788:9369 with SMTP id d9443c01a7336-2ee0dad1a75mr127580975ad.34.1794896431357;
        Mon, 16 Nov 2026 22:20:31 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm8776345ad.52.2026.11.16.22.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:20:30 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 17 Nov 2026 17:06:54 +1100
Subject: [PATCH] mm/damon/paddr: skip hugetlb folios as a whole in pageout
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-fix-damon-hugetlb-pageout-20261117-v1-1-054ef8760a92@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2NwQ6CMBBEf4Xs2Y0URaO/Qjxs27WtkZa0RUwI/
 26RhOObzLyZIXF0nOBezRD545ILvoA4VKAsecPodGFo6uYihLji031RUx882tFwfkscyHAYM+4
 VOnN90jfdUiuhiIbIZfU/6R4bp1G+WOXVvDYkJUYZySu7Rps/T2F3HvsePU+wLD8rFfSysgAAA
 A==
X-Change-ID: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: CD8B840006
X-Stat-Signature: n6zwocccd4wcbu58zdmx3ezhwazpkpky
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794896432-976936
X-HE-Meta: U2FsdGVkX1+JOOAPyvev4R9RaYdFGU2edGG2CtJW4AUGIHf6Qp6MXV382CWHJCnvR2/AQYnSq+mUszP4yy3+ejjeLxcdt2ezYCOIGmvIgAJ9mz362T8pmEJTB71yVi/3yEk/GjpTp1gxi6QxBjdU6XduLv5N3RhBwztSn4AVMk1WqZRsBGu0PU6tbgvKkXm9bWn1BXC9dXeAafTxdQc608K1XceAWgQwQZaFRoCrKcYahvhvgFNixXjsr6stSaFkki+tIxKUJx3ypcDe4aZuBzsKfo2kgNa4FzNrlCwpBOJ8Zyk2hez2v+g9dGRHJ3J8djZP2APQiTJHUXi3qDF78bKpGbqgUXsRKApqlNhrtUKA7Al1fXLBFrAWrhIk17LbpMqCc+OkYTNWjxmI4Mlr3XS9Xhbm749u8XPRrG0Ljnu8lzM1LzjtUACp1xVYdpaZ64BwJo49QRW7w9yw/Q2jmITJCzxR8/QxY0YkBpZDTK4q5+ulJmSw3HeCnqQ2k1sdtyZSnLA8vfGLxX8GpCZIDkJ4Ad8C4u2x3mYmCf92ZIO1Rf6/9n8kTw+nL80QJWgH7Ykbqn3hbAtJV8YMeGs/BtfvIAJl/nQXpfGSSJZOfiZdUMFl1QgjYEIrdNz0FL8pWajEGApcWf7JKlD3EXTP/Rs6c9roivlXRSGQt4hnKuPOzs1OSNLz6zyqI7DbL5CD/I47Z8V/D1r0LBW+rJgwzC1BerwLGAP2m892ayzqt8RV6cRjDjWltbGjHUInaXhrj/YqAY13jQRUROqcXQSXfI7TIkNCpDmd3O6tT0B/Y2IGQ+Jbu6Gk90Vypnr5K4p8yd+V++n8DIyIBcU0R+yGuGKHayHoEfixOd9I3sRV9L8ZU8winHk4BEEyB6pils30hDekQkjJnV+IVFBbRZAehd5nodwa7umeiFM8naduvLtEdu8icudPeIaQRYF62IpZvzxIBQE1If64NZEsz2z
 8/fZn4mf
 DIW1EFNVpaSuajbKVX6lPa2G3SIJuSnqV+wem1XuBABYTCQHYlhUcNwUFU4V23TkXoR/nqySo0HrSKKsDuKh36uUrsPCOFJ+G3lrlBQLxvbQ6J6cjpMp18Bv++soqAURZN2md+bJWZdpNIC8zRa2tJAGOH5aU3Y9RyvfdmIJxGn3UrFxOWoH4DV9YSE1jZALw0SEURObVRosb2SXN/mWef9dvrasGScuaUpBs6jqSSTliKEEL3BEEdarxkPMbHSXuH5FCvIten6KaNR2tHbtGGXxHpQSaN+Y08eh6CbrvgGm94xroLt4cC64q1I2nIiHpwYFuqWT+h2+5gdnU8mWUNpV/j1jkX+9ggP+pdB7yaKNqdxnum5VP4lbXNlsW+NSxKrSWAyp8kL8k79vFir0tbyoskiqoizl/vjJ/bMZY2SeLNjdLiu1NBHQhN/6edJK6A6fhvsFPwBUSPVKzSqwlbsTlew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_pa_pageout() uses damon_get_folio(), which rejects hugetlb folios
because they are not on the LRU.  The loop then advances by PAGE_SIZE and
looks up every base page of a hugetlb folio that cannot be reclaimed.

Use damon_get_monitor_folio() and skip a hugetlb folio as a whole by
advancing to its end.  Do this before the filters, the accounting and the
last_applied check, so that adjacent regions within the same hugetlb
folio are not walked by base page either.  Test the LRU flag first to keep
the hugetlb check off the path of ordinary LRU folios.

In a pageout microbenchmark in an x86-64 KVM guest, traversal time
dropped by about 99.7% for regions covering whole 2 MiB hugetlb folios.
As a side note, there is a small overhead of about 1 ns per region when
each region is a single 4 KiB page.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tested in x86-64 KVM guests.  KUnit passes.  The damos_quota.py selftest
can also fail without this patch; I will send a separate fix for it.
---
 mm/damon/paddr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b773012a876..aca48bf752c8 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-		folio = damon_get_folio(PHYS_PFN(addr));
+		folio = damon_get_monitor_folio(PHYS_PFN(addr));
+		if (folio && !folio_test_lru(folio) && folio_test_hugetlb(folio))
+			goto put_folio;
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;

---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>


