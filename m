Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB152606D830
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eQS8pVuf
Received: by kanga.kvack.org (Postfix)
	id A852E6B05B2; Wed,  4 Nov 2026 03:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34316B05B3; Wed,  4 Nov 2026 03:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9492E6B05B4; Wed,  4 Nov 2026 03:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 718976B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:49:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8001F80657
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:49:32 +0000 (UTC)
X-FDA: 85396812984.03.3D198C1
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D24D1C0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:49:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQS8pVuf;
	spf=pass (imf18.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793782170;
	b=OU3Meyx6duuM9fC4KsPRuvsM1WZT2k/OVtA5MwMqN6rICGu2lAlCXYuiSEKPgYNPiepUDE
	LR4pU00pDFK3iVF0MN+eh4lF9nSKQwSbBii/dNZURE0rGs+6ThzPTynN1S1RbEj1v0NHo9
	G4VyPWxk8CdpvxYcUGC1/ss2r/gyFBA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQS8pVuf;
	spf=pass (imf18.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793782170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q//KLy/Y3a7AScx/MmTv5eY2KIWeWBr081RjcW3CxKM=;
	b=17/9VsHkilisDcGwEYGOuCGbduIF2hyDUf0e/LI/4H7nMIILFLjdGLVOEdT/etbQKO6g1B
	L24hJFJtZx0Iqytu8GYSJqhYQZngvKO40rR+sJqPCKuLQugF8EuxQP8cYW7qjU9t777YI2
	BYh71VNSOQtCwPriTJywObkStGPwxHA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bq4IEJpkW+t4LROfZMKt2jm8AGqf9jqC24Qsw/6wVsc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782168; v=1; x=1794386968;
 b=eQS8pVuf8z1mYX50Gc3cb01VOvC8JeIZad7wyvD9EQRBkNJkeBJRnJILRDRQZgamqk1J+AQR
 exoeFagpXSLu3LF+QUnn8DV+Sz5oMcaSSte+uSLm5zGynSvpiybQ31V6lYc/Qn5JUezmaLBdG6S
 718D6PvZRhyeMuDvMtC5Nk9c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da5d20c7e6b5b114;
	Wed, 04 Nov 2026 08:49:28 +0000
X-Mizu-Trace-ID: da5d20c7e6b5b114
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Wed, 04 Nov 2026 16:49:10 +0800
Subject: [PATCH] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-for-mlock2-v1-1-57e6dd74c2bd@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQwMT3bT8It3cnPzkbCPdRDPzNAuzlMQUE0sLJaCGgqLUtMwKsGHRsRB
 +cWlSVmpyCcgEpdpaANvwU+ZuAAAA
X-Change-ID: 20261104-for-mlock2-a67f86dad498
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793782165; l=1119;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=TrH0M/9tUoCzlZ3bUvJkj4Lr3dyx5ztg1IswD37q+0I=;
 b=WmH/pfqlq6pR575URCgIXVvGxuYTxjdPhqE5cs8pgXFUDR7U2Tp3R24PgOHB4JspWE7i65a0A
 ffZGGbdU02BDX+52xJf0B+QMiNGA3KHhVvTvgCkyv5MBACTyA7DTBdS
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D24D1C0002
X-Stat-Signature: rsz4uz8365xj6xmeccwx1krtzpt87ag7
X-Rspam-User: 
X-HE-Tag: 1793782169-136967
X-HE-Meta: U2FsdGVkX19v4IVS7SUUN5V1PZKzG053eopUfGbsGpdN1Ui6HYUX1qmCiVWwdujLnhuTitFmDkKzbtWTK3hfmghVbnsezVN1det/GUkv0Kaoj4fUB0zPaefUpNVXOqlL8eE0YkPjVHIbCnFUiizsWsZC1MWVRTtk2zCbQuOQvvVA8kNjy82pi3xrewjNeEk4/T7mfAm/KLIeqX6dIFsNsoTgsGtcnBo1HJMGRLMpIwWXdHoNgTrza28P2XKegWRAbOC23HmgZc4g4+PGDhZn4p8AufnXx9V3M4T3UfKxeC1df3Belirc2vLL+VCK4e0kqqyG+0+UQK/SgJ7N9LxOfTtIhEr17m5ABz7dOp/JqshlxdhvqpbUhFw5z95OB46Qgk/Wf2qysyEsP4PnUqwprBs2oas4dbh6sVPTK9z/WlwL5Gl4JZ67Ath7dmS4m3+qKjzXRq/6PLQIC3Wi7X+i3LO5KP4laQsWFP57ECqemc78b2R+m4S1+K5BqOE8hXEEn7I0ndpToS+YXx/8tKAeJ2bbGZ+RlM7ReozKDk0MyZrx9axTllHA9I0MvNukt9vkDdhoi5j+PbfdJDGwU+gIsd+QAPorZxaWhz7vsYlGC2IyEdSI6t3NjsG2lAvcHYGnSk8gXkrmB7zv+UAKCC2CjQIUOLuZfX/Pl1tzvSqHyRpQ5RBIuUJF6/FvjMNzk1jybQD98O5SUd7F20Tc2FIggotAbaMAZv5pZoKd7snd/TMRI+FipUVNAjuU9SjAksk8tTeD8ql7NjWuP+93ZFQNbiHPC2y2DbiuRinT4LyioNBx2ZoWuDGLxpQ1hV2zXaFUlkpZ7h05hdDU3ke6JOuHGQrg23oWOYCKpqjRthq8kNwH/upQj+l3XSNsKbuMtsLsUayhYl2IgK6Zgce6Z0sUSs4lI9l8QCBTFI53sl6bYjpZvRhCrsCpVHGBFcPhXjanGGE1TIcoKYqWW+HMcCl
 BJdpgW5E
 /VsLJexglCddNJC8+O7/xjO+VHCluAEpNkOwrW0C7kjJFlMvMKkYVASIfWQtp80iSZmoiJujNA5xHPZaGLrIXRx9QTgaWJuHxnKDY1i6HdBs1p0LwEfc0y2NqD2i5wr8MeaBtxVV3HLqIMQRLxFbd/2Jf2tIqfGkgqRQCItqW/arEeejVk71tfhTIfNkukbO/RqGZuSuQ1MY1tCXGhCGOHifBFI63HOkuJ1X0sUwxWpIqOf8AoQ4Rsm10rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

is_vmflag_set() jumps to the shared 'out' label when
seek_to_smaps_entry() fails. smaps is NULL on that path, and the
code at the 'out' label calls fclose(smaps) unconditionally.
fclose(NULL) is undefined behaviour, so the test crashes before
it can report a test result.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/mlock2-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 144b550813a6..85e6cd24515a 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -66,7 +66,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
 		ksft_print_msg("Unable to parse /proc/self/smaps\n");
-		goto out;
+		return false;
 	}
 
 	while (getline(&line, &size, smaps) > 0) {

---
base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
change-id: 20261104-for-mlock2-a67f86dad498

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


