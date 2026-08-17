Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19B86C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 12:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443696B00C5; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B3D6B00CC; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294D46B00CD; Mon, 17 Aug 2026 08:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30176B00C5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:43:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D21014079F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:09 +0000 (UTC)
X-FDA: 85110726498.15.F34FA9C
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 88373140003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:43:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qXZTtngt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786970587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4fUYxQNQI9siUe9sl4T0IlOWMNDubqmMBb1FSe4NDw=;
	b=olGveY3vyo3EIWDmp9c+1N7SonDI0k4L+iZKWgsJbv3pi4xKGf8isBMFFGgeEP+PKkRH/1
	aOKdOs+XID2CqAslVt8b4gQuUWvtKFaKc8ZdHdgdC+CMb2KiQ8aR9GDFX99eHUwEajMcTf
	qIFE/ekeMUPBxs0S01bW0ALUD86WFM4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qXZTtngt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786970587;
	b=QhGtPZeRdYDtI1Wa3s3ZsfmWLWwq9E/bJCRj8UmiMGXJAh07wqBLK0xmoP1PzFmudcl9gi
	XYeTvljnbbWNfME33IzxVi8o7Bv2E7GjYOuA/MEow5ku4sBpyIowCBui6CvI1baL7xohAq
	JMHItuFdAXbE+1cmPmdg6abjZvah/64=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c1712a04ddaso552198166b.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786970586; x=1787575386; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h4fUYxQNQI9siUe9sl4T0IlOWMNDubqmMBb1FSe4NDw=;
        b=qXZTtngtkFRFA2RUuG60WjLQ1dSqzI6g0pPChe+BYbWUHI+/tIS/Zj8G3I18f4Lnss
         VaR7DXdwWubCqNQ1yn71C1O3ThByhPHmcfpnwF+S7aDTMXT5dHxjB21wcQmLh2JSUQl2
         srM87u81T0lhEXrup4QKf4BZJYIn6Kfcn/mz2Y4CC7bu9oRs7I+sarb64rGbbpHChNXV
         V8xK0mIbL78euu2E2JqFKWqOP6UixCAbaqIaws4af6zWP+NirJvkSAzPI9Ha7HGaMVMa
         Ri7VyiZRrG2cV+MY+FG7oGU0QAQ6Hz+T71u+W3AWn44xzu5ecFIJlY3TXOrvjL+NDWF/
         nt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970586; x=1787575386;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h4fUYxQNQI9siUe9sl4T0IlOWMNDubqmMBb1FSe4NDw=;
        b=oTldTuQjzzJuGQfcZ30g9RUDvt5VM7CZzYbopHKqY756ehgNUmNRRyAkTsWcbIWYln
         ZBGjjeXPBIzXHdY5F6AYM6F7UOC+OvY3N2IceyAjK+lLBo/quw1dhYinkDaAXwsMVPyk
         6hHTTnpnwX+LSBj7A/cbRBGFqcFmF77YYdjnWSdTzKIk565Ya8PU+y27K7/lcNj3dr2m
         PGg65U5W1/j5QsmMPm+xDXc6mygcwT9bPOWBO7e5nS8YP1LJFbyFrfUwP5HfJ/5h/RVf
         8K6TMNfui2oXXrpRXwN3ZpZy5jNu55tAqke5Zuw/WeQ+pUh6BGJ3EHRLrkNWkk4f7Qp0
         cIxg==
X-Gm-Message-State: AOJu0YzP1/96+iMevh7kDJSmsx4XNNGtUlsNQWS0q1rUm2289gE8LUvf
	uEjs2APpTtIn3dSYMM2KpJ/OGRZZDOLvnruWIIe3bqhbq1hPvt707xsp
X-Gm-Gg: AR+sD10mrpgnxDGu0mYYRHshvBOnzrEWLebgOBV+V+KT2jIyEi2uX8UNfGvIZtKiCFO
	g8AR9ocAVkKI97xcNsSUTF8Jxjw4hCorAVVLAGVXiIigCDkFP5ZFqBxX/5wCB0Mq0T9RdenQtld
	tCnhZ0PvP/a4//D8qLbm3HcIKBmDBd6Zltakw+ZvIX4+cfxJFg9b+YojUDRWZfhnEK4N4Sctkdf
	DwrjuV4E6s3ul0Xw2jpTUgZ7gjFys55jw/4h+ok7Be6FudXLJbUBKiMFzbKSxI8pb1KQqKDJDDi
	OjMXypYyjaZrIsCkKshAew4b6IXnhAjonmHRol/8T/u/60erDxll6zUZCmLbOS/CLjlwZrMgyip
	whYj1N9vx8bX7BybKghRw5jB36XJeYaNPpPin+adKu+r+AkLqtufpKrAr3wkEoYWGAFJqsaXPvB
	uF70grFxIOYn7n5GyVfCHLovOjIH4yUGLpMLkattVNM6bbxh3Y7w==
X-Received: by 2002:a17:906:fe07:b0:c20:191e:89de with SMTP id a640c23a62f3a-c212a1c7d33mr1077304166b.25.1786970586168;
        Mon, 17 Aug 2026 05:43:06 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:3861:1e5a::306:a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c217feb99d4sm52626266b.22.2026.08.17.05.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:43:05 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Mon, 17 Aug 2026 13:42:47 +0100
