Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 472A6CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64E36B04A7; Mon,  1 Jun 2026 23:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16CD6B04AC; Mon,  1 Jun 2026 23:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04C46B04AE; Mon,  1 Jun 2026 23:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 952846B04A7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D9F3A0796
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:24 +0000 (UTC)
X-FDA: 84833512008.27.084E872
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D3AE140003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yo9dHL5b;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tW8ZkJFH1s/aeCdAEiQB7eOXHeRrYqV2OpgEHHCsa8=;
	b=30B54FICgA2Ie6QdMKKGLxdBA80bRs9Dvg+VLdEptRWXiFdqrHvwnEgfBxUuXpdoEFZNgG
	DvW0rJiRQ+edwqzW8kMTAq9VOvo/ydvsCMwNmJZbY5ou4GZtKgWCeorYkYHsbKoC+iZYa5
	rQnfu+VzK+FAt/+ierMHo4ai7pW+0lg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yo9dHL5b;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370242;
	b=CWQ4WoeOv7h9hOkPGYJXRTWU+JDvfY9Tn+T6UQ86tljLyVlMk+J81e3L2dalAOldFsa4Zm
	gDE1r5Re7wRV4ig8qfVIRVp7Ar0X6Zd0vF6u6yfXduZS3s+lZjwSS5ZX/V2eOhveM0DMHw
	4guZl0h76tTpmNKjbJeYDZyoJOHxgAE=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-517654b8e28so5494581cf.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370241; x=1780975041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6tW8ZkJFH1s/aeCdAEiQB7eOXHeRrYqV2OpgEHHCsa8=;
        b=Yo9dHL5bepaNmoS53dVTblE6vOoAZ75eDgdc1e05B1MFogeGnlyyCJ92ybV16GZt5q
         ZXlSmQvy1G2ZMfrQHyxvqBJK1tolPS9cdz/G5k24cUk/9oeL9+O22ipaXTrqf3Q73o/u
         c2Dl5i9dhSHvTWTyCsPsJMIXCmY4+5JQ/b2qSKY218BAw9STottsVLl/S7uRiIzoEihM
         KeCMf+pR0GSXuAso4qkBzZ8koSGxHmkuvWbYNhrv6SFHV+RA+4T5CxAFqIJ2czz8+Nuh
         YOE3QOf+eYoJMUIz6qAyeSHOfgtX5b645lWOhPa9zMCEj5j4rOlxGgcLHtpMvj8WxeBb
         D+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370241; x=1780975041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6tW8ZkJFH1s/aeCdAEiQB7eOXHeRrYqV2OpgEHHCsa8=;
        b=SqSAw2osLwuPPuJRKqsaowF4ZmYW61UWEvV2PvzW5JTtUXEJdFe+KhDS4nmt9J6QoN
         oczaxD5j6ZBa8Dbc1JBi6WJk5Nrvpj1udhfvCJQ9tV0k4aM69ptZOaEZM/RlLryJ/GTf
         XsUrUwlErToQt0dAd18xNjEzrhVZT0p2NmSdXSLvHQTYK0Q/YeY/ImT0xaW3K5IoY8I0
         Ka/1V91rdwVHkEVan5/1pYk3B+Na4BQVZW5ueBOS0JBxmdFztumRQfJ9sVvL3t+BE6YP
         Hb1UkRUNITh6SF54/bjkcSKiSLxkgAd/I/RcffyH83hDkFlPFEnMp3iFkRuRJRr7T84R
         0S/g==
X-Forwarded-Encrypted: i=1; AFNElJ9lONt3MDxR1svT9SJ9rI2Ltc/d7MpgmvuVRK9jMYDRA/isKYXZSG9vlWWtXQE996BMVqdVw5wynA==@kvack.org
X-Gm-Message-State: AOJu0YygZ127Jq9j9ZjOXMz5Dh5fm4veaNjqaQ5KyBIPwzUtrsRjXwWe
	Msjo4MprbD9pT5m8o4NFIo/M8wVyYmN5RGERNLQTo6Y3eviRClBMFzhUACz6/F15xAc=
X-Gm-Gg: Acq92OHbgRBBSjeeKu6H1nTjgAR+2c8Nq7Yc2f7uckSelVBgFV6mVswINCrw4OPHHmj
	jw3Y+Zhnn/rGuj/1JeePzB/dh+kMHeLIJYAGk8XsGUuzm3foshVoyfOTdKoyFy1xPBuIyF2JBmf
	+11dY36g/UXkuhZ5DDa9Lmt+kF9dS5CTwaa3GtbEIxSFckeW6XKICLwkKiA0rocnsYFgtS1EpXy
	FkjBf+mO6SvbMzEBUyPQX+ZCZli1D95OpOQoUVtWLY/RsjIFX42Fm6zlBjWxowwmo+w8DxUZy+U
	n1tQ0/wP/4T4mPlMcNZ48taawNug7eX0TkY3STqD5WeShu9iM7F8r5nOnwg1J8FJXsBEt9QhqFU
	o0STs0khKugvKnfg56q31PM68zXKYUs5yu76ju2K3MyeutcWazvE3PwWQOFSYGed8NyLE7PC0o7
	svcU+a9lIuPcNFCkmMvWtE6W2uRF7kMNyC0Opo+btGgcOOHfIO4W3rafzPCHwLyQ==
