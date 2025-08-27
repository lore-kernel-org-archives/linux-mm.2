Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29EEFCA0FF6
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FF48E0137; Wed, 27 Aug 2025 07:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27068E0105; Wed, 27 Aug 2025 07:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70A38E0137; Wed, 27 Aug 2025 07:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB0008E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4587F598B7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:49 +0000 (UTC)
X-FDA: 83822254698.22.8ADFCA7
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 76C231C0016
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOYyb0T4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756292687; a=rsa-sha256;
	cv=none;
	b=TT43ZGA8E0qL5JUSMIv90FAeypDqf3Z17uW+UKGf02ROcpySYxij5f9M8kG4xcEvlBSXij
	ox04jm8H3LZgJwChfXfRTzGN/berik4O7IWzINwMuD3x0qLAxjqvg2+rrlLmREjCCKs/87
	7N8/2ZlLxN1FKV9RXKCzYUXCfa9A/0A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xOYyb0T4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TuauaAgKCCMI9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756292687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1JLDczBck6DvgDcQzS2GBWgdu9LwuHv0ctBDRr5UCA=;
	b=rQOVUwKJPGwtHq/YJwa3UYW+1ULjr6M3ghc1fT68Ftcc2yupJ0GFKqvFvA5y2neLniiHOi
	MWujI12C64vZr6FcyYVbHzy8q2Si67NKTr8pPuqN+1m5m5kBK5Q5JgE1IIFaZde3ze3Ug9
	x1Yq0shGzBNtJaQ9rtOwG5fIDzOt6Q8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b71fe31ffso3501735e9.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756292686; x=1756897486; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1JLDczBck6DvgDcQzS2GBWgdu9LwuHv0ctBDRr5UCA=;
        b=xOYyb0T4v/ai4Jm64IUS2PE1EzPU5bx2nqF48K7MJdXqTZMBJyG91QbzsEU1RcrC/5
         UldUDUiaYW4OOlCz01891Pc4zqE60TyzwYudOo3LTAKZo3n6O1RAwQ/MSnP2acJ5ejO7
         VbHQQ6VnuU9imo2YakMLvMP9BbHP0nOlrYD/zVboaALYNNBvpOvyG7xwEE0Cx7pOVWeE
         Q9lHHh65XmqJrt5gSRjZsFAMGqRB4COkFRbuDs1sZfFshidAJqCTJ7uQElpkfNDgl0u5
         Zc4/PoCiGfjYmrrzMc/7vjeOpNwgdqsOjRCjM6uU4Zt7QysCOYXSLEcIxE0w4/FKMZW/
         DePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756292686; x=1756897486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1JLDczBck6DvgDcQzS2GBWgdu9LwuHv0ctBDRr5UCA=;
        b=fPYNZDCWkE78N8XenDl1A4nRqabS/bT+BOvWg2RSdylZra9kIUG4M24s7UFjzSicwF
         q2I+KxZ/gjCh2xmleDf+VPWAJZob+EslSE4ZT7Xwb+vLdjHhU8qfYa+Y2tKg1uxcV0qw
         TyFfz9SClNFjbXK2qkbU06ao7rVNp0v8H5z+I6/3/6FstTBjrfxcE9gcz+cPDJ6DjzPJ
         pQTRRBFDnGr/7S6YCzRqvTFBeorCqeEESTaqC/BQgRYFWWrgIoaW0eh1KECzhSJHZxvo
         4tMJpPiY5h1ENCvVtRtBKKI3cg+Qcpd8YKujIgQ5pdlTP8l+4pvtbk7Jz4tbj74M4yQ4
         TxMA==
X-Forwarded-Encrypted: i=1; AJvYcCUjZ1wmnbBGjiWmWhD6jrNoNpPir+JRLgO6reqNpPInrd8K22me17rs1ilBk9UeOPmOBE3O8G7cJQ==@kvack.org
X-Gm-Message-State: AOJu0YxwP2pkmaccftcYawhjyWeTEtThpXK88uqUQ17zMwYFw496zLoz
	ZlOxuyw1pLJX7QoIlSifRB8W5ARfhjRFDYvA8wzYn4jq98Ee8EV0bKuHj47zLVDZCMe+4H5fS06
	PzneAyJKDEIwYhA==