Subject: [PATCH RFC 7/9] drm/locking: preserve deadlock diagnostics for
 trie-backed stacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-stackdepot-trie-v1-7-53870ca1651b@cloudflare.com>
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 88373140003
X-Stat-Signature: 3e3z85zynjpf3hjhpqwwrgkho53rbi56
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786970587-16194
X-HE-Meta: U2FsdGVkX18lvxvWOrs66wuz7haYeYP0P1wkuvew7t1rI4np21zazgNA3Fzhsycn6epjvyOYA2suINDHBYywlE8Et7wtPS8UpisX3oNcR/mSQ/Vd7PIeA5yUdpFzWeQSIdoEYHKghjsCgRyVEBMV1Gpv/sCpawGCmE3JLO++logdu2nmKG20s+bJuHGS2z+1D6+x+EtN4RdSHsXkrq/sh7Ab8A9vWv5uws8hCp3irtrD3692Aufod+FBfUdbuxYo0JbxA0MoQqUmb2TgfAxyLi4pwNbiwPJ1fOiMDVLEVTFq0W+52qkd6lToNYCAncnN3a0bUqLvjejI0wxCHhCy4LWXotKRgE/iqp6rCdD1/QtOwHcKNSik3lg6i2LhGoHTWIjsqRl29ceyVC45HLZc//ub+2rmKKhcWgI6SXDy2DHK7m6poA0muBhBa0gnae29fpfPF8Ol6WT8sxp5XEcAJBodeznsB/bj58GwBMz2paArz7xYhu/pgsyfNy/D+1wkJKs6Cv/89MEBcAcASE/skEkpKxO852lAQxeeUFRg8pH89hy/D9mDhxffaCPN881kTVbidQywJNlaxwmfCLHBnlEWCUk3GEl/Nfx0/zxMvS91iCUYy2mSfd5astzwbERYCF0Frlq03q6muXdZ3PByZ4LnXpHq+LOgoe3fYzEr30prxs9ZOyC3iErSDqxtiij7IozrggUQOxbWMi9SMb6OY6eLwIV6m4Z8HARbz8hvkbqHCmeynFf2/6NhDOmHPyb/gNqS39f8DUd2DmWIrvMXmhAzQir/22Ejqd6SCR3dRpw7gmlw3PE0UcAb3yKa9h3tZVnXuSn/bhCXW3FAVFZYZ4MnP26BEHO0XYcnIlBNg7o7zTgZZeyw/i/0ABmf0BSEcW9FlUVB25c+U0o0R57hXMVrqg5wsPrxF1z9aeA7hCQm/frcZ6+ijNOqT6M5nMDFs6WVkjoIFVBWKfAdFQ7
 NI22sHrA
 1A7lyjPe+3uaij4GZZ85h8GEBoG2JUFjixXeIOctLGB6uDOAko99VowvE2PMSfn0av/NsQWQNalBNDAzCs7rj9RVXVuzTH+jZ7OK12IFTYCyqztLudZ8FW4aPa/zg0Q7SIiJXRAgzGb1SbxltjlwGnIb0+pcGlP2bqZvAO7l7GxLeVCQY1uh69Vwz6oe7iKBchlE+HxpRpgrGosHGqTdsDRnNwkRisVTZAe2w5iigoGSOxTaIFhF8scoroMbFrzQ3BrRB6+SbiPiDqdBMbqOIkgN6qCzrpqrghj/UjEGRtVxbmnc/AY1/qLr4Ovor0e6r5mi2vMHjFfEdpJ4DVfOBx3EehmJdTX4DpElH5AnTTRMSUrTW8/wnL0p3uwpaqHGb0wGzaThp8AQZHDQLB60yyWpYxA4NezBDPi6J+Wb7snzSklfcFjQWCMQNsoBOpRvkNlcWgQUX5F319BNMh2MAZ0S2KUBYwd2yVVzd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

When a modeset lock acquisition returns -EDEADLK, DRM saves the call chain
and prints it if the caller later attempts another lock or drops its locks
without first calling drm_modeset_backoff(). This diagnostic currently
fetches the saved stack through stack_depot_fetch().

Persistent stack depot saves can now return trie-backed handles, while
stack_depot_fetch() remains limited to hash-backed records. Use
stack_depot_snprint() to format either backend. Preserve the PAGE_SIZE
buffer, two-space indentation, warning, and backtrace.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 drivers/gpu/drm/drm_modeset_lock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 2c806b0146d6..a2ddb02b2aea 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -94,16 +94,13 @@ static noinline depot_stack_handle_t __drm_stack_depot_save(void)
 static void __drm_stack_depot_print(depot_stack_handle_t stack_depot)
 {
 	struct drm_printer p = drm_dbg_printer(NULL, DRM_UT_KMS, "drm_modeset_lock");
-	unsigned long *entries;
-	unsigned int nr_entries;
 	char *buf;
 
 	buf = kmalloc(PAGE_SIZE, GFP_NOWAIT | __GFP_NOWARN);
 	if (!buf)
 		return;
 
-	nr_entries = stack_depot_fetch(stack_depot, &entries);
-	stack_trace_snprint(buf, PAGE_SIZE, entries, nr_entries, 2);
+	stack_depot_snprint(stack_depot, buf, PAGE_SIZE, 2);
 
 	drm_printf(&p, "attempting to lock a contended lock without backoff:\n%s", buf);
 

-- 
Git-155)


