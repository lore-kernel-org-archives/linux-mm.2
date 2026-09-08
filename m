Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0745C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A466B0092; Mon,  7 Sep 2026 22:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70A856B0093; Mon,  7 Sep 2026 22:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F95E6B0095; Mon,  7 Sep 2026 22:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED7A6B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:51:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7262C026F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:51:38 +0000 (UTC)
X-FDA: 85189069476.28.F5C6444
Received: from mta1.migadu.com (out-240.mta1.migadu.com [95.215.58.240])
	by imf05.hostedemail.com (Postfix) with ESMTP id A54EA100003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:51:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MVZQTeUt;
	spf=pass (imf05.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788835897;
	b=LImFOcmksXA2y1D0AgyuzUZuz65WM2Ap3MPJqXk6E9xPjes5WR4r2YHggN7UV0TmiePpXj
	AL+YkGknoI/v44iIf54yCd3bvG0JCHOjRYv/Jxcir/8hrAiJJpt8tPLMm/AV/bxp2S45hE
	oywLV+fkNE2RadMR01TvgHzczfeX4tA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MVZQTeUt;
	spf=pass (imf05.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.240 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788835897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nw6bmNMGP18ni+Bs1TZjJCfWKFuqN+x3oy/X2Rve5YA=;
	b=HWIIyu2dxHs5rBCo0ywToKQpdfIcNpXstT7PdUTEjr1B4Xpwv7Xtd+0MtqlHn4QYFG5EJu
	+td/RjWRsWJ8RUQ429N0zLgg0sQS0b6XXMjoZWWROP9Ywnvur33/Yqh187biEc7H9v09bX
	HzFmVe2NTN1lBimxF/+SKm6NdVWvxGA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KbC4/aHSZoRhlEvoZxF6IZ3ATXrmb8tfT9i+DprXs1k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788835895; v=1; x=1789440695;
 b=MVZQTeUt5Y73RsUD+bo1Pz0ULyJqKUfhz98ey6iFrR1imIzR62fky7rF1qsomXtrnFHj3onB
 k1zSZXb4rDUz5NbZAJpbt0EglYKJVcaBj77EIw8P3olpN15mgaLMfP6aUt/fqswWwjFrARG0cJR
 N5dkrX1zx4L7BOGtpylsnu40=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f40b372a38627f66;
	Tue, 08 Sep 2026 02:51:35 +0000
X-Mizu-Trace-ID: f40b372a38627f66
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
Date: Tue,  8 Sep 2026 10:51:11 +0800
Message-ID: <20260908025111.34562-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A54EA100003
X-Stat-Signature: omurcigpnqk4wei4fkg7mxywiq4czfzf
X-Rspam-User: 
X-HE-Tag: 1788835896-220452
X-HE-Meta: U2FsdGVkX18IFwMUfDaunaDoXMjYDVq0qfaKdWzRnQ9JbUiAiSSfx8ti/UTW5Au/tEfidz5dal+F1ycKLq1vP960ysRelbFtsmlDgVTZW7WbKVo2bKRTQwrsiH+n2rQq5g+0CgDtShZX2nOldKTErlQlNDBKpHVtakP0DWwY/2TS/H6LTMIGL7+ba461Vs+T9j5+6+0/vPJu25axEWJsVgrnavwOKL6x3xypX6BdVdEAXCs0tQDgcWsBHzj1iB7c4Se84idIxFgYI5LjxADNzSspFacvTdD8UWLD5VODjbGNC7uawESVNlDaJP0MdEPP6UnsPYQR3cPse+Fo1P2yuJVXxBrkDhX8zJf77JulUGC9XxCCh3eRMkC/nYzYSEN7TMvbFvTGckaHnwnHG5pdkyU9TCcF4/Fj99dE1II0sHTodM6qTzXz51nN9FCm9vLqH46Js3TpkGxRBlmsIZbjF1DuIbdN9WL3HsRvLFu3WqRmxTFU939TlsqeAjP63Ch35Vkx3u9N7+xsL5mjeYSYxFRe72PR9xWAJ+QmXb6bEF37CGIDB+SIUKFXVO8/6ECh+F9FNee0e/OKUD32uH7cm+RA+eBYOv5IYVI6o7jCKjOhArYgrgzeYBIf7qGBat2ohn63d10Z5SKMVRbS39ucXGTvRnd7szFHmFlHaIPrZUiOqeWRCufD9Yhpek09dAKuOoR0KeGbiJBl959j8r6W5CVNevGQmXY9iUInnn4juFSzy7bqQnhsgVA+Y1jr9aYLlNrlgJ1948CQchh8i6pf5XWLCcEzCmtfSkT4RhGAPobIpQKv6n/6hvw7QuQn8h2GFyecwWB7ZzoC38DVAqjfsLCdZpbc9Iarp2pIaAkCr3ImQa8eLWccGUtj3JOihFtiwT5uXjL4lx5D80NuL2ue2Xn15SfaGDp2Kqwg2wC6Qihh7qFkz5tYpxSCPB9qEFAV33aBTUq3XnZ8TQ7jtq8
 /3mBfZvO
 9Y8xMExe4WwpEs6VDpAF12RPoJIF6mXrePyD6SU+s+b+QZhx/KB1pkFbTjl9o+d3xmEX9Rj9XQjB+ggOh1lqANQi/Z3ZKGxboUH0+Nbq/GD++i1juWzdtQxBZO1qZvoKGEmTFhVaxpNtc/Xs9U5QiYQoTXBL8eoC3V8tNAM7tfeb3WW5N6/4E1yzfk16Fmu1eiNgmy5nu5GsvRUTHfTfFaOXHC/vJDO5J1QslU+8TdqWUAqxgJeBFMGSBRv854hbGlKFSuZrhrZxIfoIIB0CVj8dpR61cqhfbWVk1GgOp5skhjO8jiurdB4eyZbN6Izl8BtIuMF6dxcep0pRRZlTQGSRknEUkMtjzQsgr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

try_ptrace() treats PTRACE_PEEKDATA return value as a boolean
check. A successful read returns non-zero data (memory filled with
0x55), causing the test to incorrectly report PASS when secret memory
protection is broken.

Check the return value against -1 instead. The test should only pass
when PTRACE_PEEKDATA fails, which means secret memory protection works.

Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/memfd_secret.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
index c55d84c5e613..dd08a3a1ef14 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -145,7 +145,7 @@ static void try_ptrace(int fd, int pipefd[2])
 		exit(KSFT_FAIL);
 	}
 
-	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
 		exit(KSFT_PASS);
 
 	exit(KSFT_FAIL);
-- 
2.54.0


