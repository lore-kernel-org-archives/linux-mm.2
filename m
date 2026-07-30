Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFE7C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BE96B0099; Thu, 30 Jul 2026 05:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0A36B009D; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E2A6B009E; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F7D6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AE858088B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:54 +0000 (UTC)
X-FDA: 85044863148.19.36333FC
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAD3F8000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NxmN25Dy;
	spf=pass (imf02.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402412;
	b=8n5/gIMDum7iUp7JP6wcr0TZBgnHdrLLoWwgI1z4c14hM/zFWbunSsi4sGjJh/xV6bcg3h
	WUO+tcXA6N1arnSI4hCPNaywLn5G9BbeJGBVsEuQsiliU5oeoJmh5QEEx+TSLhox3XlA9A
	2PRH7NZaYjrKgGsV0E4r9T2YDLmzel8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NxmN25Dy;
	spf=pass (imf02.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxWmC90sRXwr8zyhQC/Nw/p1hseuCo/SkMIrvBLGNgc=;
	b=ebwcXACDRc0LdjYhEWufT/ExF6cqZtQX7t7iLwEHtjb2GFqLc/Qf/353RXEBe5B1ucgwn6
	3mq2k5IeK69pI1rrIKYwMw9xIF4u7a/DR2CMmgXN7htMHIE1VugwCqAyECzAXg/9LDHDDg
	eskVNLSQ07LypDbt4ThFR2y605fZU9M=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39c95395230so15648251fa.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402411; x=1786007211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AxWmC90sRXwr8zyhQC/Nw/p1hseuCo/SkMIrvBLGNgc=;
        b=NxmN25DymuKs6AYe/yFfUEgOOy4vqozbWz8u6EEADL2ZBwg6GHay+1/22oVlXHAxho
         NX2r8lnT5fgwh8WFLnaoEF6cUvJRwUKZ46kDEFC7yvPUWP5jTo/C/NRFYGhbuxE8DBNf
         aubRvOvdqDOSCc5dqCXQHke0GN4/qZz/hlkhfPwjsOIHnMvcFcPC0TUuDIoceLB1b2/q
         7lEzurg/q9WlSV25zD5Q1E1IiSqEPwyRmbPXw2LDk8KadBvP1ZLUpGsKHc4RTPmyC7nd
         17sw+L2OFchkZdhW5anps5btJvKAc40cW1wuookGa6xwQxFVTvTaveTCSFn5pTepM+Km
         DHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402411; x=1786007211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AxWmC90sRXwr8zyhQC/Nw/p1hseuCo/SkMIrvBLGNgc=;
        b=h5Y/HrYUKdFCOrztMUfpF6dRAADlcrhefg5aMxXRpo10sR4NiSDLOhOkiztWcxsvFO
         dJuTOcC4yfWTAkKfiiRo1wm2sPljCuMPjZFFfZS38LJuwXSs6U/B+EbuDFnq17mvV/Jn
         7bjQrAGfxvbYWhJzUlztVCuMvBdya6x5+JL7atrWVrRE5atD48l18HP2+G7mlfieU/ZA
         1EfXm+jN9NJtIjgC7mKSev3mbkPP2WMOjHS736UyVczRbM1wFJqW2aS3WqOgMZ/5gPVa
         HrvDV/DaaImelIs/gWmwUsXUJhLja7NKfG6QyAUdcRh5NVKoNdZDNJfpOnMTQ+OVQuaV
         E6jQ==
X-Gm-Message-State: AOJu0Yz1JfOzfZQBb1tqVEr4pWKS0pqcvcggnFOGlVAembSFmfve1pxb
	qcB9fXEgAmuss36jVjjpvOcnXaEo0Jwj4rPeQcnWjOoh2iPHCFUAGh7NO63Wzw==
X-Gm-Gg: AR+sD12gafgM1VjwWo5H16pr1dfps4xSa+mVyip+Vpbwg8O4zClnqv5yqTk+AOmNz/4
	sPPaQqy+EODJSKgGSUBeI5fR+Z9oqPumG3wUg2HHspuMmYmEsTxIHfFOjoYhLQI6zDy2hqVKyG9
	Nww1SjgAfih5WtRman4bwuc6h5aqIOdfd6TDdpTMAwMiqpUh5SHp7rGMLfFFT/pRf5lgr2OjtyA
	fDdIqJwwhycft91q3SbC6WRErVlH2VJ/pyyb8ujfOgyTfShcKMBJso0hKeQL9Hh5MM724OTh11M
	/koAow5XnFLlJARES1ffb37sWEe5pgRb/7wxKkykAMQFFaEbV5SHEchdc/B5QqIh/kx3TkoIHBv
	E3LdXdQYd5R4cNslTPQnPYvvYwJcdFV/cooyVQJhq5OIrdnl7esB5oSI5e8MLvszPrXcJTERsXb
	apMROlfVbqtBCU8JELA3WjOdSd8/eNluwkn4ExoC9hHtJfR6AYKosDH7Qh6bfQNW9iQejLn2Pax
	PLUSskMXXChePm494cH4yiXDbffu5dk8dgatNXfCzk14eFVIe7PkQ17lg==
X-Received: by 2002:a05:651c:1504:b0:39b:224f:93a1 with SMTP id 38308e7fff4ca-39f6d0c5d95mr3342871fa.38.1785402410327;
        Thu, 30 Jul 2026 02:06:50 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f6ac80d6bsm1928641fa.29.2026.07.30.02.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:49 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] mm/vmalloc: stop truncating byte counts derived from nr_pages
Date: Thu, 30 Jul 2026 12:06:25 +0300
Message-ID: <20260730090628.65814-1-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAD3F8000C
X-Stat-Signature: 4pjotjtpp15iuukb9m73sywna5t6yb15
X-Rspam-User: 
X-HE-Tag: 1785402412-453542
X-HE-Meta: U2FsdGVkX19QTezwzHSlXloMsoAtNiMvu3sv/80QvIpi2ebAAkvdOubm+uEhD+MB0X93FdCIyx2MPi/kesdaZQBzX2ADPoxZphrq14RR9vApCJSVqLEVVTkjP88WdCOQNPC3sQXF9UUbyL9ATMzaKRy2FU/0RWR3i1IgzW/rfHYiy6DwwAbdjmxfgSPTg5e68suTD70GcbsNQnegGbrl2bgQbYLFslNabsbkyGZEGuWxApGkBT5ffHuSAoeQUKu5N1fMREgYk9MFB3MTQqoe46spQ2qfcAsfxRtILylNjrUIxPrHmXFMOvWtrkAqaz1MV8IaTHyaWgk7yFdKQeMv4W2wMJnLsXpLVJa4sMAV3AajK0liUiwr5U9uEVh0RUR9cDe9l20GCf63vpXaIMp/GP3K1nw1Esk4B/akbdB0QTweqvHdqWTz84uuwaVbn5fVCm+Ms+mb8iwxefk26ur/xzRWrzZgZ+MgLKT/ftYkgXJWtdUYx3EVVclnMK4wTCcnvx0fsxzINlC9MvlP/6ifnuCdIHknPwzgx4jCUPsmf/Iv4Ifluzvj1pnQp/ZpaFp+EZzr7PYtplPo+aOQdQhRxo2M404LkBc/Zr37PPAvc4bpSbhtVeh4Dqj5HU0cj5YVpuCbwo/TPAUIikSJsCWUdBxjI6c+6swf0dFNpIvxyqIVbw5GLXg44HjgeuGF21Lrqu+fuAJvNSV+UpB7EM7A9FxjHTAuLFkCVUayAFmaN+1vxhRwK3MG0rjzl4PlwMkSmYy01zNBz1vUO3lp+69LFyGcoxVUJN++9hQkYpE92Nedf+zShVr9TxuM7jPnr5rQgAIYavQeAjiKgR1BxP3u4bh0Sq75wvcTkxT3IqKfOdGa10idNlbwFggIJsf8AaeOaqXQKvWOKiiV4ILi/UeFSx1jna1QSovB5Dn0+n5T6ClLsgBXPkzEDslMpDkbngd802H4s4Lo+nFx6dcLiJS
 EHE4ZQGN
 O9s5PoBh22SjGN/lfKglmlrzbdv65g4er8M1znIGsClAaeQ7eNhE7o4nloZENKTE/UFeU0dK2okiXOD+Ji2jmnlZO2zIKIQGNXCF6b3UHEhCLh9M0jlVXEcUjpGkmlT9D0dQwxc9xypWplRzciqIwF/Tsnj/U4KVKO+KsuUX8KybzP0C5IdYeZewEX403Ujjf8kYa1dil72RGhwsvMop2HiWNNCvmkmv3wGbAntJI48Lt7998Hd4J5aHd2wpC5RU5zZjcrv50ErLM9SokI0ckGYS1pqjkBClWkQZInWTO/5cOxC12adUqL9HyfJR1eF1JCxYin/is6CrJcaR/QvDKP9SjgKw58MIaON73TNX3Plgbjfyb+iH9gZtxeIRoIqs2Bt8MbF4rwwFA3GUKWHlGp9L/fRmPUKvNQHRF10HY5UIFHtk7dIPxXBXFdSEe0FnRMlIIiVr59E10EJHHiMfe5wXj3ifMsFlPORI26Ep1Yz5Z/lo34PDgkA4PfxgoQeGse5r0MRHUa98JHlAFg2FMuYI3qqQCnPA1BOwrQwQq39ECkpfjJfR6lZ0dVIqBOYX/TRrq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew asked for a v2 of the nr_pages widening, rebased on mm-new, with
the changelog clarified on what has actually been observed.

The widening reverts the two casts added by the patches I sent on 25
July, so it needs those in the tree first, and they are not in mm-new,
mm-unstable or mm-hotfixes-unstable today. They are here as 1/3 and 2/3 so
that the series applies and Sashiko can chew on it. 2/3 is byte for byte
what I sent; 1/3 has one corrected sentence in its changelog and the same
one-line diff.

Keeping the three separate is deliberate. 1/3 is a one-line fix for a
v7.2 regression and carries a Fixes: tag, so it is the part that wants to
go in on its own. 3/3 is a type change across the file.

On what has been seen in practice, since v1 of 3/3 read as though the bug
had been hit: it has not. There is no report behind any of this, I found
it reading the code. What is reachable is the 4 GiB truncation in
vread_iter(), which needs a machine with more than 4 GiB of memory and
nothing else, and makes /proc/kcore return zeros for such an area while
reporting a successful read. The vrealloc() case has the same cause but
stays latent, no in-tree caller grows an allocation that far. The rest is
unexercised, and 3/3 now separates the two thresholds instead of lumping
them together: 2^32 pages, where the field truncates, is 16 TiB and out
of reach of any hardware, while 2^31, where the plain int page indexes
break, is 8 TiB and only out of reach because nothing asks for an area
that large.

Changes in v2:
 - rebased on mm-new
 - 3/3: the changelog separates what is reachable, what is latent and what
   is merely unexercised, and answers the 16 TiB question directly
 - 3/3: the note on the mapping path no longer calls the int *nr cursor a
   cap, since it is an overflow and not a bound, and no longer claims that
   every user outside mm/vmalloc.c only indexes or shifts the count. Three
   of them pass it to a narrower parameter, which is now named
 - 1/3: dropped the claim that alloc_large_system_hash() cannot reach a
   4 GiB area. Its cap is a sixteenth of memory, so it can on a 64 GiB
   machine, just not without an explicit table size on the command line

v1 of 3/3:
https://lore.kernel.org/linux-mm/20260729175708.7074-1-iprintercanon@gmail.com/
1/3 and 2/3 as first posted:
https://lore.kernel.org/linux-mm/20260725132201.88279-1-iprintercanon@gmail.com/

Checked on x86-64: vmlinux and modules build clean, and mm/vmalloc.c plus
every file that touches vm_struct::nr_pages are clean at W=1, with
HAVE_ARCH_HUGE_VMALLOC, NUMA, KEXEC_HANDOVER, DEBUG_KMEMLEAK,
DMA_API_DEBUG and PROC_KCORE enabled. sizeof(struct vm_struct) measured
against the real headers: 72 bytes before and after with
HAVE_ARCH_HUGE_VMALLOC=n, 72 to 80 with it enabled, both sizes inside the
kmalloc-96 bucket that __get_vm_area_node() already allocates from.

Artem Lytkin (3):
  mm/vmalloc: fix 32-bit truncation of the area size in vread_iter()
  mm/vmalloc: fix 32-bit truncation in the vrealloc() grow-in-place
    check
  mm/vmalloc: make vm_struct.nr_pages an unsigned long

 include/linux/vmalloc.h |  2 +-
 mm/vmalloc.c            | 58 ++++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 31 deletions(-)


base-commit: eee677bbc48890b2bcaa42ea7942478302937a09
-- 
2.43.0


