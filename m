Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B090CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CF36B0099; Fri, 15 May 2026 02:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD926B009D; Fri, 15 May 2026 02:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A5B6B009F; Fri, 15 May 2026 02:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 924656B0099
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:53:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E21771C1B52
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:36 +0000 (UTC)
X-FDA: 84768738432.25.3E3B5A4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9C7E740003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WtGs3OSC;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b/UuIm+J2IgTzAVu/RaealEqw3KxeSmtMnC9OB/aKZQ=;
	b=mXYE+BgvLTpSsVaOp7QN/j9T4HV+6MPi2vRi5yAS5p66qazmBWr7Dv7r0TpV9IBcZASQ26
	Pn5kljSJDdp+KjTZ9uILF/Fgbpiolcqrbb2VGx+HZUNy4bY61Cg7p8wbCBaLTr4yJ8X50c
	ekFw0cT9GkmajYZkEcsWBYNI6JUYEv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828015; a=rsa-sha256;
	cv=none;
	b=CC9v6ZuVuDRVnG1X8RzOeWc3gAvoGx/Dl06aMgF8EVBVYgYiIOgUOFTMXF1J8vlhIhZ8Nv
	c/RjEk4qAZIDu91jKKUGnfZv4k2WeDQropRjlQACMskZ0IWKkXYisQQJdd4vbcJWEZiNQL
	rq+Yhu5+Z6eJXxuJDJ+XM8vdEzYytM4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WtGs3OSC;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf07.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=b/
	UuIm+J2IgTzAVu/RaealEqw3KxeSmtMnC9OB/aKZQ=; b=WtGs3OSC43oBAKoKFd
	WXa9VZ+dw8psK7DbNZ5SL7YlcIPXlg5XE9PKDzVJHiPL1m9dm0mCkS0Pr+Vi3ypU
	zqDcE/Rhv/eCkVrBTe+yKxaLSUwXVwhSk1O6c0/9Z7lqoSWid6GQL4w1rfAxiBBo
	nZjy570hznEI8KG72s6HWE+uc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBXDpTnwgZqtc7KBQ--.2204S2;
	Fri, 15 May 2026 14:53:28 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>
Subject: [PATCH v1 0/3] Cleanup and fix tools/mm/slabinfo utility
Date: Fri, 15 May 2026 14:53:22 +0800
Message-Id: <20260515065325.4009527-1-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXDpTnwgZqtc7KBQ--.2204S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF4fury7Wr17Cryfur1rJFb_yoWkJFX_Gr
	18Ka1vyw1Fqr97Jw1fuw17trZ5GF1jgr1jqF4qqF9rKryUJFn8uF4q9r9xZ34rua15Ca93
	Aan3Kry3Gry29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_O6pDUUUUU==
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbC8AgH-GoGwuh8SAAA3x
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C7E740003
X-Stat-Signature: 8jecooknjhixsrxe47a1m4jguatsja9y
X-Rspam-User: 
X-HE-Tag: 1778828013-177674
X-HE-Meta: U2FsdGVkX1/SSWxs9HD2wBcQ9QGrI6Mz5ccV1Lfxz55lHT3cKKL0VVqW1Q1StSgiajTt//l4TNjA5CY6K6znAIZguXYfjKFRyvbOvlUUQUgReDCD6C1LsaZk3zbhbtbcpV11FPtnpqRIc1/ya9JVrsdIP+KiqOdebybbGJNgTqYmYUyrSy9GZxlVLbswAM96xh0WIXovlTK2JgBJShg+n5EzM5KM67hPjUikUHmVKlqn/1rk7aSiwM0MoLtjh4R6SauYDF9NMrx3+ojCe2XMnWxZ4V80kyPk5Iq28gzaoFMowKe3n+IMBskYITdhg2HNqoN4pSlF04UVHD1HmVy8fKkM+q2ZPLj4esz6+gFYST7h2dvK0y7yCsBZ1quuBlTacHeFBYCBLZCeOQD6m379Qza7vhxKHo6rq4A1LY2MKxgjLZlZLFcMcecE/sXDe57C449YH3Uc8MwVn4+aheuokNzwDjWGc9nHFCl7XeNmdtdRonKK5WT2qo02HxbXfvfix7svdHA493dCIxE36hGg+ASMPWZhpGFqzhG/Xo6c91Ni1R3q4SOR+ZD2e3hXJFuA21RxPKA1XFc0l9oSGkkbR+r/L+QrY1tWcS5huWiRUDftcuvxrLbj6LkRZIENO6NPQFnutrEmrbE68yHODWyliwD2HaOm7+PZcRkjsfLn/UIPHVU5h+X24+Yi5nx4lb9tzZyp5AE3fEOvzO69ZN6/nOIbwDWC6RJ/NiIvbaZX640xkjXA7RYewM4zF2RsKAmsj2gy/UdxcYRoIRT/DXLzY/RtgH5SVKS3JLz6nbMR6G2P9v7X7kvc9wU6mzrLL4Iwuvg7eMLc8uDKj7mmKbRNvyiQXDeN+HWdlcWEaQMpQPxqRAveMUcTdRWe1Rc1UxMbYyTMDHUzKL3Q/ESupPPG91iXLozLpW9pb2gq3Q1UWUwi/M4O7kcR6lSf6wLhEsF/omPVJ3hkaBHMaBN8lfg
 /Vl4so7m
 alA9iBnmx0YOKvB4N9BHQIY3cPA17EEoEWOomUVFWjETGOACwYFQJFdZQXCHvc0evag3Oh2Do4RLFu2HyXVPDxx9N+JkHEI5boe2tf1E1fTADbNrIA/+l5AkxKM+DktTWVw/W/Ai8xGIRyUHpgte67VKAbM0arFd/yb4gkniyz65k9zYkwH52jmjBWxS+EiAGaqCtLVcuyJvgjGupaMWqYINBLq1qhR8uRsvzorZ5yAfD68OpYtCgwrGc0ipAjUnnaupHKeS95M52W5dHF+m4udG9rZahXKUfVC5Q/ZPg4ImAdaOpniNnV2o8vEBDu4ONsoF64/SQcFs+92qBA6o+A/mVjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes one bug and cleans up two code quality issues in tools/mm/slabinfo:

1. Fix trace disable logic inversion: when the user intends to disable
   tracing (!tracing) and it is currently enabled (s->trace),
   set_obj() was called with 1 instead of 0, which is opposite to
   the intended behavior. All other options (sanity_checks, red_zone,
   poison, store_user) in the same function use 0 for the disable
   case.

2. Remove dead assignment in get_obj_and_str(): `x = NULL` sets the
   local parameter variable instead of `*x`, which is a no-op since
   `*x` was already set to NULL on the line above.

3. Remove redundant slab->partial assignment in read_slab_dir():
   slab->partial is assigned by get_obj("partial") and then
   immediately overwritten by get_obj_and_str("partial", &t).

wangxuewen (3):
  tools/mm/slabinfo: Fix trace disable logic inversion
  tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
  tools/mm/slabinfo: remove redundant slab->partial assignment

 tools/mm/slabinfo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.25.1


