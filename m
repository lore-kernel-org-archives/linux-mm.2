Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1182DF4613D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E926B008A; Mon, 23 Mar 2026 12:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EEE6B008C; Mon, 23 Mar 2026 12:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DD46B0092; Mon, 23 Mar 2026 12:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50CDB6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:02:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C92B05C6C6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:02:19 +0000 (UTC)
X-FDA: 84577794798.02.24DC5F2
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id F14FE40023
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:02:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b="JH/4n8x6";
	spf=pass (imf27.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774281738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlomcdNVnDUltLo2uoCpQfabx00EAMLLoQfBL4FGNbM=;
	b=uRF/nfJEa3FUnHqc9JLL9hvTZXd5+nh9xukeGV7frA/o6msKK/k/JgZkrg6So7lW93Uk/G
	KxWGU+ihtUSf/3VR+cbQUiKZjgfK6hnS+ajhZmR09YU11Fq4w9GZ4vu2U6v33oc+Upg9rm
	P3onh5+Uu35d8oeURR5VRU6r96b32fc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bitbyteword.org header.s=google header.b="JH/4n8x6";
	spf=pass (imf27.hostedemail.com: domain of vineeth@bitbyteword.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=vineeth@bitbyteword.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774281738; a=rsa-sha256;
	cv=none;
	b=PKq00tr9WnhN6oT1xItdbjzy3HjAjCqbmCbGU90l6JPBELy5BuzNNdHBBg2IfO91IXaG4n
	czyKftM0MQYl+mira6Sg5xc+97HKCjzw3E+g8J5PBNnabBt6pr/YiTWFj2W6+UdPpBPDri
	UL5/joiWzDAWVSP0Bu0S1K998nblkko=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cd8dbf4f2eso28946985a.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1774281737; x=1774886537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlomcdNVnDUltLo2uoCpQfabx00EAMLLoQfBL4FGNbM=;
        b=JH/4n8x6UL7IdqVzGCHABEsbd9uX1LC9Q694L65bZUyfbrOcMX11joGBZJPwB3JFNE
         ojvmRFjdOS38VdTovNbWb6nKI7d27OV1MBg79B1SNeC3TptLWfbEGhSRRVnYq1Lmt2vE
         PUWH+/xgq3OaAUPwStb6NlVOdceOVi4aRFc6TBndwiDvOA3nIvSpj4gmCBVihz7tXPzd
         2K9EuaIeO10+Xu3NOgMEJHEIW506EaoyFhzArFIDSQq2D92DNUFBvvxw3pUhYcje6PCQ
         33XA2rgbcXK0WYqwMfnjaKV7LfKpCHu/J0PcvU8L3NovZZ/kdBrq0zMwRyw6pOIhb5iT
         CL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774281737; x=1774886537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xlomcdNVnDUltLo2uoCpQfabx00EAMLLoQfBL4FGNbM=;
        b=DUEHQzxUVNtItc65CLMF6oj7XK8CZSG0mUp8FoEAtwr0JPRfkbzuHJ+MGKM9niaxVF
         IvIkMAlIRqBstv8ZujveIuJ2PSZOHVvLB1YRWFf2Hg98S3hS8roLtVDTw2qbERj/c6mg
         uCquyHhfdwkJe8bt2FPwM04qs6zBx9nkNuLMkkyf9aqnTOpkl2Tp9zrhSP1BwqZ8sLVY
         HJK1BUKHepuNIyJaIGOxO+gUHMVFlN1CWsJxmmBLvnKOKHUkqXLyzpawpIRy/vEFgDXB
         VtQ61L8dT0rEpApKqQSFssXpNS/aU46MfwF3RabmNlUEqruM0uoXO5edqfjP+mvc9K8p
         spQw==
X-Forwarded-Encrypted: i=1; AJvYcCU2cJUULhXTADTqU6KjYBHBW1OSlIOV3NqAhcJ+Mrz9ZtBELBE88XqJO7Vab+Jm0Y5Fq0bVn+71Rw==@kvack.org
X-Gm-Message-State: AOJu0YwRKrUd8a+1q7UUQ4hxskkSoMyVrwghnfhvThJbLyP6UfqHC7b8
	HeTxDWWki+MQlheR5Ew0Aoj++OeO8GDOx2ecFADkOQ3quFT5TXDAKXi3Ce8i6yNgP90=
X-Gm-Gg: ATEYQzzHODoMnKGnFUg/KlDaQcDS2RuJA7ap+1wsxMPx0uAryWTkNILuzsWfJpBvKry
	TGeOikSft/CCNBrGk0E/yLMuBWjwwJd7v9nLc8gyD68LxGsw3ReWld/qrzkuZnmRvEcGwcgNaR+
	0nThGD1yltIOHuoWSf2zgzPNvYHmLLGWLKZH495XswA1RMe0K1hlaafpGRJx8JwGQUbg9nE6Oly
	bTWWkL0ndVN7SY3y5CmAkP/sp2DtMKLPeRWRnwa+qq2MG6+Gr0uWjNBtlNUWLl0g+D506EGNsJi
	XfIpsC6uPTO4eVm/ORrlFDOGiXQ348g/UzqMZ6tey87tXBt+xjv7L2uKT8sUR7vzU/7FG03hiCt
	LptGM0AHoj0Rvc8A5R7PivU+4YLZvcjAzVDAzy1YjdqcimKVGzL91FUMiZhbp//58olxmsg7n7s
	j3f+2EKtWTTju6ADF7Y1dOM6/sA25moEnpTqLjUnjeI5Z5HcPqndhp2nRWVYKhPeI7UQ==
X-Received: by 2002:a05:620a:1a04:b0:8b2:e5da:d317 with SMTP id af79cd13be357-8cfc7f69b95mr1829148885a.54.1774281699112;
        Mon, 23 Mar 2026 09:01:39 -0700 (PDT)
Received: from vinmini.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9088df1sm843364185a.25.2026.03.23.09.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:01:38 -0700 (PDT)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: 
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 18/19] mm: damon: Use trace_call__##name() at guarded tracepoint call sites
Date: Mon, 23 Mar 2026 12:00:37 -0400
Message-ID: <20260323160052.17528-19-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323160052.17528-1-vineeth@bitbyteword.org>
References: <20260323160052.17528-1-vineeth@bitbyteword.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F14FE40023
X-Stat-Signature: 8tacoc6yguxegem6qz56rwentxmfqttj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774281737-654457
X-HE-Meta: U2FsdGVkX18Q1YiK5/pAexoEG7d2s/b47IuqpKROSR1hHkaqZSowOh6wkrdBfsTlKk5aKVfMkUU4CTDU68GQtQ+8UCSHSXmONX1XYDMRsMNnf5oJekr9lTO0lffk7aMI86tfTd9r7tQwdd8ujqsUByZzGdztVwShBo/49K0qOJNaWcrXYQJGv4xkS3O5KJckpP+f4ccc7pW+nwHlLqL7bkRmaF8qV6J2W4f/FiWvjqeekQFXWYC4/HWz6g73xApQJFaGe5aOfL55W56szKb/pTwGYDGQYtlXIPulDjDdNh5vlzRs89XS854qENmiUdMVmhZStjS9J8U43bwc2hh+MGGhvcDRUE+eevMfLjyZl66eWinl3LcosR1tjkVN4KW52q0sBgdT2S7EA2ZOu9ebtycKpYuqkDh6eqMKZl+xWNbVB6sK+OV45Y468xk2ljlnA/80SgZqf3rHgQ116BVK3Le1mLuhyNFx+MygY65a77AuH27IiR/dzHUJBjSR0dvs9+WVZk702Ov9gmpGgDEyCs0dUQYdji8A85kGodObzly0RRgjS/dMplGoN8N2QSxk1QTBHIg4wsT5kTkgM3zoLckbQ37kRt2ei9AWFUE2Bz0AdiLcYzfE3cejyDmAdXIRzs1yIavckbvh7XQ8UBpMJwr4MbL2pGHO6VcrpY2i7x2dQCXhcH8XqppZsPs+C254aV0OIsmFLvHy+wpMmkzvBIqB0ZxS9orF1xyWJyhIe7WKN7C1eywXgTlNRYwLd8HKQiuc616w0rNQpJoSPdOzXgi+zqugcvQ2x4vhy2RGW6ZpWuthX9Bx1+i6nwqg3RfbuXGsiumpi+NELC2fvrQZ9li7uJyoVUECHzctE786W8Vc75JJYvUi8JJGtxG1dqzRApNAirWFEaJfJrz8ZhDG1A22xdTFpZbxwDuNtywTkvzDykcIyAWJHjhlYJInhqkPSkV0zkuUzdjJgPzlWDd
 H1deMRHU
 uhLZjKDARJOa7PLQOR90LCpzbN7iEYD1UPzxusvyHOBc3KDRLErC65ROMJmcWTPB7Z/CjH23GIE9izmmJTP7HcJCp4ry3tkTivHbNf4I+KIBeCqghdxYlfywWJnYh9YK5hnB/by/PueT8+aHRYeV/QsHeLDB0rfCHU7C0zDpUi1kAR81zieL2amW34Xq5UUFTWrRzg4iovD7xM0JxKvADje/W+epCtRJErJgDnbCJHSmiN5xJhoJqMEyh5OSmwDdvjINJDlkAC/7+7jZ/XGNd19Hw1xvvV7/LdxlkQdLq1aqi2PTvSpj8S63P29GGjait8ADacFFjkdBgVCdYXrLTTPWhauxmEwapLydxi5ZmjaL+yAaYwRY9I08iUAJ2odH11shHOh2hOKHkPlJkZe0A0XwcypkAxMO8DlQs8l0darGwyT1ZGOTlLA1ewk9g3dYBWJWBOjUxcCFF28Y2kU4fAZFGp5/2MquExaCo4BZb4tbgruH2xi/fQvQfIdEmkp44oVJ4P2I9B5JY8AXRKKBjpiUVqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace trace_damos_stat_after_apply_interval() with
trace_call__damos_stat_after_apply_interval() at a site already guarded
by an early return when !trace_damos_stat_after_apply_interval_enabled(),
avoiding a redundant static_branch_unlikely() re-evaluation inside the
tracepoint.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index adfc52fee9dc2..b1cc4f44f90a2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2342,7 +2342,7 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 			break;
 		sidx++;
 	}
-	trace_damos_stat_after_apply_interval(cidx, sidx, &s->stat);
+	trace_call__damos_stat_after_apply_interval(cidx, sidx, &s->stat);
 }
 
 static void kdamond_apply_schemes(struct damon_ctx *c)
-- 
2.53.0


