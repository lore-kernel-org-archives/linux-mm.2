Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 821F7CD6E4C
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 01:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8A26B00D2; Sat, 30 May 2026 21:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EFC6B00D4; Sat, 30 May 2026 21:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95946B00D5; Sat, 30 May 2026 21:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B78986B00D2
	for <linux-mm@kvack.org>; Sat, 30 May 2026 21:02:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79E9B8DCB8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:02:23 +0000 (UTC)
X-FDA: 84825914166.09.5187CA0
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 956332000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:02:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AzIS6vI6;
	spf=pass (imf03.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780189341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcbBqWTkzkDxwNMdgJ7xVJp7N/TN/+GdHi920u4savY=;
	b=mms0fpk1/HsJTu1djrQaxOhjeMPw0io1FhCrSmlW9/tHQ6vgwAgHLPFHe3u2W8jMmG70Iq
	P9RGQwpORlMKyEtJ6+/p+PwJ0sUr6UcMoGIKeSFKGMnFCuvGPqjpmhuqkSGIeyWc3s8jfu
	/y3/udPUVi//vSzX7q2q5J1J3mXuvbk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AzIS6vI6;
	spf=pass (imf03.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780189341; a=rsa-sha256;
	cv=none;
	b=A+2gZAbPuENu2WHJtJ2cASruVRFTuxpkewDnNgARnOYhn+vP3MLJGjMMGL0nCwj47zTu5d
	IBh2zd5aFNZiSILHC+8cCAvGet11LqXnE65e+HYFqkrJZoULdEJNytbfGoVqzO+/bs9EPp
	U0xUI8rGCm6CpiOjwJZ+dTTbSBpI1bE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490a7876f8cso1431895e9.3
        for <linux-mm@kvack.org>; Sat, 30 May 2026 18:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780189340; x=1780794140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcbBqWTkzkDxwNMdgJ7xVJp7N/TN/+GdHi920u4savY=;
        b=AzIS6vI6Z4mtCMzJuJf83S9BunbxX8sCZ0I1K5j5WBMNTpng9q1QL3gkAj52LgcD2k
         DleR4QGpCUP+W/B7OuUont9rqCIkv5SktbBsG++CkFhwvPiJ2i303Y/AR5NTvWG+m9bB
         NbLyda7piOXv01ew1Wm9zwJ2G1494ubac0f0JsboWtZVVCdgmJava6MtPkr0eo6A1jVV
         dOvnHCM+qlEa6yuGA/+OfCx/9swxoKvV4rld8pH0V4IPRho7UWSjmuJ8a+GSfdZ2K7ij
         unhDvzWvqaduGGHgsqRab632bFnLhrX6bPlHE3Uh3IIRcSnmt3hBvaslpEmrMlfxE3k5
         iMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780189340; x=1780794140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BcbBqWTkzkDxwNMdgJ7xVJp7N/TN/+GdHi920u4savY=;
        b=G3BrJ1TQnE2mnUdOAD2KGtjxVeLO+yFEgFY+AzF8qQ/x/s/064ywJxWW6FdPEjKiqZ
         PyxffSE9daBuzuU2lgJ5R+UsXhiRuGCj72pJ9O8I7RsvV7NkWir2gSGSbF9OO0X62qSS
         DgljkihsPVKNgQ/UH9j57AEaIgI1OUUJ113vynAIKVcpsvJCQtT2qhyMOCT9O1Djr9yK
         n+gba+MjULhKO0b2mBpChR1wp/x2gZUMLRhvXqjyBGZ2+UJW4LJlUs/xJoP1pjpjawOs
         PvgwQMSQE264z3QwcfX8xhH0QKBLFYBcYt/7RO2GXb8DtHqHcfoCrKn5W1G9K7U/HtkI
         LkQw==
X-Forwarded-Encrypted: i=1; AFNElJ8q4EIAPJShcJYi4wODXYgUh8gnD/WQivjxaf6Nqxox+apjeAZNTwsplhu1Y80lQlzjVHk31acvQg==@kvack.org
X-Gm-Message-State: AOJu0YygNqbEo4HiLmJpsqnl5JZOPKE1XdGRjs9mhD1qpLxFdzAwhmnf
	B+P9hCJPCMWiKnUHf+cNQ4d/SY0K30is6RDHbPOdm7aNS4gLPG0wYZt3
X-Gm-Gg: Acq92OF2asVJ+Y3LvtBPlV6f4B4pQj8U0Z/6ss3QAxTgz25B1+dXW02vniseFc7F055
	rfzzf+92gi8IFcRhnsECnsZrBOVFB5Lp97Iuq83FJDnr3fCBB0CHeA89fQQxtkxD/LDngTe/df0
	aBXYMciTZPRf1JgfTuwWqjfAxjU7Ou5TO0QvZ6c3AA3bDFwZteajVpA+bHSMxCn9WLPUXWYGA1H
	i7KibQtFfdFwhEiJ68pIsuyHtaQEKAxYPCQ0rmnC5wRM1gcY/Ai0p2twnuGW1QcJuG1NltD9Jta
	fxHXHTr3z1hcxK6LResBvATb0dypX9KC822eLc9b1jbj+3aM5LRoeZksj01TFL4oQ9mlrl5rjo/
	rp1KZAwmlaxw6uoWylLccpyMCRJBq+EuLx7apzEgmf6JE5tMvkKHKzvZ6SMR9oPuppTne42bUM9
	ij84RV4xw1gz91O2o5n9PVi2DLy8xPSQ==
X-Received: by 2002:a05:600d:8648:20b0:490:9d5c:a3e0 with SMTP id 5b1f17b1804b1-490a29215ebmr71216825e9.9.1780189339981;
        Sat, 30 May 2026 18:02:19 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4909c103908sm45297445e9.22.2026.05.30.18.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2026 18:02:19 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev
Subject: [PATCH 1/3] tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
Date: Sun, 31 May 2026 01:01:05 +0000
Message-ID: <20260531010107.1953702-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 956332000A
X-Stat-Signature: g84kqqtm1coob5rc3tktbmo8kkjddi1k
X-HE-Tag: 1780189341-19472
X-HE-Meta: U2FsdGVkX1/vXN28x9UR8AuyYVmzXcg55YeN/tlGEhgF2QKTfX2nZi13KgGK1OX5u+shYKNBbsE0nZaOaIcRY6Apn4eCcZEeEICdtc9lnk4ZTC0tf/Ua9qkeuKgCpCfE+0wCVvco+27rvNDfp7N6mHjIJrqZcomYE5b/nQxFVEY6sklWtcHUOqIrsk1cGXz2VzDRzYGGtUX3ZI1zWXOTcHFAZAEHN+qcIC/pqc0HLE2r+6Yv5b8ntR587MRF+XOZfrNYIE4Taf+DiLsBQmMlpee9nC/St5234oy+R2t69QPoAB5KZxm89zDoISmoNUHFBmwp8yZFzSRON0HzOu4/MpVreQBJIzcpV++aKr1vTmHTqI1UwKAiGlS50z4fkjFfmyBvgc8GnOivpp3+1y/4RPpyh91JHQ1ZFZU3Ec5s92e0O1lUGtf4B6q+G2sNXAwzr1mmafyFeObwe966IXCk+KFl+2+uUADDNx/EFnAe647X8NdW48Sv5ndEY5D6nr64uSF4fPh2YxbNZfIf6YuiDgHekc6mtWHUMF5nEeY2qWEyeSIz6rXFVEkdgpOvYc4LQlkb8/W1x8lq/JVvzMWr6jWPsZGvgm/r5txUGRc6NLyMq/Xy+ybR/Ou/MZrMpq8b3l1JEIzFHIp82Q0AKlhx17LhiioJ9OLpXI01pIT9xr0HYHzAf7jaUUwQDFnFV8wvOBu/5zQ22sSvJGHNRZ3YoTuiDqh8Ri7S0yDQ6TkGRHc5AFDDag4Sp04b+1qPA9xbAFVaedjCrmaqhVVl8LTaqTuHBx3y3Xn321l/lD09T6F8r0cqWZJHPF9pU/z/4k0oRRhisoxcPzBYiilEGUZbWlKOzQuJ4w8LG5LB9PVQ8LO0TNL74Wqg3WQ6FLYTR8AvdCHjxKPIsyGScZVREMH8Og+O3p38mS5gwBBl54goY6eaSyBbhFPnaAnWFpvL100VaqYv4QV1fbLiUxZ8J+h
 /Ot3SrH2
 iPZak+OYubPaNoIncsqt83NfuxO0YE6H1ViS6FhHDvmmkfUFFjrTPBSvnbvr7G+NJflyfwGERMsdGrSMAOVM6LmHOLT+YAMCRIH1O/qZtdOGDF3W3oYSIHbUUN8OhtmWmWN3uaeWxeV5vQgjEmOJHod10bOIaToio7cFO5G7Y2E2+CSZ81psGp4yNWRg3IcMYr/qgywiuX3y2xsFLD3iVXYPx1XoxkjGHms7GPVRS9/cH8MWXgpKXub2YIhAjJGshgZBKQ0+N60E45Vf6zL1mHytJ6A7ACPLoQ2LthBgg1aNmnLncMvYoJJQRTKZeKA5gv8ipIoqsZs3KjaMi8q0Cm8Ufz1VqOBj+l7aiIfM+LQ5Xa25USw5GZZ+YuGSw7s/QHicS+jpDwbvmlJ0n/vuPTimz1IGTJh9EVb6bNwijSXinVlBASt5HubnnCbDmQiuw/lRFP2Itot1p4okPhYU/w6U36Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove unused parameter "flags" from "link_pipe".

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 fs/splice.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..59adbc2fa4d6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1849,7 +1849,7 @@ static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
  */
 static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 			 struct pipe_inode_info *opipe,
-			 size_t len, unsigned int flags)
+			 size_t len)
 {
 	struct pipe_buffer *ibuf, *obuf;
 	unsigned int i_head, o_head;
@@ -1962,7 +1962,7 @@ ssize_t do_tee(struct file *in, struct file *out, size_t len,
 		if (!ret) {
 			ret = opipe_prep(opipe, flags);
 			if (!ret)
-				ret = link_pipe(ipipe, opipe, len, flags);
+				ret = link_pipe(ipipe, opipe, len);
 		}
 	}
 
-- 
2.47.3