X-Google-Smtp-Source: AGHT+IGrAcbdSroEv8381iwG9fFa7HIZzG92rr8VYjO8Tn1BstPgPDU22+oW3fciclP7XBaLivl8yhvcXwvINQ==
X-Received: from wmbhe13.prod.google.com ([2002:a05:600c:540d:b0:459:dcca:571e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr175548825e9.18.1756292686018;
 Wed, 27 Aug 2025 04:04:46 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:04:41 +0000
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
Subject: [PATCH 1/3] tools: testing: Allow importing arch headers in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 76C231C0016
X-Stat-Signature: qrudy6hmttyywwhfnmqkwewee18ufxae
X-HE-Tag: 1756292687-185769
X-HE-Meta: U2FsdGVkX18VUdY/gMpKadcfhM8An7NZtRie+xNeYuOHqxydPGVYjJ3Wu2wVfiTWB0uzUsU70B6twGDLM0stORM53ZQZEbNInQLykjeeff+f2bt06liJHBU+JtIOGEld9Sfq5bysCwXmTe9alESU6MwUpmnwvyOlBdAWHdmGIh4GcGu9ZZswEqLqeLeHh/97VdPDsto2Z+BLbF0XGRSLc1fjctDKmTgDlR7dOSfNhOIU+PLb//6QVawpJ/u3a4vU/WsRVTdauFdO5644ZvMcPgfI/O4U4DPlWZ8nPClyKR8pAPwInQStV/MsdtZZalLaOYh9Cx73mdmdr0q+RGjoBTczmRXm0DNeh6535GLZdyJ2g2OyzWh9cll9nP7JMOAqYffPgmB8VA3ciqA8ikCd3X8Z+rvc5DMjuYe2+S3imxU7CJ9CmE7U8bFvZTMAEPq9tKvhcsX8fpRea974AdAjmAWPMYKJNRJZc1bxaKaTZ/GytGaQqlJFoX2wWM1iwEmRJ+HRcm5EnsBWdyQOwKdlUKO45tuCAFQrDHcZ3xWm6D8bor8OaPBSOR525i9C9qGxNgaliljmSsmB6DvyRZ+ApWOOZ1WzYwAxhPTzVPPwHtbcsqyl/34QnseaJdgUrQ+AmZHk+8aVLjxhoL/6pVhjJ5Eyt5B7RvIWT9ubfZR/STOq/WIxEqPYeW5F5rC+NoKf/2hfmfU/k2GHPZ9am4nLyDFEVVQqrEoX4j7CoSYtFLassbU+92B0vs5xovcIYVU3w0kAMkYe4ARGA5jZzZkBATdNFwppCuxmNSQgt8dcidGLjbbBx/+yfNDMB/+y3xmJLuh3r7QwbvDqwTYWFJbbgmFUTW0HeEtKebuL+3iWJf61KXSFqY+StFYjASyyVtZBDzuFrBR5/e5tDGI+Hk2rjaSNUrV3sD7mRas3Rwae8Ut/adoLV9QgPSJA3Bzy9bwkpCKOd1kNep7aG5QtyOz
 uFEn/c+m
 YlnmnYOA8nBf9GiUx1SZEFLMYhB+/mm2lmTNW6mz0OiRvmveC4/njbpjjeWRslHxJBxIu7CGOu1tn0o966UxLXueWff8Xdh88vYAZIKXqnagLWVjdGEMuaQAJ0U6DAHgELvj31sctK6t84vIxdYxMLEQKwblKaaPr6gOpHLdxC0qHS2eRT4q4UTl5G1AIuWaMORkfgadXW3rz14VaFw9n40CPMT0kAl6NT+UZ6r4WG34GTKqT8+LjmwabTtk5us67NaivO5R0GXtKIAzr+aFu2Wpg2cwyKos6Qltcsgb7IB861Z/5xWoR2/ms6XGKZL5Ru5jpmh/qvQlmMt4RfxoKs5WRB20Ob1lYl8my+q9bP6zIZ7hg/37B+PlZxAHH0wsfU7WFSwJAnIWlv23nrs9+TsC4QcIhp1IeAaE0gMH3CXeRT7sJqvr+XAFoDQIOul5vXxnGjuo7uGRuNeAZ5EZKPinZj5R61ZmGHcPxJ9vGcYSrawqr6grkvxrL167E2cwfmEedRPBSbAMBJNvgXU+wunyp3Cy0QlNL8qe9KGleH+66G8Etuc9j8KWMAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is an arch/ tree under tools. This contains some useful stuff, to
make that available, import the necessary Make helper file and then add
it to the -I flags.

There still aren't that many headers so also just smush all of them into
SHARED_DEPS instead of starting to do any header dependency hocus pocus.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/shared.mk | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
index 923ee2492256b693c5cf16cc014d9d2410be5457..937aaa7623320da1085a8e0f43f6a728ddd3ab1c 100644
--- a/tools/testing/shared/shared.mk
+++ b/tools/testing/shared/shared.mk
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
+include ../../scripts/Makefile.arch
 
-CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
+CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
+	  -I../../../lib -g -Og -Wall \
 	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
 LDFLAGS += -fsanitize=address -fsanitize=undefined
 LDLIBS += -lpthread -lurcu
@@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.mk ../shared/*.h generated/map-shift.h \
 	generated/bit-length.h generated/autoconf.h \
 	../../include/linux/*.h \
 	../../include/asm/*.h \
+	../../arch/$(SRCARCH)/include/asm/*.h \
 	../../../include/linux/xarray.h \
 	../../../include/linux/maple_tree.h \
 	../../../include/linux/radix-tree.h \

-- 
2.50.1


