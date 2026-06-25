Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3153ACDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20A986B00CF; Thu, 25 Jun 2026 14:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2D76B00D0; Thu, 25 Jun 2026 14:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3AA6B00D1; Thu, 25 Jun 2026 14:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D96AC6B00CF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:49:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 543B81201DF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:04 +0000 (UTC)
X-FDA: 84919322208.25.C889167
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf06.hostedemail.com (Postfix) with ESMTP id AC19218000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:49:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MUGaXe1e;
	spf=pass (imf06.hostedemail.com: domain of 3HHg9agYKCFsLNK7G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3HHg9agYKCFsLNK7G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782413342;
	b=Y406mVz8t/QeZ5sHzeGLdLkqkhAu7PEsJg/bo74vFrNSGzIwQrFkfbwNMiszHW8dreBSIi
	k2CVjSd/L718EhuakMML5Xc+R34le/kxq9za2rLQEjcISltQWE4gSOj8iTwzLZa8N6Cb+H
	+335asNNB+nJXKbCqotAZ05GRCK6lKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782413342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8t1slEySKjYRNrpDBCSz0j8EtJbN7SppOvf4s1su1l8=;
	b=haTCOc3Ym27piPEmij6litrJPdQ/Q4yw7QQsEnadgs/slNya1u99/u7oLZrl+lXPCDmA/V
	jARN6ZWveBI4sUA40a1T7oNfCO2/z8ozx6UsgEQAFAj9x8htkhzgRxzFKGkKB1j1wmczsI
	bUHYXzpTDt2R3vRFNpZKJ0Gosgo0wis=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MUGaXe1e;
	spf=pass (imf06.hostedemail.com: domain of 3HHg9agYKCFsLNK7G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3HHg9agYKCFsLNK7G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-30c011c7cb9so578483eec.1
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782413341; x=1783018141; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8t1slEySKjYRNrpDBCSz0j8EtJbN7SppOvf4s1su1l8=;
        b=MUGaXe1eg104TKB/NEi/lwoYBEvlpvZp9uq9S4/qvfi9DxTeiZS15JFdqRZ120O7+g
         QCjXiiA3xILm5lWlMgEmpRQelNyEKykPLLZNvqdsIodqt1IO3H4dMozAea9x3QwVGfuj
         h0iPw5RofLB0k9MoQGyUKTgJv4Q6/bFUYY71LmJ9JOOuoxMoLG0mZyXc39XBb2+T3Xm0
         GaRVgMo7oVcHPMx/XKCZ1Afq8mM+jhsAP21MVPhBb3o6apqvWWp4Rnbyuc4B7od4+vxh
         pHL7gfrstnLF1ZQhGaCBl31HBYKXL936b/x0JA9p++TaPuC8TyxqvCYhT7wNcH+ToEfL
         YPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782413341; x=1783018141;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8t1slEySKjYRNrpDBCSz0j8EtJbN7SppOvf4s1su1l8=;
        b=JhVo4dT46YENmFJsY76ZRConTfDUX9AAbKkgo8t6y+2pT6E2jZkJum9AnGSarn5F9H
         GzmQAt28GEo484ns37FX3pdd/GXO2IAzDkZrzIaf0jeoZr6uZtUeirZBdAjNwFdY692a
         Soxa6nTTWJYmdujzU9QhnLQYLn87qQqhosDxPXoSnBoNUZc5av/oEVqKHU8MZYD9hDZO
         z0+BU/sFYeaUDL8ksGw/C8AIK40+vPG42NLJfDLfVtp9aA3Rt0lnF58Tl67paZUk4tGm
         oxlp5dsWHMIKSodJFU6RkLYoA85n7TIkH+Ag7xISups8My+lwOa25G/qBLc0j/x6JyFr
         DMrQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp8lvWNSfhaCXT623A5tRfc2dMlagOCwKtTye02eZWg0eacBKGvANCB09PJflTCCAfMYBxBpuSXpQ==@kvack.org
X-Gm-Message-State: AOJu0YzKwwNKfhSJog7IoGTe8cTbpz8tjyairVbx+1KojoWWtofdAncH
	5ipU9vONIzTfdEVIFLmHJkAIL2cAln4EJxbKNvpiG0yMfH9okgdS+lKoKem7aLmgleazjHnCBuw
	OQFAboQ==
X-Received: from dyuw15-n2.prod.google.com ([2002:a05:693c:880f:20b0:30b:cb5d:6afa])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:80cf:b0:30c:52c5:6e3f
 with SMTP id 5a478bee46e88-30c84fa60aemr4101831eec.18.1782413340821; Thu, 25
 Jun 2026 11:49:00 -0700 (PDT)
Date: Thu, 25 Jun 2026 11:48:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260625184857.2193482-1-surenb@google.com>
Subject: [PATCH 0/2] move alloc_tag.c file under mm/
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: eauero8j3iobcn5nxmcwx69hzrhefi57
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC19218000A
X-HE-Tag: 1782413342-130868
X-HE-Meta: U2FsdGVkX1+diYumZBcXW7oLXB9+ygOXJ9y4nWF8d50PpP8qADbhdwCEw+y0SAWIXdAhgR1MqqBACQy6PTSiXcczBhyAGPZwS+fc9Hj+mChg6rnFz+YbA5orSgaWUT6UEfR8aMcf3d/YrrfNEP02VbV0S7jJWyoVNk0G1iLAAGLOBvYaIcCAxIRF6w72cgx+s87VPIXiC/jBVwTmc8k3ggpIeTHrq8Y0NbhPDIFt656mQFh/n3wRVkoO01lhyRDPbML+mVLFgdWwcVJ1jZJjWrC+7WZyA17vpdgbPlP6715tMDMJd8pTZQq1+82StxeNv9SwtBcFHx0HzQLlfMGmLjofpyfzKABmR2C97fuSy1itW8dIFBgyq5fcSFCtCnQ35K132hDf0wK8FiU27MogU+T0LZrls+28mOpH7t6I3k0KyFtaYMqReb1Zosb8+oQcciF6lqqixpUWAgiovA7BXqqEI7P1uF9qMGZ91mLvtchyFP7OgX3IKQ0GdQNIbEzAekLPAOkLnicMlacMjooreAG699d4N0g8+2se/LgxcADWXQVH5nD5JN/GsKon1w7x9uuc2ootKYMrcSKtBSrWMtLbGiurLSqIlEYAsH+e2WsiyURn6ztbdBtIaeGZGAVxdUjN5NulD3tF5Wm1FgYKnZ3OQ/TMm5Hv3Ak+AGC3i+DhsxGcacotA9XflHxjuzzKpAjxlrNa+j8RyI6gIbIYfRTkWfQ6P70EZ0Bozkt/TPxMINC99W9Vd5vTTXrpM3I2b8fm3PKyrEjFWZ8SFnLHLuLUPA8piS5HZ891CWbMUy9vMsNaOJk8hpobmm3fmpA0AnOlU70D2JT4aT/dvQ63q+Dr1aqJQb29bOHkKts9LSjldZ1b3CmOeUh7MxFGKm6dDbKBsPC2w9Ppp53b0J27Fa7s0j8xBMkpJWBozhluCrNW2S1MXeB6Eho4Wwka9fL8thPmMTMkklxA7rC0H6o
 u1R5+hN8
 2FVKQEg0O+bB5pUS6JypLPaznfOrxr909I3tLC07a2kv8Sh6VcCDXCqVkMYr5/Pm2o0+RkMPAahSHbNTm4sX6pp8PSS759RMUrpTkLJyxXh9bnLe/uylp48q2H8R4VmNhPYNR0uc08HZPUekHHPDSshN5+LDhnHVgkhgRaHQh7RImZmLzb7iyCGhoeBs9Dv959RTtfOk56Ft1Li12mwUmZhD57U1PSMEf3ofBs/Rf9SXo31M3GWXqdigVvMUtzt6k0wXncSIMSeXLCD8KHqcmICkup49IYibB5vnzXnhumhxrOsefQEQJ7JsViU/c9G3QK72bd6+hGLUfIw8EMoVhDTnJ2ipO+iV6qf36059T7wJKzqdkpOO9RTxv7zKmi+sgRwc8r2NwTT+eEiL9frmbQc+SieQOEpm5mRy7N2WE8Rz9pmuxIpMGjXq6QuLWTyaVbr6ufvoQGitIAwWO4No6rmCi80ExSDYXZEOTn/gwBl1eUkVuPWiOZVptyHWcOZdbK8sdcYSdZX0xjaVap4Yd+iyGngow241Z5AopmRwJ/B+R3kqmXTgS0s1yHLOfTWj3Tfgp7IdVM6ey1qoXXMPbUMS0ra3bGO7mbo+cy5Velk7NME8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory allocation profiling is ultimately an mm feature and now that we
need to use some internal mm definitions in it [1], the time is right to
move its implementation under mm/. The move is straight-forward, involving
just alloc_tag.c file. Update config, makefiles and maintainers as well.

[1] https://lore.kernel.org/all/20260622-alloc-trylock-v2-13-31f31367d420@google.com/

Lorenzo Stoakes (1):
  mm: move alloc tag to mm

Suren Baghdasaryan (1):
  MAINTAINERS: move inactive maintainer to CREDITS

 CREDITS                 |  4 ++++
 MAINTAINERS             | 21 ++++++++++-----------
 lib/Kconfig.debug       | 28 ----------------------------
 lib/Makefile            |  1 -
 mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
 mm/Makefile             |  1 +
 {lib => mm}/alloc_tag.c |  0
 7 files changed, 43 insertions(+), 40 deletions(-)
 rename {lib => mm}/alloc_tag.c (100%)


base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
-- 
2.55.0.rc0.799.gd6f94ed593-goog