X-Received: by 2002:a05:622a:4c14:b0:50e:6377:197d with SMTP id d75a77b69052e-5173a6197f2mr192694801cf.8.1780370241637;
        Mon, 01 Jun 2026 20:17:21 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:21 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v5 02/13] liveupdate: avoid mixing cleanup guards with goto in luo_session_retrieve_fd
Date: Tue,  2 Jun 2026 03:17:06 +0000
Message-ID: <20260602031717.197696-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zscdrhqoxfg46x6a1ubqnqazh6hpi55x
X-Rspamd-Queue-Id: 6D3AE140003
X-HE-Tag: 1780370242-589613
X-HE-Meta: U2FsdGVkX19lsypY9LrWIxHhYZPqza3fZJsPMdGZqyDEBMO80yLwTC40YROQQT/3qER4aku/Lz5M3z2R1wTRRSHron7TBVA3cYpxhpdzeA2yZnjffbbfzl4/5zO8fQ9pElbSLmFF5wksqYvRo8Cl2dzro9IoRqs81u0GjB7wSUL9YuxgLLEH99DmFt51TOBzoXVbZcYCW0jvdUXvqB5q1Ay+3DXvBS/ePLbwxdaYQygiqn1wlzhaolRPmMO2XU4YILVEsua9xv7Icei2891sdnyxBrp/Z0BP2ugCPMZg5SPpa/IFN8DtLHELxNW/JTfvF4GC+M3qeHXxSwO4GQaaUkYIuqaDQfo13OZlztEpt81IjXdhx/N3ib9miDKcIExlDUJyVmTrtH1XfWIb6fW6d5vdlnyuJ9QTcqr/TT3+Xb3nFCgyF7PBIPaLquPX9pdcazAa61eoYvk+bafY3xIQz2S5MOhUwqTihjJc2YUsZscYwEgmRCS2EAraEeAHIrKH0lRVBEJFmR8w+k6FSx5G4TbGx5TnK0EG2UaCPL0U4IEiLTyKaqGD8ImxQNKP8MwFeBlGYw83QBp9lZUBKqQHkN0XXdQLUjSu6m5D7/UYa26xpXcTGnB9EX+JtMPOY6PPpXiW7ZiEZO984CYvBNEYPDju3LbqzLFzCbDRobgX1w6JDELMZgvs+0d0iuRxOHQIPFVAyUjsO9YEs1/K89DQMeeD65drAbsKWvRC5Gti5kkvhN9BlCYS0aBlNgFSJSMZfLVuCczaJjM6HnzyNiAFuDFJp7s4qg6ywMs3r3YgYkj06A5yyjQS6XcjnExJASDVB792CjNsfzyC8wZdpisjkNqKyTeuZUnrFUD1tuN98GeRaNWNYA8T5pXzZV2wYvAZzQTa9a/wlMjX3Y/i7jLiBuBlnNmhWPbZVqNfCI6nUkcfAXKj2Kx3XGmkXnvIqZQBxzUaYRdz41SYcPDLdcQ
 iB4MyJnM
 utNXnNopUIg5OGDDJwOnpBN69OmloO0T9xqUn/aenzIlr3TT1cCpatoT+zvn1/65kfVp8tfFanWgknjnYSJ1SYkPlfifw7ZMtCT1kLVjlidul8ivfJjj7McWuNlYKVF6m+TRJASc8THlHp1EhowIbE+bljhHrd48PJq1PS0hZ+0WfKhevGvwgnNy7LGkIGKNDX+cNcFDco/EvUgKdzknq+PSyCn7fM10NDKGZrvEPjhlwFc6QyR+Z3NutuCXSEVK+HwtE8OQpZwqoeTV97MWg/AiVDePxnESGcUEbfWuYypULMkNUj/6rakyR1r0fHtRs7qDf78STVLI9XhE6C/8wl9ZLGDa7d2lJCyCs5WX5M225DroYrRC4ToPfsYUEcZsxv2Sml2qzcjjt2Qs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactoring luo_session_retrieve_fd() to avoid mixing automated
cleanup-style guards with goto-based resource release, which is not
recommended under the Linux kernel coding style.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 5c6cebc6e326..7b2f9cbabb05 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -291,25 +291,24 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	if (argp->fd < 0)
 		return argp->fd;
 
-	guard(mutex)(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
-	if (err < 0)
-		goto  err_put_fd;
+	scoped_guard(mutex, &session->mutex) {
+		err = luo_retrieve_file(&session->file_set, argp->token, &file);
+		if (err < 0) {
+			put_unused_fd(argp->fd);
+			return err;
+		}
+	}
 
 	err = luo_ucmd_respond(ucmd, sizeof(*argp));
-	if (err)
-		goto err_put_file;
+	if (err) {
+		fput(file);
+		put_unused_fd(argp->fd);
+		return err;
+	}
 
 	fd_install(argp->fd, file);
 
 	return 0;
-
-err_put_file:
-	fput(file);
-err_put_fd:
-	put_unused_fd(argp->fd);
-
-	return err;
 }
 
 static int luo_session_finish(struct luo_session *session,
-- 
2.53.0


