Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF32CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 11:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D746B008A; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD3E6B008C; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B399E6B0092; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3386B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:12:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09BC41A0007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:22 +0000 (UTC)
X-FDA: 84907284924.18.088BA8C
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3268C140005
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:12:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RFC2Eivn;
	spf=pass (imf09.hostedemail.com: domain of 3khg5agkKCAEubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3khg5agkKCAEubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782126740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
	b=agC4YsAir86+EtPlwkpAp8bQ39iRLnkto43Mo+Gsb2/6B3pTB1HBPd2oM7zK0rAM+DQAlE
	aLMlP3fyeenOzicTJUwHY4nq29rjaqTMRspWIUpL3fknG85PsBm9KayDT6GvqIul2Y10sj
	tg+EwKpCWNfxJ0JApT5WJxRWkQKrm4M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782126740;
	b=oFbMwQ2wSWrNvGXcuil/UsYkaRECTDWMs8ikFTadSnhX5qVgc5X7Rlaifg4/qUnLiDjTL9
	VEPLcNyOeHt4wmN18gkHflq+DU4PNQ+ONK9JU8ViCMtuMU+R/b0UwgWFMw+4UghxwsNsFx
	QfB7yNru4PyEHgVYZIwINJDLbrf5VuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RFC2Eivn;
	spf=pass (imf09.hostedemail.com: domain of 3khg5agkKCAEubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3khg5agkKCAEubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-697bd22237dso655747a12.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782126739; x=1782731539; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
        b=RFC2EivnOW7oQbYqsiR8RpKh3QODiqi8qqLHPyaDS7hCcDR/lMuGyQB8Le/jfchxZf
         YvSJKJZK6Ace1p/HWpFEmVhbUVO0OT/X3vwSv8SZpBRtYdHmPANulyBwVh74rdZHreoX
         fW4qT8QPwDDNVCD4D3YLFwQKKpqwNMgtyfc5w3+r68njZKoqvwyEEtJ/r+gfofNJTFDg
         VXMCmHO2+bPPSuEE3LjVVGSPlrF9Dqee6fbUt36Lk2eJ7uUCPr0qOcpDsXKt6N9f3/VU
         NAeNl4PfmxGk1veE2bBizjAyGwNR8RQlB9h7cYHTl5PLbQUN/Y0eBShz+aRl6i0vJotw
         xT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782126739; x=1782731539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W0tMHlxfhNRj9OWJ2aLcf95z6Lv7ns1VwKEy9Zm5rfk=;
        b=DVTNbRVy4Zi7WTL0YjGsx2PIoTL+MnC/amZuit+bdWVtq+cNKiTFhg8SKwguEfiOJV
         i7YVkIvAqBmnTkgkVZj4FZqK8QkwnAZzUbrVG8MpUMZWUk/MAzyN0XAMX7e3dyC+prAg
         6QUbuFLfIfqteVzxYE39xd9oyV3Rs+9OVOybu1dJ6zGtj0pWWpI7tiR50UisDHkxbH0a
         o91hgrkgbb+n2kvkGZHNPKxA6LKJBHTn5TYDycmao763Eyv5x8rZ77qfwW7hyaBu2Y+Q
         cFV6vWcx5b5BLnP74XZGUri5yT+FOshL/OrGPma9vLeNz0bIp7ti8nu7WWjKh/zk0PEU
         hKjQ==
X-Forwarded-Encrypted: i=1; AFNElJ8F/F+qO5RBBkBHHSQj/sqpEKHEBy91g0Oj59pFAlna0GdPSI2OECBY7vxtuXjTDOvA2HdPCCJhpQ==@kvack.org
X-Gm-Message-State: AOJu0YxXl7AoYxWLgY8dnjX4MUYtaI9fA1ONe5R+KdG2uDEtKjflSP4V
	Oe/EhDvlLzsVgWO/0SfA2traR0FZRCGHtN2m1nmrpzucEGmn4TSnW6Q7m5Ik46OCEWQvRryxqHt
	Pvix/IPXAA/Hmm+X9+A==
X-Received: from edti7.prod.google.com ([2002:aa7:c9c7:0:b0:695:8ee5:960f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a295:10b0:697:6415:1186 with SMTP id 4fb4d7f45d1cf-697641513cfmr3638026a12.26.1782126738554;
 Mon, 22 Jun 2026 04:12:18 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:12:14 +0000
In-Reply-To: <20260622111215.4157974-1-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260622111215.4157974-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260622111215.4157974-2-tarunsahu@google.com>
Subject: [RESEND PATCH v3 1/2] kho: add KHOSER_COPY_TYPE(UN)SAFE for phys copy
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Pratyush Yadav <pratyush@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bsf6zddritdz3ujajxxw4jnoosfojewc
X-Rspamd-Queue-Id: 3268C140005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782126739-356480
X-HE-Meta: U2FsdGVkX1/ru06rM414/CxGwt0qFnD6+CQaX02/91gXUd98cLkFN8mCTg2Xy37+MHK/3jv0rzW+FJLqxwANiKPGKZ9bMqWUONilpRYO5RlybWLzbnu9N9HLM9XGrWZhcRNyd1gwwWhHST7v1BKQKVxwVI6ZSQ2/JE7csfwFsT5t4pKAA5Wc/oI+aMWpO4XLtlWLUl/ErysRam8SwDsMRznQEwN4Z9ZgwWY74jokSOT1nSCiuaMBP4/1FcKtvloUP1YpNMM+mhPSbK2NMUEix3fj6b7A8zwP50ZNkthR/FyxYGIU9eQme96Wk3KCQekqdHZ2b7u7MDf/KsKjVfUpBqDQ0kDX6YsPqGjQs8dmycv5iHCWlyv6KUNHIvM8zUkXzuYoH56v+EApEeCqnMGIf1wtTnLZcu4+FmazIEtVP8uh/DEz2xElcCO8fZ0D7D65+u32SsIAQPVhpAWf3Qvx7yImY+eNxvo+gw/rzvhvXm9FCCXXTrvWzxsypSfwxLV89vzsPJvGzNnPv1EViuNKyL24VJuTkmbhHu9GsfbwWZQks7cIaknUmHhWUjQ7J8gFH2r+fsyox8K+G4/dtBi0O1AwbwcGbBE9iVJbXrjbzs6EG7Foy6hzvUJopWdocdAtU5SegqbP+FfGwHlDwR8Jos6sk1g6ArTmU3PqkixWWbv8hLdWC30661gbCcilHlnZNnBB0s+fG4ttTv8pqm+81m/wLs5FBJtV56vyQIIUxYnO02ZC4PGdI4uPdMv0bqHVp1Ijava6cCZxRXY9STdw+3ZIgnfbhpwm94jedafljvXtB974R9bZimtR1VOY1Jg5em04zXOXKyAKNyfY+9tzS87KfjTqRxmif2tm6N1nnKHNS3AS1INF7dR8G74lkSZDU9zRl6moci+AdMU5toJqBma1JHs7ng8i0q+5om+J4Wly++QtJUkE1+p4CQmSsWjeZsM56gEJjjmuuG6XNaG
 7vaul4/c
 GtjNBsRuu7qoZpCiLOU0YuUQgg3trij+V6TIMysQ8PSJ8tAFAzIMQ1ISHaXYpTOjwsjVeN41+FVwNIrM/zoT63k1W1AX3/wuzbC3yuHuLwi4WRA8MjPXkvsW7m8Pl+yjdKOOESIhT809N5uVoqysa5Di2NZ10fO2bqQ8X6bk3cEcluxEwiuiyafgPhg6c4Z5XkxwnX7nk1/n+kB08/GNJ/HXaaDv6GqJt4HOsJBQetbbJb3D7lnH1zSESFK5Jd3E4oFtQ/zje4T4CeHAXGZFjX66ma78EJaaYAyRGc+nlUjy8cow42rHcTvjXbYfG6fbl9bP3Zq0Vmp7JkHFcAPtBx5JQSYJ+wZ2vLUdxej6dv8TWYCuaTt+duk50poNFf/uuHTfGt0XdxN9mmLSv5lel3SQLIcusfYn0BTiuUTFGYJedjwKpTu4Y1K50c1va4qNq84T+0412E5nvo9360vbpry3n1sUprd6mGkpzdC0mKRgV/jxky8tNOGpUMB64JPf/0LrfBAMGUplr16yUYjA1dWKhI0HUXunE99WIVdlye+fgVHwyleDISRnT/MhVauwY+/IYRUSsF8VePZSL6pbGcZ/tE2QtLWAF8LyCsCx3ACkbBHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding KHOSER_COPY_TYPESAFE and KHOSER_COPY_TYPEUNSAFE to copy one
serializeable pointer to another. It basically allows copy of phys val
of the serializeable pointer.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 5e2eb8519bda..618408fbe9c9 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -139,6 +139,18 @@
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
+/* Copies one serializable pointer to another of same type. */
+#define KHOSER_COPY_TYPESAFE(dest, src) \
+	({ \
+		typecheck(typeof((dest).ptr), (src).ptr); \
+		(dest).phys = (src).phys; \
+	})
+
+/* Copies one serializable pointer to another. */
+#define KHOSER_COPY_TYPEUNSAFE(dest, src) \
+	({ \
+		(dest).phys = (src).phys; \
+	})
 /*
  * This header is embedded at the beginning of each `kho_vmalloc_chunk`
  * and contains a pointer to the next chunk in the linked list,
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog


