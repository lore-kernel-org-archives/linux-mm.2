Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0055C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5226B008A; Thu, 10 Sep 2026 02:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5CA6B008C; Thu, 10 Sep 2026 02:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3576B009B; Thu, 10 Sep 2026 02:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA8A66B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:44:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BA6EC041C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:44:52 +0000 (UTC)
X-FDA: 85196914824.02.81316CD
Received: from mta0.migadu.com (out-200.mta0.migadu.com [91.218.175.200])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55C6840003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:44:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNubjFmR;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e318VQ58QIXBKk94juM9lnAeH84bOk9nVPxKJTzbpNw=;
	b=a+3RfJlVsk5WXhWKX8jUBZUQCbygJAIFPAje+fOy/bkrCPsLJbzUDQNkv298yKSWNjZVYi
	+RqCinCMD/kEsGQlprTA1T80pIezGigluMU7IsjiEKp9S6RFPU5D90hpLILR80Vjy0FxLu
	BHeDthzHoSxuMNudEnJLEain9QUwpig=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022690;
	b=U7YyJ7foqdjjG/x60FqGlMQ9y8XmlUxVVBCCujRUGCfozcrDHtkqS6Ti4mSmp2w9AfDJeE
	GJxW/0zeQoRn2hveNGeNAH70WRc5QzYWWTrkrBhXT6tcBK2VIqzqTGhE59GSZ/k9laJHFi
	eaPup9ftl8meSYqg+DJ/TQUPzRbevf4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YNubjFmR;
	spf=pass (imf12.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.200 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yBUrNGwIgiJGAXA0ONd3HE3wg2i9nbJ983f8uZj0C1M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789022681; v=1; x=1789627481;
 b=YNubjFmRhC/4XbUlHvgq00a+HtrpO/7fIU0OsnNHAnquE4OKV4hCdfC4843PicpCGstj3Pe4
 /myiJ7wlbQ9dshwLz/ox9Ej0jujncZjOAz4AoO0PWLFaLAI+Ba5DPc7OW8t15xWXrHLBVIxueQ7
 2lWTDNR+naPTcHr0fgeKWLB8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f6102d5745d8b7b1;
	Thu, 10 Sep 2026 06:44:41 +0000
X-Mizu-Trace-ID: f6102d5745d8b7b1
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
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2] selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
Date: Thu, 10 Sep 2026 14:44:15 +0800
Message-ID: <20260910064415.71623-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 543hcuszubt5kow1j4nsxto7biyngzmz
X-Rspam-User: 
X-Rspamd-Queue-Id: 55C6840003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789022688-291916
X-HE-Meta: U2FsdGVkX19EFlkmP4tHYU/52fu+/bQ6b+rYYRggBlJK8aaehFCKvlb/VRCmYqXD34Ca2/O5+Hwwb6k6FBuBuOWmxxlKvj6GapiUV6ojKWH/vbX/9YQNuc1rCAtRuyqIowm2XAsn5kWe2tdLjxSj2SeZxiOZJ1ZuantizAICZcj1SPUCS8bqoU5YvnApdBZYRjbOohufc1VWMVcwRgsu5T5D+VsuV6XDtkI5IGAPUEdAr0GKu8XYDoLFxj/zxSg1QbGHYu6ARXMfdM3aPDi2HKpTMiUdstBbgkskB9khpVr/TkewFnT1LLUI+YcZya1Np1vefXqxIAa6aiCfMhizkMc6EtORqvF3+ESQ8ZKkV4tzc0afQAZryV+e2Lmb5ORoyRnHNkpuO7/JIVbB12DHDhPDTiGXJ6Oj28cW0xkT3H+l0H+WrLeepJAtOw9iqzthUIqgPVJNGHQ/epR6swoLioHKaPb0LjCUnKL7T2pm7ZuQ/wmjKvMrSGraLuCSZUeM3jWgk2Nknf/RY3WbGFEAcf2LIqF5LWUB0dljfatmhvgONiRW6UEMGclt98RdiSvdWrhF3IzXGP5j6nSw7uawO8YiHPQHpiLtAKgDCKfgTCiPynmgYTIlh1uJs+ZvWrtMicmGVM4evYX1yKUPvd1wFF+V1LrgeL2XBS1uRJvE91nf2PdZdZ7I6DlUC2pf6iFDuXQye/ASoX/FEEWcILUZNKCcSA2nujtFO8V9omSqCaWDe/Hx41HQq3/biczSC1x/RNCshtbYSPbNfgpBJzmKZYNcid8ICa4jRHkWFbrCtuYh5wo6wN03m1EeiDqlRmz1wvLLLQlwLtWhVwBN+BV+DTeGjR0lOdKAnzCLvrFykm3moX9tRkn404QxCqtc6+cLbmmMQ78xbIbURbQSTvAamKI+C0qwo032WR6vR9Lh3Go4LXqnCoNTuMSVxfJA+/jk6JIinre/dCZzWR+1NX9
 vBhoQOvI
 wQPFSos+EJtdB4TUWMha5F8ah5BZuIiS15lmKlZs3Y6oyHwEqSZLjfr3js2FQ0mxo2Ztpgwqn8u5iT79pKMZV4ftMgHfLuiyxTUJqWt+AJ2/gXogRGkbX7FMRoWqrUFhU0zZJRqip5XxXVCNq9LZjy4a4KkefGRxqJcvdpWTZGIzOepp15LDSheZoDAHsRIqcknUtdlol6AlksPkGsGn5TczBALzmWoPrgSvat/Qcp4OjQprNnmDIDFSbhKsAAWN34pMkhNcv77aktbQaWj6RFH6870S7WucWvUPZQCPBUdLMkHCC1/1A0y1Pd1UMd/pmKtGi8mJijdb9hsOX75qx1/O2oQHmadzg4YEKpXT3ozRQgQke5Y9bntgDu5Qalg1TZa7V6S9GPHF0L5gPpIXzu1fZa2ViQdGFOPnq
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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Add a comment explaining why PEEKDATA on secret memory is expected to
  fail, as suggested during review.
- Add Acked-by from Lorenzo Stoakes and Mike Rapoport
---
 tools/testing/selftests/mm/memfd_secret.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
index c55d84c5e613..aef774be87f1 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -145,7 +145,8 @@ static void try_ptrace(int fd, int pipefd[2])
 		exit(KSFT_FAIL);
 	}
 
-	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+	/* PEEKDATA on secret memory must fail, else protection is broken. */
+	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
 		exit(KSFT_PASS);
 
 	exit(KSFT_FAIL);
-- 
2.54.0


