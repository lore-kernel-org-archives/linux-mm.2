Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC83C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7CB6B00BF; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FFF6B00C0; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3C76B00BF; Sat,  4 Jul 2026 14:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 063316B00BB
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D6C61C3736
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:49 +0000 (UTC)
X-FDA: 84951887538.22.2CCCFB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id DAE9F40006
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwjGmKH8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188707;
	b=lZGnZEVlP3fBDzDr3awfMIok+E9SyCBhQIhdAR1YO2WTHeZnAR3aQ9xudTcwSd8e7U7ptU
	aQWTBhTKiH+l37bcJXtLTEKB2Xgfg2gvhEcTJ+ukcAynj46b7Yutuzd+NQLOl+b1gyr8h3
	U5Wyo2a6kPb6f91sjn2jkAijmTg6MTY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JwjGmKH8;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	b=6HRRgWARviLVyldJLrxh89D3AezlX0gmGKQU/0z+kAO/k0wbEwck472maHbVjifU7YDfH1
	DfDmHJLEs4tT4qTF9g8HFJCLa3FLYKLgRV7o8E2EarVtdbGyvgqvx7t7AdGIuS4cnNQLGV
	xbYGv96w6/sErBVi6Z/cV4zINl+76/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 682B660EEF
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BBDC1F00A3E;
	Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188707;
	bh=LS4CO1+OYp8+pSPAS3NbVTVyYCl94ZecPiNEYxC3hmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwjGmKH8EFGhoDc831CIAQSrtTGXEUzuPUo/drzvqVbSey/lZGCwsp++HLFvK8Ci8
	 0ZwaKWeXPMjXieC/ALlqSwTXyaHUx95hH6XpL7nUeOB5Fws1aMqx8CIuX6yKtYwhJ+
	 lcj4RAd/d8qUrKXV7IRufXex9bJddFpAKI9d9p03t45Us5pgzmh9bzsqFK2rfNEf5q
	 DOYGDLhxo10R8YtJ8aZnvi7Hzn63kQTMY2ZiblwTUuCveq+EDxBvKiVXJlBykk9veF
	 WS8uH842NJmjvX5v4+1pMlqrL8SDLQbKBUSVcxuvtD3ydhikrd8OwatiG+rj2XU/Nv
	 UzPHHDHyCSdMA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/11] samples/damon/mtier: stop all contexts with single damon_stop() call
Date: Sat,  4 Jul 2026 11:11:31 -0700
Message-ID: <20260704181135.132956-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DAE9F40006
X-Stat-Signature: jf4qusnm3z8y81xb1t99jn3kr6xhrswc
X-HE-Tag: 1783188707-670465
X-HE-Meta: U2FsdGVkX194tQMp9Vw0JqqW/1bSr6ikZmp5/iRuhdMV00ygx/sze/UHGsSeGcrluSKefEnMJ+CWSsmgUq7LM1xlnIUia+80g45UZ6vIRa+dSnGTJeq9EXK8bfqzdnzoGLw2yEZ/3gqUwv6VVCgFIcKn9QmULOBjt23dDbkDFIGSctbeCIZHXUK+9LmKmKJOfKVlrW0d5VFp2P+AZ7qiMl8/wj5MdmCdOnghTTC06EV8OAinrZ5XxtLWF3OFPFE4g5UPpYY+/u7jRqIJDSX2H+pvSbjb3pyJGQo9ZkoYBThVgMYeSVlET9SugOg6suYQ51ia8GrUcA3JMNi7PlAHxUNA/0U3ueLTAGr0/UBIty/uboLAZ77tls5+57PZ+B5xtVuTi5qcZagAqEnGzRt8xZgb8F5an22pzPPqLiJBgJ1wtXWmhpdqKwwPChJj6eoEPRRzt1ZeCD0laWbFni8hnyCMEluVW9e3iSMcKCSZFT2aTTKwGYF+9Hv+/CZ+IZoMJhERIWy+8592O37hRQhr+cPw5k4PS2bAx00b3+HGx+mMjvQqRcqT+4YiR1KoJ3FvQwGft+1PpDbilz0aOAlCdm11NjHY784qvttmyT3zEyFSvE6PPvlhmF0Lm9AdJlrHJB1vE9kHAFGSzr9yBW/cdQjzJ3ddEWSd/6B22ZQlKdAVZOFdIoEHib6Y1OfsL0+OLY6Su+ApThbArY9KcWhb/Sk+kH8p7e3g9QgwJAmb6B+GGhkzVjEnAgA1+M3k4xj+07eMuQdesZcbej1y7tUfCsygxMzZFv4AuntM/+Q3O5pbsCN6s8d50oGVh/xQAbOnkMft7r1RuMzoCZmvoZ8tAT2KFdzzrnN+C3EVvcqDQPhBzNlK0rs3rB3lKNMCEmhwuna5csQMM7vozEOFMsWlUWBjo46G+S/nmYTZe97/M4CLQvz/teXtat5n3S2VUoiLhSlfPuWYx6bVhuepQis
 61JqoRdh
 YcKtavANF0butJjfoQGnm16lK39ZsRvc2RoFOsnehrRidYlh45AXgFgFq5baBOH2SQ2SPgy6QCT5jIC6AQQ+A/w2qSmEzqnC+N8dkwkNgHOK1dsrMExigFYf/48bwa55uCN1ONSMA7s5lEhLm1OB/v+n2jX5x4jxEQpPPAItlrozhls6q23VthoPUQ+8RPrPMUUpXZ9Gn4qD0xdIjoqyyRgm6m8uqowdezJBIABR4NBZXyl7K/sUvNxk8GhJslgmgaP3LyjObccU1rPYuf+NULkixhd9Pc8vhCt40VS9l/QXg5U5dOOhqauZscie6XPObjJNXyPnRiOj23O4/nL8htQBOceaO0nLh1kVPTdzCV9ciDtZXzYaRQsGTWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() was theoretically able to return failure while keeping the
second context for mtier running.  mtier stops its contexts one by one
with two damon_stop() call for the reason.  damon_stop() is refactored
to always successfully stop all requested DAMON contexts.  The two calls
are unnecessary.  Use only single damon_stop() call for all contexts.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 90881e8bd441f..ac9c24b92ead8 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -200,8 +200,7 @@ static int damon_sample_mtier_start(void)
 
 static void damon_sample_mtier_stop(void)
 {
-	damon_stop(ctxs, 1);
-	damon_stop(&ctxs[1], 1);
+	damon_stop(ctxs, 2);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 }
-- 
2.47.3

